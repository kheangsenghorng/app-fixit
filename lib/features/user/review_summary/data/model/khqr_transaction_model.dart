class KhqrTransaction {
  final String? externalRef;
  final String? hash;
  final String? fromAccountId;
  final String? toAccountId;
  final String? currency;
  final double? amount;

  KhqrTransaction({
    this.externalRef,
    this.hash,
    this.fromAccountId,
    this.toAccountId,
    this.currency,
    this.amount,
  });

  factory KhqrTransaction.fromJson(Map<String, dynamic> json) {
    return KhqrTransaction(
      externalRef: json['externalRef'],
      hash: json['hash'],
      fromAccountId: json['fromAccountId'],
      toAccountId: json['toAccountId'],
      currency: json['currency'],
      amount: (json['amount'] as num?)?.toDouble(),
    );
  }
}