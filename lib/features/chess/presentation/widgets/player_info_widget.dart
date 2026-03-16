import 'package:flutter/material.dart';
import '../../data/models/player_model.dart';

/// Widget to display player information
class PlayerInfoWidget extends StatelessWidget {
  final PlayerModel player;
  final bool isCurrentPlayer;
  final bool isWhitePlayer;

  const PlayerInfoWidget({
    super.key,
    required this.player,
    this.isCurrentPlayer = false,
    this.isWhitePlayer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isCurrentPlayer ? 4 : 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 32,
              backgroundColor:
                  isWhitePlayer ? Colors.grey[300] : Colors.grey[700],
              backgroundImage:
                  player.avatar != null ? NetworkImage(player.avatar!) : null,
              child: player.avatar == null
                  ? Text(
                      player.username.isNotEmpty
                          ? player.username[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: isWhitePlayer ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            // Player details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.username,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rating: ${player.rating.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStat(context, 'W: ${player.wins}'),
                      const SizedBox(width: 12),
                      _buildStat(context, 'L: ${player.losses}'),
                      const SizedBox(width: 12),
                      _buildStat(context, 'D: ${player.draws}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Win Rate: ${player.winRate.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            if (isCurrentPlayer)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'You',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String stat) {
    return Text(
      stat,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
