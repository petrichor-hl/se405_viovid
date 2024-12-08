import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/auth/data/auth_repository.dart';
import 'package:viovid_app/features/result_type.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginStarted>(_onLoginStarted);
    on<AuthRegisterStarted>(_onRegisterStarted);
  }

  final AuthRepository authRepository;

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
  }

  void _onLoginStarted(AuthLoginStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoginInProgress());
    final result = await authRepository.login(
      email: event.email,
      password: event.password,
    );
    // await Future.delayed(const Duration(seconds: 2));
    return (switch (result) {
      Success() => emit(AuthLoginSuccess()),
      Failure() => emit(AuthLoginFailure(result.message)),
    });
  }

  void _onRegisterStarted(AuthRegisterStarted event, Emitter<AuthState> emit) {}
}
