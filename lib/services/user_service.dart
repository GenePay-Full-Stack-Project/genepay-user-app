import '../models/user.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  String? _authToken;

  Future<void> setAuthToken(String token) async {
    _authToken = token;
  }

  Future<User?> getUserById(String userId) async {
    // Mock implementation - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));
    return User(
      id: userId,
      name: 'John Doe',
      email: 'john.doe@example.com',
      nicNumber: '123456789V',
      phoneNumber: '+94771234567',
      faceEnrolled: false,
    );
  }

  Future<User> updateUser(String userId, Map<String, dynamic> data) async {
    // Mock implementation - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 800));
    return User(
      id: userId,
      name: data['fullName'] ?? 'John Doe',
      email: 'john.doe@example.com',
      nicNumber: '123456789V',
      phoneNumber: data['phoneNumber'] ?? '+94771234567',
      faceEnrolled: false,
    );
  }

  Future<void> linkFace(String userId, String faceId) async {
    // Mock implementation - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 1000));
    // In a real app, this would make an API call to link the face
  }

  Future<void> deleteFace(String userId) async {
    // Mock implementation - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 1000));
    // In a real app, this would make an API call to delete the face
  }
}
