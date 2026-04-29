import 'package:dio/dio.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../model/booking_providers_response.dart';

class ServiceBookingProviderRepository {
  final Dio dio;

  ServiceBookingProviderRepository(this.dio);

  Future<BookingProvidersResponse> getByBookingId(int bookingId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.serviceBookingProvidersByBooking(bookingId),
      );

      final data = response.data;

      if (response.statusCode == 200 && data['success'] == true) {
        return BookingProvidersResponse.fromJson(data);
      }

      throw Exception(
        data['message'] ?? 'Failed to retrieve booking providers',
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  String _handleDioError(DioException error) {
    final response = error.response;
    final data = response?.data;

    if (data is Map<String, dynamic> && data['message'] != null) {
      return data['message'].toString();
    }

    switch (response?.statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'You do not have permission to access this resource.';
      case 404:
        return 'Booking providers not found.';
      case 422:
        return 'Validation error.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection or server is unreachable.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}