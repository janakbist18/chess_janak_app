import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_model.dart';

/// Profile remote data source
class ProfileRemoteDataSource {
  ProfileRemoteDataSource();

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
final profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSource();
});
