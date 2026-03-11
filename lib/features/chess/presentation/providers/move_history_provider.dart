import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Move history provider
class MoveHistoryNotifier extends StateNotifier<List<String>> {
  MoveHistoryNotifier() : super([]);

  void addMove(String move) {
    state = [...state, move];
  }

  void removeLastMove() {
    if (state.isNotEmpty) {
      state = state.sublist(0, state.length - 1);
    }
  }

  void clearMoves() {
    state = [];
  }
}

/// Provider for move history
final moveHistoryProvider =
    StateNotifierProvider<MoveHistoryNotifier, List<String>>((ref) {
      return MoveHistoryNotifier();
    });
