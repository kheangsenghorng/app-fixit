import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/network/dio_provider.dart';
import '../model/user_service_bookings_response.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final dio = ref.read(dioProvider);
  return PaymentRepository(dio);
});

class PaymentRepository {
  final Dio dio;

  PaymentRepository(this.dio);

  Future<UserServiceBookingsResponse> getPaymentsHistory(int userId) async {
    try {
      final response = await dio.get('${ApiEndpoints.paymentsHistory}/$userId');

      return UserServiceBookingsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch payment history');
    }
  }
}

final paymentsHistoryProvider =
FutureProvider.family<UserServiceBookingsResponse, int>((ref, userId) async {
  final repo = ref.read(paymentRepositoryProvider);
  return repo.getPaymentsHistory(userId);
});