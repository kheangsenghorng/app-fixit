class WalletResponse {
  final bool success;
  final String message;
  final WalletModel? data;

  WalletResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? WalletModel.fromJson(json['data']) : null,
    );
  }
}

class WalletModel {
  final int? walletId;
  final int? userId;
  final double balance;
  final String currency;
  final String status;
  final String? phone;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final WalletUser? user;

  WalletModel({
    this.walletId,
    this.userId,
    required this.balance,
    required this.currency,
    required this.status,
    this.phone,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      walletId: json['wallet_id'] ?? json['id'],
      userId: json['user_id'],
      balance: double.tryParse(json['balance']?.toString() ?? '0') ?? 0,
      currency: json['currency']?.toString() ?? 'USD',
      status: json['status']?.toString() ?? 'active',
      phone: json['phone']?.toString(),
      isActive: json['is_active'] == true || json['is_active'] == 1,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      user: json['user'] != null ? WalletUser.fromJson(json['user']) : null,
    );
  }
}

class WalletUser {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;

  WalletUser({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  factory WalletUser.fromJson(Map<String, dynamic> json) {
    return WalletUser(
      id: json['id'],
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
    );
  }
}