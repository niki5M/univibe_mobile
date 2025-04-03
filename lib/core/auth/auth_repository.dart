import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
          scopes: ['openid', 'profile', 'email'],
        ),
      );

      if (result != null) {
        print("Access Token: ${result.accessToken}");
        print("Refresh Token: ${result.refreshToken}");
        print("ID Token: ${result.idToken}");

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

  Future<Map<String, dynamic>?> fetchUserProfile(String accessToken) async {
    final userInfoUrl =
        'https://keycloak.univibe.ru/realms/univibe/protocol/openid-connect/userinfo';

    try {
      final response = await http.get(
        Uri.parse(userInfoUrl),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Failed to fetch user profile: ${response.body}");
        return null;
      }
    } catch (e) {
      print("User profile fetch error: $e");
      return null;
    }
  }

  Future<void> logout(String idToken) async {
    final logoutUrl =
        'https://keycloak.univibe.ru/realms/univibe/protocol/openid-connect/logout';

    try {
      final response = await http.post(
        Uri.parse(logoutUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'id_token_hint': idToken, 'client_id': _clientId},
      );

      if (response.statusCode == 200) {
        print("Logout successful");
      } else {
        print("Logout failed: ${response.body}");
      }
    } catch (e) {
      print("Logout error: $e");
    }
  }
}