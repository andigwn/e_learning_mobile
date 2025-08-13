import 'package:e_learning_mobile/features/dashboard/bloc/dash_bloc.dart';
import 'package:e_learning_mobile/features/jadwal/bloc/jadwal_bloc.dart';
import 'package:e_learning_mobile/features/jadwal/persentation/widgets/hari_tab_bar.dart';
import 'package:e_learning_mobile/features/jadwal/persentation/widgets/jadwal_list.dart';
import 'package:e_learning_mobile/features/jadwal/persentation/widgets/jadwal_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JadwalPage extends StatefulWidget {
  final int rombelId;
  const JadwalPage({super.key, required this.rombelId});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  int selectedTab = 0;
  int? _lastLoadedRombelId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  void _loadData() {
    final rombelId = widget.rombelId;
    if (_lastLoadedRombelId != rombelId) {
      _lastLoadedRombelId = rombelId;
      context.read<JadwalBloc>().add(LoadJadwal(rombelId));
      context.read<StudentBloc>().add(LoadStudentDashboard());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jadwal Pelajaran',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF328E6E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
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
      body: Column(
        children: [
          HariTabBar(
            selectedIndex: selectedTab,
            onTabChanged: (index) => setState(() => selectedTab = index),
          ),
          Expanded(
            child: BlocBuilder<JadwalBloc, JadwalState>(
              builder: (context, jadwalState) {
                // Jadwal loading/error states
                if (jadwalState is JadwalLoading) {
                  return const JadwalLoadingWidget();
                } else if (jadwalState is JadwalError) {
                  return Center(child: Text(jadwalState.message));
                }
                // Only proceed if jadwal is loaded
                else if (jadwalState is JadwalLoaded) {
                  return BlocBuilder<StudentBloc, StudentState>(
                    builder: (context, studentState) {
                      // Student loading/error states
                      if (studentState is StudentLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (studentState is StudentError) {
                        return Center(child: Text(studentState.message));
                      }
                      // Both loaded - show schedule
                      else if (studentState is StudentDashboardLoaded) {
                        return JadwalList(
                          jadwal: jadwalState.jadwal,
                          selectedDayIndex: selectedTab,
                          siswaRombel: studentState.dashboard,
                        );
                      }

                      // Initial/other states
                      return const Center(child: Text('Memuat data siswa...'));
                    },
                  );
                }

                // Initial/other states
                return const Center(child: Text('Memuat jadwal...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
