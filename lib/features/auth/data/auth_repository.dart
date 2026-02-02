import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_provider.dart';

import '../../../core/models/user_model.dart';
import 'models/auth_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(dioProvider));
});

class AuthRepository {
  final Dio dio;

  AuthRepository(this.dio);

  // ---------------- LOGIN ----------------

  Future<AuthModel> login(String login, String password) async {
    final res = await dio.post(ApiEndpoints.login, data: {
      'login': login,
      'password': password,
    });

    return AuthModel.fromJson(res.data);
  }

  // ---------------- REGISTER ----------------

  Future<AuthModel> register({
    required String name,
    String? email,
    String? phone,
    required String password,
  }) async {
    final res = await dio.post(ApiEndpoints.register, data: {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': password,
    });

    return AuthModel.fromJson(res.data);
  }

  // ---------------- OTP ----------------

  /// Send OTP
  Future<void> sendOtp(String phone) async {
    await dio.post(
      ApiEndpoints.sendOtp,
      data: {
        'phone': phone,
      },
    );
  }

  /// Verify OTP
  Future<void> verifyOtp({
    required String phone,
    required String code,
  }) async {
    await dio.post(
      ApiEndpoints.verifyOtp,
      data: {
        'phone': phone,
        'code': code,
      },
    );
  }

  // ---------------- USER ----------------

  Future<UserModel> me() async {
    final res = await dio.get(ApiEndpoints.me);
    return UserModel.fromJson(res.data['user']);
  }

  Future<void> logout() async {
    await dio.post(ApiEndpoints.logout);
  }

  // ---------------- REFRESH TOKEN ----------------

  Future<AuthModel> refreshToken() async {
    final res = await dio.post(ApiEndpoints.refresh);
    return AuthModel.fromJson(res.data);
  }
}
