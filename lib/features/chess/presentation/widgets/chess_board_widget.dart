import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/chess_engine.dart';

/// Chess board widget
class ChessBoardWidget extends ConsumerStatefulWidget {
  final String fen;
  final Function(String from, String to) onMoveMade;
  final bool isWhiteBottom;
  final bool isInteractive;

  const ChessBoardWidget({
    super.key,
    required this.fen,
    required this.onMoveMade,
    this.isWhiteBottom = true,
    this.isInteractive = true,
  });

  @override
  ConsumerState<ChessBoardWidget> createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends ConsumerState<ChessBoardWidget> {
  late ChessGame _chessGame;
  String? _selectedSquare;
  List<String> _legalMoves = [];

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  @override
  void didUpdateWidget(ChessBoardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fen != widget.fen) {
      _initializeBoard();
    }
  }

  void _initializeBoard() {
    _chessGame = ChessGame();
    _chessGame.loadFEN(widget.fen);
    _selectedSquare = null;
    _legalMoves = [];
  }

  void _onSquareTapped(int rank, int file) {
    if (!widget.isInteractive) return;

    final square = ChessSquare(file: file, rank: rank);
    final algebraic = square.toAlgebraic();

    if (_selectedSquare == null) {
      // Select a piece
      if (_chessGame.board[rank][file] != null) {
        setState(() {
          _selectedSquare = algebraic;
          _legalMoves = _getLegalMovesForSquare(algebraic);
        });
      }
    } else {
      if (_selectedSquare == algebraic) {
        // Deselect
        setState(() {
          _selectedSquare = null;
          _legalMoves = [];
        });
      } else if (_legalMoves.contains(algebraic)) {
        // Make move
        widget.onMoveMade(_selectedSquare!, algebraic);
        setState(() {
          _selectedSquare = null;
          _legalMoves = [];
        });
      } else {
        // Select different piece
        if (_chessGame.board[rank][file] != null) {
          setState(() {
            _selectedSquare = algebraic;
            _legalMoves = _getLegalMovesForSquare(algebraic);
          });
        }
      }
    }
  }

  List<String> _getLegalMovesForSquare(String square) {
    try {
      final fromSquare = ChessSquare.fromAlgebraic(square);
      if (fromSquare == null) return [];

      return _chessGame
          .getLegalMoves()
          .where((move) => move.from == fromSquare)
          .map((move) => move.to.toAlgebraic())
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final squares = _buildBoardSquares();
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemCount: 64,
          itemBuilder: (context, index) {
            final rank = widget.isWhiteBottom ? 7 - (index ~/ 8) : index ~/ 8;
            final file = widget.isWhiteBottom ? index % 8 : 7 - (index % 8);
            return squares[rank][file];
          },
        ),
      ),
    );
  }

  List<List<Widget>> _buildBoardSquares() {
    final List<List<Widget>> squares = [];

    for (int rank = 0; rank < 8; rank++) {
      final row = <Widget>[];
      for (int file = 0; file < 8; file++) {
        final square = ChessSquare(file: file, rank: rank);
        final algebraic = square.toAlgebraic();
        final piece = _chessGame.board[rank][file];
        final isLight = (rank + file) % 2 == 0;
        final isSelected = _selectedSquare == algebraic;
        final isLegalMove = _legalMoves.contains(algebraic);

        row.add(
          _buildSquare(
            rank: rank,
            file: file,
            piece: piece,
            isLight: isLight,
            isSelected: isSelected,
            isLegalMove: isLegalMove,
            algebraic: algebraic,
          ),
        );
      }
      squares.add(row);
    }

    return squares;
  }

  Widget _buildSquare({
    required int rank,
    required int file,
    required ChessPiece? piece,
    required bool isLight,
    required bool isSelected,
    required bool isLegalMove,
    required String algebraic,
  }) {
    Color backgroundColor = isLight ? Colors.grey[100]! : Colors.grey[700]!;

    if (isSelected) {
      backgroundColor = Colors.amber;
    } else if (isLegalMove) {
      backgroundColor = Colors.green.withOpacity(0.5);
    }

    return GestureDetector(
      onTap: () => _onSquareTapped(rank, file),
      child: Container(
        color: backgroundColor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Coordinates
            Positioned(
              top: 4,
              left: 4,
              child: Text(
                algebraic,
                style: TextStyle(
                  fontSize: 9,
                  color: isLight ? Colors.grey[700] : Colors.grey[300],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Piece
            if (piece != null)
              Text(
                piece.toSymbol(),
                style: const TextStyle(fontSize: 36),
              ),
            // Legal move indicator
            if (isLegalMove && piece == null)
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.shade700,
                ),
              ),
            // Legal capture indicator
            if (isLegalMove && piece != null)
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red.shade700,
                    width: 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
