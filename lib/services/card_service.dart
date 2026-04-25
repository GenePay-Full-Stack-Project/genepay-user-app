import 'api_service.dart';
import '../models/card_model.dart';
import '../models/add_card_request.dart';

class CardService extends ApiService {
  CardService({super.client});

  Future<List<CardModel>> getUserCards(int userId) async {
    final response = await get<List<CardModel>>('/cards/user/$userId', (json) {
      if (json is List) {
        return json
            .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <CardModel>[];
    });

    if (response.success && response.data != null) {
      return response.data!;
    }
    throw ApiException(response.message);
  }

  Future<CardModel> addUserCard(int userId, AddCardRequest request) async {
    final response = await post<CardModel>(
      '/cards/user/$userId',
      request.toJson(),
      (json) => CardModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    }
    throw ApiException(response.message);
  }

  Future<CardModel> getUserDefaultCard(int userId) async {
    final response = await get<CardModel>(
      '/cards/user/$userId/default',
      (json) => CardModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) return response.data!;
    throw ApiException(response.message);
  }

  Future<CardModel> setUserDefaultCard(int userId, int cardId) async {
    final response = await put<CardModel>(
      '/cards/user/$userId/$cardId/set-default',
      {},
      (json) => CardModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.success && response.data != null) return response.data!;
    throw ApiException(response.message);
  }

  Future<void> removeUserCard(int userId, int cardId) async {
    final response = await delete<void>(
      '/cards/user/$userId/$cardId',
      (json) {},
    );

    if (response.success) return;
    throw ApiException(response.message);
  }
}
