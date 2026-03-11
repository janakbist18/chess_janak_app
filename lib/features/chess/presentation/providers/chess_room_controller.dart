import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/game_state_model.dart';
import '../../data/models/chess_move_model.dart';
import '../../data/repositories/chess_repository.dart';

/// Chess game state provider
final chessGameStateProvider =
    StateNotifierProvider<ChessRoomController, GameStateModel?>((ref) {
      final repository = ref.watch(chessRepositoryProvider);
      return ChessRoomController(repository);
    });

/// Chess room controller
class ChessRoomController extends StateNotifier<GameStateModel?> {
  final ChessRepository _repository;

  ChessRoomController(this._repository) : super(null);

  Future<void> loadGameState(String gameId) async {
    try {
      final state = await _repository.getGameState(gameId);
      this.state = state;
    } catch (e) {
      this.state = null;
    }
  }

  void makeMove(String gameId, ChessMoveModel move) {
    _repository.sendMove(gameId, move);
  }
}
