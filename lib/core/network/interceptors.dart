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
        final newToken = await repo.refreshToken();

        await TokenStorage.save(newToken);

        ref.read(authControllerProvider.notifier).updateAuth(newToken, null);

        final request = err.requestOptions;
        request.headers['Authorization'] = 'Bearer $newToken';

        _isRefreshing = false;

        final response = await dio.fetch(request);
        return handler.resolve(response);
      } catch (_) {
        _isRefreshing = false;
        _isLoggingOut = true;

        // 🔥 FULL LOCAL LOGOUT
        await TokenStorage.clear();
        ref.invalidate(userProvider);
        ref.read(authControllerProvider.notifier).forceLogout();

      }

    }


    return handler.next(err);
  }
}
