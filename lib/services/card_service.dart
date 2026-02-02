import '../models/card_model.dart';
import '../models/add_card_request.dart';
import 'auth_service.dart';

class CardService {
  static final CardService _instance = CardService._internal();

  factory CardService() {
    return _instance;
  }

  CardService._internal();

  String? _authToken;

  Future<void> initialize() async {
    // Initialize card service
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> setAuthToken(String token) async {
    _authToken = token;
  }

  Future<CardModel?> getUserDefaultCard(String userId) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 800));
    return CardModel(
      id: '1',
      cardLast4: '1234',
      cardType: 'Visa',
      cardBrand: 'Visa',
      isDefault: true,
    );
  }

  Future<List<CardModel>> getUserCards(String userId) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      CardModel(
        id: '1',
        cardLast4: '1234',
        cardType: 'Visa',
        cardBrand: 'Visa',
        isDefault: true,
      ),
      CardModel(
        id: '2',
        cardLast4: '5678',
        cardType: 'Mastercard',
        cardBrand: 'Mastercard',
        isDefault: false,
      ),
    ];
  }

  Future<void> setUserDefaultCard(String userId, String cardId) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, this would make an API call
  }

  Future<String?> getCurrentUserId() async {
    final auth = AuthService();
    return await auth.getCurrentUserId();
  }

  Future<void> addUserCard(String userId, AddCardRequest request) async {
    // Mock implementation - simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Validate card number (basic Luhn algorithm check)
    if (!_validateCardNumber(request.cardNumber)) {
      throw Exception('Invalid card number');
    }
    
    // In a real app, this would make an API call to add the card
    // For now, just simulate success
  }

  bool _validateCardNumber(String cardNumber) {
    // Basic Luhn algorithm validation
    if (cardNumber.isEmpty || cardNumber.length != 16) {
      return false;
    }
    
    int sum = 0;
    bool alternate = false;
    
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.tryParse(cardNumber[i]) ?? 0;
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    return (sum % 10 == 0);
  }
}
