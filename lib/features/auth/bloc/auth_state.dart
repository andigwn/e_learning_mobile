part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthSuccess extends AuthState {
  final int roleId;
  final String token;

  const AuthSuccess({required this.roleId, required this.token});

  @override
  List<Object> get props => [roleId];
}

class AuthError extends AuthState {
  final String errors;

  const AuthError(this.errors);

  @override
  List<Object> get props => [errors];
}
