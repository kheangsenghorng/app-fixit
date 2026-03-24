import '../../../../core/models/user_model.dart';

class AuthModel {
  final bool success;
  final String? token;
  final String? tokenType;
  final UserModel? user;
  final int? expiresIn;
  final String? message;
  final String? requestId;
  final String? channel;
  final String? login;

  const AuthModel({
    this.success = false,
    this.token,
    this.tokenType,
    this.user,
    this.expiresIn,
    this.message,
    this.requestId,
    this.channel,
    this.login,
  });

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  bool get isOtp {
    final msg = message?.toLowerCase() ?? '';
    return requestId != null ||
        msg.contains('otp sent') ||
        (success && channel != null && login != null && !isLoggedIn);
  }

  AuthModel copyWith({
    bool? success,
    String? token,
    String? tokenType,
    UserModel? user,
    int? expiresIn,
    String? message,
    String? requestId,
    String? channel,
    String? login,
  }) {
    return AuthModel(
      success: success ?? this.success,
      token: token ?? this.token,
      tokenType: tokenType ?? this.tokenType,
      user: user ?? this.user,
      expiresIn: expiresIn ?? this.expiresIn,
      message: message ?? this.message,
      requestId: requestId ?? this.requestId,
      channel: channel ?? this.channel,
      login: login ?? this.login,
    );
  }

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      success: json['success'] == true,
      token: json['token']?.toString() ?? json['access_token']?.toString(),
      tokenType: json['token_type']?.toString(),
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      expiresIn: json['expires_in'] is int
          ? json['expires_in'] as int
          : int.tryParse(json['expires_in']?.toString() ?? ''),
      message: json['message']?.toString(),
      requestId: json['request_id']?.toString(),
      channel: json['channel']?.toString(),
      login: json['login']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'access_token': token,
      'token_type': tokenType,
      'user': user?.toJson(),
      'expires_in': expiresIn,
      'message': message,
      'request_id': requestId,
      'channel': channel,
      'login': login,
    };
  }
}