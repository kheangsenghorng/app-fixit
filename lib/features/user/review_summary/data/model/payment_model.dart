class Payment {
  final bool success;
  final String message;
  final PaymentData data;

  Payment({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: PaymentData.fromJson(json['data'] ?? {}),
    );
  }
}

class PaymentData {
  final int id;
  final int userId;
  final int ownerId;
  final int serviceBookingId;
  final int? couponsId;
  final String transactionId;
  final num originalAmount;
  final num discountAmount;
  final num finalAmount;
  final String method;
  final String status;
  final String createdAt;
  final String updatedAt;

  PaymentData({
    required this.id,
    required this.userId,
    required this.ownerId,
    required this.serviceBookingId,
    required this.couponsId,
    required this.transactionId,
    required this.originalAmount,
    required this.discountAmount,
    required this.finalAmount,
    required this.method,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      ownerId: json['owner_id'] ?? 0,
      serviceBookingId: json['service_booking_id'] ?? 0,
      couponsId: json['coupons_id'],
      transactionId: json['transaction_id'] ?? '',
      originalAmount: json['original_amount'] ?? 0,
      discountAmount: json['discount_amount'] ?? 0,
      finalAmount: json['final_amount'] ?? 0,
      method: json['method'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}