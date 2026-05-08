import 'package:fixit/core/models/service_model.dart';

class ServiceListResponse {
  final bool success;
  final String message;
  final List<Service> data;

  ServiceListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceListResponse.fromJson(Map<String, dynamic> json) {
    return ServiceListResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List? ?? [])
          .map(
            (e) => Service.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList(),
    );
  }
}