// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
  id: (json['id'] as num?)?.toInt(),
  transactionId: json['transactionId'] as String?,
  userId: (json['userId'] as num?)?.toInt(),
  merchantId: (json['merchantId'] as num?)?.toInt(),
  amount: (json['amount'] as num?)?.toDouble(),
  currency: json['currency'] as String?,
  description: json['description'] as String?,
  merchantName: json['merchantName'] as String?,
  status: $enumDecodeNullable(_$TransactionStatusEnumMap, json['status']),
  type: $enumDecodeNullable(_$TransactionTypeEnumMap, json['type']),
  bankingTransactionId: json['bankingTransactionId'] as String?,
  failureReason: json['failureReason'] as String?,
  metadata: json['metadata'] as String?,
  biometricVerified: json['biometricVerified'] as bool?,
  stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
  faceVerificationId: json['faceVerificationId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionId': instance.transactionId,
      'userId': instance.userId,
      'merchantId': instance.merchantId,
      'amount': instance.amount,
      'currency': instance.currency,
      'description': instance.description,
      'merchantName': instance.merchantName,
      'status': _$TransactionStatusEnumMap[instance.status],
      'type': _$TransactionTypeEnumMap[instance.type],
      'bankingTransactionId': instance.bankingTransactionId,
      'failureReason': instance.failureReason,
      'metadata': instance.metadata,
      'biometricVerified': instance.biometricVerified,
      'faceVerificationId': instance.faceVerificationId,
      'stripePaymentIntentId': instance.stripePaymentIntentId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'PENDING',
  TransactionStatus.processing: 'PROCESSING',
  TransactionStatus.completed: 'COMPLETED',
  TransactionStatus.failed: 'FAILED',
  TransactionStatus.cancelled: 'CANCELLED',
  TransactionStatus.refunded: 'REFUNDED',
};

const _$TransactionTypeEnumMap = {
  TransactionType.payment: 'PAYMENT',
  TransactionType.refund: 'REFUND',
  TransactionType.adjustment: 'ADJUSTMENT',
};
