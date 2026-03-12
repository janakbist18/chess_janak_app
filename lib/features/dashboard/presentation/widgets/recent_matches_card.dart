import 'package:flutter/material.dart';

/// Recent matches card widget
class RecentMatchesCard extends StatelessWidget {
  const RecentMatchesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Matches',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            // TODO: Add match list items
            const Center(child: Text('No recent matches')),
          ],
        ),
      ),
    );
  }
}
