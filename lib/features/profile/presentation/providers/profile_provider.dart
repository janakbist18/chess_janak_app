import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository.dart';

/// Provider for current player profile data
final currentPlayerProvider =
    FutureProvider<Map<String, dynamic>?>((ref) async {
  // TODO: Implement fetching current player profile from backend
  // When profile_remote_datasource.dart is fully implemented
  try {
    // final repository = ref.watch(profileRepositoryProvider);
    // return await repository.getCurrentPlayer();
    return {};
  } catch (e) {
    return null;
  }
});

/// Provider for player game history
final gameHistoryProvider =
    FutureProvider<List<Map<String, dynamic>>?>((ref) async {
  // TODO: Implement fetching game history from backend
  // When profile_remote_datasource.dart is fully implemented
  try {
    // final repository = ref.watch(profileRepositoryProvider);
    // return await repository.getGameHistory();
    return [];
  } catch (e) {
    return null;
  }
});

/// Provider for profile repository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepository(remoteDataSource);
});
