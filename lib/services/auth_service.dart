import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  String? _token;
  String? _userId = '1';

  Future<User> getCurrentUser() async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: _userId,
      name: 'John Doe',
      email: 'john@example.com',
      faceEnrolled: false,
    );
  }

  Future<String?> getCurrentUserId() async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 200));
    return _userId;
  }

  Future<void> login(String nic, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (nic.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Invalid credentials');
    }

    _userId = '1';
    _token = 'mock-token';
  }

  String? getToken() => _token;

  Future<void> setToken(String token) async {
    _token = token;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
  }
}
