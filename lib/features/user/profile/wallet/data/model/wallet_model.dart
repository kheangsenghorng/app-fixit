import 'wallet_transaction_model.dart';

class WalletResponse {
  final bool success;
  final String message;
  final Wallet? data;

  WalletResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? Wallet.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class Wallet {
  final int walletId;
  final int userId;
  final double balance;
  final String currency;
  final String status;
  final String? phone;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final WalletUser? user;
  final List<WalletTransaction> transactions;

  Wallet({
    required this.walletId,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.status,
    this.phone,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.transactions = const [],
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      walletId: _toInt(json['wallet_id']),
      userId: _toInt(json['user_id']),
      balance: _toDouble(json['balance']),
      currency: json['currency'] ?? '',
      status: json['status'] ?? '',
      phone: json['phone'],
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null ? WalletUser.fromJson(json['user']) : null,
      transactions: json['transactions'] != null
          ? List<WalletTransaction>.from(
        json['transactions'].map(
              (item) => WalletTransaction.fromJson(item),
        ),
      )
          : [],
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
      'user': user?.toJson(),
      'transactions': transactions.map((item) => item.toJson()).toList(),
    };
  }
}

class WalletUser {
  final int id;
  final int? ownerId;
  final String name;
  final String? email;
  final String? phone;
  final String role;
  final bool isActive;
  final String? emailVerifiedAt;
  final String? avatar;
  final String? createdAt;
  final String? updatedAt;

  WalletUser({
    required this.id,
    this.ownerId,
    required this.name,
    this.email,
    this.phone,
    required this.role,
    required this.isActive,
    this.emailVerifiedAt,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletUser.fromJson(Map<String, dynamic> json) {
    return WalletUser(
      id: _toInt(json['id']),
      ownerId: json['owner_id'] == null ? null : _toInt(json['owner_id']),
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      role: json['role'] ?? '',
      isActive: json['is_active'] ?? false,
      emailVerifiedAt: json['email_verified_at'],
      avatar: json['avatar'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
      'email_verified_at': emailVerifiedAt,
      'avatar': avatar,
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