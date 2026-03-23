enum PieceType { pawn, rook, knight, bishop, queen, king, empty }

enum PieceColor { white, black }

class ChessPiece {
  final PieceType type;
  final PieceColor color;

  ChessPiece({required this.type, required this.color});

  String toSymbol() {
    const symbols = {
      'wK': '♔',
      'wQ': '♕',
      'wR': '♖',
      'wB': '♗',
      'wN': '♘',
      'wP': '♙',
      'bK': '♚',
      'bQ': '♛',
      'bR': '♜',
      'bB': '♝',
      'bN': '♞',
      'bP': '♟',
    };
    final key =
        '${color == PieceColor.white ? 'w' : 'b'}${type.name.toUpperCase()[0]}';
    return symbols[key] ?? '';
  }

  static ChessPiece? fromFEN(String char) {
    final colorMap = {
      'K': PieceColor.white,
      'Q': PieceColor.white,
      'R': PieceColor.white,
      'B': PieceColor.white,
      'N': PieceColor.white,
      'P': PieceColor.white,
      'k': PieceColor.black,
      'q': PieceColor.black,
      'r': PieceColor.black,
      'b': PieceColor.black,
      'n': PieceColor.black,
      'p': PieceColor.black,
    };

    final typeMap = {
      'K': PieceType.king,
      'Q': PieceType.queen,
      'R': PieceType.rook,
      'B': PieceType.bishop,
      'N': PieceType.knight,
      'P': PieceType.pawn,
      'k': PieceType.king,
      'q': PieceType.queen,
      'r': PieceType.rook,
      'b': PieceType.bishop,
      'n': PieceType.knight,
      'p': PieceType.pawn,
    };

    if (colorMap.containsKey(char) && typeMap.containsKey(char)) {
      return ChessPiece(
        color: colorMap[char]!,
        type: typeMap[char]!,
      );
    }
    return null;
  }

  ChessPiece copy() => ChessPiece(type: type, color: color);
}

class ChessSquare {
  int file;
  int rank;

  ChessSquare({required this.file, required this.rank});

  String toAlgebraic() {
    return '${String.fromCharCode(97 + file)}${8 - rank}';
  }

  static ChessSquare? fromAlgebraic(String sq) {
    if (sq.length != 2) return null;
    final file = sq.codeUnitAt(0) - 97;
    final rank = 8 - int.tryParse(sq[1])!;
    if (file < 0 || file > 7 || rank < 0 || rank > 7) return null;
    return ChessSquare(file: file, rank: rank);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChessSquare &&
          runtimeType == other.runtimeType &&
          file == other.file &&
          rank == other.rank;

  @override
  int get hashCode => file.hashCode ^ rank.hashCode;

  ChessSquare copy() => ChessSquare(file: file, rank: rank);
}

class ChessMove {
  final ChessSquare from;
  final ChessSquare to;
  final PieceType? promotion;

  ChessMove({
    required this.from,
    required this.to,
    this.promotion,
  });

  String toAlgebraic() {
    final result = '${from.toAlgebraic()}${to.toAlgebraic()}';
    if (promotion != null) {
      const promotionMap = {
        PieceType.queen: 'q',
        PieceType.rook: 'r',
        PieceType.bishop: 'b',
        PieceType.knight: 'n',
      };
      return result + (promotionMap[promotion] ?? 'q');
    }
    return result;
  }

  static ChessMove? fromAlgebraic(String move) {
    if (move.length < 4) return null;
    final from = ChessSquare.fromAlgebraic(move.substring(0, 2));
    final to = ChessSquare.fromAlgebraic(move.substring(2, 4));
    if (from == null || to == null) return null;

    PieceType? promotion;
    if (move.length > 4) {
      const promotionMap = {
        'q': PieceType.queen,
        'r': PieceType.rook,
        'b': PieceType.bishop,
        'n': PieceType.knight
      };
      promotion = promotionMap[move[4]];
    }

    return ChessMove(from: from, to: to, promotion: promotion);
  }

