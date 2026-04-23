import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/network/dio_provider.dart';
import '../model/payment_model.dart';
import '../model/payment_request_model.dart';
import '../model/payment_response_model.dart';

class PaymentRepository {
  final Dio dio;

  PaymentRepository(this.dio);

  // Generate KHQR / QR code payment
  Future<PaymentResponse> generatePayment(PaymentRequest request) async {
    try {
      final response = await dio.post(
        ApiEndpoints.generatePayment,
        data: request.toJson(),
      );

      return PaymentResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to generate payment',
      );
    }
  }

  // Check MD5 payment status
  Future<String?> checkMd5(String md5) async {
    try {
      final response = await dio.post(
        ApiEndpoints.checkMd5,
        data: {'md5': md5},
      );

      return response.data?['data']?['data']?['externalRef']?.toString();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to check md5',
      );
    }
  }

  // Create / fetch payment record
  Future<Payment> payment(PaymentRequest request) async {
    try {
      final response = await dio.post(
        ApiEndpoints.payment,
        data: request.toJson(),
      );

      return Payment.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to create payment',
      );
    }
  }
}

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return PaymentRepository(dio);
});

final generatePaymentProvider =
FutureProvider.family<PaymentResponse, PaymentRequest>((ref, request) async {
  final repository = ref.watch(paymentRepositoryProvider);
  return repository.generatePayment(request);
});

final paymentProvider =
FutureProvider.family<Payment, PaymentRequest>((ref, request) async {
  final repository = ref.watch(paymentRepositoryProvider);
  return repository.payment(request);
});