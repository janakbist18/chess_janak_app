import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_profile_model.dart';
import '../providers/leaderboard_provider.dart';
import 'enhanced_profile_screen.dart';

/// Leaderboard screen showing ranked players
class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leaderboard = ref.watch(leaderboardProvider);
    final selectedFilter = ref.watch(leaderboardFilterProvider);
    final currentRank = ref.watch(currentPlayerRankProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: LeaderboardFilter.values
                  .map(
                    (filter) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        selected: selectedFilter == filter,
                        label: Text(_formatFilterName(filter)),
                        onSelected: (_) {
                          ref.read(leaderboardFilterProvider.notifier).state =
                              filter;
                          ref
                              .read(leaderboardProvider.notifier)
                              .updateFilter(filter);
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Current player rank (if ranked)
          if (currentRank != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                border: Border.all(color: Colors.amber[700]!, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber[700],
                    ),
                    child: Center(
                      child: Text(
                        currentRank.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Your Rank',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          // Leaderboard list
          Expanded(
            child: leaderboard.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.leaderboard,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No players yet',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: leaderboard.length,
                    itemBuilder: (context, index) {
                      final entry = leaderboard[index];
                      return _LeaderboardEntryTile(
                        entry: entry,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EnhancedProfileScreen(
                                userId: entry.player.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatFilterName(LeaderboardFilter filter) {
    switch (filter) {
      case LeaderboardFilter.all:
        return 'All Time';
      case LeaderboardFilter.thisMonth:
        return 'This Month';
      case LeaderboardFilter.thisWeek:
        return 'This Week';
      case LeaderboardFilter.rapid:
        return 'Rapid';
      case LeaderboardFilter.blitz:
        return 'Blitz';
    }
  }
}

/// Individual leaderboard entry tile
class _LeaderboardEntryTile extends StatelessWidget {
  final LeaderboardEntry entry;
  final VoidCallback onTap;

  const _LeaderboardEntryTile({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isTopThree = entry.rank <= 3;
    final medalEmoji = _getMedalEmoji(entry.rank);

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isTopThree ? Colors.amber[50] : Colors.white,
          border: Border.all(
            color: isTopThree ? Colors.amber[700]! : Colors.grey[300]!,
            width: isTopThree ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isTopThree
              ? [
                  BoxShadow(
                    color: Colors.amber[700]!.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Rank with medal
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getRankColor(entry.rank),
              ),
              child: Center(
                child: entry.rank <= 3
                    ? Text(medalEmoji, style: const TextStyle(fontSize: 24))
                    : Text(
                        entry.rank.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Player info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.player.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getTitleColor(entry.player.title),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          entry.player.title,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.gamesPlayed} games • ${(entry.winRate * 100).toStringAsFixed(1)}% win rate',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Rating
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber[700],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                entry.rating.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMedalEmoji(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '';
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey[400]!;
    }
  }

  Color _getTitleColor(String title) {
    switch (title.toLowerCase()) {
      case 'gm':
        return Colors.red[700]!;
      case 'im':
        return Colors.deepOrange[700]!;
      case 'fm':
        return Colors.orange[700]!;
      case 'nm':
        return Colors.amber[700]!;
      default:
        return Colors.grey[600]!;
    }
  }
}
