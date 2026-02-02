import '../models/transaction.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();

  factory PaymentService() {
    return _instance;
  }

  PaymentService._internal();

  String? _authToken;

  Future<void> initialize() async {
    // Initialize payment service
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> setAuthToken(String token) async {
    _authToken = token;
  }

  Future<List<Transaction>> getUserTransactions(String userId) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    return [
      Transaction(
        id: '1',
        merchantName: 'Supermarket',
        merchantId: 'merchant_1',
        amount: 2500.00,
        currency: 'LKR',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: TransactionStatus.completed,
        type: TransactionType.payment,
        biometricVerified: true,
      ),
      Transaction(
        id: '2',
        merchantName: 'Gas Station',
        merchantId: 'merchant_2',
        amount: 5000.00,
        currency: 'LKR',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        status: TransactionStatus.completed,
        type: TransactionType.payment,
        biometricVerified: true,
      ),
    ];
  }

  Future<double> getUserTotalSpends(String userId) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
    return 12500.00;
  }
}
