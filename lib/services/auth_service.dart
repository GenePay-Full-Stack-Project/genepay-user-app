import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  String? _token;
  String? _userId = '1';

  Future<void> initialize() async {
    // Mock initialization - load token from storage if needed
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<User> getCurrentUser() async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: _userId,
      name: 'John Doe',
      email: 'john@example.com',
      nicNumber: '123456789V',
      phoneNumber: '+94771234567',
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

  Future<void> register({
    required String name,
    required String email,
    required String nicNumber,
    required String phoneNumber,
    required String password,
  }) async {
    // Mock registration
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (name.trim().isEmpty || email.trim().isEmpty || 
        nicNumber.trim().isEmpty || phoneNumber.trim().isEmpty || 
        password.trim().isEmpty) {
      throw Exception('All fields are required');
    }
    
    if (password.length < 8) {
      throw Exception('Password must be at least 8 characters');
    }
    
    // Simulate successful registration
    _userId = '1';
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
