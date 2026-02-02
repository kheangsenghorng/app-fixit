import '../../../../core/models/user_model.dart';

class AuthModel {
  final String message;
  final String token;
  final int expiresIn;
  final UserModel? user;

  AuthModel({
    required this.message,
    required this.token,
    required this.expiresIn,
    this.user,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      message: json['message'] ?? '',
      token: json['access_token'],
      expiresIn: json['expires_in'],
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
    );
  }

  AuthModel copyWith({
    String? token,
    int? expiresIn,
    UserModel? user,
  }) {
    return AuthModel(
      message: message,
      token: token ?? this.token,
      expiresIn: expiresIn ?? this.expiresIn,
      user: user ?? this.user,
    );
  }
}
