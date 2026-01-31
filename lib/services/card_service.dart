import '../models/card_model.dart';

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
}
