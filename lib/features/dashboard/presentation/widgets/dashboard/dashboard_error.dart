import 'package:e_learning_mobile/features/dashboard/bloc/dash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardError extends StatelessWidget {
  final String message;
  const DashboardError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<StudentBloc>().add(LoadStudentDashboard());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Coba Lagi',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
