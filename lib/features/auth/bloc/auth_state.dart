part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthInitial extends AuthState {}

// REGISTER
class AuthRegisterInProgress extends AuthState {}

class AuthRegisterSuccess extends AuthState {}

class AuthRegisterFailure extends AuthState {
  AuthRegisterFailure(this.message);

  final String message;
}

// LOGIN
class AuthLoginInProgress extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthLoginFailure extends AuthState {
  AuthLoginFailure(this.message);

  final String message;
}

// LOGOUT
class AuthLogoutInProgress extends AuthState {}

class AuthLogoutFailure extends AuthState {
  AuthLogoutFailure(this.message);

  final String message;
}
