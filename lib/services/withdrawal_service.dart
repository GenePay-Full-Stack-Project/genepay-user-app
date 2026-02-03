import 'api_service.dart';
import '../models/withdrawal.dart';

class WithdrawalService extends ApiService {
  WithdrawalService({super.client});

  // Request withdrawal
  Future<Withdrawal> requestWithdrawal({
    required int merchantId,
    required double amount,
    required String currency,
    String? description,
  }) async {
    final response = await post<Withdrawal>(
      '/withdrawals/request?merchantId=$merchantId',
      {'amount': amount, 'currency': currency, 'notes': description},
      (json) => Withdrawal.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Get withdrawal by ID
  Future<Withdrawal> getWithdrawal(int withdrawalId) async {
    final response = await get<Withdrawal>(
      '/withdrawals/$withdrawalId',
      (json) => Withdrawal.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Get merchant withdrawals
  Future<List<Withdrawal>> getMerchantWithdrawals(int merchantId) async {
    final response = await get<List<Withdrawal>>(
      '/withdrawals/merchant/$merchantId',
      (json) {
        if (json is List) {
          return json
              .map((item) => Withdrawal.fromJson(item as Map<String, dynamic>))
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

  // Get all withdrawals (admin)
  Future<List<Withdrawal>> getAllWithdrawals() async {
    final response = await get<List<Withdrawal>>('/withdrawals/all', (json) {
      if (json is List) {
        return json
            .map((item) => Withdrawal.fromJson(item as Map<String, dynamic>))
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

  // Approve withdrawal
  Future<Withdrawal> approveWithdrawal(int withdrawalId) async {
    final response = await post<Withdrawal>(
      '/withdrawals/$withdrawalId/approve',
      {},
      (json) => Withdrawal.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Cancel withdrawal
  Future<Withdrawal> cancelWithdrawal(int withdrawalId) async {
    final response = await post<Withdrawal>(
      '/withdrawals/$withdrawalId/cancel',
      {},
      (json) => Withdrawal.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }
}
