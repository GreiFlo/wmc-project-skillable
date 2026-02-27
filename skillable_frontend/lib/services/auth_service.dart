import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skillable_frontend/models/auth-models/auth_respons.dart';

class AuthException implements Exception {
  final String message;
  final int? statusCode;

  AuthException(this.message, {this.statusCode});

  @override
  String toString() => 'AuthException($statusCode): $message';
}

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3000/auth';
  final http.Client _client;

  AuthService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/register');

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    return _handleResponse(response);
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/login');

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return _handleResponse(response);
  }

  AuthResponse _handleResponse(http.Response response) {
    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(body);
    }

    final errorMessage =
        body['error'] as String? ?? 'Unknown error (${response.statusCode})';

    throw AuthException(errorMessage, statusCode: response.statusCode);
  }

  void dispose() => _client.close();
}