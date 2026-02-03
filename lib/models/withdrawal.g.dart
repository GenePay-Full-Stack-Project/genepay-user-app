// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Withdrawal _$WithdrawalFromJson(Map<String, dynamic> json) => Withdrawal(
  id: (json['id'] as num?)?.toInt(),
  merchantId: (json['merchantId'] as num?)?.toInt(),
  amount: (json['amount'] as num?)?.toDouble(),
  currency: json['currency'] as String?,
  status: $enumDecodeNullable(_$WithdrawalStatusEnumMap, json['status']),
  stripeTransferId: json['stripeTransferId'] as String?,
  description: json['description'] as String?,
  requestedAt: json['requestedAt'] == null
      ? null
      : DateTime.parse(json['requestedAt'] as String),
  processedAt: json['processedAt'] == null
      ? null
      : DateTime.parse(json['processedAt'] as String),
);

Map<String, dynamic> _$WithdrawalToJson(Withdrawal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'merchantId': instance.merchantId,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': _$WithdrawalStatusEnumMap[instance.status],
      'stripeTransferId': instance.stripeTransferId,
      'description': instance.description,
      'requestedAt': instance.requestedAt?.toIso8601String(),
      'processedAt': instance.processedAt?.toIso8601String(),
    };

const _$WithdrawalStatusEnumMap = {
  WithdrawalStatus.pending: 'PENDING',
  WithdrawalStatus.approved: 'APPROVED',
  WithdrawalStatus.processing: 'PROCESSING',
  WithdrawalStatus.completed: 'COMPLETED',
  WithdrawalStatus.cancelled: 'CANCELLED',
  WithdrawalStatus.failed: 'FAILED',
};
