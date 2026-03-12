import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';

/// Interceptor for adding authentication token to requests
class AuthInterceptor extends Interceptor {
  final SecureStorageService secureStorageService;

  AuthInterceptor({required this.secureStorageService});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await secureStorageService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // Handle token retrieval error silently
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await secureStorageService.clearAuthTokens();
    }
    return handler.next(err);
  }
}
