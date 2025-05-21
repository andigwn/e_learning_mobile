import 'package:e_learning_mobile/features/auth/bloc/auth_bloc.dart';
import 'package:e_learning_mobile/features/auth/domain/repository/auth_repository.dart';
import 'package:e_learning_mobile/features/auth/persentaion/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background dua warna
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      flex: 6, // 60% hijau
                      child: Container(color: const Color(0xFF328E6E)),
                    ),
                    Expanded(
                      flex: 4, // 40% putih
                      child: Container(color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Konten utama
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 80),
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            child: const Icon(
                              Icons.people,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Contoh konten
                        BlocProvider(
                          create: (context) => AuthBloc(AuthRepositoryImpl()),
                          child: const LoginForm(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
