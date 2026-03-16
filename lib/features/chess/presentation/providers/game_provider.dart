import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/chess_remote_datasource.dart';
import '../../data/models/game_state_model.dart';
import '../../data/models/chess_move_model.dart';
// import '../../../core/websocket/socket_client.dart'; // TODO: Implement WebSocket client

/// Current game state provider
final currentGameStateProvider =
    StateNotifierProvider<GameStateNotifier, AsyncValue<GameStateModel?>>(
        (ref) {
  final chessDataSource = ref.watch(chessRemoteDataSourceProvider);
  return GameStateNotifier(chessDataSource);
});

/// GameStateNotifier for managing chess game state
class GameStateNotifier extends StateNotifier<AsyncValue<GameStateModel?>> {
  final ChessRemoteDataSource _chessDataSource;

  GameStateNotifier(this._chessDataSource) : super(const AsyncValue.data(null));

  /// Fetch game state from backend
  Future<void> fetchGameState(String roomId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _chessDataSource.getGameState(roomId));
  }

  /// Make a move
  Future<void> makeMove({
    required String roomId,
    required String from,
    required String to,
    String? promotion,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final move = ChessMoveModel(
        from: from,
        to: to,
        promotion: promotion,
        moveNumber: 0, // Server will assign the correct move number
        timestamp: DateTime.now(),
      );
      await _chessDataSource.makeMove(roomId, move);
      // Fetch updated game state
      return await _chessDataSource.getGameState(roomId);
    });
  }

  /// Resign from game
  Future<void> resignGame(String roomId) async {
    state = const AsyncValue.loading();
    try {
      // TODO: Implement resign API endpoint in ChessRemoteDataSource
      // await _chessDataSource.resignGame(roomId);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Clear current game state
  void clearGame() {
    state = const AsyncValue.data(null);
  }
}

/// Provider for user's active game rooms
final userActiveRoomsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  // TODO: Implement when chess datasource is ready
  return [];
});

/// Provider for game move history
final gameMoveHistoryProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, roomId) async {
  // TODO: Implement when chess datasource is ready
  return [];
});

/// Provider for user's game statistics
final userGameStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  // TODO: Implement when profile datasource is ready
  return {
    'total_games': 0,
    'wins': 0,
    'losses': 0,
    'draws': 0,
    'win_percentage': 0.0,
  };
});

/// Provider for specific game details
final gameDetailsProvider =
    FutureProvider.family<GameStateModel?, String>((ref, roomId) async {
  final chessDataSource = ref.watch(chessRemoteDataSourceProvider);
  try {
    return await chessDataSource.getGameState(roomId);
  } catch (e) {
    return null;
  }
});

/// Provider for WebSocket client
// final socketClientProvider = Provider<SocketClient>((ref) {
//   return SocketClient();
// });
