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
    _autoLogin();
    return const AsyncData(null);
  }

  // ---------------- AUTO LOGIN ----------------

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

  // ---------------- LOGIN ----------------

  Future<void> login(String login, String password) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(authRepositoryProvider);

      final result = await repo.login(login, password);

      await TokenStorage.save(result.token);

      state = AsyncData(result);

      await loadProfile();
    } catch (e, st) {
      String message = "Login failed";

      if (e is DioException) {
        final status = e.response?.statusCode;

        if (status == 401) {
          message = "Invalid credentials";
        } else if (status == 403) {
          message = "Account not verified. Please verify OTP.";
        } else {
          message = e.response?.data['message'] ?? e.message ?? message;
        }
      }

      state = AsyncError(message, st);
    }
  }


  // ---------------- REGISTER (NO AUTO LOGIN) ----------------

  Future<void> register({
    required String name,
    String? phone,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(authRepositoryProvider);

      // Only create user (inactive) — OTP comes next
      await repo.register(
        name: name,
        phone: phone,
        password: password,
      );

      state = const AsyncData(null);
    } catch (e, st) {
      String message = "Registration failed";

      if (e is DioException) {
        message = e.response?.data['message'] ?? message;
      }

      state = AsyncError(message, st);
    }
  }

  // ---------------- VERIFY OTP + AUTO LOGIN ----------------

  Future<void> verifyOtp({
    required String phone,
    required String code,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      // 1️⃣ Verify OTP (backend activates user)
      await ref.read(authRepositoryProvider).verifyOtp(
        phone: phone,
        code: code,
      );

      // 2️⃣ Login after OTP success
      await login(phone, password);
    } catch (e, st) {
      String message = "OTP verification failed";

      if (e is DioException) {
        message = e.response?.data['message'] ?? message;
      }

      state = AsyncError(message, st);
    }
  }

  // ---------------- UPDATE AUTH (INTERCEPTOR) ----------------

  void updateAuth(String token, UserModel? user) {
    final current = state.value;

    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        token: token,
        user: user,
      ),
    );
  }

  // ---------------- LOAD PROFILE ----------------

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

  // ---------------- LOGOUT ----------------

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (_) {}

    await TokenStorage.clear();

    ref.invalidate(userProvider);

    state = const AsyncData(null);
  }

  void forceLogout() {
    state = const AsyncData(null);
  }
}
