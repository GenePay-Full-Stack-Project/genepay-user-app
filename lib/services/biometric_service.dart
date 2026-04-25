import 'dart:convert';
import 'package:http/http.dart' as http;

class BiometricService {
  static const String _biometricBaseUrl = String.fromEnvironment(
    'BIOMETRIC_BASE_URL',
    defaultValue: 'http://54.255.53.212',
  );

  final http.Client _client;

  BiometricService({http.Client? client}) : _client = client ?? http.Client();

  Future<EnrollFaceResponse> enrollFace({
    required int userId,
    required String imageBase64,
  }) async {
    try {
      final url = Uri.parse('$_biometricBaseUrl/biometric/enroll');

      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'image_base64': imageBase64}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return EnrollFaceResponse.fromJson(data);
      } else {
        String errorMessage = 'Face enrollment failed';
        try {
          final error = jsonDecode(response.body);
          if (error is Map<String, dynamic>) {
            if (error['detail'] is List) {
              errorMessage = (error['detail'] as List)
                  .map((e) => e['msg'] ?? e.toString())
                  .join(', ');
            } else if (error['detail'] is String) {
              errorMessage = error['detail'];
            } else if (error['message'] is String) {
              errorMessage = error['message'];
            }
          }
        } catch (_) {
          if (response.body.isNotEmpty) errorMessage = response.body;
        }
        throw BiometricException(errorMessage, statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is BiometricException) rethrow;
      throw BiometricException('Network error: ${e.toString()}');
    }
  }
}

class EnrollFaceResponse {
  final bool success;
  final String message;
  final String? faceId;
  final bool livenessPasssed;
  final double? livenessConfidence;
  final double? qualityScore;

  EnrollFaceResponse({
    required this.success,
    required this.message,
    this.faceId,
    required this.livenessPasssed,
    this.livenessConfidence,
    this.qualityScore,
  });

  factory EnrollFaceResponse.fromJson(Map<String, dynamic> json) {
    return EnrollFaceResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? 'Unknown error',
      faceId: json['face_id'] as String?,
      livenessPasssed: json['liveness_passed'] as bool? ?? false,
      livenessConfidence: (json['liveness_confidence'] as num?)?.toDouble(),
      qualityScore: (json['quality_score'] as num?)?.toDouble(),
    );
  }
}

class BiometricException implements Exception {
  final String message;
  final int? statusCode;

  BiometricException(this.message, {this.statusCode});

  @override
  String toString() =>
      'BiometricException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}