  @override
  String toString() => toAlgebraic();
}

class ChessGame {
  late List<List<ChessPiece?>> board;
  late PieceColor turn;
  late bool whiteCanCastleKingSide;
  late bool whiteCanCastleQueenSide;
  late bool blackCanCastleKingSide;
  late bool blackCanCastleQueenSide;
  late ChessSquare? enpassantSquare;
  late int halfmoveClock;
  late int fullmoveNumber;
  late List<String> moveHistory;

  ChessGame() {
    loadFEN('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1');
    moveHistory = [];
  }

  void loadFEN(String fen) {
    final parts = fen.split(' ');

    // Initialize board
    board = List.generate(8, (_) => List.filled(8, null));
    final ranks = parts[0].split('/');

    for (int rank = 0; rank < 8; rank++) {
      int file = 0;
      for (final char in ranks[rank].split('')) {
        if (int.tryParse(char) != null) {
          file += int.parse(char);
        } else {
          final piece = ChessPiece.fromFEN(char);
          if (piece != null) {
            board[rank][file] = piece;
            file++;
          }
        }
      }
    }

    // Parse turn
    turn = parts[1] == 'w' ? PieceColor.white : PieceColor.black;

    // Parse castling rights
    whiteCanCastleKingSide = parts[2].contains('K');
    whiteCanCastleQueenSide = parts[2].contains('Q');
    blackCanCastleKingSide = parts[2].contains('k');
    blackCanCastleQueenSide = parts[2].contains('q');

    // Parse en passant
    enpassantSquare =
        parts[3] != '-' ? ChessSquare.fromAlgebraic(parts[3]) : null;

    // Parse clocks
    halfmoveClock = int.tryParse(parts[4]) ?? 0;
    fullmoveNumber = int.tryParse(parts[5]) ?? 1;
  }

  String toFEN() {
    final buffer = StringBuffer();

    // Board
    for (int rank = 0; rank < 8; rank++) {
      int emptyCount = 0;
      for (int file = 0; file < 8; file++) {
        final piece = board[rank][file];
        if (piece == null) {
          emptyCount++;
        } else {
          if (emptyCount > 0) {
            buffer.write(emptyCount);
            emptyCount = 0;
          }
          final symbol = _pieceToFEN(piece);
          buffer.write(symbol);
        }
      }
      if (emptyCount > 0) buffer.write(emptyCount);
      if (rank < 7) buffer.write('/');
    }

    buffer.write(' ${turn == PieceColor.white ? 'w' : 'b'} ');

    // Castling
    String castling = '';
    if (whiteCanCastleKingSide) castling += 'K';
    if (whiteCanCastleQueenSide) castling += 'Q';
    if (blackCanCastleKingSide) castling += 'k';
    if (blackCanCastleQueenSide) castling += 'q';
    buffer.write(castling.isEmpty ? '-' : castling);
    buffer.write(' ');

    // En passant
    buffer.write(enpassantSquare?.toAlgebraic() ?? '-');
    buffer.write(' $halfmoveClock $fullmoveNumber');

    return buffer.toString();
  }

  String _pieceToFEN(ChessPiece piece) {
    const map = {
      PieceType.king: 'k',
      PieceType.queen: 'q',
      PieceType.rook: 'r',
      PieceType.bishop: 'b',
      PieceType.knight: 'n',
      PieceType.pawn: 'p',
      PieceType.empty: '',
    };
    final char = map[piece.type]!;
    return piece.color == PieceColor.white ? char.toUpperCase() : char;
  }

  bool isLegalMove(ChessMove move) {
    if (board[move.from.rank][move.from.file] == null) return false;

    final piece = board[move.from.rank][move.from.file]!;
    if (piece.color != turn) return false;

    if (!_isPseudoLegalMove(move, piece)) return false;

    // Make the move temporarily
    final originalPiece = board[move.to.rank][move.to.file];
    board[move.to.rank][move.to.file] = piece;
    board[move.from.rank][move.from.file] = null;

    // Check if king is in check
    final kingSquare = _findKing(piece.color);
    final isCheck =
        kingSquare != null && _isSquareAttacked(kingSquare, piece.color);

    // Undo the move
    board[move.from.rank][move.from.file] = piece;
    board[move.to.rank][move.to.file] = originalPiece;

    return !isCheck;
  }

