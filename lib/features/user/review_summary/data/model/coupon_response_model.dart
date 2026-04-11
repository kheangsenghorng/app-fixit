import '../../../../../core/models/coupon_model.dart';

class CouponResponse {
  final CouponData data;

  CouponResponse({
    required this.data,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      data: CouponData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
    };
  }
}