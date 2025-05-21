import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/core/storage/secure_storage.dart';
import 'package:e_learning_mobile/features/auth/domain/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginSubmitted>(_handleLogin);
  }

  Future<void> _handleLogin(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await repository.login(event.username, event.password);
      await SecureStorage.saveToken(response.data.token);
      await SecureStorage.saveInt('role_id', response.data.id_role);
      emit(
        AuthSuccess(roleId: response.data.id_role, token: response.data.token),
      );
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
