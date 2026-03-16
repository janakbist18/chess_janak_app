import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/user_profile_model.dart';

/// Leaderboard filter options
enum LeaderboardFilter { all, thisMonth, thisWeek, rapid, blitz }

/// Notifier for managing leaderboards
class LeaderboardNotifier extends StateNotifier<List<LeaderboardEntry>> {
  LeaderboardNotifier() : super([]);

  /// Fetch leaderboard data
  Future<void> fetchLeaderboard(LeaderboardFilter filter) async {
    try {
      // TODO: Implement API call to fetch leaderboard
      // For now, return empty state - will be populated from backend
      state = [];
    } catch (e) {
      print('Error fetching leaderboard: $e');
    }
  }

  /// Update filter and refresh
  Future<void> updateFilter(LeaderboardFilter filter) async {
    await fetchLeaderboard(filter);
  }

  /// Get current player rank
  int? getCurrentPlayerRank(String userId) {
    try {
      final entry = state.firstWhere((e) => e.player.id == userId);
      return entry.rank;
    } catch (_) {
      return null;
    }
  }

  /// Search player in leaderboard
  LeaderboardEntry? searchPlayer(String playerId) {
    try {
      return state.firstWhere((e) => e.player.id == playerId);
    } catch (_) {
      return null;
    }
  }
}

/// Notifier for managing user profile
class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null);

  /// Fetch current user profile
  Future<void> fetchCurrentProfile() async {
    try {
      // TODO: Implement API call to fetch current user profile
      // For now, return null - will be populated from backend
      state = null;
    } catch (e) {
      print('Error fetching profile: $e');
      state = null;
    }
  }

  /// Fetch another user's profile
  Future<UserProfile?> fetchProfile(String userId) async {
    try {
      // TODO: Implement API call to fetch user profile
      return null;
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  /// Update bio
  Future<void> updateBio(String bio) async {
    if (state == null) return;
    try {
      // TODO: Implement API call to update bio
      state = state!.copyWith(bio: bio);
    } catch (e) {
      print('Error updating bio: $e');
    }
  }

  /// Update profile image
  Future<void> updateProfileImage(String imageUrl) async {
    if (state == null) return;
    try {
      // TODO: Implement API call to update profile image
      state = state!.copyWith(profileImage: imageUrl);
    } catch (e) {
      print('Error updating profile image: $e');
    }
  }

  /// Follow user
  Future<void> followUser(String userId) async {
    if (state == null) return;
    try {
      // TODO: Implement API call to follow user
      state = state!.copyWith(following: state!.following + 1);
    } catch (e) {
      print('Error following user: $e');
    }
  }

  /// Unfollow user
  Future<void> unfollowUser(String userId) async {
    if (state == null) return;
    try {
      // TODO: Implement API call to unfollow user
      if (state!.following > 0) {
        state = state!.copyWith(following: state!.following - 1);
      }
    } catch (e) {
      print('Error unfollowing user: $e');
    }
  }
}

/// Provider for current user profile
final currentUserProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier();
});

/// Provider for other user profiles (by userId)
final userProfileProvider = FutureProvider.family<UserProfile?, String>((
  ref,
  userId,
) async {
  final notifier = UserProfileNotifier();
  return await notifier.fetchProfile(userId);
});

/// Provider for leaderboard data
final leaderboardProvider =
    StateNotifierProvider<LeaderboardNotifier, List<LeaderboardEntry>>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      final notifier = LeaderboardNotifier();
      // Fetch default leaderboard on creation
      Future.microtask(
        () => notifier.fetchLeaderboard(LeaderboardFilter.all),
      );
      return notifier;
    },
    loading: () => LeaderboardNotifier(),
    error: (_, __) => LeaderboardNotifier(),
  );
});

/// Provider for leaderboard filter
final leaderboardFilterProvider = StateProvider<LeaderboardFilter>((ref) {
  return LeaderboardFilter.all;
});

/// Provider for current player rank in leaderboard
final currentPlayerRankProvider = Provider<int?>((ref) {
  final leaderboard = ref.watch(leaderboardProvider);
  final auth = ref.watch(authStateProvider);

  return auth.maybeWhen(
    data: (user) {
      if (user == null) return null;
      try {
        final entry = leaderboard.firstWhere((e) => e.player.id == user.id);
        return entry.rank;
      } catch (_) {
        return null;
      }
    },
    orElse: () => null,
  );
});

/// Provider for top 10 players
final topPlayersProvider = Provider<List<LeaderboardEntry>>((ref) {
  final leaderboard = ref.watch(leaderboardProvider);
  return leaderboard.take(10).toList();
});

/// Provider for searching players in leaderboard
final leaderboardSearchProvider = StateProvider<String>((ref) => '');

/// Filtered leaderboard based on search
final filteredLeaderboardProvider = Provider<List<LeaderboardEntry>>((ref) {
  final leaderboard = ref.watch(leaderboardProvider);
  final query = ref.watch(leaderboardSearchProvider);

  if (query.isEmpty) return leaderboard;

  final lowercaseQuery = query.toLowerCase();
  return leaderboard
      .where(
        (entry) => entry.player.name.toLowerCase().contains(lowercaseQuery),
      )
      .toList();
});
