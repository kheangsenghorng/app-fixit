import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/network/dio_provider.dart';
import '../model/coupon_usage_response_model.dart';


class CouponUsageRepository {
  final Dio dio;

  CouponUsageRepository(this.dio);

  Future<CouponUsageResponse> createCouponUsage({
    required int couponId,
    required int userId,
    int timesUsed = 1,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.couponUsage,
        data: {
          'coupon_id': couponId,
          'user_id': userId,
          'times_used': timesUsed,
        },
      );

      return CouponUsageResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Failed to save coupon usage: $e');
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return e.response?.data?['message']?.toString() ??
          'Server error: ${e.response?.statusCode}';
    }

    return e.message ?? 'Network error occurred';
  }
}

final couponUsageRepositoryProvider =
Provider<CouponUsageRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CouponUsageRepository(dio);
});