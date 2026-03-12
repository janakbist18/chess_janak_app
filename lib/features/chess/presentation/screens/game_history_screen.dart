import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/game_history_widget.dart';
import '../../data/models/game_history_model.dart';
// TODO: Add proper game history provider when implemented

class GameHistoryScreen extends ConsumerWidget {
  final String playerId;

  const GameHistoryScreen({
    super.key,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Load game history from provider
    final gameHistoryAsync = const AsyncValue<List<GameHistoryModel>>.data([]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game History'),
        centerTitle: true,
      ),
      body: gameHistoryAsync.when(
        data: (games) => GameHistoryListWidget(
          games: games,
          onGameTapped: (game) {
            // TODO: Select game via provider
            // ref.read(selectedGameHistoryProvider.notifier).selectGame(game);
            // Navigate to game analysis screen
          },
        ),
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
                  // TODO: Refresh game history
                  // ref.refresh(gameHistoryProvider(playerId));
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
