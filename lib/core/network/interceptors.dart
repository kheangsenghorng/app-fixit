import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/user/profile/providers/user_provider.dart';
import '../constants/api_endpoints.dart';
import '../storage/token_storage.dart';
import 'dio_provider.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  bool _isRefreshing = false;
  bool _isLoggingOut = false;

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final token = await TokenStorage.get();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    final path = err.requestOptions.path;

    final isAuthRoute =
        path.contains(ApiEndpoints.login) ||
            path.contains(ApiEndpoints.verifyOtp) ||
            path.contains(ApiEndpoints.sendOtp);

    // ❌ DO NOT REFRESH during auth / OTP flow
    if (isAuthRoute) {
      return handler.next(err);
    }

    // ❌ Only handle 401 when token exists
    final token = await TokenStorage.get();
    if (token == null) {
      return handler.next(err);
    }

    // ✅ REFRESH TOKEN
    if (err.response?.statusCode == 401 &&
        !_isRefreshing &&
        !_isLoggingOut &&
        !path.contains(ApiEndpoints.refresh) &&
        !path.contains(ApiEndpoints.logout)) {
      _isRefreshing = true;

      try {
        final dio = Dio(
          BaseOptions(baseUrl: ref.read(dioProvider).options.baseUrl),
        );

        final repo = AuthRepository(dio);

        final auth = await repo.refreshToken();
        final newToken = auth.token;

        // ✅ SAVE TOKEN (IMPORTANT)
        await TokenStorage.save(newToken!);

        // ✅ UPDATE STATE
        ref.read(authControllerProvider.notifier).updateAuth(newToken, null);

        // 🔁 Retry original request
        final request = err.requestOptions;
        request.headers['Authorization'] = 'Bearer $newToken';

        _isRefreshing = false;

        final response = await dio.fetch(request);
        return handler.resolve(response);

      } catch (e) {
        _isRefreshing = false;
        _isLoggingOut = true;

        // 🔥 FORCE LOGOUT
        await TokenStorage.clear();
        ref.invalidate(userProvider);
        ref.read(authControllerProvider.notifier).forceLogout();
      }
    }

    return handler.next(err);
  }
}
