import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

/// Profile repository
class ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepository(this._remoteDataSource);

  Future<ProfileModel> getProfile(String userId) async {
    return await _remoteDataSource.getProfile(userId);
  }

  Future<ProfileModel> updateProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    return await _remoteDataSource.updateProfile(userId, data);
  }

  Future<String> uploadAvatar(String userId, String imagePath) async {
    return await _remoteDataSource.uploadAvatar(userId, imagePath);
  }
}

/// Provider for profile repository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepository(remoteDataSource);
});
