import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';

/// Interceptor for adding authentication token to requests
class AuthInterceptor extends Interceptor {
  final SecureStorageService secureStorageService;

  AuthInterceptor(this.secureStorageService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await secureStorageService.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // Handle token retrieval error silently
    }
    return handler.next(options);
  }
import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.secureStorageService,
  });

  final SecureStorageService secureStorageService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorageService.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    handler.next(options);
  }
}
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Handle unauthorized - typically refresh token or logout
      await secureStorageService.clearToken();
    }
    return handler.next(err);
  }
}
