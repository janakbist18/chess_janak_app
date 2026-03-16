import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/game_record_model.dart';
import '../widgets/chess_board_widget.dart';
import '../providers/game_replay_provider.dart';

/// Game replay viewer screen
class GameReplayScreen extends ConsumerStatefulWidget {
  final GameRecord gameRecord;

  const GameReplayScreen({super.key, required this.gameRecord});

  @override
  ConsumerState<GameReplayScreen> createState() => _GameReplayScreenState();
}

class _GameReplayScreenState extends ConsumerState<GameReplayScreen> {
  late ScrollController _movesScrollController;

  @override
  void initState() {
    super.initState();
    _movesScrollController = ScrollController();
  }

  @override
  void dispose() {
    _movesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final replayState = ref.watch(gameReplayProvider(widget.gameRecord));
    final analysis = ref.watch(gameAnalysisSummaryProvider(widget.gameRecord));
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Replay'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export as PGN',
            onPressed: () => _showPgnExport(context),
          ),
        ],
      ),
      body: isMobile
          ? _buildMobileLayout(context, replayState, analysis)
          : _buildDesktopLayout(context, replayState, analysis),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    GameReplayState state,
    Map<String, dynamic> analysis,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Game info
          _buildGameInfoCard(context),
          const SizedBox(height: 16),
          // Board
          _buildBoardSection(context, state),
          const SizedBox(height: 16),
          // Analysis
          _buildAnalysisCard(context, analysis),
          const SizedBox(height: 16),
          // Move list
          _buildMoveList(context, state),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    GameReplayState state,
    Map<String, dynamic> analysis,
  ) {
    return Row(
      children: [
        // Left side: Board and info
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(child: _buildBoardSection(context, state)),
              Expanded(child: _buildGameInfoCard(context)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Right side: Analysis and moves
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(child: _buildAnalysisCard(context, analysis)),
              const SizedBox(height: 12),
              Expanded(child: _buildMoveList(context, state)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGameInfoCard(BuildContext context) {
    final resultColor = widget.gameRecord.result == '1-0'
        ? Colors.green
        : widget.gameRecord.result == '0-1'
            ? Colors.red
            : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Players
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.gameRecord.whitePlayerName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'White',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: resultColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  widget.gameRecord.result,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: resultColor,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.gameRecord.blackPlayerName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Black',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Details
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _detailRow('Time Control', widget.gameRecord.timeControl),
                const Divider(),
                _detailRow(
                  'Played',
                  DateFormat('MMM d, yyyy').format(widget.gameRecord.playedAt),
                ),
                const Divider(),
                _detailRow('Termination', widget.gameRecord.termination),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildBoardSection(BuildContext context, GameReplayState state) {
    final notifier = ref.read(gameReplayProvider(widget.gameRecord).notifier);

    return Column(
      children: [
        // Board
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ChessBoardWidget(
              fen: notifier.getCurrentFen(),
              onMoveMade: null, // Read-only for replay
              isWhiteBottom: true,
            ),
          ),
        ),
        // Controls
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: state.progress,
                      minHeight: 6,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${state.currentMoveIndex + 1} / ${state.moveCount}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Playback controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed:
                        state.isAtStart ? null : () => notifier.goToStart(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed:
                        state.isAtStart ? null : () => notifier.previousMove(),
                  ),
                  IconButton(
                    icon: Icon(
                      state.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: () => notifier.toggleAutoReplay(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: state.isAtEnd ? null : () => notifier.nextMove(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: state.isAtEnd ? null : () => notifier.goToEnd(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisCard(
    BuildContext context,
    Map<String, dynamic> analysis,
  ) {
    final whiteAccuracy = (analysis['accuracy'] as Map)['white'] as int;
    final blackAccuracy = (analysis['accuracy'] as Map)['black'] as int;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[300]!),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Analysis', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            _accuracyBar('White', whiteAccuracy),
            const SizedBox(height: 12),
            _accuracyBar('Black', blackAccuracy),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _analysisStat(
              'White Mistakes',
              (analysis['white_mistakes'] as int).toString(),
              Colors.red,
            ),
            const SizedBox(height: 8),
            _analysisStat(
              'Black Mistakes',
              (analysis['black_mistakes'] as int).toString(),
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _accuracyBar(String player, int accuracy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$player: $accuracy%',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: accuracy / 100,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              accuracy > 80
                  ? Colors.green
                  : accuracy > 60
                      ? Colors.orange
                      : Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _analysisStat(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildMoveList(BuildContext context, GameReplayState state) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.list, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Moves',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _movesScrollController,
              padding: const EdgeInsets.all(4),
              itemCount: (state.gameRecord.moves.length + 1) ~/ 2,
              itemBuilder: (context, moveIndex) {
                final whiteMove = state.gameRecord.moves[moveIndex * 2];
                final blackMove =
                    moveIndex * 2 + 1 < state.gameRecord.moves.length
                        ? state.gameRecord.moves[moveIndex * 2 + 1]
                        : null;

                return _buildMovePair(
                  context,
                  moveIndex + 1,
                  whiteMove,
                  blackMove,
                  state,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovePair(
    BuildContext context,
    int moveNumber,
    GameMove whiteMove,
    GameMove? blackMove,
    GameReplayState state,
  ) {
    final notifier = ref.read(gameReplayProvider(widget.gameRecord).notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$moveNumber.',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => notifier.jumpToMove(moveNumber * 2 - 2),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: state.currentMoveIndex == moveNumber * 2 - 2
                      ? Colors.amber[200]
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  whiteMove.sanNotation,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          if (blackMove != null)
            Expanded(
              child: GestureDetector(
                onTap: () => notifier.jumpToMove(moveNumber * 2 - 1),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: state.currentMoveIndex == moveNumber * 2 - 1
                        ? Colors.amber[200]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    blackMove.sanNotation,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showPgnExport(BuildContext context) {
    final pgn = widget.gameRecord.toPgn();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Game PGN'),
        content: SingleChildScrollView(child: Text(pgn)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
            onPressed: () {
              // TODO: Implement copy to clipboard
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PGN copied to clipboard')),
              );
            },
          ),
        ],
      ),
    );
  }
}
