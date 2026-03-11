import 'package:flutter/material.dart';
import '../../../../core/widgets/premium_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            PremiumCard(
              child: Column(
                children: [
                  CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
                  SizedBox(height: 12),
                  Text('Player Profile'),
                  SizedBox(height: 8),
                  Text('Phase 8 will implement profile API integration and stats cards.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}