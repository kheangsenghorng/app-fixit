import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/auth_repository.dart';
import '../../data/models/auth_model.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthModel? build() {
    return null;
  }

  Future<void> restoreSession() async {
    try {
      final token = await TokenStorage.get();

      if (token == null || token.isEmpty) {
        state = const AsyncData(null);
        return;
      }

      final user = await ref.read(authRepositoryProvider).me();

      state = AsyncData(
        AuthModel(
          success: true,
          token: token,
          user: user,
          expiresIn: null,
          message: null,
          requestId: null,
          channel: null,
          login: null,
        ),
      );
    } catch (e) {
      debugPrint('AUTO LOGIN FAILED: $e');
      await TokenStorage.clear();
      state = const AsyncData(null);
    }
  }

  Future<void> login(String login, String password) async {
    state = const AsyncLoading();

    try {
      await TokenStorage.clear();

      final repo = ref.read(authRepositoryProvider);
      final result = await repo.login(login, password);

      if (_isOtpResponse(result)) {
        state = AsyncData(result);
        return;
      }

      if (result.isLoggedIn && result.token != null && result.token!.isNotEmpty) {
        await TokenStorage.save(result.token!);
        state = AsyncData(result);
        await loadProfile();
        return;
      }

      throw result.message ?? 'Invalid response';
    } catch (e, st) {
      state = AsyncError(_mapLoginError(e), st);
    }
  }

  Future<void> register({
    required String name,
    String? phone,
    String? email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      await TokenStorage.clear();

      final repo = ref.read(authRepositoryProvider);

      final result = await repo.register(
        name: name,
        phone: phone,
        email: email,
        password: password,
      );

      if (_isOtpResponse(result)) {
        state = AsyncData(result);
        return;
      }

      throw result.message ?? 'Invalid register response';
    } catch (e, st) {
      state = AsyncError(_mapRegisterError(e), st);
    }
  }

  Future<void> verifyOtp({
    required String phone,
    required String code,
  }) async {
    state = const AsyncLoading();

    try {
      final result = await ref.read(authRepositoryProvider).verifyOtp(
        phone: phone,
        code: code,
      );

      if (result.token != null && result.token!.isNotEmpty) {
        await TokenStorage.save(result.token!);
        state = AsyncData(result);
        await loadProfile();
        return;
      }

      throw result.message ?? 'OTP verification failed';
    } catch (e, st) {
      state = AsyncError(_mapOtpError(e), st);
    }
  }

  Future<void> loadProfile() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.me();
      final token = await TokenStorage.get();

      if (token != null && token.isNotEmpty) {
        final current = state.valueOrNull;

        state = AsyncData(
          (current ?? const AuthModel()).copyWith(
            token: token,
            user: user,
          ),
        );
      }
    } catch (e) {
      await TokenStorage.clear();
      state = const AsyncData(null);
    }
  }

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (_) {}

    await TokenStorage.clear();
    state = const AsyncData(null);
  }

  Future<void> forceLogout() async {
    await TokenStorage.clear();
    state = const AsyncData(null);
  }

  void clearError() {
    state = AsyncData(state.valueOrNull);
  }

  void updateAuth(String token, UserModel? user) {
    final current = state.valueOrNull;

    state = AsyncData(
      (current ?? const AuthModel()).copyWith(
        token: token,
        user: user,
      ),
    );
  }

  bool _isOtpResponse(AuthModel result) {
    final msg = result.message?.toLowerCase() ?? '';

    return result.requestId != null ||
        msg.contains('otp sent') ||
        msg.contains('verify otp') ||
        msg.contains('verification code') ||
        (!result.isLoggedIn &&
            ((result.login != null && result.login!.isNotEmpty) ||
                (result.channel != null && result.channel!.isNotEmpty)));
  }

  String _mapLoginError(Object e) {
    if (e is String) return e;

    if (e is DioException) {
      final status = e.response?.statusCode;
      final data = e.response?.data;

      if (status == 401) return 'Invalid credentials';
      if (status == 403) return 'Account not verified. Please verify OTP.';

      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ?? e.message ?? 'Login failed';
      }

      return e.message ?? 'Login failed';
    }

    return e.toString().replaceAll('Exception: ', '');
  }

  String _mapRegisterError(Object e) {
    if (e is String) return e;

    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ?? 'Registration failed';
      }
      return e.message ?? 'Registration failed';
    }

    return e.toString().replaceAll('Exception: ', '');
  }

  String _mapOtpError(Object e) {
    if (e is String) return e;

    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ?? 'OTP verification failed';
      }
      return e.message ?? 'OTP verification failed';
    }

    return e.toString().replaceAll('Exception: ', '');
  }
}