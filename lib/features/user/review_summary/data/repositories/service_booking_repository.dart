import 'package:dio/dio.dart';
import '../../../../../core/constants/api_endpoints.dart';

class ServiceBookingRepository {
  final Dio dio;

  ServiceBookingRepository(this.dio);

  Future<Response> createBooking({
    required int userId,
    required int serviceId,
    required String houseNo,
    required String street,
    required String bookingDate,
    required String bookingHours,
    required String address,
    required double latitude,
    required double longitude,
    required String mapUrl,
    String? note,

  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.bookingService,
        data: {
          'user_id':userId,
          'service_id': serviceId,
          'house_number':houseNo,
          'street_number':street,
          'booking_date': bookingDate,
          'booking_hours': bookingHours,
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
          'map_url': mapUrl,
          'notes': note,
        },
      );

      return response;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            'Failed to create service booking',
      );
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }
}