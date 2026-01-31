import '../models/user.dart';

class AuthService {
  String? _token;

  Future<User> getCurrentUser() async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      faceEnrolled: false,
    );
  }

  String? getToken() => _token;

  Future<void> setToken(String token) async {
    _token = token;
  }

  Future<void> logout() async {
    _token = null;
  }
}
