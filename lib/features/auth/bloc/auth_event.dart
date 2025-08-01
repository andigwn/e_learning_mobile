part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;

  const LoginSubmitted({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}
