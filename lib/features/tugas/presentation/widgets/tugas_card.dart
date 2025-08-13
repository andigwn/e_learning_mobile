// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_learning_mobile/core/routes/app_route.dart';
import 'package:e_learning_mobile/features/tugas/data/model/tugas_model.dart';
import '../../../../utils/download_utils.dart';

class TugasCard extends StatefulWidget {
  final Tugas tugas;
  final int? siswaRombelId;

  const TugasCard({
    super.key,
    required this.tugas,
    required this.siswaRombelId,
  });

  @override
  State<TugasCard> createState() => _TugasCardState();
}

class _TugasCardState extends State<TugasCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..translate(0.0, _isHovering ? -4.0 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(_isHovering ? 0.2 : 0.1),
              spreadRadius: _isHovering ? 2 : 1,
              blurRadius: _isHovering ? 10 : 6,
              offset: const Offset(0, 3),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, theme.primaryColor.withOpacity(0.03)],
          ),
          border: Border.all(
            color: theme.primaryColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.assignment,
                          color: theme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tugas.judul ?? 'Tugas Tanpa Judul',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: theme.primaryColorDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (widget.tugas.deskripsi != null &&
                                widget.tugas.deskripsi!.isNotEmpty)
                              Text(
                                widget.tugas.deskripsi!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (widget.tugas.deadline != null)
                    _buildDeadlineBadge(context),
                  const SizedBox(height: 16),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeadlineBadge(BuildContext context) {
    Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: Colors.orange.shade700, size: 18),
          const SizedBox(width: 8),
          Text(
            'Deadline: ${widget.tugas.deadline}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        if (widget.tugas.filePetunjuk != null &&
            widget.tugas.filePetunjuk!.isNotEmpty)
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: OutlinedButton.icon(
                onPressed:
                    () => downloadFile(context, widget.tugas.filePetunjuk!),
                icon: const Icon(Icons.download),
                label: const Text('Unduh Petunjuk'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.primaryColor,
                  side: BorderSide(color: theme.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        if (widget.tugas.filePetunjuk != null &&
            widget.tugas.filePetunjuk!.isNotEmpty)
          const SizedBox(width: 12),
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()..scale(_isHovering ? 1.02 : 1.0),
            child: ElevatedButton(
              onPressed: () => _handleKerjakanButton(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: theme.primaryColor.withOpacity(0.3),
                elevation: 4,
              ),
              child: const Text(
                'Kerjakan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleKerjakanButton(BuildContext context) {
    if (widget.siswaRombelId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mendapatkan data siswa'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (widget.tugas.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tugas tidak valid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.goNamed(
      Routes.pengumpulanTugas,
      extra: {
        'siswaRombelId': widget.siswaRombelId!,
        'tugasId': widget.tugas.id!,
      },
    );
  }
}
