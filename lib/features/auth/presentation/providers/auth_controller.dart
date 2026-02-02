import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../user/profile/providers/user_provider.dart';
import '../../data/auth_repository.dart';
import '../../data/models/auth_model.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<AuthModel?> build() {
    // Start auto login but don't block build
    _autoLogin();
    return const AsyncData(null);
  }

  Future<void> _autoLogin() async {
    try {
      final token = await TokenStorage.get();
      if (token == null) return;

      await loadProfile();
    } catch (e) {
      debugPrint('AUTO LOGIN FAILED: $e');
      state = const AsyncData(null);
    }
  }

  Future<void> login(String login, String password) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(authRepositoryProvider);

      final result = await repo.login(login, password);

      // Save token
      await TokenStorage.save(result.token);

      // Set state directly
      state = AsyncData(result);

      // Load profile
      await loadProfile();

    } catch (e, st) {
      String message = "Invalid credentials";

      if (e is DioException) {
        if (e.response?.statusCode != 401 && e.response?.statusCode != 422) {
          message = "API_DOWN: ${e.message}";
        } else {
          message = e.response?.data['message'] ?? "Invalid credentials";
        }
      }

      state = AsyncError(message, st);
    }
  }


  Future<void> register({
    required String name,
    String? phone,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(authRepositoryProvider);

      final result = await repo.register(
        name: name,
        phone: phone,
        password: password,
      );

      await TokenStorage.save(result.token);


      await TokenStorage.save(result.token);

      state = AsyncData(result);

      await loadProfile();
    } catch (e, st) {
      String message = "Registration failed";

      if (e is DioException) {
        if (e.response?.statusCode != 401 && e.response?.statusCode != 422) {
          message = "API_DOWN: ${e.message}";
        } else {
          message = e.response?.data['message'] ?? "Registration failed";
        }
      }

      state = AsyncError(message, st);
    }
  }



  /// Used by interceptor after refresh
  void updateAuth(String token, UserModel? user) {
    final current = state.value;

    state = AsyncData(
      current!.copyWith(
        token: token,
        user: user,
      ),
    );
  }


  Future<void> loadProfile() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.me();

      final token = await TokenStorage.get();
      if (token != null) {
        updateAuth(token, user);
      }
    } catch (e) {
      debugPrint('LOAD PROFILE FAILED: $e');
    }
  }

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (_) {}

    await TokenStorage.clear();

    // 🔥 Reset user provider
    ref.invalidate(userProvider);

    // 🔥 Reset auth
    state = const AsyncData(null);
  }
  void forceLogout() {
    state = const AsyncData(null);
  }


}
