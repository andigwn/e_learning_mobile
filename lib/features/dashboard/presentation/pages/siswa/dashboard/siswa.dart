import 'package:e_learning_mobile/core/routes/app_route.dart';
import 'package:e_learning_mobile/features/dashboard/bloc/dash_bloc.dart';
import 'package:e_learning_mobile/features/dashboard/domain/repositories/student_repo.dart';
import 'package:e_learning_mobile/features/dashboard/presentation/widgets/dashboard/build_header_logo.dart';
import 'package:e_learning_mobile/features/dashboard/presentation/widgets/dashboard/menu_card.dart';
import 'package:e_learning_mobile/features/dashboard/presentation/widgets/dashboard/subject_card.dart';
import 'package:e_learning_mobile/features/dashboard/presentation/widgets/dashboard/sutdent_info_card.dart';
import 'package:e_learning_mobile/features/jadwal/bloc/jadwal_bloc.dart';
import 'package:e_learning_mobile/features/jadwal/domain/repositories/jadwal_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
                    ..add(LoadStudentProfile()),
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
        ),
        body: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StudentError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    ElevatedButton(
                      onPressed: () {
                        context.read<StudentBloc>().add(LoadStudentProfile());
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            } else if (state is StudentProfileLoaded) {
              final rombelId = state.student.rombelId;
              if (rombelId != null) {
                // Pastikan hanya trigger sekali, misal dengan Future.microtask
                Future.microtask(() {
                  context.read<JadwalBloc>().add(LoadJadwal(rombelId));
                });
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Logo
                      const BuildHeaderLogo(),
                      const SizedBox(height: 20),

                      // Student Info Card
                      BuildStudentInfoCard(student: state.student),
                      const SizedBox(height: 20),

                      // Today's Subjects
                      const Text(
                        'Mata Pelajaran Hari Ini',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<JadwalBloc, JadwalState>(
                        builder: (context, jadwalState) {
                          if (jadwalState is JadwalLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (jadwalState is JadwalLoaded) {
                            // Filter jadwal sesuai hari ini
                            final today = DateTime.now();
                            final todayJadwal =
                                jadwalState.jadwal.where((jadwal) {
                                  // Misal field jadwal.hari berisi nama hari, sesuaikan dengan model kamu
                                  return jadwal.hari?.toLowerCase() ==
                                      DateFormat(
                                        'EEEE',
                                        'id_ID',
                                      ).format(today).toLowerCase();
                                }).toList();

                            if (todayJadwal.isEmpty) {
                              return const Text('Tidak ada jadwal hari ini.');
                            }

                            return SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount: todayJadwal.length,
                                itemBuilder: (context, index) {
                                  return SubjectCard(
                                    jadwal: todayJadwal[index],
                                    onTap: () {},
                                  );
                                },
                              ),
                            );
                          } else if (jadwalState is JadwalError) {
                            return Text(jadwalState.message);
                          }
                          return const SizedBox();
                        },
                      ),
                      const SizedBox(height: 20),
                      // Additional Menu
                      const Text(
                        'Menu Lainnya',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 2.5,
                            ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          const List<String> menuItems = [
                            'Jadwal Pelajaran',
                            'Nilai',
                            'E-Book',
                            'Hasil Studi',
                          ];
                          return MenuCard(
                            title: menuItems[index],
                            onTap: () {
                              // Handle menu item tap
                              if (menuItems[index] == 'Jadwal Pelajaran') {
                                context.goNamed(Routes.jadwal, extra: rombelId);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('Tidak ada data.'));
            }
          },
        ),
      ),
    );
  }
}
