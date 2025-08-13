// lib/features/absensi/presentation/widgets/student_info_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_learning_mobile/features/dashboard/data/model/dashboard_model.dart';
import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';

class StudentInfoCard extends StatelessWidget {
  final DashboardResponse siswaRombel;
  final Jadwal jadwal;
  final bool isBelumMulai;
  final bool isJadwalSelesai;
  final bool isHariJadwal;

  const StudentInfoCard({
    super.key,
    required this.siswaRombel,
    required this.jadwal,
    required this.isBelumMulai,
    required this.isJadwalSelesai,
    required this.isHariJadwal,
  });

  String _getMapelName() {
    return jadwal.guruMapel.mapel['nama_mapel'] ?? '-';
  }

  String _getJamSelesai(BuildContext context) {
    try {
      final jamSelesaiStr = jadwal.jamSelesai.format(context);
      final jamSelesaiDt = DateFormat('HH:mm').parse(jamSelesaiStr);
      return DateFormat('HH:mm').format(jamSelesaiDt);
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFE8F5E9)],
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.green.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.fingerprint, color: Colors.green, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Informasi Absensi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.person,
              label: "Nama Siswa",
              value: siswaRombel.siswa.name,
            ),
            _InfoRow(
              icon: Icons.class_,
              label: "Kelas",
              value: siswaRombel.rombel.nama,
            ),
            _InfoRow(
              icon: Icons.menu_book,
              label: "Mata Pelajaran",
              value: _getMapelName(),
            ),
            _InfoRow(
              icon: Icons.access_time,
              label: "Jam Pelajaran",
              value:
                  "${jadwal.jamMulai.format(context)} - ${_getJamSelesai(context)}",
            ),
            _InfoRow(
              icon: Icons.calendar_today,
              label: "Tanggal",
              value: DateFormat(
                'EEEE, dd MMMM yyyy',
                'id_ID',
              ).format(DateTime.now()),
            ),
            if (isBelumMulai) ...[
              const SizedBox(height: 12),
              _StatusInfoCard(
                message:
                    'Absen akan mulai pada ${jadwal.jamMulai.format(context)}',
                color: Colors.blue[700]!,
                icon: Icons.access_time,
              ),
            ],
            if (isJadwalSelesai) ...[
              const SizedBox(height: 12),
              _StatusInfoCard(
                message: 'Waktu absen berakhir pada ${_getJamSelesai(context)}',
                color: Colors.orange[700]!,
                icon: Icons.timer_off,
              ),
            ],
            if (!isHariJadwal) ...[
              const SizedBox(height: 12),
              _StatusInfoCard(
                message: 'Hari ini bukan jadwal ${jadwal.hari.name}',
                color: Colors.orange[700]!,
                icon: Icons.calendar_today,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusInfoCard extends StatelessWidget {
  final String message;
  final Color color;
  final IconData icon;

  const _StatusInfoCard({
    required this.message,
    required this.color,
    this.icon = Icons.info,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        // ignore: deprecated_member_use
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: Colors.green[700]),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
