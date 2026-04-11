import 'package:fixit/core/models/service_model.dart';

class ServiceResponse {
  final bool success;
  final String message;
  final List<Service> data;

  ServiceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => Service.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}