
import '../../../../../core/models/coupon_model.dart';
import '../../../../../core/models/user_model.dart';

class CouponUsageResponse {
  final bool success;
  final String message;
  final CouponUsageData data;

  CouponUsageResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CouponUsageResponse.fromJson(Map<String, dynamic> json) {
    return CouponUsageResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CouponUsageData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class CouponUsageData {
  final int id;
  final int couponId;
  final int userId;
  final int timesUsed;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CouponData coupon;
  final UserModel user;

  CouponUsageData({
    required this.id,
    required this.couponId,
    required this.userId,
    required this.timesUsed,
    required this.createdAt,
    required this.updatedAt,
    required this.coupon,
    required this.user,
  });

  factory CouponUsageData.fromJson(Map<String, dynamic> json) {
    return CouponUsageData(
      id: json['id'],
      couponId: json['coupon_id'],
      userId: json['user_id'],
      timesUsed: json['times_used'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      coupon: CouponData.fromJson(json['coupon']),
      user: UserModel.fromJson(json['user']),
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
      'coupon': coupon.toJson(),
      'user': user.toJson(),
    };
  }
}