import 'user_service_bookings_response.dart';

class ServiceBookingResponse {
  final bool success;
  final String message;
  final ServiceBooking data;

  ServiceBookingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceBookingResponse.fromJson(Map<String, dynamic> json) {
    return ServiceBookingResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ServiceBooking.fromJson(json['data'] ?? {}),
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