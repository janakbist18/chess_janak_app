import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import '../storage/secure_storage_service.dart';
import 'auth_interceptor.dart';
import 'api_client.dart';

final dioProvider = Provider<Dio>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: Env.connectTimeout,
      receiveTimeout: Env.receiveTimeout,
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(secureStorageService: secureStorage),
  );

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
    ),
  );

  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});
