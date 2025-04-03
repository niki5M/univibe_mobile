import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      final authData = await authRepository.login();
      if (authData != null) {
        emit(AuthAuthenticated(authData['accessToken']!));
      } else {
        emit(AuthError("Ошибка авторизации"));
      }
    });

    on<AuthLogoutRequested>((event, emit) {
      emit(AuthInitial());
    });
  }
}