import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Chess game state notifier
class ChessGameStateNotifier extends StateNotifier<Map<String, dynamic>> {
  ChessGameStateNotifier()
    : super({
        'fen': 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
        'currentTurn': 'white',
        'gameStatus': 'active',
      });

  void updateFen(String fen) {
    state = {...state, 'fen': fen};
  }

  void toggleTurn() {
    final newTurn = state['currentTurn'] == 'white' ? 'black' : 'white';
    state = {...state, 'currentTurn': newTurn};
  }
}

/// Provider for chess game state
final chessGameStateProvider =
    StateNotifierProvider<ChessGameStateNotifier, Map<String, dynamic>>((ref) {
      return ChessGameStateNotifier();
    });
