import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/premium_card.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlayerAsync = ref.watch(currentPlayerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: currentPlayerAsync.when(
        data: (playerData) {
          if (playerData == null || playerData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No profile data available'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // ignore: unused_result
                      ref.refresh(currentPlayerProvider);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final gameHistory = ref.watch(gameHistoryProvider);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile Header
              PremiumCard(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, size: 48),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      playerData['username'] ?? 'Anonymous',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      playerData['email'] ?? '',
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Statistics
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          context,
                          'Rating',
                          '${playerData['rating'] ?? 1200}',
                        ),
                        _buildStatCard(
                          context,
                          'Wins',
                          '${playerData['wins'] ?? 0}',
                        ),
                        _buildStatCard(
                          context,
                          'Losses',
                          '${playerData['losses'] ?? 0}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          context,
                          'Draws',
                          '${playerData['draws'] ?? 0}',
                        ),
                        _buildStatCard(
                          context,
                          'Win %',
                          '${_calculateWinPercentage(playerData)} %',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Game History
              gameHistory.when(
                data: (games) {
                  if (games == null || games.isEmpty) {
                    return PremiumCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Icon(Icons.sports,
                                size: 36, color: Colors.grey),
                            const SizedBox(height: 8),
                            const Text('No games played yet'),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Game History',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      ...games.map((game) {
                        return PremiumCard(
                          child: ListTile(
                            leading: _buildResultIcon(game['result']),
                            title: Text(game['opponent'] ?? 'Unknown'),
                            subtitle: Text(
                              '${game['game_mode']?.toUpperCase()} • ${game['date'] ?? 'Recent'}',
                            ),
                            trailing: Text(
                              game['result']?.toUpperCase() ?? 'DRAW',
                              style: TextStyle(
                                color: _getResultColor(game['result']),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => PremiumCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error loading history: $error'),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Actions
              ElevatedButton.icon(
                onPressed: () {
                  // ignore: unused_result
                  ref.refresh(currentPlayerProvider);
                  // ignore: unused_result
                  ref.refresh(gameHistoryProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Profile'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // ignore: unused_result
                  ref.refresh(currentPlayerProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  String _calculateWinPercentage(Map<String, dynamic> playerData) {
    final wins = (playerData['wins'] ?? 0) as int;
    final losses = (playerData['losses'] ?? 0) as int;
    final draws = (playerData['draws'] ?? 0) as int;
    final total = wins + losses + draws;

    if (total == 0) return '0';
    return ((wins / total) * 100).toStringAsFixed(1);
  }

  Icon _buildResultIcon(String? result) {
    switch (result?.toLowerCase()) {
      case 'win':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'loss':
        return const Icon(Icons.cancel, color: Colors.red);
      case 'draw':
        return const Icon(Icons.circle, color: Colors.orange);
      default:
        return const Icon(Icons.help, color: Colors.grey);
    }
  }

  Color _getResultColor(String? result) {
    switch (result?.toLowerCase()) {
      case 'win':
        return Colors.green;
      case 'loss':
        return Colors.red;
      case 'draw':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
