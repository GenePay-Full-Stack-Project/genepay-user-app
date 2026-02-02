import 'auth_service.dart';

class ServiceManager {
  static final ServiceManager _instance = ServiceManager._internal();

  factory ServiceManager() => _instance;

  ServiceManager._internal();

  final AuthService authService = AuthService();
}
