import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chess_move_model.dart';
import '../models/game_state_model.dart';
import '../models/game_history_model.dart';
import '../models/player_model.dart';
import 'package:chess_janak_app/core/network/dio_provider.dart';
import 'package:chess_janak_app/core/config/api_endpoints.dart';

/// Chess remote data source for handling API calls
/// Connected to Django backend
class ChessRemoteDataSource {
  final Dio _dio;

  ChessRemoteDataSource(this._dio);

  /// Get current game state from Django
  /// Connects to: GET /api/chess/room/{room_id}/
  Future<GameStateModel> getGameState(String roomId) async {
    try {
      final response = await _dio.get(ApiEndpoints.roomMatch(roomId));
      return GameStateModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Make a move in the game - sends move to Django via REST API
  Future<GameStateModel> makeMove(String roomId, ChessMoveModel move) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.roomMatch(roomId)}moves/',
        data: {
          'from': move.from,
          'to': move.to,
          'promotion': move.promotion,
        },
      );
      return GameStateModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get move history for a game
  /// Connects to: GET /api/chess/room/{room_id}/moves/
  Future<List<ChessMoveModel>> getMoveHistory(String roomId) async {
    try {
      final response = await _dio.get(ApiEndpoints.roomMoves(roomId));
      final data = response.data is List
          ? response.data
          : response.data['results'] ?? [];
      return (data as List<dynamic>)
          .map((move) => ChessMoveModel.fromJson(move as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get game history for a player
  Future<List<GameHistoryModel>> getGameHistory(String playerId) async {
    try {
      final response =
          await _dio.get('${ApiEndpoints.base}/players/$playerId/games');
      final List<dynamic> data = response.data is List
          ? response.data
          : response.data['results'] ?? [];
      return data
          .map(
              (game) => GameHistoryModel.fromJson(game as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Create a new game room using Django rooms API
  /// Connects to: POST /api/rooms/create/
  Future<Map<String, dynamic>> createRoom({
    required String gameMode,
    int? timeLimit,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.createRoom,
        data: {
          'game_mode': gameMode,
          'time_limit': timeLimit,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Join an existing game room
  Future<Map<String, dynamic>> joinRoom(String inviteCode) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.joinRoom,
        data: {'invite_code': inviteCode},
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Get user's rooms (active games)
  Future<List<Map<String, dynamic>>> getUserRooms() async {
    try {
      final response = await _dio.get(ApiEndpoints.myRooms);
      final data = response.data is List
          ? response.data
          : response.data['results'] ?? [];
      return (data as List<dynamic>)
          .map((room) => room as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get room details
  Future<Map<String, dynamic>> getRoomDetails(String roomId) async {
    try {
      final response = await _dio.get(ApiEndpoints.roomDetail(roomId));
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Look up invite code
  Future<Map<String, dynamic>> lookupInvite(String inviteCode) async {
    try {
      final response = await _dio.get(ApiEndpoints.inviteLookup(inviteCode));
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Get player profile
  Future<PlayerModel> getPlayerProfile(String playerId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.base}/players/$playerId');
      return PlayerModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get leaderboard
  Future<List<PlayerModel>> getLeaderboard({int limit = 50}) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.base}/leaderboard',
        queryParameters: {'limit': limit},
      );
      final List<dynamic> data = response.data;
      return data
          .map((player) => PlayerModel.fromJson(player as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Find random opponent
  Future<PlayerModel> findRandomOpponent() async {
    try {
      final response = await _dio.get('${ApiEndpoints.base}/players/random');
      return PlayerModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

/// Provider for chess remote data source
final chessRemoteDataSourceProvider = Provider<ChessRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ChessRemoteDataSource(dio);
});
