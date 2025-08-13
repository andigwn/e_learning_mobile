import 'package:e_learning_mobile/core/routes/app_route.dart';
import 'package:e_learning_mobile/core/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initRedirect();
  }

  Future<void> _initRedirect() async {
    // Delay minimal untuk tampilan splash (opsional)
    await Future.delayed(const Duration(seconds: 2));

    // Biarkan GoRouter yang handle redirect via logic di AppRouter
    final authStatus = await SecureStorage.getAuthStatus();

    if (!mounted) return;

    if (authStatus['hasToken']) {
      switch (authStatus['roleId']) {
        case 1:
          context.goNamed(Routes.home);
          break;
        default:
          context.goNamed(Routes.login);
      }
    } else {
      context.goNamed(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF328E6E),
      body: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 500),
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
