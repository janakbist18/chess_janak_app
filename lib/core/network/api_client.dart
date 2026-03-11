import 'package:dio/dio.dart';
import 'network_exceptions.dart';

class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> get(String path) async {
    try {
      return await _dio.get(path);
    } on DioException catch (e) {
      throw NetworkException(_extractMessage(e));
    }
  }

  Future<Response<dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
  }) async {
    try {
      return await _dio.post(path, data: formData ?? data);
    } on DioException catch (e) {
      throw NetworkException(_extractMessage(e));
    }
  }

  String _extractMessage(DioException e) {
    final responseData = e.response?.data;
    if (responseData is Map<String, dynamic> && responseData.isNotEmpty) {
      final firstValue = responseData.values.first;
      if (firstValue is List && firstValue.isNotEmpty) {
        return firstValue.first.toString();
      }
      return firstValue.toString();
    }

    return e.message ?? 'Something went wrong.';
  }
}