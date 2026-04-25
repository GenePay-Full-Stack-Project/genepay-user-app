import 'api_service.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/user.dart';
import 'user_service.dart';
import '../models/token_verify_response.dart';

class AuthService extends ApiService {
  AuthService({super.client});

  // User login
  Future<AuthResponse> login(String nicNumber, String password) async {
    final loginRequest = LoginRequest(nicNumber: nicNumber, password: password);

    final response = await post<AuthResponse>(
      '/users/login',
      loginRequest.toJson(),
      (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      // Store the authentication token
      await setAuthToken(response.data!.token);
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // User registration
  Future<User> register({
    required String name,
    required String email,
    required String nicNumber,
    required String phoneNumber,
    String? password,
  }) async {
    final registerRequest = RegisterRequest(
      fullName: name,
      email: email,
      nicNumber: nicNumber,
      phoneNumber: phoneNumber,
      password: password,
    );

    final response = await post<User>(
      '/users/register',
      registerRequest.toJson(),
      (json) => User.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Get current user profile
  Future<User> getCurrentUser() async {
    // Some backends route unknown paths like `/users/profile` into
    // the `GET /users/{userId}` handler which attempts to parse the
    // value as a number and causes a 500. To avoid that, directly
    // resolve the user id from the stored JWT and call `/users/{id}`.
    await initialize();
    final id = await getCurrentUserId();
    if (id == null) throw ApiException('Unable to resolve current user id');

    final userService = UserService();
    if (getToken() != null) await userService.setAuthToken(getToken()!);
    return userService.getUserById(id);
  }

  // Note: ApiService already provides getCurrentUserId() which is async.

  // Logout (clear token)
  Future<void> logout() async {
    await clearAuthToken();
  }

  // Check if user is authenticated by fetching the current user profile.
  // This validates the token AND confirms the user still exists in the DB.
  Future<bool> isAuthenticated() async {
    await initialize();
    final token = getToken();
    if (token == null || token.isEmpty) return false;
    try {
      final user = await getCurrentUser();
      return user.id != null;
    } catch (_) {
      return false;
    }
  }

  // Send verification code
  Future<void> sendVerificationCode(String email) async {
    final response = await post<void>('/users/send-verification-code', {
      'email': email,
    }, (json) {});

    if (!response.success) {
      throw ApiException(response.message);
    }
  }

  // Verify JWT token by calling backend /users/verify-token
  Future<TokenVerifyResponse> verifyToken(String token) async {
    final response = await post<TokenVerifyResponse>(
      '/users/verify-token',
      {'token': token},
      (json) => TokenVerifyResponse.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }
    throw ApiException(response.message);
  }

  // Verify email
  Future<void> verifyEmail(String email, String code) async {
    final response = await post<void>('/users/verify-email', {
      'email': email,
      'verificationCode': code,
    }, (json) {});

    if (!response.success) {
      throw ApiException(response.message);
    }
  }
}
