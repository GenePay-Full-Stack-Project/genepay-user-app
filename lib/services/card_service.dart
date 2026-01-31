import '../models/card_model.dart';

class CardService {
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
      isDefault: true,
    );
  }
}
