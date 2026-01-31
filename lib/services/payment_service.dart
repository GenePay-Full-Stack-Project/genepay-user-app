import '../models/transaction.dart';

class PaymentService {
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
        amount: 2500.00,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: TransactionStatus.completed,
      ),
      Transaction(
        id: '2',
        merchantName: 'Gas Station',
        amount: 5000.00,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        status: TransactionStatus.completed,
      ),
    ];
  }
}