  bool _isPseudoLegalMove(ChessMove move, ChessPiece piece) {
    if (move.from == move.to) return false;

    final targetSquare = board[move.to.rank][move.to.file];
    if (targetSquare != null && targetSquare.color == piece.color) return false;

    switch (piece.type) {
      case PieceType.pawn:
        return _isLegalPawnMove(move, piece);
      case PieceType.rook:
        return _isLegalRookMove(move) && _isPathClear(move);
      case PieceType.knight:
        return _isLegalKnightMove(move);
      case PieceType.bishop:
        return _isLegalBishopMove(move) && _isPathClear(move);
      case PieceType.queen:
        return (_isLegalRookMove(move) || _isLegalBishopMove(move)) &&
            _isPathClear(move);
      case PieceType.king:
        return _isLegalKingMove(move);
      case PieceType.empty:
        return false;
    }
  }

  bool _isLegalPawnMove(ChessMove move, ChessPiece piece) {
    final direction = piece.color == PieceColor.white ? -1 : 1;
    final startRank = piece.color == PieceColor.white ? 6 : 1;

    // Forward move
    if (move.to.file == move.from.file) {
      if (board[move.to.rank][move.to.file] != null) return false;

      if (move.to.rank == move.from.rank + direction) {
        return true;
      }

      if (move.from.rank == startRank &&
          move.to.rank == move.from.rank + 2 * direction &&
          board[move.from.rank + direction][move.from.file] == null) {
        return true;
      }
    }

    // Capture
    if ((move.to.file - move.from.file).abs() == 1 &&
        move.to.rank == move.from.rank + direction) {
      if (board[move.to.rank][move.to.file] != null) {
        return true;
      }

      // En passant
      if (enpassantSquare == move.to) {
        return true;
      }
    }

    return false;
  }

  bool _isLegalRookMove(ChessMove move) {
    return move.from.file == move.to.file || move.from.rank == move.to.rank;
  }

  bool _isLegalKnightMove(ChessMove move) {
    final fileDiff = (move.to.file - move.from.file).abs();
    final rankDiff = (move.to.rank - move.from.rank).abs();
    return (fileDiff == 2 && rankDiff == 1) || (fileDiff == 1 && rankDiff == 2);
  }

  bool _isLegalBishopMove(ChessMove move) {
    return (move.to.file - move.from.file).abs() ==
        (move.to.rank - move.from.rank).abs();
  }

  bool _isLegalKingMove(ChessMove move) {
    return (move.to.file - move.from.file).abs() <= 1 &&
        (move.to.rank - move.from.rank).abs() <= 1;
  }

  bool _isPathClear(ChessMove move) {
    final fileDir = move.to.file > move.from.file
        ? 1
        : move.to.file < move.from.file
            ? -1
            : 0;
    final rankDir = move.to.rank > move.from.rank
        ? 1
        : move.to.rank < move.from.rank
            ? -1
            : 0;

    int currentFile = move.from.file + fileDir;
    int currentRank = move.from.rank + rankDir;

    while (currentFile != move.to.file || currentRank != move.to.rank) {
      if (board[currentRank][currentFile] != null) return false;
      currentFile += fileDir;
      currentRank += rankDir;
    }

    return true;
  }

