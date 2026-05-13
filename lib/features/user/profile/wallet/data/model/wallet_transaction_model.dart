class WalletTransaction {
  final int walletTransactionId;
  final int walletId;
  final int userId;
  final int? paymentId;
  final int? serviceBookingId;
  final String type;
  final String? method;
  final String? transactionRef;
  final String? externalTransactionId;
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  WalletTransaction({
    required this.walletTransactionId,
    required this.walletId,
    required this.userId,
    this.paymentId,
    this.serviceBookingId,
    required this.type,
    this.method,
    this.transactionRef,
    this.externalTransactionId,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      walletTransactionId: _toInt(json['wallet_transaction_id']),
      walletId: _toInt(json['wallet_id']),
      userId: _toInt(json['user_id']),
      paymentId: json['payment_id'] == null ? null : _toInt(json['payment_id']),
      serviceBookingId: json['service_booking_id'] == null
          ? null
          : _toInt(json['service_booking_id']),
      type: json['type'] ?? '',
      method: json['method'],
      transactionRef: json['transaction_ref'],
      externalTransactionId: json['external_transaction_id'],
      amount: _toDouble(json['amount']),
      balanceBefore: _toDouble(json['balance_before']),
      balanceAfter: _toDouble(json['balance_after']),
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wallet_transaction_id': walletTransactionId,
      'wallet_id': walletId,
      'user_id': userId,
      'payment_id': paymentId,
      'service_booking_id': serviceBookingId,
      'type': type,
      'method': method,
      'transaction_ref': transactionRef,
      'external_transaction_id': externalTransactionId,
      'amount': amount,
      'balance_before': balanceBefore,
      'balance_after': balanceAfter,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}