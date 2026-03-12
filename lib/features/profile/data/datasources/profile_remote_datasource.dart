import 'package:chess_janak_app/core/network/dio_provider.dart' show apiClientProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/config/api_endpoints.dart';

/// Profile remote data source
class ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSource(this._apiClient);

  Future<ProfileModel> getProfile(String userId) async {
    // TODO: Implement get profile API call
    throw UnimplementedError();
  }

  Future<ProfileModel> updateProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    // TODO: Implement update profile API call
    throw UnimplementedError();
  }

  Future<String> uploadAvatar(String userId, String imagePath) async {
    // TODO: Implement avatar upload
    throw UnimplementedError();
  }
}

/// Provider for profile remote data source
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileRemoteDataSource(apiClient);
});
