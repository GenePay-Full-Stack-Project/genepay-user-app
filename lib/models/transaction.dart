enum TransactionStatus { pending, completed, failed }

class Transaction {
  final String? id;
  final String? merchantName;
  final double? amount;
  final DateTime? createdAt;
  final TransactionStatus? status;

  Transaction({
    this.id,
    this.merchantName,
    this.amount,
    this.createdAt,
    this.status,
  });
}
