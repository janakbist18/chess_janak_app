import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/game_history_widget.dart';
import '../providers/game_provider.dart';
import '../../data/models/game_history_model.dart';

class GameHistoryScreen extends ConsumerWidget {
  final String playerId;

  const GameHistoryScreen({
    super.key,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch game history from provider
    final gameHistoryAsync = ref.watch(gameMoveHistoryProvider(playerId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game History'),
        centerTitle: true,
      ),
      body: gameHistoryAsync.when(
        data: (games) {
          // Convert Map to GameHistoryModel
          final gameModels = games.isEmpty
              ? <GameHistoryModel>[]
              : games
                  .map((g) => GameHistoryModel(
                        gameId: g['gameId'] ?? '',
                        whitePlayerId: g['whitePlayerId'] ?? '',
                        blackPlayerId: g['blackPlayerId'] ?? '',
                        whitePlayerName: g['whitePlayerName'] ?? 'Unknown',
                        blackPlayerName: g['blackPlayerName'] ?? 'Unknown',
                        whitePlayerAvatar: g['whitePlayerAvatar'],
                        blackPlayerAvatar: g['blackPlayerAvatar'],
                        result: g['result'] ?? 'draw',
                        winnerId: g['winnerId'],
                        endReason: g['endReason'] ?? 'unknown',
                        moves: List<String>.from(g['moves'] ?? []),
                        gameMode: g['gameMode'] ?? 'Blitz',
                        durationSeconds: g['durationSeconds'] ?? 0,
                        playedAt: g['playedAt'] is DateTime
                            ? g['playedAt']
                            : DateTime.parse(g['playedAt'] ??
                                DateTime.now().toIso8601String()),
                      ))
                  .toList();

          if (gameModels.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.videogame_asset_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No games played yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Dashboard'),
                  ),
                ],
              ),
            );
          }
          return GameHistoryListWidget(
            games: gameModels,
            onGameTapped: (game) {
              // TODO: Navigate to game analysis screen with game details
              // context.push(RouteNames.gameAnalysis, extra: game);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load games',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(gameMoveHistoryProvider(playerId));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
