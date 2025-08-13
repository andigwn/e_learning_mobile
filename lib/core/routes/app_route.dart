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
import 'package:e_learning_mobile/features/pengumpulan_tugas/bloc/pengumpulan_tugas_bloc.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/domain/repository/pengumpulan_tugas_repo.dart';
import 'package:e_learning_mobile/features/pengumpulan_tugas/presentation/pengumpulan_tugas.dart';
import 'package:e_learning_mobile/features/splashscreen/splashscreen.dart';
import 'package:e_learning_mobile/features/tugas/bloc/tugas_bloc.dart';
import 'package:e_learning_mobile/features/tugas/domain/respository/tugas_repo.dart';
import 'package:e_learning_mobile/features/tugas/presentation/tugas_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
                  int siswaRombelId = 0;
                  int jadwalId = 0;

                  if (state.extra is Map) {
                    final extra = state.extra as Map<String, dynamic>;
                    siswaRombelId = extra['siswaRombelId'] as int? ?? 0;
                    jadwalId = extra['jadwalId'] as int? ?? 0;
                  }

                  if (siswaRombelId == 0 || jadwalId == 0) {
                    return MaterialPage(
                      child: Scaffold(
                        appBar: AppBar(title: const Text('Error')),
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Data absensi tidak valid',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => context.pop(),
                                child: const Text('Kembali'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return MaterialPage(
                    child: BlocProvider(
                      create:
                          (context) =>
                              AbsensiBloc(context.read<AbsensiRepository>()),
                      child: AbsensiPage(
                        siswaRombelId: siswaRombelId,
                        jadwalId: jadwalId,
                      ),
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
                routes: [
                  GoRoute(
                    path: "pengumpulan-tugas",
                    name: Routes.pengumpulanTugas,
                    pageBuilder: (context, state) {
                      // Validasi dan ekstrak parameter dengan aman
                      if (state.extra is! Map<String, dynamic>) {
                        return _buildErrorPage(
                          context,
                          "Format data tidak valid",
                        );
                      }

                      final args = state.extra as Map<String, dynamic>;
                      final siswaRombelId = args['siswaRombelId'] as int?;
                      final tugasId = args['tugasId'] as int?;

                      if (siswaRombelId == null || tugasId == null) {
                        return _buildErrorPage(
                          context,
                          "Data siswa atau tugas tidak valid",
                        );
                      }

                      return MaterialPage(
                        key: state.pageKey,
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create:
                                  (context) => PengumpulanTugasBloc(
                                    context.read<PengumpulanTugasRepository>(),
                                  ),
                            ),
                          ],
                          child: PengumpulanTugasPage(
                            siswaRombelId: siswaRombelId,
                            tugasId: tugasId,
                          ),
                        ),
                      );
                    },
                  ),
                ],
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

  // Helper untuk halaman error
  MaterialPage _buildErrorPage(BuildContext context, String message) {
    return MaterialPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
