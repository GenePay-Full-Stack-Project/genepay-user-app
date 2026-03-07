import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_response.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.5.166:8080';
  static const String apiPrefix = '/api/v1';

  final http.Client _client;
  String? _authToken;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Try to extract a numeric user id from the stored JWT auth token.
  /// This decodes the token payload without verifying signature and looks
  /// for common claims: `userId`, `id`, or `sub`.
  int? getUserIdFromToken() {
    if (_authToken == null) return null;

    try {
      final parts = _authToken!.split('.');
      if (parts.length < 2) return null;

      String payload = parts[1];

      // Base64Url needs padding to be a multiple of 4
      final mod = payload.length % 4;
      if (mod == 2) payload = '$payload==';
      if (mod == 3) payload = '$payload=';

      final decoded = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> map = jsonDecode(decoded);

      if (map.containsKey('userId')) return (map['userId'] as num?)?.toInt();
      if (map.containsKey('id')) return (map['id'] as num?)?.toInt();
      if (map.containsKey('sub')) {
        final sub = map['sub'];
        if (sub is num) return sub.toInt();
        return int.tryParse(sub.toString());
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Ensure token is loaded then return user id (or null)
  Future<int?> getCurrentUserId() async {
    if (_authToken == null) await initialize();
    return getUserIdFromToken();
  }

  // Initialize service and load stored token
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
  }

  // Set authentication token
  Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Clear authentication token
  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Get authentication headers
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  // Generic GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint,
    T Function(Object? json) fromJson,
  ) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl$apiPrefix$endpoint'),
        headers: _headers,
      );

      return _handleResponse<T>(response, fromJson);
    } on ApiException {
      // If we already created a meaningful ApiException, rethrow it unchanged
      rethrow;
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Generic POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint,
    Map<String, dynamic> body,
    T Function(Object? json) fromJson,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$apiPrefix$endpoint'),
        headers: _headers,
        body: jsonEncode(body),
      );

      return _handleResponse<T>(response, fromJson);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint,
    Map<String, dynamic> body,
    T Function(Object? json) fromJson,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl$apiPrefix$endpoint'),
        headers: _headers,
        body: jsonEncode(body),
      );

      return _handleResponse<T>(response, fromJson);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Generic DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint,
    T Function(Object? json) fromJson,
  ) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl$apiPrefix$endpoint'),
        headers: _headers,
      );

      return _handleResponse<T>(response, fromJson);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Handle HTTP response
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Object? json) fromJson,
  ) {
    try {
      // Try to decode JSON. If the body isn't JSON, fall back to using the
      // raw body as the message so server error details aren't lost.
      Map<String, dynamic> responseBody = {};
      try {
        if (response.body.isNotEmpty) {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) {
            responseBody = decoded;
          } else {
            // If the decoded JSON isn't a map, keep the raw body under "data"
            responseBody = {'data': decoded};
          }
        }
      } catch (e) {
        // Non-JSON response body; include it as the message for easier debugging
        responseBody = {'message': response.body};
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<T>.fromJson(responseBody, fromJson);
      } else {
        // Log details for easier debugging in development
        // ignore: avoid_print
        print(
          'API ERROR ${response.statusCode} ${response.request?.url} - body: ${response.body}',
        );

        final errorMessage =
            responseBody['message'] ?? 'Unknown error occurred';
        throw ApiException(errorMessage, statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to parse response: ${e.toString()}');
    }
  }

  // Get stored token
  String? getToken() {
    return _authToken;
  }
}

// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}
