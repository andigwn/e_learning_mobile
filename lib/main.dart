import 'package:e_learning_mobile/core/routes/app_route.dart';
import 'package:e_learning_mobile/features/auth/domain/repository/auth_repository.dart';
import 'package:e_learning_mobile/features/dashboard/domain/repositories/student_repo.dart';
import 'package:e_learning_mobile/features/jadwal/domain/repositories/jadwal_repo.dart';
import 'package:e_learning_mobile/features/absensi/domain/repository/absensi_repository.dart';
import 'package:e_learning_mobile/features/tugas/domain/respository/tugas_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider<AuthRepositoryImpl>(
          create: (context) => AuthRepositoryImpl(),
        ),
        RepositoryProvider<StudentRepository>(
          create: (context) => StudentRepository(),
        ),
        RepositoryProvider<JadwalRepo>(create: (context) => JadwalRepo()),
        RepositoryProvider<AbsensiRepository>(
          create: (context) => AbsensiRepository(),
        ),
        RepositoryProvider<TugasRepo>(create: (context) => TugasRepo()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter().router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
