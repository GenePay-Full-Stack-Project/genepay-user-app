import 'api_service.dart';
import '../models/transaction.dart';

class PaymentService extends ApiService {
  PaymentService({super.client});

  // Initiate payment
  Future<Transaction> initiatePayment({
    required int userId,
    required int merchantId,
    required double amount,
    required String currency,
    String? description,
  }) async {
    final response = await post<Transaction>(
      '/payments/initiate?userId=$userId',
      {
        'merchantId': merchantId,
        'amount': amount,
        'currency': currency,
        'description': description,
      },
      (json) => Transaction.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Verify payment with biometric
  Future<Transaction> verifyPayment(
    String transactionId,
    String faceData,
  ) async {
    final response = await post<Transaction>(
      '/payments/verify',
      {'transactionId': transactionId, 'faceData': faceData},
      (json) => Transaction.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Get transaction by ID
  Future<Transaction> getTransaction(int transactionId) async {
    final response = await get<Transaction>(
      '/payments/$transactionId',
      (json) => Transaction.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Get user transactions
  Future<List<Transaction>> getUserTransactions(int userId) async {
    final response = await get<List<Transaction>>('/payments/user/$userId', (
      json,
    ) {
      // Handle paginated response structure: data.content
      if (json is Map<String, dynamic> && json.containsKey('content')) {
        final content = json['content'];
        if (content is List) {
          return content
              .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      // Fallback: handle direct list response
      if (json is List) {
        return json
            .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    });

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Get merchant transactions
  Future<List<Transaction>> getMerchantTransactions(int merchantId) async {
    final response = await get<List<Transaction>>(
      '/payments/merchant/$merchantId',
      (json) {
        // Handle paginated response structure: data.content
        if (json is Map<String, dynamic> && json.containsKey('content')) {
          final content = json['content'];
          if (content is List) {
            return content
                .map(
                  (item) => Transaction.fromJson(item as Map<String, dynamic>),
                )
                .toList();
          }
        }
        // Fallback: handle direct list response
        if (json is List) {
          return json
              .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Refund transaction
  Future<Transaction> refundTransaction(
    int transactionId, {
    String? reason,
  }) async {
    final response = await post<Transaction>(
      '/payments/$transactionId/refund',
      {'reason': reason},
      (json) => Transaction.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Get user total spends
  Future<double> getUserTotalSpends(int userId) async {
    final response = await get<double>(
      '/payments/user/$userId/total-spends',
      (json) => (json as num).toDouble(),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }
}
