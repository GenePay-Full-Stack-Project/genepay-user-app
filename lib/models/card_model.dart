import 'package:json_annotation/json_annotation.dart';

part 'card_model.g.dart';

@JsonSerializable()
class CardModel {
  final int? id;
  final int? userId;
  final int? merchantId;
  final String? cardLast4;
  final String? cardBrand;
  final String? expiryMonth;
  final String? expiryYear;
  final String? paymentToken;
  final bool? isDefault;
  final bool? isActive;
  final String? nickname;
  final DateTime? createdAt;
  final DateTime? lastUsedAt;

  CardModel({
    this.id,
    this.userId,
    this.merchantId,
    this.cardLast4,
    this.cardBrand,
    this.expiryMonth,
    this.expiryYear,
    this.paymentToken,
    this.isDefault,
    this.isActive,
    this.nickname,
    this.createdAt,
    this.lastUsedAt,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(_normalize(json));
  static Map<String, dynamic> _normalize(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    if (normalized['paymentToken'] == null &&
        normalized['payment_token'] != null) {
      normalized['paymentToken'] = normalized['payment_token'];
    }
    if (normalized['userId'] == null && normalized['user_id'] != null) {
      normalized['userId'] = normalized['user_id'];
    }
    if (normalized['merchantId'] == null && normalized['merchant_id'] != null) {
      normalized['merchantId'] = normalized['merchant_id'];
    }
    return normalized;
  }

  Map<String, dynamic> toJson() => _$CardModelToJson(this);
}
