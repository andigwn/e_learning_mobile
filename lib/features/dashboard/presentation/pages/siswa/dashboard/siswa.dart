import 'package:e_learning_mobile/features/dashboard/bloc/dash_bloc.dart';
import 'package:e_learning_mobile/features/dashboard/domain/repositories/student_repo.dart';
import 'package:e_learning_mobile/features/dashboard/presentation/widgets/dashboard/dashboard_error.dart';
import 'package:e_learning_mobile/features/dashboard/presentation/widgets/dashboard/dashboard_loaded_view.dart';
import 'package:e_learning_mobile/features/dashboard/presentation/widgets/dashboard/dashboard_loading.dart';
import 'package:e_learning_mobile/features/jadwal/bloc/jadwal_bloc.dart';
import 'package:e_learning_mobile/features/jadwal/domain/repositories/jadwal_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SiswaPage extends StatelessWidget {
  const SiswaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  StudentBloc(context.read<StudentRepository>())
                    ..add(LoadStudentDashboard()),
        ),
        BlocProvider(
          create: (context) => JadwalBloc(context.read<JadwalRepo>()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF328E6E),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.teal.shade700, Colors.teal.shade500],
              ),
            ),
          ),
        ),
        body: BlocListener<StudentBloc, StudentState>(
          listener: (context, state) {
            // PERBAIKAN: Panggil LoadJadwal ketika dashboard berhasil dimuat
            if (state is StudentDashboardLoaded) {
              final rombelId = state.dashboard.rombel.id;
              context.read<JadwalBloc>().add(LoadJadwal(rombelId));
            }
          },
          child: BlocBuilder<StudentBloc, StudentState>(
            builder: (context, state) {
              if (state is StudentLoading) {
                return const DashboardLoading();
              } else if (state is StudentError) {
                return DashboardError(message: state.message);
              } else if (state is StudentDashboardLoaded) {
                return DashboardLoadedView(dashboard: state.dashboard);
              } else {
                return Center(
                  child: TweenAnimationBuilder(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, child) {
                      final clampedValue = value.clamp(0.0, 1.0);
                      return Opacity(
                        opacity: clampedValue,
                        child: Transform.scale(
                          scale: clampedValue,
                          child: const Text('Tidak ada data.'),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
