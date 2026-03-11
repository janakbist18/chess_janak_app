import 'package:flutter/material.dart';

/// Invite card widget
class InviteCard extends StatelessWidget {
  final VoidCallback onCopy;
  final String inviteCode;

  const InviteCard({Key? key, required this.onCopy, required this.inviteCode})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Share Code'),
            const SizedBox(height: 12),
            SelectableText(
              inviteCode,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onCopy,
              icon: const Icon(Icons.copy),
              label: const Text('Copy'),
            ),
          ],
        ),
      ),
    );
  }
}
