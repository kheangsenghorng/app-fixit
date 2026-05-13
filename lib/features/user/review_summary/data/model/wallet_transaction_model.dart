class WalletTransactionResponse {
  final bool success;
  final String message;
  final WalletTransaction? data;

  WalletTransactionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory WalletTransactionResponse.fromJson(Map<String, dynamic> json) {
    return WalletTransactionResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] == null
          ? null
          : WalletTransaction.fromJson(json['data']),
    );
  }
}

class WalletTransactionListResponse {
  final bool success;
  final String message;
  final List<WalletTransaction> data;

  WalletTransactionListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WalletTransactionListResponse.fromJson(Map<String, dynamic> json) {
    return WalletTransactionListResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is List
          ? (json['data'] as List)
          .map((e) => WalletTransaction.fromJson(e))
          .toList()
          : [],
    );
  }
}

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

  final WalletModel? wallet;
  final UserModel? user;
  final PaymentModel? payment;
  final ServiceBookingModel? serviceBooking;

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
    this.wallet,
    this.user,
    this.payment,
    this.serviceBooking,
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
      type: json['type']?.toString() ?? '',
      method: json['method']?.toString(),
      transactionRef: json['transaction_ref']?.toString(),
      externalTransactionId: json['external_transaction_id']?.toString(),
      amount: _toDouble(json['amount']),
      balanceBefore: _toDouble(json['balance_before']),
      balanceAfter: _toDouble(json['balance_after']),
      description: json['description']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      wallet: json['wallet'] == null ? null : WalletModel.fromJson(json['wallet']),
      user: json['user'] == null ? null : UserModel.fromJson(json['user']),
      payment:
      json['payment'] == null ? null : PaymentModel.fromJson(json['payment']),
      serviceBooking: json['service_booking'] == null
          ? null
          : ServiceBookingModel.fromJson(json['service_booking']),
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
      'wallet': wallet?.toJson(),
      'user': user?.toJson(),
      'payment': payment?.toJson(),
      'service_booking': serviceBooking?.toJson(),
    };
  }
}

class WalletModel {
  final int walletId;
  final int userId;
  final double balance;
  final String? currency;
  final String? status;
  final String? phone;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  WalletModel({
    required this.walletId,
    required this.userId,
    required this.balance,
    this.currency,
    this.status,
    this.phone,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      walletId: _toInt(json['wallet_id']),
      userId: _toInt(json['user_id']),
      balance: _toDouble(json['balance']),
      currency: json['currency']?.toString(),
      status: json['status']?.toString(),
      phone: json['phone']?.toString(),
      isActive: json['is_active'] == true,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wallet_id': walletId,
      'user_id': userId,
      'balance': balance,
      'currency': currency,
      'status': status,
      'phone': phone,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class UserModel {
  final int id;
  final int? ownerId;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final bool isActive;
  final String? avatar;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    this.ownerId,
    this.name,
    this.email,
    this.phone,
    this.role,
    required this.isActive,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _toInt(json['id']),
      ownerId: json['owner_id'] == null ? null : _toInt(json['owner_id']),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      role: json['role']?.toString(),
      isActive: json['is_active'] == true,
      avatar: json['avatar']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'is_active': isActive,
      'avatar': avatar,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class PaymentModel {
  final int id;
  final int userId;
  final int? ownerId;
  final int? serviceBookingId;
  final int? couponsId;
  final String? transactionId;
  final double originalAmount;
  final double discountAmount;
  final double finalAmount;
  final String? method;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  PaymentModel({
    required this.id,
    required this.userId,
    this.ownerId,
    this.serviceBookingId,
    this.couponsId,
    this.transactionId,
    required this.originalAmount,
    required this.discountAmount,
    required this.finalAmount,
    this.method,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      ownerId: json['owner_id'] == null ? null : _toInt(json['owner_id']),
      serviceBookingId: json['service_booking_id'] == null
          ? null
          : _toInt(json['service_booking_id']),
      couponsId: json['coupons_id'] == null ? null : _toInt(json['coupons_id']),
      transactionId: json['transaction_id']?.toString(),
      originalAmount: _toDouble(json['original_amount']),
      discountAmount: _toDouble(json['discount_amount']),
      finalAmount: _toDouble(json['final_amount']),
      method: json['method']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'owner_id': ownerId,
      'service_booking_id': serviceBookingId,
      'coupons_id': couponsId,
      'transaction_id': transactionId,
      'original_amount': originalAmount,
      'discount_amount': discountAmount,
      'final_amount': finalAmount,
      'method': method,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class ServiceBookingModel {
  final int id;
  final int userId;
  final int serviceId;
  final int packageId;
  final int addressId;
  final String? bookingDate;
  final String? bookingHours;
  final int quantity;
  final String? notes;
  final String? bookingStatus;
  final String? customerStatus;
  final String? createdAt;
  final String? updatedAt;

  ServiceBookingModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.packageId,
    required this.addressId,
    this.bookingDate,
    this.bookingHours,
    required this.quantity,
    this.notes,
    this.bookingStatus,
    this.customerStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceBookingModel.fromJson(Map<String, dynamic> json) {
    return ServiceBookingModel(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      serviceId: _toInt(json['service_id']),
      packageId: _toInt(json['package_id']),
      addressId: _toInt(json['address_id']),
      bookingDate: json['booking_date']?.toString(),
      bookingHours: json['booking_hours']?.toString(),
      quantity: _toInt(json['quantity']),
      notes: json['notes']?.toString(),
      bookingStatus: json['booking_status']?.toString(),
      customerStatus: json['customer_status']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'package_id': packageId,
      'address_id': addressId,
      'booking_date': bookingDate,
      'booking_hours': bookingHours,
      'quantity': quantity,
      'notes': notes,
      'booking_status': bookingStatus,
      'customer_status': customerStatus,
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