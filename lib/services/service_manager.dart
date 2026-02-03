import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'user_service.dart';
import 'payment_service.dart';
import 'withdrawal_service.dart';

class ServiceManager {
  static final ServiceManager _instance = ServiceManager._internal();
  factory ServiceManager() => _instance;

  ServiceManager._internal();

  http.Client? _client;
  late AuthService authService;
  late UserService userService;
  late PaymentService paymentService;
  late WithdrawalService withdrawalService;

  // Initialize all services
  Future<void> initialize() async {
    _client = http.Client();

    authService = AuthService(client: _client);
    userService = UserService(client: _client);
    paymentService = PaymentService(client: _client);
    withdrawalService = WithdrawalService(client: _client);

    // Initialize auth service to load stored token
    await authService.initialize();
  }

  // Dispose all services
  void dispose() {
    _client?.close();
  }
}
