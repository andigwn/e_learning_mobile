import 'package:e_learning_mobile/core/routes/app_route.dart';
import 'package:e_learning_mobile/core/storage/secure_storage.dart';
import 'package:e_learning_mobile/core/utils/validator.dart';
import 'package:e_learning_mobile/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthSuccess) {
          await SecureStorage.saveToken(state.token);

          if (!mounted) return;
          context.goNamed(Routes.home);
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errors)));
        }
      },
      child: Card(
        color: Color(0xFFE1EEBC),
        elevation: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Welcome',
                  style: GoogleFonts.tienne(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Nomor Induk Siswa',
                    prefixIcon: const Icon(Icons.person),
                    labelStyle: GoogleFonts.tienne(),
                  ),
                  validator: Validators.requiredField,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    labelStyle: GoogleFonts.tienne(),
                  ),
                  validator: Validators.requiredField,
                ),
                const SizedBox(height: 30),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF328E6E),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<AuthBloc>().add(
                            LoginSubmitted(
                              username: _usernameController.text.trim(),
                              password: _passwordController.text.trim(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'MASUK',
                        style: GoogleFonts.tienne(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
