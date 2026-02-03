import 'api_service.dart';
import '../models/user.dart';

class UserService extends ApiService {
  UserService({super.client});

  // Get user by ID
  Future<User> getUserById(int userId) async {
    final response = await get<User>(
      '/users/$userId',
      (json) => User.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Get user by email
  Future<User> getUserByEmail(String email) async {
    final response = await get<User>(
      '/users/email/$email',
      (json) => User.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Link card to user
  Future<User> linkCard(int userId, String paymentMethodToken) async {
    final response = await post<User>(
      '/users/$userId/link-card',
      {'paymentMethodToken': paymentMethodToken},
      (json) => User.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Link face biometric to user
  Future<User> linkFace(int userId, String faceId) async {
    final response = await post<User>(
      '/users/$userId/link-face',
      {'faceId': faceId},
      (json) => User.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Update user profile (if backend supports PUT /users/{userId})
  Future<User> updateUser(int userId, Map<String, dynamic> updateData) async {
    final response = await put<User>(
      '/users/$userId',
      updateData,
      (json) => User.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Delete face biometric for user
  Future<User> deleteFace(int userId) async {
    final response = await delete<User>(
      '/users/$userId/delete-face',
      (json) => User.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }
}
