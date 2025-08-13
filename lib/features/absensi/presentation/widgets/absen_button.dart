// lib/features/absensi/presentation/widgets/absen_button.dart
import 'package:flutter/material.dart';
import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';

class AbsenButton extends StatelessWidget {
  final bool isDisabled;
  final bool isSubmitting;
  final bool isBelumMulai;
  final bool isJadwalSelesai;
  final bool isHariJadwal;
  final Jadwal jadwal;
  final VoidCallback onPressed;
  final String? errorMessage;

  const AbsenButton({
    super.key,
    required this.isDisabled,
    required this.isSubmitting,
    required this.isBelumMulai,
    required this.isJadwalSelesai,
    required this.isHariJadwal,
    required this.jadwal,
    required this.onPressed,
    this.errorMessage,
  });

  String _getButtonText() {
    if (isBelumMulai) return 'BELUM WAKTU ABSEN';
    if (isJadwalSelesai) return 'WAKTU ABSEN BERAKHIR';
    if (!isHariJadwal) return 'BUKAN HARI JADWAL';
    return 'ABSEN MASUK SEKARANG';
  }

  String _getStatusText(BuildContext context) {
    if (isBelumMulai) {
      return 'Absen akan mulai pada ${jadwal.jamMulai.format(context)}';
    }
    if (isJadwalSelesai) {
      return 'Waktu absen untuk jadwal ini sudah berakhir';
    }
    if (!isHariJadwal) {
      return 'Hari ini bukan jadwal ${jadwal.hari.name}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final statusText = _getStatusText(context);

    return Column(
      children: [
        if (errorMessage != null && errorMessage!.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red[100]!),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.red.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red[700], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient:
                isDisabled
                    ? LinearGradient(
                      colors: [Colors.grey[400]!, Colors.grey[600]!],
                    )
                    : LinearGradient(
                      colors: [Colors.green[700]!, Colors.green[900]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            boxShadow:
                isDisabled
                    ? null
                    : [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.green.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: isDisabled ? null : onPressed,
            child:
                isSubmitting
                    ? const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                    : Text(
                      _getButtonText(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
          ),
        ),
        if (statusText.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            statusText,
            style: TextStyle(
              color: isBelumMulai ? Colors.blue[800] : Colors.red[700],
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}
