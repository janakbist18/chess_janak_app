import 'package:flutter/material.dart';
import '../../../../core/widgets/premium_card.dart';

class JoinRoomScreen extends StatelessWidget {
  const JoinRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Room')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: PremiumCard(
          child: Text(
            'Phase 8 will implement invite code input, deep-link parsing, and join room API.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}