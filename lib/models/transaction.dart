enum TransactionStatus { pending, completed, failed, cancelled, refunded, processing }

enum TransactionType { payment, refund, transfer }

class Transaction {
  final String? id;
  final String? merchantName;
  final String? merchantId;
  final double? amount;
  final String? currency;
  final DateTime? createdAt;
  final TransactionStatus? status;
  final TransactionType? type;
  final bool? biometricVerified;

  Transaction({
    this.id,
    this.merchantName,
    this.merchantId,
    this.amount,
    this.currency,
    this.createdAt,
    this.status,
    this.type,
    this.biometricVerified,
  });
}
