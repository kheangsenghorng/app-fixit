import '../../../../core/models/user_model.dart';

class ProfileResponseModel {
  final bool success;
  final String message;
  final UserModel user;

  ProfileResponseModel({
    required this.success,
    required this.message,
    required this.user,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}
