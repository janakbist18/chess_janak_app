/// Represents a single move in a game
class GameMove {
  final String moveNumber; // e.g., "1", "2", etc.
  final String sanNotation; // Standard algebraic notation (e.g., "e4", "Nf3")
  final String from; // Square (e.g., "e2")
  final String to; // Square (e.g., "e4")
  final String? promotion; // Promotion piece (Q, R, B, N) if applicable
  final String fen; // FEN after the move
  final int? evaluation; // Stockfish evaluation in centipawns
  final String? bestMove; // Best move according to analysis
  final int moveTime; // Time taken for move in milliseconds
  final bool isWhiteMove;

  GameMove({
    required this.moveNumber,
    required this.sanNotation,
    required this.from,
    required this.to,
    this.promotion,
    required this.fen,
    this.evaluation,
    this.bestMove,
    required this.moveTime,
    required this.isWhiteMove,
  });

  factory GameMove.fromJson(Map<String, dynamic> json) {
    return GameMove(
      moveNumber: json['move_number'] as String,
      sanNotation: json['san_notation'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      promotion: json['promotion'] as String?,
      fen: json['fen'] as String,
      evaluation: json['evaluation'] as int?,
      bestMove: json['best_move'] as String?,
      moveTime: json['move_time'] as int? ?? 0,
      isWhiteMove: json['is_white_move'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'move_number': moveNumber,
        'san_notation': sanNotation,
        'from': from,
        'to': to,
        'promotion': promotion,
        'fen': fen,
        'evaluation': evaluation,
        'best_move': bestMove,
        'move_time': moveTime,
        'is_white_move': isWhiteMove,
      };
}

/// Represents complete game record
class GameRecord {
  final String gameId;
  final String whitePlayerId;
  final String whitePlayerName;
  final String blackPlayerId;
  final String blackPlayerName;
  final List<GameMove> moves;
  final String result; // "1-0", "0-1", "1/2-1/2"
  final String termination; // checkmate, resignation, timeout, draw, etc.
  final int whiteRatingChange;
  final int blackRatingChange;
  final DateTime playedAt;
  final String timeControl; // "5+3", "10+0", etc.
  final String variant;
  final String startingFen;

  GameRecord({
    required this.gameId,
    required this.whitePlayerId,
    required this.whitePlayerName,
    required this.blackPlayerId,
    required this.blackPlayerName,
    required this.moves,
    required this.result,
    required this.termination,
    required this.whiteRatingChange,
    required this.blackRatingChange,
    required this.playedAt,
    required this.timeControl,
    this.variant = 'standard',
    this.startingFen =
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
  });

  factory GameRecord.fromJson(Map<String, dynamic> json) {
    return GameRecord(
      gameId: json['id'] as String,
      whitePlayerId: json['white_player_id'] as String,
      whitePlayerName: json['white_player_name'] as String,
      blackPlayerId: json['black_player_id'] as String,
      blackPlayerName: json['black_player_name'] as String,
      moves: (json['moves'] as List<dynamic>?)
              ?.map((e) => GameMove.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      result: json['result'] as String? ?? '*',
      termination: json['termination'] as String? ?? 'unfinished',
      whiteRatingChange: json['white_rating_change'] as int? ?? 0,
      blackRatingChange: json['black_rating_change'] as int? ?? 0,
      playedAt: DateTime.parse(
        json['played_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      timeControl: json['time_control'] as String? ?? '3+2',
      variant: json['variant'] as String? ?? 'standard',
      startingFen: json['starting_fen'] as String? ??
          'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': gameId,
        'white_player_id': whitePlayerId,
        'white_player_name': whitePlayerName,
        'black_player_id': blackPlayerId,
        'black_player_name': blackPlayerName,
        'moves': moves.map((m) => m.toJson()).toList(),
        'result': result,
        'termination': termination,
        'white_rating_change': whiteRatingChange,
        'black_rating_change': blackRatingChange,
        'played_at': playedAt.toIso8601String(),
        'time_control': timeControl,
        'variant': variant,
        'starting_fen': startingFen,
      };

  /// Get PGN (Portable Game Notation) format
  String toPgn() {
    final buffer = StringBuffer();

    // Add headers
    buffer.writeln('[Event "Chess Game"]');
    buffer.writeln('[White "$whitePlayerName"]');
    buffer.writeln('[Black "$blackPlayerName"]');
    buffer.writeln('[Result "$result"]');
    buffer.writeln(
      '[Date "${playedAt.year}.${playedAt.month.toString().padLeft(2, '0')}.${playedAt.day.toString().padLeft(2, '0')}"]',
    );
    buffer.writeln('[TimeControl "$timeControl"]');
    buffer.writeln('[Termination "$termination"]');

    buffer.writeln();

    // Add moves
    for (int i = 0; i < moves.length; i++) {
      if (i % 2 == 0) {
        buffer.write('${(i ~/ 2) + 1}. ');
      }
      buffer.write('${moves[i].sanNotation} ');
    }

    buffer.write(result);

    return buffer.toString();
  }

  /// Get analysis summary
  Map<String, dynamic> getAnalysisSummary() {
    int whiteMistakes = 0;
    int blackMistakes = 0;
    String? worstMove;
    int? worstEval;

    for (final move in moves) {
      if (move.evaluation != null && move.bestMove != null) {
        if (move.evaluation!.abs() > 300) {
          // Evaluation swing > 3 pawns
          if (move.isWhiteMove) {
            whiteMistakes++;
          } else {
            blackMistakes++;
          }

          if (worstEval == null || move.evaluation!.abs() > worstEval) {
            worstEval = move.evaluation!.abs();
            worstMove = move.sanNotation;
          }
        }
      }
    }

    return {
      'white_mistakes': whiteMistakes,
      'black_mistakes': blackMistakes,
      'worst_move': worstMove,
      'accuracy': {
        'white':
            100 - (whiteMistakes / (moves.length / 2).ceil() * 100).toInt(),
        'black':
            100 - (blackMistakes / (moves.length / 2).ceil() * 100).toInt(),
      },
    };
  }
}
