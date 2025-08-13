import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TugasEmptyState extends StatelessWidget {
  const TugasEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/empty.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            Text(
              'Belum Ada Tugas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Saat ini tidak ada tugas yang tersedia.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Silakan periksa kembali nanti',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
