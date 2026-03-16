import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import '../../.././auth/presentation/providers/auth_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('♟️ Chess Janak'),
        elevation: 0,
        backgroundColor: Colors.amber.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
              context.go(RouteNames.login);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Card
                authState.when(
                  data: (user) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.shade700,
                            Colors.amber.shade900,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, ${user?.username ?? 'Player'}! 👋',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ready to play some chess?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text('Error: $error'),
                  ),
                ),
                const SizedBox(height: 32),

                // Quick Stats
                Row(
                  children: [
                    _StatCard(
                      title: 'Wins',
                      value: '12',
                      icon: Icons.emoji_events,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      title: 'Draws',
                      value: '5',
                      icon: Icons.handshake,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      title: 'Rating',
                      value: '1650',
                      icon: Icons.trending_up,
                      color: Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Main Actions
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                _DashboardActionTile(
                  title: 'Play Now',
                  subtitle: 'Find and join a game',
                  icon: Icons.play_circle_fill,
                  color: Colors.green,
                  onTap: () => context.push(RouteNames.findGame),
                ),
                const SizedBox(height: 12),

                _DashboardActionTile(
                  title: 'Create Room',
                  subtitle: 'Create a new game room',
                  icon: Icons.add_circle_outline,
                  color: Colors.blue,
                  onTap: () => context.push(RouteNames.createRoom),
                ),
                const SizedBox(height: 12),

                _DashboardActionTile(
                  title: 'Your Profile',
                  subtitle: 'View stats and achievements',
                  icon: Icons.person,
                  color: Colors.purple,
                  onTap: () => context.push(RouteNames.profile),
                ),
                const SizedBox(height: 12),

                _DashboardActionTile(
                  title: 'Game History',
                  subtitle: 'Review past games',
                  icon: Icons.history,
                  color: Colors.orange,
                  onTap: () => context.push(RouteNames.gameHistory),
                ),
                const SizedBox(height: 32),

                // Recent Games
                Text(
                  'Recent Games',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                _RecentGameTile(
                  opponent: 'John Doe',
                  result: 'Won',
                  time: '2 hours ago',
                  resultColor: Colors.green,
                ),
                const SizedBox(height: 12),

                _RecentGameTile(
                  opponent: 'Jane Smith',
                  result: 'Draw',
                  time: '1 day ago',
                  resultColor: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

class _RecentGameTile extends StatelessWidget {
  final String opponent;
  final String result;
  final String time;
  final Color resultColor;

  const _RecentGameTile({
    required this.opponent,
    required this.result,
    required this.time,
    required this.resultColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 24, child: Icon(Icons.person)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opponent,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: resultColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              result,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: resultColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
