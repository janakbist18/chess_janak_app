import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/models/profile_model.dart';

/// Profile controller
class ProfileController extends StateNotifier<ProfileModel?> {
  final ProfileRepository _repository;

  ProfileController(this._repository) : super(null);

  Future<void> loadProfile(String userId) async {
    try {
      final profile = await _repository.getProfile(userId);
      state = profile;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    try {
      final profile = await _repository.updateProfile(userId, data);
      state = profile;
    } catch (e) {
      // Handle error
    }
  }
}

/// Provider for profile controller
final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileModel?>((ref) {
      final repository = ref.watch(profileRepositoryProvider);
      return ProfileController(repository);
    });
