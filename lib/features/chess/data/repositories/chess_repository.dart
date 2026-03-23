import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/chess_remote_datasource.dart';
import '../models/chess_move_model.dart';
import '../models/game_state_model.dart';
import '../models/game_history_model.dart';
import '../models/player_model.dart';

/// Chess repository for handling game logic and data
class ChessRepository {
  final ChessRemoteDataSource _remoteDataSource;

  ChessRepository(this._remoteDataSource);

  /// Get current game state
  Future<GameStateModel> getGameState(String gameId) {
    return _remoteDataSource.getGameState(gameId);
  }

  /// Make a move
  Future<GameStateModel> makeMove(String gameId, ChessMoveModel move) {
    return _remoteDataSource.makeMove(gameId, move);
  }

  /// Get move history
  Future<List<ChessMoveModel>> getMoveHistory(String gameId) {
    return _remoteDataSource.getMoveHistory(gameId);
  }

  /// Get game history
  Future<List<GameHistoryModel>> getGameHistory(String playerId) {
    return _remoteDataSource.getGameHistory(playerId);
  }

  /// Create a new game room
  Future<Map<String, dynamic>> createRoom({
    required String gameMode,
    int? timeLimit,
  }) {
    return _remoteDataSource.createRoom(
      gameMode: gameMode,
      timeLimit: timeLimit,
    );
  }

  /// Join a game room
  Future<Map<String, dynamic>> joinRoom(String inviteCode) {
    return _remoteDataSource.joinRoom(inviteCode);
  }

  /// Get user's game rooms
  Future<List<Map<String, dynamic>>> getUserRooms() {
    return _remoteDataSource.getUserRooms();
  }

  /// Get room details
  Future<Map<String, dynamic>> getRoomDetails(String roomId) {
    return _remoteDataSource.getRoomDetails(roomId);
  }

  /// Lookup invite code
  Future<Map<String, dynamic>> lookupInvite(String inviteCode) {
    return _remoteDataSource.lookupInvite(inviteCode);
  }

  /// Get player profile
  Future<PlayerModel> getPlayerProfile(String playerId) {
    return _remoteDataSource.getPlayerProfile(playerId);
  }

  /// Get leaderboard
  Future<List<PlayerModel>> getLeaderboard({int limit = 50}) {
    return _remoteDataSource.getLeaderboard(limit: limit);
  }

  /// Find random opponent
  Future<PlayerModel> findRandomOpponent() {
    return _remoteDataSource.findRandomOpponent();
  }
}

/// Provider for chess repository
final chessRepositoryProvider = Provider<ChessRepository>((ref) {
  final remoteDataSource = ref.watch(chessRemoteDataSourceProvider);
  return ChessRepository(remoteDataSource);
});
