import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/merchant.dart';

class MerchantService extends ApiService {
  MerchantService({http.Client? client}) : super(client: client);

  // Register merchant
  Future<Merchant> registerMerchant({
    required String name,
    required String email,
    required String businessName,
    required String businessType,
    required String phoneNumber,
    required String password,
  }) async {
    final response = await post<Merchant>(
      '/merchants/register',
      {
        'email': email,
        'password': password,
        'businessName': businessName,
        'ownerName': name,
        'phoneNumber': phoneNumber,
        'businessType': businessType,
      },
      (json) => Merchant.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Login merchant
  Future<Merchant> loginMerchant(String email, String password) async {
    final response = await post<Merchant>('/merchants/login', {
      'email': email,
      'password': password,
    }, (json) => Merchant.fromJson(json as Map<String, dynamic>));

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Get merchant by ID
  Future<Merchant> getMerchantById(int merchantId) async {
    final response = await get<Merchant>(
      '/merchants/$merchantId',
      (json) => Merchant.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Start Stripe Connect onboarding
  Future<Map<String, dynamic>> onboardMerchant(
    int merchantId,
    String refreshUrl,
    String returnUrl,
  ) async {
    final response = await post<Map<String, dynamic>>(
      '/merchants/$merchantId/onboard?refreshUrl=$refreshUrl&returnUrl=$returnUrl',
      {},
      (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Complete onboarding
  Future<Merchant> completeOnboarding(int merchantId, String accountId) async {
    final response = await post<Merchant>(
      '/merchants/$merchantId/complete-onboarding',
      {'accountId': accountId},
      (json) => Merchant.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }

  // Link face biometric to merchant
  Future<Merchant> linkFace(int merchantId, String faceId) async {
    final response = await post<Merchant>(
      '/merchants/$merchantId/link-face',
      {'faceId': faceId},
      (json) => Merchant.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(response.message);
    }
  }
}
