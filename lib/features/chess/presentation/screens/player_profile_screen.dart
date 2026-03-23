import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/player_info_widget.dart';
import '../widgets/game_history_widget.dart';
import '../providers/player_provider.dart';
import '../../data/models/game_history_model.dart';

class PlayerProfileScreen extends ConsumerWidget {
  final String playerId;

  const PlayerProfileScreen({
    super.key,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerAsync = ref.watch(currentPlayerProvider(playerId));
    // TODO: Load game history from provider
    final gameHistoryAsync = const AsyncValue<List<GameHistoryModel>>.data([]);

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
      body: playerAsync.when(
        data: (player) => SingleChildScrollView(
          child: Column(
            children: [
              // Player card
              Padding(
                padding: const EdgeInsets.all(16),
                child: PlayerInfoWidget(
                  player: player,
                  isCurrentPlayer: true,
                  isWhitePlayer: true,
                ),
              ),
              // Stats section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5,
                      ),
                      children: [
                        _buildStatCard(
                          context,
                          'Games Played',
                          '${player.gamesPlayed}',
                          Colors.blue,
                        ),
                        _buildStatCard(
                          context,
                          'Win Rate',
                          '${player.winRate.toStringAsFixed(1)}%',
                          Colors.green,
                        ),
                        _buildStatCard(
                          context,
                          'Wins',
                          '${player.wins}',
                          Colors.blue,
                        ),
                        _buildStatCard(
                          context,
                          'Rating',
                          '${player.rating.toStringAsFixed(0)}',
                          Colors.orange,
                        ),
                      ],
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
                  child: GameHistoryListWidget(games: games.take(10).toList()),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Failed to load games: $error'),
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

  Widget _buildStatCard(
      BuildContext context, String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
