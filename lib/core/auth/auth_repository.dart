import 'package:flutter_appauth/flutter_appauth.dart';

class AuthRepository {
  final FlutterAppAuth _appAuth = FlutterAppAuth();

  final String _clientId = "mobile-client-id";
  final String _redirectUrl = "com.example.unimobile.auth://*";
  final String _issuer = "https://keycloak.univibe.ru/realms/univibe";

  final AuthorizationServiceConfiguration _serviceConfiguration =
  const AuthorizationServiceConfiguration(
    authorizationEndpoint:
    'https://keycloak.univibe.ru/realms/univibe/protocol/openid-connect/auth',
    tokenEndpoint:
    'https://keycloak.univibe.ru/realms/univibe/protocol/openid-connect/token',
    endSessionEndpoint:
    'https://keycloak.univibe.ru/realms/univibe/protocol/openid-connect/logout',
  );

  Future<Map<String, String>?> login() async {
    try {
      final AuthorizationTokenResponse? result =
      await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          serviceConfiguration: _serviceConfiguration,
          scopes: ['openid'],
        ),
      );

      if (result != null) {
        return {
          'accessToken': result.accessToken ?? '',
          'refreshToken': result.refreshToken ?? '',
          'idToken': result.idToken ?? '',
        };
      }
      return null;
    } catch (e) {
      print('Authorization error: $e');
      return null;
    }
  }
}