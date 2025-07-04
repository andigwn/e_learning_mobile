import 'package:e_learning_mobile/core/routes/app_route.dart';
import 'package:e_learning_mobile/features/dashboard/bloc/dash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/features/jadwal/bloc/jadwal_bloc.dart';
import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';
import 'package:go_router/go_router.dart';

class JadwalPage extends StatefulWidget {
  final int rombelId;
  const JadwalPage({Key? key, required this.rombelId}) : super(key: key);

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  int selectedTab = 0;
  final List<String> hariList = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
  int? _lastLoadedRombelId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ambil rombelId dari widget argument
    final rombelId = widget.rombelId;
    if (_lastLoadedRombelId != rombelId) {
      _lastLoadedRombelId = rombelId;
      context.read<JadwalBloc>().add(LoadJadwal(rombelId));
    }
    // Pastikan StudentBloc sudah memuat data siswa
    final studentBloc = context.read<StudentBloc>();
    if (studentBloc.state is StudentInitial) {
      studentBloc.add(LoadStudentProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jadwal Pelajaran',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF328E6E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Tab Bar Hari
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(hariList.length, (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedTab == index
                                ? const Color(0xFF328E6E)
                                : const Color(0xFFE9F5D6),
                        foregroundColor:
                            selectedTab == index
                                ? Colors.white
                                : const Color(0xFF328E6E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                      child: Text(hariList[index]),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: BlocBuilder<JadwalBloc, JadwalState>(
              builder: (context, jadwalState) {
                if (jadwalState is JadwalLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (jadwalState is JadwalLoaded) {
                  final filtered =
                      jadwalState.jadwal.where((jadwal) {
                        return (jadwal.hari?.toLowerCase().trim() ?? '') ==
                            hariList[selectedTab].toLowerCase().trim();
                      }).toList();
                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada jadwal hari ini.'),
                    );
                  }
                  // Ambil student dari StudentBloc
                  return BlocBuilder<StudentBloc, StudentState>(
                    builder: (context, studentState) {
                      if (studentState is! StudentProfileLoaded) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final student = studentState.student;
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final jadwal = filtered[index];
                          return _JadwalCard(jadwal: jadwal, student: student);
                        },
                      );
                    },
                  );
                } else if (jadwalState is JadwalError) {
                  return Center(child: Text(jadwalState.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _JadwalCard extends StatelessWidget {
  final Jadwal jadwal;
  final dynamic student;
  const _JadwalCard({required this.jadwal, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE9F5D6),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 4, height: 40, color: const Color(0xFF328E6E)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    (jadwal.mapel ?? '-').toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  jadwal.guru ?? '-',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF328E6E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Text(
                  jadwal.hari ?? '-',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Text(
                  '${jadwal.jamMulai ?? '-'} s/d ${jadwal.jamSelesai ?? '-'}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF328E6E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    print('DEBUG student: \\${student.toJson()}');
                    print('DEBUG jadwal: \\${jadwal.toJson()}');
                    if (student != null) {
                      context.goNamed(
                        Routes.absensi,
                        extra: {
                          'student': student.toJson(),
                          'jadwal': jadwal.toJson(),
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data siswa tidak tersedia'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Masuk Kelas'),
                ),
                const SizedBox(width: 8),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () {
                    context.goNamed(
                      Routes.tugas,
                      extra: {'jadwalId': jadwal.id},
                    );
                  },
                  icon: Icon(Icons.book, color: Colors.green[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
