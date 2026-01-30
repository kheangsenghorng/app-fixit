import '../../../../core/models/user_model.dart';

class AuthModel {
  final String message;
  final String token;
  final UserModel? user;

  AuthModel({
    required this.message,
    required this.token,
    this.user,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      message: json['message'] ?? '',
      token: json['token'],
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
    );
  }

  AuthModel copyWith({
    String? token,
    UserModel? user,
  }) {
    return AuthModel(
      message: message,
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
}
