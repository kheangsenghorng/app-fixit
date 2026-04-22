class PaymentRequest {
  final num? amount;
  final String? billNumber;
  final String? mobileNumber;
  final String? storeLabel;
  final String? terminalLabel;
  final String? purposeOfTransaction;
  final int? expirationTimestamp;

  final int? userId;
  final int? ownerId;
  final int? serviceBookingId;
  final int? couponsId;
  final String? transactionId;
  final num? originalAmount;
  final num? discountAmount;
  final num? finalAmount;
  final String? method;
  final String? status;

  PaymentRequest({
    this.amount,
    this.billNumber,
    this.mobileNumber,
    this.storeLabel,
    this.terminalLabel,
    this.purposeOfTransaction,
    this.expirationTimestamp,
    this.userId,
    this.ownerId,
    this.serviceBookingId,
    this.couponsId,
    this.transactionId,
    this.originalAmount,
    this.discountAmount,
    this.finalAmount,
    this.method,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      if (amount != null) 'amount': amount,
      if (billNumber != null) 'bill_number': billNumber,
      if (mobileNumber != null) 'mobile_number': mobileNumber,
      if (storeLabel != null) 'store_label': storeLabel,
      if (terminalLabel != null) 'terminal_label': terminalLabel,
      if (purposeOfTransaction != null)
        'purpose_of_transaction': purposeOfTransaction,
      if (expirationTimestamp != null)
        'expiration_timestamp': expirationTimestamp,
      if (userId != null) 'user_id': userId,
      if (ownerId != null) 'owner_id': ownerId,
      if (serviceBookingId != null) 'service_booking_id': serviceBookingId,
      'coupons_id': couponsId,
      if (transactionId != null) 'transaction_id': transactionId,
      if (originalAmount != null) 'original_amount': originalAmount,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (finalAmount != null) 'final_amount': finalAmount,
      if (method != null) 'method': method,
      if (status != null) 'status': status,
    };
  }
}