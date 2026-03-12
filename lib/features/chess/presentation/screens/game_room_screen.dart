import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/chess_board_widget.dart';
import '../widgets/move_list_widget.dart';
import '../widgets/game_timer_widget.dart';
import '../widgets/player_info_widget.dart';
import '../providers/player_provider.dart';

class GameRoomScreen extends ConsumerStatefulWidget {
  final String gameId;

  const GameRoomScreen({
    super.key,
    required this.gameId,
  });

  @override
  ConsumerState<GameRoomScreen> createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends ConsumerState<GameRoomScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: Load game state from provider when game_provider is reimplemented
    // Future.microtask(() {
    //   ref.read(chessGameStateProvider.notifier).loadGameState(widget.gameId);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Watch game state and timer from providers
    final gameState = null;
    final timerState = null;
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (gameState == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Game Room')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Game'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showGameMenu(context),
          ),
        ],
      ),
      body: isMobile
          ? _buildMobileLayout(context, gameState)
          : _buildDesktopLayout(context, gameState),
    );
  }

  Widget _buildMobileLayout(BuildContext context, dynamic gameState) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Black player info
            _buildPlayerCard(true, gameState),
            const SizedBox(height: 16),
            // Black timer
            GameTimerWidget(
              isWhiteTimer: false,
              isActive: gameState.fen.contains(' b '),
            ),
            const SizedBox(height: 16),
            // Chess board
            ChessBoardWidget(
              fen: gameState.fen,
              onMoveMade: _handleMove,
              isWhiteBottom: true,
            ),
            const SizedBox(height: 16),
            // White timer
            GameTimerWidget(
              isWhiteTimer: true,
              isActive: gameState.fen.contains(' w '),
            ),
            const SizedBox(height: 16),
            // White player info
            _buildPlayerCard(false, gameState),
            const SizedBox(height: 16),
            // Move list
            SizedBox(
              height: 200,
              child: MoveListWidget(moves: gameState.moves),
            ),
            const SizedBox(height: 16),
            // Action buttons
            _buildActionButtons(context, gameState),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, dynamic gameState) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Left side - Player info and board
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildPlayerCard(true, gameState),
                const SizedBox(height: 16),
                GameTimerWidget(
                  isWhiteTimer: false,
                  isActive: gameState.fen.contains(' b '),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ChessBoardWidget(
                    fen: gameState.fen,
                    onMoveMade: _handleMove,
                    isWhiteBottom: true,
                  ),
                ),
                const SizedBox(height: 16),
                GameTimerWidget(
                  isWhiteTimer: true,
                  isActive: gameState.fen.contains(' w '),
                ),
                const SizedBox(height: 16),
                _buildPlayerCard(false, gameState),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Right side - Move list and controls
          Expanded(
            child: Column(
              children: [
                Text(
                  'Moves',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: MoveListWidget(moves: gameState.moves),
                ),
                const SizedBox(height: 16),
                _buildActionButtons(context, gameState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(bool isBlackPlayer, dynamic gameState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor:
                  isBlackPlayer ? Colors.grey[700] : Colors.grey[300],
              child: Text(
                isBlackPlayer ? 'B' : 'W',
                style: TextStyle(
                  color: isBlackPlayer ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBlackPlayer
                        ? gameState.blackPlayerName
                        : gameState.whitePlayerName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'vs ${isBlackPlayer ? gameState.whitePlayerName : gameState.blackPlayerName}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, dynamic gameState) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {},
            child: const Text('Offer Draw'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => _resignGame(context, gameState),
            child: const Text('Resign'),
          ),
        ),
      ],
    );
  }

  void _handleMove(String from, String to) {
    // TODO: Implement move handling when game_provider is reimplemented
    // ref.read(chessGameStateProvider.notifier).makeLocalMove(from, to);
  }

  void _resignGame(BuildContext context, dynamic gameState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resign Game'),
        content: const Text('Are you sure you want to resign this game?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement resign when game_provider is reimplemented
              // ref.read(chessGameStateProvider.notifier).resignGame(gameState.gameId);
              Navigator.pop(context);
            },
            child: const Text('Resign', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showGameMenu(BuildContext context) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(0, AppBar().preferredSize.height, 0, 0),
      items: <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'draw',
          child: Text('Offer Draw'),
        ),
        const PopupMenuItem<String>(
          value: 'analysis',
          child: Text('View Game Analysis'),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'resign',
          onTap: () => _resignGame(context, null),
          child: const Text('Resign', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
