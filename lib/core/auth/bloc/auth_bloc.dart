import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  String? idToken;
  Map<String, dynamic>? userProfile;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      final authData = await authRepository.login();
      if (authData != null) {
        idToken = authData['idToken'];
        userProfile = authData['userProfile'];
        emit(AuthAuthenticated(
          accessToken: authData['accessToken']!,
          userProfile: userProfile,
        ));
      } else {
        emit(AuthError("Ошибка авторизации"));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      if (idToken != null) {
        await authRepository.logout(idToken!);
      }
      idToken = null;
      userProfile = null;
      emit(AuthInitial());
    });
  }
}