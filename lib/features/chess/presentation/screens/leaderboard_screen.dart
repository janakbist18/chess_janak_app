import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/leaderboard_widget.dart';
import '../providers/player_provider.dart';

class LeaderboardScreen extends ConsumerWidget {
  final String? currentPlayerId;

  const LeaderboardScreen({
    super.key,
    this.currentPlayerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
      ),
      body: leaderboardAsync.when(
        data: (players) => LeaderboardWidget(
          players: players,
          currentPlayerId: currentPlayerId,
          onPlayerTapped: (player) {
            // Navigate to player profile
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tapped: ${player.username}'),
                duration: const Duration(seconds: 1),
              ),
            );
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
                'Failed to load leaderboard',
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
                  // ignore: unused_result
                  ref.refresh(leaderboardProvider);
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
