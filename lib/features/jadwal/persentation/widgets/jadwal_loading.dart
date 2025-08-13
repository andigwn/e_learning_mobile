import 'package:flutter/material.dart';

class JadwalLoadingWidget extends StatelessWidget {
  const JadwalLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              color: const Color(0xFF328E6E),
              backgroundColor: Colors.teal.shade100,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Memuat Jadwal Pelajaran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mohon tunggu sebentar...',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
