import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/game_history_widget.dart';
import '../providers/game_provider.dart';
import '../../data/models/game_history_model.dart';

class PlayerProfileScreen extends ConsumerWidget {
  final String playerId;

  const PlayerProfileScreen({
    super.key,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStatsAsync = ref.watch(userGameStatsProvider);
    final gameHistoryAsync = ref.watch(gameMoveHistoryProvider(playerId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: gameStatsAsync.when(
        data: (stats) => SingleChildScrollView(
          child: Column(
            children: [
              // Player stats section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Player Statistics',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              context,
                              'Total Games',
                              '${stats['total_games'] ?? 0}',
                            ),
                            _buildStatItem(
                              context,
                              'Wins',
                              '${stats['wins'] ?? 0}',
                            ),
                            _buildStatItem(
                              context,
                              'Losses',
                              '${stats['losses'] ?? 0}',
                            ),
                            _buildStatItem(
                              context,
                              'Draws',
                              '${stats['draws'] ?? 0}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Win Rate: ${(stats['win_percentage'] ?? 0).toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Game history section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: gameHistoryAsync.when(
                      data: (history) => history.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('No games found'),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: history.length,
                              itemBuilder: (context, index) => GameHistoryTile(
                                game:
                                    _convertToGameHistoryModel(history[index]),
                              ),
                            ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (err, stack) => Center(
                        child: Text('Error: $err'),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('Challenge'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.person_add),
                        label: const Text('Follow'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Game history section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recent Games',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              gameHistoryAsync.when(
                data: (games) => SizedBox(
                  height: 400,
                  child: GameHistoryListWidget(
                    games:
                        games.take(10).map(_convertToGameHistoryModel).toList(),
                  ),
                ),
                loading: () => const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SizedBox(
                  height: 400,
                  child: Center(
                    child: Text('Error loading games: $err'),
                  ),
                ),
              ),
            ],
          ),
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
              Text(error.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  GameHistoryModel _convertToGameHistoryModel(dynamic g) {
    if (g is GameHistoryModel) return g;
    final map = g as Map<String, dynamic>;
    return GameHistoryModel(
      gameId: map['gameId'] ?? '',
      whitePlayerId: map['whitePlayerId'] ?? '',
      blackPlayerId: map['blackPlayerId'] ?? '',
      whitePlayerName: map['whitePlayerName'] ?? 'Unknown',
      blackPlayerName: map['blackPlayerName'] ?? 'Unknown',
      whitePlayerAvatar: map['whitePlayerAvatar'],
      blackPlayerAvatar: map['blackPlayerAvatar'],
      result: map['result'] ?? 'draw',
      winnerId: map['winnerId'],
      endReason: map['endReason'] ?? 'unknown',
      moves: List<String>.from(map['moves'] ?? []),
      gameMode: map['gameMode'] ?? 'Blitz',
      durationSeconds: map['durationSeconds'] ?? 0,
      playedAt: map['playedAt'] is DateTime
          ? map['playedAt']
          : DateTime.parse(map['playedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
