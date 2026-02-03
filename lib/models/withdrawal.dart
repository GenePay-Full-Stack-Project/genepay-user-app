import 'package:json_annotation/json_annotation.dart';

part 'withdrawal.g.dart';

enum WithdrawalStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('PROCESSING')
  processing,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('FAILED')
  failed,
}

@JsonSerializable()
class Withdrawal {
  final int? id;
  final int? merchantId;
  final double? amount;
  final String? currency;
  final WithdrawalStatus? status;
  final String? stripeTransferId;
  final String? description;
  final DateTime? requestedAt;
  final DateTime? processedAt;

  Withdrawal({
    this.id,
    this.merchantId,
    this.amount,
    this.currency,
    this.status,
    this.stripeTransferId,
    this.description,
    this.requestedAt,
    this.processedAt,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalFromJson(json);
  Map<String, dynamic> toJson() => _$WithdrawalToJson(this);
}
