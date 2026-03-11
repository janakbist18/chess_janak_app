import 'package:flutter/material.dart';
import '../../../../core/widgets/premium_card.dart';

class CreateRoomScreen extends StatelessWidget {
  const CreateRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Room')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: PremiumCard(
          child: Text(
            'Phase 8 will implement create room API integration, invite code display, share, and QR.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}