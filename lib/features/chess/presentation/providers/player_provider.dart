import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/player_model.dart';
import '../../data/repositories/chess_repository.dart';

/// Provider for current player profile
final currentPlayerProvider =
    FutureProvider.family<PlayerModel, String>((ref, playerId) async {
  final repository = ref.watch(chessRepositoryProvider);
  return repository.getPlayerProfile(playerId);
});

/// Provider for opponent player profile
final opponentPlayerProvider =
    FutureProvider.family<PlayerModel, String>((ref, playerId) async {
  final repository = ref.watch(chessRepositoryProvider);
  return repository.getPlayerProfile(playerId);
});

/// Provider for leaderboard
final leaderboardProvider = FutureProvider<List<PlayerModel>>((ref) async {
  final repository = ref.watch(chessRepositoryProvider);
  return repository.getLeaderboard(limit: 50);
});

/// Provider for finding random opponent
final randomOpponentProvider = FutureProvider<PlayerModel>((ref) async {
  final repository = ref.watch(chessRepositoryProvider);
  return repository.findRandomOpponent();
});
