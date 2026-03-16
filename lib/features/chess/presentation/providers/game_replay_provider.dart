import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/game_record_model.dart';

/// Notifier for managing game replay state
class GameReplayNotifier extends StateNotifier<GameReplayState> {
  final GameRecord gameRecord;

  GameReplayNotifier({required this.gameRecord})
      : super(
          GameReplayState(
            gameRecord: gameRecord,
            currentMoveIndex: -1, // -1 means starting position
            isPlaying: false,
          ),
        );

  /// Go to next move
  void nextMove() {
    if (state.currentMoveIndex < gameRecord.moves.length - 1) {
      state = state.copyWith(currentMoveIndex: state.currentMoveIndex + 1);
    }
  }

  /// Go to previous move
  void previousMove() {
    if (state.currentMoveIndex > -1) {
      state = state.copyWith(currentMoveIndex: state.currentMoveIndex - 1);
    }
  }

  /// Jump to specific move
  void jumpToMove(int moveIndex) {
    if (moveIndex >= -1 && moveIndex < gameRecord.moves.length) {
      state = state.copyWith(currentMoveIndex: moveIndex);
    }
  }

  /// Go to start
  void goToStart() {
    state = state.copyWith(currentMoveIndex: -1, isPlaying: false);
  }

  /// Go to end
  void goToEnd() {
    state = state.copyWith(
      currentMoveIndex: gameRecord.moves.length - 1,
      isPlaying: false,
    );
  }

  /// Start auto-replay
  void startAutoReplay({Duration stepDuration = const Duration(seconds: 2)}) {
    state = state.copyWith(isPlaying: true, autoPlaySpeed: stepDuration);
    _autoPlay();
  }

  /// Pause auto-replay
  void pauseAutoReplay() {
    state = state.copyWith(isPlaying: false);
  }

  /// Toggle auto-replay
  void toggleAutoReplay() {
    if (state.isPlaying) {
      pauseAutoReplay();
    } else {
      startAutoReplay();
    }
  }

  /// Auto-play logic
  void _autoPlay() async {
    while (state.isPlaying &&
        state.currentMoveIndex < gameRecord.moves.length - 1) {
      await Future.delayed(state.autoPlaySpeed);
      nextMove();
    }
    // Auto-stop at end
    state = state.copyWith(isPlaying: false);
  }

  /// Get current board FEN
  String getCurrentFen() {
    if (state.currentMoveIndex < 0) {
      return gameRecord.startingFen;
    }
    return gameRecord.moves[state.currentMoveIndex].fen;
  }

  /// Get current move
  GameMove? getCurrentMove() {
    if (state.currentMoveIndex < 0 ||
        state.currentMoveIndex >= gameRecord.moves.length) {
      return null;
    }
    return gameRecord.moves[state.currentMoveIndex];
  }

  /// Get all moves up to current position
  List<GameMove> getMovesUpToCurrent() {
    if (state.currentMoveIndex < 0) {
      return [];
    }
    return gameRecord.moves.sublist(0, state.currentMoveIndex + 1);
  }
}

/// State for game replay
class GameReplayState {
  final GameRecord gameRecord;
  final int currentMoveIndex; // -1 for starting position
  final bool isPlaying; // Auto-replay in progress
  final Duration autoPlaySpeed; // Speed for auto-replay

  GameReplayState({
    required this.gameRecord,
    required this.currentMoveIndex,
    required this.isPlaying,
    this.autoPlaySpeed = const Duration(seconds: 2),
  });

  GameReplayState copyWith({
    GameRecord? gameRecord,
    int? currentMoveIndex,
    bool? isPlaying,
    Duration? autoPlaySpeed,
  }) {
    return GameReplayState(
      gameRecord: gameRecord ?? this.gameRecord,
      currentMoveIndex: currentMoveIndex ?? this.currentMoveIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      autoPlaySpeed: autoPlaySpeed ?? this.autoPlaySpeed,
    );
  }

  // Helper getters
  bool get isAtStart => currentMoveIndex < 0;
  bool get isAtEnd => currentMoveIndex >= gameRecord.moves.length - 1;
  int get moveCount => gameRecord.moves.length;
  double get progress =>
      isAtStart ? 0 : (currentMoveIndex + 1) / gameRecord.moves.length;
}

/// Provider for game replay
final gameReplayProvider = StateNotifierProvider.family<GameReplayNotifier,
    GameReplayState, GameRecord>((ref, gameRecord) {
  return GameReplayNotifier(gameRecord: gameRecord);
});

/// Provider for game history list
final gameHistoryProvider = FutureProvider<List<GameRecord>>((ref) async {
  // TODO: Implement API call to fetch game history
  return [];
});

/// Provider for specific game record
final gameRecordProvider = FutureProvider.family<GameRecord?, String>((
  ref,
  gameId,
) async {
  // TODO: Implement API call to fetch specific game record
  return null;
});

/// Provider for game analysis summary
final gameAnalysisSummaryProvider =
    Provider.family<Map<String, dynamic>, GameRecord>((ref, gameRecord) {
  return gameRecord.getAnalysisSummary();
});

/// Provider for tracking selected game in history
final selectedGameHistoryProvider = StateProvider<GameRecord?>((_) => null);
