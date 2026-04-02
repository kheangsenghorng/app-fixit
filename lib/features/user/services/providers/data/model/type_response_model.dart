import '../../../../../../core/models/type_model.dart';

class TypeResponse {
  final String message;
  final List<TypeModel> data;

  const TypeResponse({
    required this.message,
    required this.data,
  });

  factory TypeResponse.fromJson(Map<String, dynamic> json) {
    return TypeResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TypeModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}