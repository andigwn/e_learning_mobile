import 'package:e_learning_mobile/core/routes/refresh_strem.dart';
import 'package:e_learning_mobile/core/storage/secure_storage.dart';
import 'package:e_learning_mobile/features/absensi/bloc/absensi_bloc.dart';
import 'package:e_learning_mobile/features/absensi/domain/repository/absensi_repository.dart';
import 'package:e_learning_mobile/features/absensi/presentation/absensi.dart';
import 'package:e_learning_mobile/features/auth/persentaion/pages/login/login.dart';
import 'package:e_learning_mobile/features/dashboard/bloc/dash_bloc.dart';
import 'package:e_learning_mobile/features/dashboard/domain/repositories/student_repo.dart';
import 'package:e_learning_mobile/features/dashboard/presentation/pages/siswa/dashboard/siswa.dart';
import 'package:e_learning_mobile/features/jadwal/bloc/jadwal_bloc.dart';
import 'package:e_learning_mobile/features/jadwal/domain/repositories/jadwal_repo.dart';
import 'package:e_learning_mobile/features/jadwal/persentation/jadwal_page.dart';
import 'package:e_learning_mobile/features/splashscreen/splashscreen.dart';
import 'package:e_learning_mobile/features/tugas/bloc/tugas_bloc.dart';
import 'package:e_learning_mobile/features/tugas/domain/respository/tugas_repo.dart';
import 'package:e_learning_mobile/features/tugas/presentation/tugas_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:e_learning_mobile/features/dashboard/data/model/dashboard_model.dart';
import 'package:e_learning_mobile/features/jadwal/data/model/jadwal_model.dart';

part 'route_name.dart';

class AppRouter {
  late final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: Routes.splash,
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const SplashScreen()),
      ),
      GoRoute(
        path: '/login',
        name: Routes.login,
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const LoginPage()),
      ),
      GoRoute(
        path: '/home',
        name: Routes.home,
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const SiswaPage()),
        routes: [
          GoRoute(
            path: 'jadwal',
            name: Routes.jadwal,
            pageBuilder: (context, state) {
              int rombelId = 0;
              if (state.extra is int) {
                rombelId = state.extra as int;
              } else if (state.extra is Map &&
                  (state.extra as Map).containsKey('rombelId')) {
                rombelId = (state.extra as Map)['rombelId'] as int? ?? 0;
              }
              return MaterialPage(
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create:
                          (context) => JadwalBloc(context.read<JadwalRepo>()),
                    ),
                    BlocProvider(
                      create:
                          (context) =>
                              StudentBloc(context.read<StudentRepository>()),
                    ),
                  ],
                  child: JadwalPage(rombelId: rombelId),
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'absensi',
                name: Routes.absensi,
                pageBuilder: (context, state) {
                  var student =
                      state.extra is Map && state.extra != null
                          ? (state.extra as Map)['student']
                          : null;
                  var jadwal =
                      state.extra is Map && state.extra != null
                          ? (state.extra as Map)['jadwal']
                          : null;
                  // Konversi jika bertipe Map (termasuk IdentityMap)
                  if (student != null && student is Map) {
                    student = Student.fromJson(
                      Map<String, dynamic>.from(student),
                    );
                  }
                  if (jadwal != null && jadwal is Map) {
                    jadwal = Jadwal.fromJson(Map<String, dynamic>.from(jadwal));
                  }
                  return MaterialPage(
                    child: BlocProvider(
                      create:
                          (context) =>
                              AbsensiBloc(context.read<AbsensiRepository>()),
                      child: AbsensiPage(student: student, jadwal: jadwal),
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'tugas',
                name: Routes.tugas,
                pageBuilder: (context, state) {
                  int jadwalId = 0;
                  if (state.extra is int) {
                    jadwalId = state.extra as int;
                  } else if (state.extra is Map &&
                      (state.extra as Map).containsKey('jadwalId')) {
                    jadwalId = (state.extra as Map)['jadwalId'] as int? ?? 0;
                  }
                  return MaterialPage(
                    key: state.pageKey,
                    child: BlocProvider(
                      create:
                          (context) =>
                              TugasBloc(context.read<TugasRepo>())
                                ..add(LoadTugas(jadwalId)),
                      child: TugasPage(jadwalId: jadwalId),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) async {
      final isSplash = state.matchedLocation == '/splash';
      final isLogin = state.matchedLocation == '/login';
      final isLoggedIn = await SecureStorage.hasToken();

      // Biarkan splash screen handle redirect internal
      if (isSplash) return null;

      // Redirect ke login jika belum login
      if (!isLoggedIn && !isLogin) {
        return '/login';
      }

      // Redirect ke home jika sudah login tapi mencoba akses login
      if (isLoggedIn && isLogin) {
        return '/home';
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      Stream.periodic(
        const Duration(seconds: 1),
      ).asyncMap((_) => SecureStorage.hasToken()),
    ),
  );
}
