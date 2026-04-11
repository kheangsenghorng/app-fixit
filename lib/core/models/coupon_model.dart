import 'owner_model.dart';

class CouponData {
  final int id;
  final String uniqueId;
  final int? ownerId;
  final String discountType;
  final String discountValue;
  final DateTime expiresAt;
  final int maxUses;
  final int maxUsesPerUser;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int usersCount;
  final int totalTimesUsed;
  final Owner? owner;
  final List<CouponUsage> usages;

  CouponData({
    required this.id,
    required this.uniqueId,
    this.ownerId,
    required this.discountType,
    required this.discountValue,
    required this.expiresAt,
    required this.maxUses,
    required this.maxUsesPerUser,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.usersCount,
    required this.totalTimesUsed,
    this.owner,
    required this.usages,
  });

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      id: json['id'],
      uniqueId: json['unique_id'],
      ownerId: json['owner_id'],
      discountType: json['discount_type'],
      discountValue: json['discount_value'],
      expiresAt: DateTime.parse(json['expires_at']),
      maxUses: json['max_uses'],
      maxUsesPerUser: json['max_uses_per_user'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      usersCount: json['users_count'],
      totalTimesUsed: json['total_times_used'],
      owner: json['owner'] != null
          ? Owner.fromJson(json['owner'])
          : null,
      usages: (json['usages'] as List<dynamic>? ?? [])
          .map((e) => CouponUsage.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unique_id': uniqueId,
      'owner_id': ownerId,
      'discount_type': discountType,
      'discount_value': discountValue,
      'expires_at': expiresAt.toIso8601String(),
      'max_uses': maxUses,
      'max_uses_per_user': maxUsesPerUser,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'users_count': usersCount,
      'total_times_used': totalTimesUsed,
      'owner': owner?.toJson(),
      'usages': usages.map((e) => e.toJson()).toList(),
    };
  }
}

class CouponUsage {
  final int id;
  final int couponId;
  final int userId;
  final int timesUsed;
  final DateTime createdAt;
  final DateTime updatedAt;

  CouponUsage({
    required this.id,
    required this.couponId,
    required this.userId,
    required this.timesUsed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CouponUsage.fromJson(Map<String, dynamic> json) {
    return CouponUsage(
      id: json['id'],
      couponId: json['coupon_id'],
      userId: json['user_id'],
      timesUsed: json['times_used'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coupon_id': couponId,
      'user_id': userId,
      'times_used': timesUsed,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}