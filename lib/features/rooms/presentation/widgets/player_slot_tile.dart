import 'package:flutter/material.dart';

/// Player slot tile widget
class PlayerSlotTile extends StatelessWidget {
  final String? playerName;
  final String? playerImage;
  final bool isFilled;

  const PlayerSlotTile({
    Key? key,
    this.playerName,
    this.playerImage,
    this.isFilled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: playerImage != null
            ? NetworkImage(playerImage!)
            : null,
        child: playerImage == null ? const Icon(Icons.person) : null,
      ),
      title: Text(playerName ?? 'Waiting for player...'),
      trailing: isFilled ? const Icon(Icons.check, color: Colors.green) : null,
    );
  }
}
