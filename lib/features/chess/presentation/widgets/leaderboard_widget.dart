import 'package:flutter/material.dart';
import '../../data/models/player_model.dart';

/// Widget to display leaderboard
class LeaderboardWidget extends StatelessWidget {
  final List<PlayerModel> players;
  final String? currentPlayerId;
  final Function(PlayerModel)? onPlayerTapped;

  const LeaderboardWidget({
    Key? key,
    required this.players,
    this.currentPlayerId,
    this.onPlayerTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.leaderboard,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No players yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        final rank = index + 1;
        final isCurrentPlayer = player.playerId == currentPlayerId;

        return LeaderboardTile(
          rank: rank,
          player: player,
          isCurrentPlayer: isCurrentPlayer,
          onTap: onPlayerTapped != null ? () => onPlayerTapped!(player) : null,
        );
      },
    );
  }
}

/// Individual leaderboard tile
class LeaderboardTile extends StatelessWidget {
  final int rank;
  final PlayerModel player;
  final bool isCurrentPlayer;
  final VoidCallback? onTap;

  const LeaderboardTile({
    Key? key,
    required this.rank,
    required this.player,
    this.isCurrentPlayer = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isCurrentPlayer ? Colors.blue.withOpacity(0.1) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Rank
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getRankColor(rank),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                backgroundImage: player.avatar != null
                    ? NetworkImage(player.avatar!)
                    : null,
                child: player.avatar == null
                    ? Text(
                        player.username.isNotEmpty
                            ? player.username[0].toUpperCase()
                            : '?',
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Player info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.username,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildStatBadge(context, '${player.gamesPlayed} Games'),
                        const SizedBox(width: 8),
                        _buildStatBadge(context, '${player.winRate.toStringAsFixed(1)}% Win'),
                      ],
                    ),
                  ],
                ),
              ),
              // Rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${player.rating.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    'Rating',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey;
    if (rank == 3) return Colors.orange;
    return Colors.blue;
  }
}
