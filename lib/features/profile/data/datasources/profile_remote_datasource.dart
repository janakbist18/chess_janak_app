import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_model.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/config/api_endpoints.dart';

/// Profile remote data source
class ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSource(this._dio);

  Future<ProfileModel> getProfile(String userId) async {
    try {
      final response = await _dio.get(ApiEndpoints.profileDetail(userId));
      return ProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProfileModel> updateProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.patch(
        ApiEndpoints.profileDetail(userId),
        data: data,
      );
      return ProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadAvatar(String userId, String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(imagePath),
      });
      final response = await _dio.post(
        ApiEndpoints.profileAvatar(userId),
        data: formData,
      );
      final responseData = response.data as Map<String, dynamic>;
      return responseData['avatar_url'] as String;
    } catch (e) {
      rethrow;
    }
  }
}

/// Provider for profile remote data source
final profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileRemoteDataSource(dio);
});
