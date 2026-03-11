import 'package:flutter/material.dart';
import '../../../../core/widgets/premium_card.dart';

class WaitingRoomScreen extends StatelessWidget {
  const WaitingRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Waiting Room')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: PremiumCard(
          child: Text(
            'Phase 8 and Phase 9 will implement live waiting room presence, player slots, and start flow.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}