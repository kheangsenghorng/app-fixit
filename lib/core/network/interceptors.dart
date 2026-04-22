import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_controller.dart';
import '../storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  bool _isRefreshing = false;
  final List<Completer<void>> _pendingRequests = [];

  bool _isAuthRoute(String path) {
    return path.contains('/login') ||
        path.contains('/register') ||
        path.contains('/verifyOtp') ||
        path.contains('/sendOtp') ||
        path.contains('/refresh') ||
        path.contains('/logout');
  }

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    if (_isAuthRoute(options.path)) {
      return handler.next(options);
    }

    final token = await TokenStorage.get();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    final request = err.requestOptions;
    final statusCode = err.response?.statusCode;

    if (statusCode != 401 || _isAuthRoute(request.path)) {
      return handler.next(err);
    }

    if (request.extra['retried'] == true) {
      await _logoutLocally();
      return handler.next(err);
    }

    try {
      if (_isRefreshing) {
        final completer = Completer<void>();
        _pendingRequests.add(completer);
        await completer.future;
      } else {
        _isRefreshing = true;
        await _refreshToken();
        _isRefreshing = false;

        for (final completer in _pendingRequests) {
          if (!completer.isCompleted) {
            completer.complete();
          }
        }
        _pendingRequests.clear();
      }

      final newToken = await TokenStorage.get();

      if (newToken == null || newToken.isEmpty) {
        await _logoutLocally();
        return handler.next(err);
      }

      request.headers['Authorization'] = 'Bearer $newToken';
      request.extra['retried'] = true;

      final retryDio = Dio(
        BaseOptions(
          baseUrl: dotenv.env['FLUTTER_PUBLIC_API_URL']!,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      final response = await retryDio.fetch(request);
      return handler.resolve(response);
    } catch (_) {
      _isRefreshing = false;

      for (final completer in _pendingRequests) {
        if (!completer.isCompleted) {
          completer.completeError(Exception('Refresh failed'));
        }
      }
      _pendingRequests.clear();

      await _logoutLocally();
      return handler.next(err);
    }
  }

  Future<void> _refreshToken() async {
    final token = await TokenStorage.get();

    if (token == null || token.isEmpty) {
      throw Exception('No token available');
    }

    final refreshDio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['FLUTTER_PUBLIC_API_URL']!,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    final response = await refreshDio.post(
      '/refresh',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid refresh response');
    }

    final newToken = data['token']?.toString();

    if (newToken == null || newToken.isEmpty) {
      throw Exception('Refresh token missing');
    }

    await TokenStorage.save(newToken);

    ref.read(authControllerProvider.notifier).updateAuth(newToken, null);
  }

  Future<void> _logoutLocally() async {
    await TokenStorage.clear();
    await ref.read(authControllerProvider.notifier).forceLogout();
  }
}