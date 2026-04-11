import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/network/dio_provider.dart';
import '../model/coupon_response_model.dart';

class CouponRepository {
  final Dio dio;

  CouponRepository(this.dio);

  Future<CouponResponse> getCouponByUniqueId(
      String uniqueId,
      int ownerId,
      ) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.coupons}/$uniqueId',
        queryParameters: {
          'owner_id': ownerId,
        },
      );

      return CouponResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Failed to fetch coupon: $e');
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

final couponRepositoryProvider = Provider<CouponRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CouponRepository(dio);
});