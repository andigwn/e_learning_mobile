import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/features/absensi/bloc/absensi_bloc.dart';
import 'package:e_learning_mobile/features/dashboard/data/model/dashboard_model.dart';
import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';

class AbsensiPage extends StatefulWidget {
  final Student student;
  final Jadwal jadwal;
  const AbsensiPage({Key? key, required this.student, required this.jadwal})
    : super(key: key);

  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  double sekolahLat = -0.063078;
  double sekolahLng = 109.355868;
  double maxDistance = 100; // meter

  Future<void> _absenMasuk() async {
    final siswa = widget.student;
    final jadwal = widget.jadwal;
    // 1. Ambil lokasi
    final pos = await _getCurrentLocation();
    if (pos == null) {
      _showMessage('Lokasi tidak aktif atau izin ditolak');
      return;
    }
    // 2. Cek radius
    final inRange =
        Geolocator.distanceBetween(
          pos.latitude,
          pos.longitude,
          sekolahLat,
          sekolahLng,
        ) <=
        maxDistance;
    if (!inRange) {
      _showMessage('Anda di luar jangkauan lokasi absen!');
      return;
    }
    // 3. Hitung verifikasi_absensi
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final jamMulaiDt = DateFormat('HH:mm').parse(jadwal.jamMulai ?? '07:00');
    final jamMulaiToday = DateTime(
      now.year,
      now.month,
      now.day,
      jamMulaiDt.hour,
      jamMulaiDt.minute,
    );
    final terlambat = now.difference(jamMulaiToday).inMinutes > 15;
    final verifikasiAbsensi = terlambat ? 'Terlambat' : 'TepatWaktu';
    final statusVerifikasi = 'Terverifikasi';
    // 4. Dispatch event ke Bloc
    context.read<AbsensiBloc>().add(
      AbsenMasukEvent(
        siswaId: siswa.id ?? 0,
        jadwalId: jadwal.id ?? 0,
        tanggal: todayStr,
        status: 'Hadir',
        latitude: pos.latitude,
        longitude: pos.longitude,
        alamatIp: '', // Isi jika ada
        deviceId: '', // Isi jika ada
        statusVerifikasi: statusVerifikasi,
        verifikasiAbsensi: verifikasiAbsensi,
      ),
    );
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void initState() {
    super.initState();
    final siswa = widget.student;
    final jadwal = widget.jadwal;
    // Fetch absensi saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AbsensiBloc>().add(
        LoadAbsensi(siswaId: siswa.id ?? 0, jadwalId: jadwal.id ?? 0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final siswa = widget.student;
    final jadwal = widget.jadwal;
    // Cek apakah hari dan jam sudah selesai
    final now = DateTime.now();
    final hariSekarang = DateFormat('EEEE', 'id_ID').format(now).toLowerCase();
    final hariJadwal = (jadwal.hari ?? '').toLowerCase();
    final jamSelesai = jadwal.jamSelesai;
    bool isJadwalSelesai = false;
    if (hariSekarang != hariJadwal) {
      isJadwalSelesai = true;
    } else if (jamSelesai != null) {
      try {
        final jamSelesaiDt = DateFormat('HH:mm').parse(jamSelesai);
        final jamSelesaiToday = DateTime(
          now.year,
          now.month,
          now.day,
          jamSelesaiDt.hour,
          jamSelesaiDt.minute,
        );
        if (now.isAfter(jamSelesaiToday)) {
          isJadwalSelesai = true;
        }
      } catch (_) {}
    }

    return BlocListener<AbsensiBloc, AbsensiState>(
      listener: (context, state) {
        if (state is AbsensiSuccess) {
          _showMessage('Absen berhasil!');
        } else if (state is AbsensiError) {
          _showMessage(state.message);
        } else if (state is AbsensiLoaded) {
          // AUTO-ABSEN LOGIC
          final absensiList = state.absensiList;
          final now = DateTime.now();
          final hariSekarang =
              DateFormat('EEEE', 'id_ID').format(now).toLowerCase();
          final hariJadwal = (widget.jadwal.hari ?? '').toLowerCase();
          final jamSelesai = widget.jadwal.jamSelesai;
          final siswa = widget.student;
          final jadwal = widget.jadwal;
          bool isJadwalSelesai = false;
          if (hariSekarang == hariJadwal && jamSelesai != null) {
            try {
              final jamSelesaiDt = DateFormat('HH:mm').parse(jamSelesai);
              final jamSelesaiToday = DateTime(
                now.year,
                now.month,
                now.day,
                jamSelesaiDt.hour,
                jamSelesaiDt.minute,
              );
              if (now.isAfter(jamSelesaiToday)) {
                isJadwalSelesai = true;
              }
            } catch (_) {}
          }
          // Cek jika sudah lewat jam selesai, hari ini jadwal, dan belum absen hari ini
          if (hariSekarang == hariJadwal && isJadwalSelesai) {
            final todayStr = DateFormat('yyyy-MM-dd').format(now);
            final sudahAbsen = absensiList.any(
              (a) =>
                  a.tanggal == todayStr &&
                  (a.status == 'Hadir' || a.status == 'Terlambat'),
            );
            final sudahTidakHadir = absensiList.any(
              (a) => a.tanggal == todayStr && a.status == 'Tidak Hadir',
            );
            if (!sudahAbsen && !sudahTidakHadir) {
              // Trigger auto-absen Tidak Hadir
              context.read<AbsensiBloc>().add(
                AbsenMasukEvent(
                  siswaId: siswa.id ?? 0,
                  jadwalId: jadwal.id ?? 0,
                  tanggal: todayStr,
                  status: 'Alpa',
                  latitude: 0.0,
                  longitude: 0.0,
                  alamatIp: '',
                  deviceId: '',
                  statusVerifikasi: 'Ditolak',
                  verifikasiAbsensi: 'Terlambat',
                ),
              );
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF328E6E),
          title: const Text(
            'Absensi Siswa',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Placeholder for image
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image, size: 60),
                ),
                const SizedBox(height: 24),
                // Info Siswa
                Column(
                  children: [
                    _InfoRow(
                      icon: Icons.person,
                      label: "Nama Siswa",
                      value: siswa.name ?? '-',
                    ),
                    _InfoRow(
                      icon: Icons.class_,
                      label: "Kelas",
                      value: siswa.rombelName ?? '-',
                    ),
                    _InfoRow(
                      icon: Icons.menu_book,
                      label: "Mata Pelajaran",
                      value: jadwal.mapel ?? '-',
                    ),
                    _InfoRow(
                      icon: Icons.access_time,
                      label: "Jam Masuk - Jam Selesai",
                      value:
                          "${jadwal.jamMulai ?? '-'} - ${jadwal.jamSelesai ?? '-'}",
                    ),
                    _InfoRow(
                      icon: Icons.calendar_today,
                      label: "Tanggal",
                      value: DateFormat('dd MMMM yyyy').format(DateTime.now()),
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<AbsensiBloc, AbsensiState>(
                      builder: (context, state) {
                        final isLoading = state is AbsensiButtonLoading;
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isJadwalSelesai
                                      ? Colors
                                          .red // warna merah jika sudah selesai
                                      : const Color.fromARGB(255, 240, 136, 31),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed:
                                (isLoading || isJadwalSelesai)
                                    ? null
                                    : _absenMasuk,
                            child:
                                isJadwalSelesai
                                    ? const Text(
                                      "Sudah Selesai",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                    )
                                    : isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      "Absen Masuk",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                    ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Tabel Absensi
                BlocBuilder<AbsensiBloc, AbsensiState>(
                  builder: (context, state) {
                    List<TableRow> rows = [
                      TableRow(
                        decoration: const BoxDecoration(
                          color: Color(0xFF328E6E),
                        ),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Tanggal",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Status",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Verifikasi Absensi",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Pertemuan",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ];

                    if (state is AbsensiLoaded) {
                      if (state.absensiList.isEmpty) {
                        rows.add(
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Tidak ada data absensi',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('-', textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('-', textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('-', textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        );
                      } else {
                        rows.addAll(
                          state.absensiList.map(
                            (absensi) => TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    absensi.tanggal ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    absensi.status ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    absensi.verifikasiAbsensi ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    absensi.pertemuan?.toString() ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    } else if (state is AbsensiLoading) {
                      rows.add(
                        TableRow(
                          children: List.generate(
                            4,
                            (_) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                        ),
                      );
                    } else if (state is AbsensiError) {
                      if (state.lastAbsensi.isNotEmpty) {
                        rows.addAll(
                          state.lastAbsensi.map(
                            (absensi) => TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    absensi.tanggal ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    absensi.status ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    absensi.verifikasiAbsensi ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    absensi.pertemuan?.toString() ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        rows.add(
                          TableRow(
                            children: List.generate(
                              4,
                              (_) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("-", textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      rows.add(
                        TableRow(
                          children: List.generate(
                            4,
                            (_) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("-", textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      );
                    }

                    return Table(
                      border: TableBorder.all(color: const Color(0xFF328E6E)),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                      },
                      children: rows,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Text(" : "),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
