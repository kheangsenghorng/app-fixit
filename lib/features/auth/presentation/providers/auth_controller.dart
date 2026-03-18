import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/storage/token_storage.dart';
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

      // ❌ No token → not logged in
      if (token == null || token.isEmpty) {
        state = const AsyncData(null);
        return;
      }

      // 🔄 Optional: show loading during auto login
      state = const AsyncLoading();

      // 👤 Load user profile
      final user = await ref.read(authRepositoryProvider).me();

      // ✅ Restore auth state
      state = AsyncData(
        AuthModel(
          token: token,
          user: user,
          expiresIn: null,
          message: null,
          requestId: null,
        ),
      );

    } catch (e) {
      debugPrint('AUTO LOGIN FAILED: $e');

      // ❌ Token invalid → clear everything
      await TokenStorage.clear();

      state = const AsyncData(null);
    }
  }

  // ---------------- LOGIN ----------------

  Future<void> login(String login, String password) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(authRepositoryProvider);

      final result = await repo.login(login, password);

      // ✅ OTP FLOW
      if (result.isOtp) {
        state = AsyncData(result);

        // 👉 UI should listen and navigate to OTP screen
        return;
      }

      // ✅ DIRECT LOGIN (if backend supports)
      if (result.isLoggedIn) {
        await TokenStorage.save(result.token!);

        state = AsyncData(result);

        await loadProfile();
        return;
      }

      throw Exception("Invalid response");

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
    String? email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(authRepositoryProvider);

      final result = await repo.register(
        name: name,
        phone: phone,
        email: email,
        password: password,
      );

      // 🔐 OTP FLOW (same as login)
      if (result.requestId != null) {
        state = AsyncData(result);
        return;
      }

      throw Exception("Invalid register response");

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
      final result = await ref.read(authRepositoryProvider).verifyOtp(
        phone: phone,
        code: code,
      );

      if (result.token != null) {
        await TokenStorage.save(result.token!);
        state = AsyncData(result);
        await loadProfile();
        return;
      }

      // Fallback: if backend doesn't return token on verify, login manually
      await login(phone, password);
    } catch (e, st) {
      state = AsyncError(e is DioException
          ? e.response?.data['message'] ?? "OTP verification failed"
          : "OTP verification failed", st);
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
      // ❌ If profile fails → logout
      await TokenStorage.clear();
      state = const AsyncData(null);
    }
  }

  // ---------------- LOGOUT ----------------

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (_) {}

    await TokenStorage.clear();

    state = const AsyncData(null);
  }

  void forceLogout() async {
    await TokenStorage.clear();
    state = const AsyncData(null);
  }
}
