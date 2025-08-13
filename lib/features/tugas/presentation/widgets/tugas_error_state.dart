import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:e_learning_mobile/features/tugas/bloc/tugas_bloc.dart';

class TugasErrorState extends StatelessWidget {
  final String message;
  final int jadwalId;

  const TugasErrorState({
    super.key,
    required this.message,
    required this.jadwalId,
  });

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
              'assets/animations/error.json',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24),
            Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed:
                  () => context.read<TugasBloc>().add(LoadTugas(jadwalId)),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                elevation: 3,
                // ignore: deprecated_member_use
                shadowColor: theme.primaryColor.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
