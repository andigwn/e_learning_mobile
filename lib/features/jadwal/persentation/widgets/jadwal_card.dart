import 'package:e_learning_mobile/core/routes/app_route.dart';
import 'package:e_learning_mobile/features/dashboard/data/model/dashboard_model.dart';
import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JadwalCard extends StatefulWidget {
  final Jadwal jadwal;
  final DashboardResponse siswaRombel;
  final VoidCallback? onTap;

  const JadwalCard({
    super.key,
    required this.jadwal,
    required this.siswaRombel,
    this.onTap,
  });

  @override
  State<JadwalCard> createState() => _JadwalCardState();
}

class _JadwalCardState extends State<JadwalCard> {
  bool _isHovered = false;

  // Helper methods to get nested data
  String get mapelName {
    return widget.jadwal.guruMapel.mapel['nama_mapel'] ?? 'Mata Pelajaran';
  }

  String get guruName {
    return widget.jadwal.guruMapel.guru['nama'] ?? 'Guru';
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: widget.onTap,
            splashColor: Colors.teal.shade100,
            highlightColor: Colors.teal.shade50,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF5FBF8), Color(0xFFE9F5D6)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 12),
                    _buildScheduleInfo(context),
                    const SizedBox(height: 16),
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF328E6E),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mapelName.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1.1,
                  color: Color(0xFF1A5D46),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                guruName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal.shade100),
          ),
          child: Text(
            widget.jadwal.hari.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF328E6E),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: Colors.teal.shade700),
              const SizedBox(width: 8),
              Text(
                widget.jadwal.jamMulai.format(context),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            '—',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Text(
                widget.jadwal.jamSelesai.format(context),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Icon(Icons.timer_outlined, size: 18, color: Colors.teal.shade700),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF328E6E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            icon: const Icon(Icons.login, size: 18),
            label: const Text('Masuk Kelas'),
            onPressed:
                () => context.goNamed(
                  Routes.absensi,
                  extra: {
                    'siswaRombelId': widget.siswaRombel.id,
                    'jadwalId': widget.jadwal.id,
                  },
                ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: IconButton(
            icon: Icon(Icons.assignment, color: Colors.teal.shade700),
            onPressed:
                () => context.goNamed(
                  Routes.tugas,
                  extra: {'jadwalId': widget.jadwal.id},
                ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
