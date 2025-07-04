import 'package:e_learning_mobile/core/storage/secure_storage.dart';
import 'package:e_learning_mobile/features/dashboard/bloc/dash_bloc.dart';
import 'package:e_learning_mobile/features/dashboard/data/model/dashboard_model.dart';
import 'package:e_learning_mobile/features/dashboard/domain/repositories/student_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDashboardPage extends StatelessWidget {
  const StudentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              StudentBloc(context.read<StudentRepository>())
                ..add(LoadStudentProfile()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard Siswa'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await SecureStorage.clearAuthData();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
        body: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StudentError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    ElevatedButton(
                      onPressed: () {
                        context.read<StudentBloc>().add(LoadStudentProfile());
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            } else if (state is StudentProfileLoaded) {
              return _buildDashboardContent(state.student);
            }
            return const Center(child: Text('Data belum dimuat'));
          },
        ),
      ),
    );
  }

  Widget _buildDashboardContent(Student student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Tampilkan data siswa
          Text('Nama: ${student.name}'),
          Text('NIS: ${student.nis}'),
          // Text('Kelas: ${student.classroom}'),
          // ... widget lainnya
        ],
      ),
    );
  }
}
