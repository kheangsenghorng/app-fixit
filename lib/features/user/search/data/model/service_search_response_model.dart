import '../../../../../core/models/service_model.dart';

class ServiceSearchResponse {
  final bool success;
  final String message;
  final List<Service> data;

  ServiceSearchResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceSearchResponse.fromJson(Map<String, dynamic> json) {
    return ServiceSearchResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => Service.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}