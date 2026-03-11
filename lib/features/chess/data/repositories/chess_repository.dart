import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/chess_remote_datasource.dart';
import '../datasources/chess_socket_datasource.dart';
import '../models/chess_move_model.dart';
import '../models/game_state_model.dart';

/// Chess repository
class ChessRepository {
  final ChessRemoteDataSource _remoteDataSource;
  final ChessSocketDataSource _socketDataSource;

  ChessRepository(this._remoteDataSource, this._socketDataSource);

  Future<GameStateModel> getGameState(String gameId) async {
    return await _remoteDataSource.getGameState(gameId);
  }

  Future<void> makeMove(String gameId, ChessMoveModel move) async {
    return await _remoteDataSource.makeMove(gameId, move);
  }

  void subscribeToGameUpdates(String gameId, Function callback) {
    _socketDataSource.subscribeToGameUpdates(gameId, callback);
  }

  void unsubscribeFromGameUpdates(Function callback) {
    _socketDataSource.unsubscribeFromGameUpdates(callback);
  }

  void sendMove(String gameId, ChessMoveModel move) {
    _socketDataSource.sendMove(gameId, move);
  }

  void resignGame(String gameId) {
    _socketDataSource.resignGame(gameId);
  }
}

/// Provider for chess repository
final chessRepositoryProvider = Provider<ChessRepository>((ref) {
  final remoteDataSource = ref.watch(chessRemoteDataSourceProvider);
  final socketDataSource = ref.watch(chessSocketDataSourceProvider);
  return ChessRepository(remoteDataSource, socketDataSource);
});
