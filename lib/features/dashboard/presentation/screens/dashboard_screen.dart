import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/premium_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _DashboardActionTile(
        title: 'Create Room',
        subtitle: 'Generate invite link and room code',
        icon: Icons.add_box_rounded,
        onTap: () => context.push(RouteNames.createRoom),
      ),
      _DashboardActionTile(
        title: 'Join Room',
        subtitle: 'Join using invite code or link',
        icon: Icons.meeting_room_rounded,
        onTap: () => context.push(RouteNames.joinRoom),
      ),
      _DashboardActionTile(
        title: 'Profile',
        subtitle: 'View stats and edit profile',
        icon: Icons.person_rounded,
        onTap: () => context.push(RouteNames.profile),
      ),
      _DashboardActionTile(
        title: 'Settings',
        subtitle: 'Change theme and preferences',
        icon: Icons.settings_rounded,
        onTap: () => context.push(RouteNames.settings),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Janak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: actions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => actions[index],
        ),
      ),
    );
  }
}

class _DashboardActionTile extends StatelessWidget {
  const _DashboardActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: PremiumCard(
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              child: Icon(icon),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}