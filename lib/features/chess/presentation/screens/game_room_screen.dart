import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/chess_board_widget.dart';
import '../widgets/move_list_widget.dart';
import '../widgets/game_timer_widget.dart';
import '../providers/game_provider.dart';

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
    // Load game state when screen initializes
    Future.microtask(() {
      ref.read(currentGameStateProvider.notifier).fetchGameState(widget.gameId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameStateAsync = ref.watch(currentGameStateProvider);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width < 1024;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '♟️ Chess Game',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showGameInfo(context),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showGameMenu(context),
          ),
        ],
      ),
      body: gameStateAsync.when(
        data: (gameState) {
          if (gameState == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.games, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Game not found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return isMobile
              ? _buildMobileLayout(context, gameState)
              : isTablet
                  ? _buildTabletLayout(context, gameState)
                  : _buildDesktopLayout(context, gameState);
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading game...'),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Error: $error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  ref.invalidate(currentGameStateProvider);
                },
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, dynamic gameState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 12,
        children: [
          // Black player info with timer
          _buildCompactPlayerCard(true, gameState, context),
          const SizedBox(height: 4),

          // Chess board
          ChessBoardWidget(
            fen: gameState.fen,
            onMoveMade: _handleMove,
            isWhiteBottom: true,
            maxWidth: MediaQuery.of(context).size.width - 24,
          ),
          const SizedBox(height: 4),

          // White player info with timer
          _buildCompactPlayerCard(false, gameState, context),
          const SizedBox(height: 8),

          // Action buttons
          _buildActionButtonsMobile(context, gameState),

          // Move list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Move History',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: MoveListWidget(moves: gameState.moves),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, dynamic gameState) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          // Left column - Board
          Expanded(
            flex: 3,
            child: Column(
              spacing: 12,
              children: [
                _buildPlayerCard(true, gameState),
                const SizedBox(height: 8),
                GameTimerWidget(
                  isWhiteTimer: false,
                  isActive: gameState.fen.contains(' b '),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ChessBoardWidget(
                    fen: gameState.fen,
                    onMoveMade: _handleMove,
                    isWhiteBottom: true,
                  ),
                ),
                const SizedBox(height: 8),
                GameTimerWidget(
                  isWhiteTimer: true,
                  isActive: gameState.fen.contains(' w '),
                ),
                const SizedBox(height: 8),
                _buildPlayerCard(false, gameState),
              ],
            ),
          ),

          // Right column - Controls and moves
          Expanded(
            flex: 2,
            child: Column(
              spacing: 12,
              children: [
                _buildActionButtons(context, gameState),
                const SizedBox(height: 8),
                Text(
                  'Moves',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Expanded(
                  child: Card(
                    child: MoveListWidget(moves: gameState.moves),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, dynamic gameState) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          // Center - Board with players
          Expanded(
            flex: 2,
            child: Column(
              spacing: 12,
              children: [
                _buildPlayerCard(true, gameState),
                GameTimerWidget(
                  isWhiteTimer: false,
                  isActive: gameState.fen.contains(' b '),
                ),
                Expanded(
                  child: ChessBoardWidget(
                    fen: gameState.fen,
                    onMoveMade: _handleMove,
                    isWhiteBottom: true,
                  ),
                ),
                GameTimerWidget(
                  isWhiteTimer: true,
                  isActive: gameState.fen.contains(' w '),
                ),
                _buildPlayerCard(false, gameState),
              ],
            ),
          ),

          // Right - Moves list
          Expanded(
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Move History',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const Divider(height: 0),
                  Expanded(
                    child: MoveListWidget(moves: gameState.moves),
                  ),
                ],
              ),
            ),
          ),

          // Far right - Controls
          Column(
            spacing: 12,
            children: [
              _buildActionButtons(context, gameState),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Game Status',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Divider(),
                      _buildStatusInfo('Turn',
                          gameState.fen.contains(' w ') ? 'White' : 'Black'),
                      _buildStatusInfo('Moves', '${gameState.moves.length}'),
                      _buildStatusInfo('Captured Pieces',
                          gameState.capturedPiecesCount ?? 0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactPlayerCard(
    bool isBlackPlayer,
    dynamic gameState,
    BuildContext context,
  ) {
    final isWhiteTurn = gameState.fen.contains(' w ');
    final isCurrentPlayer = isBlackPlayer ? !isWhiteTurn : isWhiteTurn;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrentPlayer ? Colors.amber[50] : Colors.grey[50],
        border: Border.all(
          color: isCurrentPlayer ? Colors.amber : Colors.grey[300]!,
          width: isCurrentPlayer ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
                isBlackPlayer ? Colors.grey[800] : Colors.grey[200],
            child: Text(
              isBlackPlayer ? '♚' : '♛',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBlackPlayer
                      ? gameState.blackPlayerName
                      : gameState.whitePlayerName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isCurrentPlayer ? 'Your turn' : 'Waiting...',
                  style: TextStyle(
                    fontSize: 12,
                    color: isCurrentPlayer ? Colors.amber[700] : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentPlayer)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber[600],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(bool isBlackPlayer, dynamic gameState) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor:
                  isBlackPlayer ? Colors.grey[800] : Colors.grey[200],
              child: Text(
                isBlackPlayer ? '♚' : '♛',
                style: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBlackPlayer
                        ? gameState.blackPlayerName
                        : gameState.whitePlayerName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${gameState.whiteRating} rated',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtonsMobile(
    BuildContext context,
    dynamic gameState,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          _buildActionButton(
            context,
            'Draw',
            Icons.handshake,
            Colors.blue,
            () {},
          ),
          _buildActionButton(
            context,
            'Resign',
            Icons.flag,
            Colors.red,
            () => _resignGame(context, gameState),
          ),
          _buildActionButton(
            context,
            'More',
            Icons.more_horiz,
            Colors.grey,
            () => _showGameMenu(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, dynamic gameState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: 8,
          children: [
            _buildActionButton(
              context,
              'Offer Draw',
              Icons.handshake,
              Colors.blue,
              () {},
              isExpanded: true,
            ),
            _buildActionButton(
              context,
              'Resign Game',
              Icons.flag,
              Colors.red,
              () => _resignGame(context, gameState),
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed, {
    bool isExpanded = false,
  }) {
    final button = ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      onPressed: onPressed,
    );

    return isExpanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  Widget _buildStatusInfo(String label, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showGameInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Information'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Game Details'),
              SizedBox(height: 12),
              Text('Game ID: chess_game_001'),
              Text('Mode: Blitz (5+3)'),
              Text('Started: 2 minutes ago'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleMove(String from, String to) {
    ref.read(currentGameStateProvider.notifier).makeMove(
          roomId: widget.gameId,
          from: from,
          to: to,
        );
  }

  void _resignGame(BuildContext context, dynamic gameState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resign Game'),
        content: const Text(
          'Are you sure you want to resign this game?\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(currentGameStateProvider.notifier)
                  .resignGame(widget.gameId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You have resigned from the game.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Resign', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showGameMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Game Menu',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.handshake),
              title: const Text('Offer Draw'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Draw offer sent')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('View Analysis'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to analysis
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Game Info'),
              onTap: () {
                Navigator.pop(context);
                _showGameInfo(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.flag, color: Colors.red),
              title: const Text('Resign', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                // Retrieve gameState here if needed
                final gameState = ref.read(currentGameStateProvider).value;
                _resignGame(context, gameState);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
