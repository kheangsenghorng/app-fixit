import '../../../../core/models/user_model.dart';

class AuthModel {
  final String? message;
  final String? token;
  final int? expiresIn;
  final String? requestId; // ✅ ADD THIS
  final UserModel? user;

  AuthModel({
    this.message,
    this.token,
    this.expiresIn,
    this.requestId,
    this.user,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      message: json['message'],
      token: json['access_token'], // null if OTP
      expiresIn: json['expires_in'],
      requestId: json['request_id'], // ✅ important
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
    );
  }

  bool get isOtp => requestId != null;
  bool get isLoggedIn => token != null;

  AuthModel copyWith({
    String? token,
    int? expiresIn,
    UserModel? user,
  }) {
    return AuthModel(
      message: message,
      token: token ?? this.token,
      expiresIn: expiresIn ?? this.expiresIn,
      requestId: requestId,
      user: user ?? this.user,
    );
  }
}