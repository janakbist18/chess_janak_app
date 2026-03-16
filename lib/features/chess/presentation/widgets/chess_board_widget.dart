import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/chess_engine.dart';

/// Advanced responsive chess board widget
class ChessBoardWidget extends ConsumerStatefulWidget {
  final String fen;
  final Function(String from, String to)? onMoveMade;
  final bool isWhiteBottom;
  final bool isInteractive;
  final double? maxWidth;

  const ChessBoardWidget({
    super.key,
    required this.fen,
    this.onMoveMade,
    this.isWhiteBottom = true,
    this.isInteractive = true,
    this.maxWidth,
  });

  @override
  ConsumerState<ChessBoardWidget> createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends ConsumerState<ChessBoardWidget>
    with TickerProviderStateMixin {
  late ChessGame _chessGame;
  String? _selectedSquare;
  List<String> _legalMoves = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
        _animationController.forward(from: 0.0);
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
        widget.onMoveMade?.call(_selectedSquare!, algebraic);
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
          _animationController.forward(from: 0.0);
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
    final size = MediaQuery.of(context).size;
    final boardSize =
        widget.maxWidth ?? (size.width > 800 ? 500.0 : size.width * 0.9);
    final squareSize = boardSize / 8;

    return Center(
      child: Container(
        width: boardSize,
        height: boardSize,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.brown[900]!,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: _buildBoard(squareSize),
      ),
    );
  }

  Widget _buildBoard(double squareSize) {
    final squares = _buildBoardSquares();
    return GridView.builder(
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
    Color backgroundColor = isLight
        ? const Color(0xFFE8D4B8) // Light square
        : const Color(0xFF8B6F47); // Dark square

    if (isSelected) {
      backgroundColor = Colors.amber.shade600;
    } else if (isLegalMove) {
      backgroundColor = isLight ? Colors.green.shade200 : Colors.green.shade600;
    }

    return GestureDetector(
      onTap: () => _onSquareTapped(rank, file),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: backgroundColor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Coordinates (only on edges)
            if ((file == 0 && widget.isWhiteBottom) ||
                (file == 7 && !widget.isWhiteBottom))
              Positioned(
                bottom: 2,
                left: 2,
                child: Text(
                  '${rank + 1}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isLight ? Colors.brown[900] : Colors.grey[300],
                  ),
                ),
              ),
            if ((rank == 7 && widget.isWhiteBottom) ||
                (rank == 0 && !widget.isWhiteBottom))
              Positioned(
                top: 2,
                right: 2,
                child: Text(
                  String.fromCharCode(97 + file), // a, b, c, etc.
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isLight ? Colors.brown[900] : Colors.grey[300],
                  ),
                ),
              ),
            // Piece with animation
            if (piece != null)
              Transform.scale(
                scale: isSelected ? 0.95 : 1.0,
                child: MouseRegion(
                  cursor: widget.isInteractive
                      ? SystemMouseCursors.grab
                      : MouseCursor.defer,
                  child: Text(
                    piece.toSymbol(),
                    style: const TextStyle(
                      fontSize: 45,
                      height: 1,
                    ),
                  ),
                ),
              ),
            // Legal move indicator on empty square
            if (isLegalMove && piece == null)
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.shade700,
                ),
              ),
            // Legal capture indicator
            if (isLegalMove && piece != null)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red.shade600,
                    width: 3,
                  ),
                ),
              ),
            // Selection indicator
            if (isSelected)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
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
