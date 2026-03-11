import 'package:flutter/material.dart';

/// Player info bar widget
class PlayerInfoBar extends StatelessWidget {
  final String playerName;
  final int rating;
  final String timeRemaining;
  final bool isCurrentTurn;
  final String? playerImage;

  const PlayerInfoBar({
    Key? key,
    required this.playerName,
    required this.rating,
    required this.timeRemaining,
    required this.isCurrentTurn,
    this.playerImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrentTurn
            ? Theme.of(context).primaryColor.withOpacity(0.2)
            : Colors.transparent,
        border: isCurrentTurn
            ? Border.all(color: Theme.of(context).primaryColor, width: 2)
            : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: playerImage != null
                ? NetworkImage(playerImage!)
                : null,
            child: playerImage == null ? const Icon(Icons.person) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(playerName, style: Theme.of(context).textTheme.titleSmall),
                Text('Rating: $rating'),
              ],
            ),
          ),
          Text(timeRemaining, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