  bool makeMove(ChessMove move) {
    if (!isLegalMove(move)) return false;

    final piece = board[move.from.rank][move.from.file]!;
    final capturedPiece = board[move.to.rank][move.to.file];

    // Handle en passant capture
    if (piece.type == PieceType.pawn && enpassantSquare == move.to) {
      final captureRank = move.from.rank;
      board[captureRank][move.to.file] = null;
    }

    // Handle pawn promotion
    if (piece.type == PieceType.pawn &&
        ((piece.color == PieceColor.white && move.to.rank == 0) ||
            (piece.color == PieceColor.black && move.to.rank == 7))) {
      board[move.to.rank][move.to.file] = ChessPiece(
        type: move.promotion ?? PieceType.queen,
        color: piece.color,
      );
    } else {
      board[move.to.rank][move.to.file] = piece;
    }

    board[move.from.rank][move.from.file] = null;

    // Handle castling
    if (piece.type == PieceType.king) {
      if (move.from.file == 4 && move.to.file == 6) {
        // King side castling
        final rook = board[move.from.rank][7];
        if (rook != null) {
          board[move.from.rank][5] = rook;
          board[move.from.rank][7] = null;
        }
      } else if (move.from.file == 4 && move.to.file == 2) {
        // Queen side castling
        final rook = board[move.from.rank][0];
        if (rook != null) {
          board[move.from.rank][3] = rook;
          board[move.from.rank][0] = null;
        }
      }

      if (piece.color == PieceColor.white) {
        whiteCanCastleKingSide = false;
        whiteCanCastleQueenSide = false;
      } else {
        blackCanCastleKingSide = false;
        blackCanCastleQueenSide = false;
      }
    }

    // Update castling rights for rooks
    if (piece.type == PieceType.rook) {
      if (piece.color == PieceColor.white) {
        if (move.from.file == 0) whiteCanCastleQueenSide = false;
        if (move.from.file == 7) whiteCanCastleKingSide = false;
      } else {
        if (move.from.file == 0) blackCanCastleQueenSide = false;
        if (move.from.file == 7) blackCanCastleKingSide = false;
      }
    }

    // Update en passant square
    enpassantSquare = null;
    if (piece.type == PieceType.pawn &&
        (move.to.rank - move.from.rank).abs() == 2) {
      enpassantSquare = ChessSquare(
        file: move.to.file,
        rank: (move.from.rank + move.to.rank) ~/ 2,
      );
    }

    // Update halfmove clock
    if (piece.type == PieceType.pawn || capturedPiece != null) {
      halfmoveClock = 0;
    } else {
      halfmoveClock++;
    }

    // Update fullmove number
    if (piece.color == PieceColor.black) {
      fullmoveNumber++;
    }

    moveHistory.add(move.toAlgebraic());
    turn = turn == PieceColor.white ? PieceColor.black : PieceColor.white;

    return true;
  }

  ChessSquare? _findKing(PieceColor color) {
    for (int rank = 0; rank < 8; rank++) {
      for (int file = 0; file < 8; file++) {
        final piece = board[rank][file];
        if (piece != null &&
            piece.type == PieceType.king &&
            piece.color == color) {
          return ChessSquare(file: file, rank: rank);
        }
      }
    }
    return null;
  }

  bool _isSquareAttacked(ChessSquare square, PieceColor byColor) {
    for (int rank = 0; rank < 8; rank++) {
      for (int file = 0; file < 8; file++) {
        final piece = board[rank][file];
        if (piece != null && piece.color == byColor) {
          final fromSquare = ChessSquare(file: file, rank: rank);
          if (_isPseudoLegalMove(
              ChessMove(from: fromSquare, to: square), piece)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool isInCheck(PieceColor color) {
    final kingSquare = _findKing(color);
    return kingSquare != null &&
        _isSquareAttacked(kingSquare,
            color == PieceColor.white ? PieceColor.black : PieceColor.white);
  }

  List<ChessMove> getLegalMoves() {
    final moves = <ChessMove>[];
    for (int rank = 0; rank < 8; rank++) {
      for (int file = 0; file < 8; file++) {
        final piece = board[rank][file];
        if (piece != null && piece.color == turn) {
          final from = ChessSquare(file: file, rank: rank);
          for (int toRank = 0; toRank < 8; toRank++) {
            for (int toFile = 0; toFile < 8; toFile++) {
              final to = ChessSquare(file: toFile, rank: toRank);
              final move = ChessMove(from: from, to: to);
              if (isLegalMove(move)) {
                moves.add(move);
              }
            }
          }
        }
      }
    }
    return moves;
  }

  bool isCheckmate() {
    return isInCheck(turn) && getLegalMoves().isEmpty;
  }

  bool isStalemate() {
    return !isInCheck(turn) && getLegalMoves().isEmpty;
  }

  GameStatus getGameStatus() {
    if (isCheckmate()) return GameStatus.checkmate;
    if (isStalemate()) return GameStatus.stalemate;
    if (halfmoveClock >= 100) return GameStatus.fiftyMoveRule;
    if (isInCheck(turn)) return GameStatus.check;
    return GameStatus.ongoing;
  }
}

enum GameStatus { ongoing, check, checkmate, stalemate, fiftyMoveRule }
