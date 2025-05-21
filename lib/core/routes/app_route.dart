import 'package:e_learning_mobile/core/routes/refresh_strem.dart';
import 'package:e_learning_mobile/core/storage/secure_storage.dart';
import 'package:e_learning_mobile/features/auth/persentaion/pages/login/login.dart';
import 'package:e_learning_mobile/features/dashboard/presentation/pages/siswa/dashboard/siswa.dart';
import 'package:e_learning_mobile/features/splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
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
              return MaterialPage(key: state.pageKey, child: const SiswaPage());
            },
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
