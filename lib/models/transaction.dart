import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

enum TransactionStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('PROCESSING')
  processing,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('FAILED')
  failed,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('REFUNDED')
  refunded,
}

enum TransactionType {
  @JsonValue('PAYMENT')
  payment,
  @JsonValue('REFUND')
  refund,
  @JsonValue('ADJUSTMENT')
  adjustment,
}

@JsonSerializable()
class Transaction {
  final int? id;
  final String? transactionId; // backend UUID
  final int? userId;
  final int? merchantId;
  final double? amount;
  final String? currency;
  final String? description;
  final String? merchantName;
  final TransactionStatus? status;
  final TransactionType? type;
  final String? bankingTransactionId;
  final String? failureReason;
  final String? metadata;
  final bool? biometricVerified;
  final String? faceVerificationId;
  final String? stripePaymentIntentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  Transaction({
    this.id,
    this.transactionId,
    this.userId,
    this.merchantId,
    this.amount,
    this.currency,
    this.description,
    this.merchantName,
    this.status,
    this.type,
    this.bankingTransactionId,
    this.failureReason,
    this.metadata,
    this.biometricVerified,
    this.stripePaymentIntentId,
    this.faceVerificationId,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    if (normalized['transactionId'] == null &&
        normalized['transaction_id'] != null) {
      normalized['transactionId'] = normalized['transaction_id'];
    }
    if (normalized['bankingTransactionId'] == null &&
        normalized['banking_transaction_id'] != null) {
      normalized['bankingTransactionId'] = normalized['banking_transaction_id'];
    }
    if (normalized['faceVerificationId'] == null &&
        normalized['face_verification_id'] != null) {
      normalized['faceVerificationId'] = normalized['face_verification_id'];
    }
    if (normalized['biometricVerified'] == null &&
        normalized['biometric_verified'] != null) {
      normalized['biometricVerified'] = normalized['biometric_verified'];
    }

    return _$TransactionFromJson(normalized);
  }

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
