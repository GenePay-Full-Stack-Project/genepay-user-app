// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardModel _$CardModelFromJson(Map<String, dynamic> json) => CardModel(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  merchantId: (json['merchantId'] as num?)?.toInt(),
  cardLast4: json['cardLast4'] as String?,
  cardBrand: json['cardBrand'] as String?,
  expiryMonth: json['expiryMonth'] as String?,
  expiryYear: json['expiryYear'] as String?,
  paymentToken: json['paymentToken'] as String?,
  isDefault: json['isDefault'] as bool?,
  isActive: json['isActive'] as bool?,
  nickname: json['nickname'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  lastUsedAt: json['lastUsedAt'] == null
      ? null
      : DateTime.parse(json['lastUsedAt'] as String),
);

Map<String, dynamic> _$CardModelToJson(CardModel instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'merchantId': instance.merchantId,
  'cardLast4': instance.cardLast4,
  'cardBrand': instance.cardBrand,
  'expiryMonth': instance.expiryMonth,
  'expiryYear': instance.expiryYear,
  'paymentToken': instance.paymentToken,
  'isDefault': instance.isDefault,
  'isActive': instance.isActive,
  'nickname': instance.nickname,
  'createdAt': instance.createdAt?.toIso8601String(),
  'lastUsedAt': instance.lastUsedAt?.toIso8601String(),
};
