import 'package:flutter/material.dart';
import '../../../../core/widgets/premium_card.dart';

class GameRoomScreen extends StatelessWidget {
  const GameRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Room')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PremiumCard(
            child: Text(
              'Phase 9 will build the realtime chess board UI.',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 12),
          PremiumCard(
            child: Text(
              'Phase 10 will add Messenger-style chat.',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 12),
          PremiumCard(
            child: Text(
              'Phase 11 will add WebRTC video/audio call UI.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}