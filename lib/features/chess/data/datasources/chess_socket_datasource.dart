import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chess_move_model.dart';
import '../../../../core/websocket/socket_client.dart';
import '../../../../core/websocket/socket_message.dart';

/// Chess socket data source
class ChessSocketDataSource {
  final SocketClient _socketClient;

  ChessSocketDataSource(this._socketClient);

  void subscribeToGameUpdates(String gameId, Function(SocketMessage) callback) {
    _socketClient.on(callback);
  }

  void unsubscribeFromGameUpdates(Function(SocketMessage) callback) {
    _socketClient.off(callback);
  }

  void sendMove(String gameId, ChessMoveModel move) {
    final message = SocketMessage(
      type: 'move',
      payload: {'gameId': gameId, 'move': move.toJson()},
    );
    _socketClient.send(message);
  }

  void resignGame(String gameId) {
    final message = SocketMessage(type: 'resign', payload: {'gameId': gameId});
    _socketClient.send(message);
  }
}

/// Provider for chess socket data source
final chessSocketDataSourceProvider = Provider<ChessSocketDataSource>((ref) {
  final socketClient = ref.watch(socketClientProvider);
  return ChessSocketDataSource(socketClient);
});
