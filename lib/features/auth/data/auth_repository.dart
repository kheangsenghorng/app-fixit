import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/models/user_model.dart';
import 'models/auth_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(dioProvider));
});

class AuthRepository {
  final Dio dio;

  AuthRepository(this.dio);

  Future<AuthModel> login(String login, String password) async {
    final res = await dio.post('/login', data: {
      'login': login,
      'password': password,
    });

    return AuthModel.fromJson(res.data);
  }

  Future<AuthModel> register({
    required String name,
    String? email,
    String? phone,
    required String password,
  }) async {
    final res = await dio.post('/register', data: {
      'name': name,
      'phone': phone,
      'password': password,
      'password_confirmation': password, // 🔥 REQUIRED
    });

    return AuthModel.fromJson(res.data);
  }



  Future<UserModel> me() async {
    final res = await dio.get('/me');
    return UserModel.fromJson(res.data['user']);
  }

  Future<void> logout() async {
    await dio.post('/logout');
  }

  // ✅ ADD THIS
  Future<AuthModel> refreshToken() async {
    final res = await dio.post('/refresh');

    print(res);
    return AuthModel.fromJson(res.data);
  }


}
