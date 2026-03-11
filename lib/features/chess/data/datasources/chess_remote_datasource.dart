import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chess_move_model.dart';
import '../models/game_state_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/websocket/socket_client.dart';

/// Chess remote data source
class ChessRemoteDataSource {
  final ApiClient _apiClient;

  ChessRemoteDataSource(this._apiClient);

  Future<GameStateModel> getGameState(String gameId) async {
    // TODO: Implement get game state API call
    throw UnimplementedError();
  }

  Future<void> makeMove(String gameId, ChessMoveModel move) async {
    // TODO: Implement make move API call
    throw UnimplementedError();
  }

  Future<void> surrenderGame(String gameId) async {
    // TODO: Implement surrender API call
    throw UnimplementedError();
  }
}

/// Provider for chess remote data source
final chessRemoteDataSourceProvider = Provider<ChessRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChessRemoteDataSource(apiClient);
});
