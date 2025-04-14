abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String accessToken;
  final Map<String, dynamic>? userProfile;

  AuthAuthenticated({
    required this.accessToken,
    this.userProfile,
  });
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}