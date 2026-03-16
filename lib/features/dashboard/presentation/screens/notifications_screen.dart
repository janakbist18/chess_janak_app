import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifications and Activity Feed Screen
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = [
      _NotificationItem(
        type: 'challenge',
        title: 'New Challenge from Alex',
        description: 'Alex Chen challenged you to a Blitz game',
        timestamp: 'Just now',
        icon: Icons.sports_esports,
        color: Colors.blue,
        actionable: true,
      ),
      _NotificationItem(
        type: 'friend_request',
        title: 'Friend Request',
        description: 'Sarah Johnson sent you a friend request',
        timestamp: '5 mins ago',
        icon: Icons.person_add,
        color: Colors.purple,
        actionable: true,
      ),
      _NotificationItem(
        type: 'achievement',
        title: '🏆 Achievement Unlocked!',
        description: 'You earned "Rapid Champion" badge - Win 10 rapid games',
        timestamp: '1 hour ago',
        icon: Icons.emoji_events,
        color: Colors.amber,
        actionable: false,
      ),
      _NotificationItem(
        type: 'tournament',
        title: 'Tournament Starting Soon',
        description: 'Blitz Championship starts in 2 hours',
        timestamp: '2 hours ago',
        icon: Icons.emoji_events,
        color: Colors.orange,
        actionable: true,
      ),
      _NotificationItem(
        type: 'game_result',
        title: 'Game Completed',
        description: 'Your game against Krishna ended in a draw',
        timestamp: 'Yesterday',
        icon: Icons.check_circle,
        color: Colors.green,
        actionable: false,
      ),
      _NotificationItem(
        type: 'rating_change',
        title: 'Rating Updated',
        description: 'Your rating increased to 1850 (+45)',
        timestamp: 'Yesterday',
        icon: Icons.trending_up,
        color: Colors.green,
        actionable: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔔 Notifications'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('All notifications marked as read')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Notification settings',
            onPressed: () {},
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No Notifications',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'re all caught up!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              itemBuilder: (context, index) => _NotificationTile(
                notification: notifications[index],
                onDismiss: () {},
              ),
            ),
    );
  }
}

class _NotificationItem {
  final String type;
  final String title;
  final String description;
  final String timestamp;
  final IconData icon;
  final Color color;
  final bool actionable;

  _NotificationItem({
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.icon,
    required this.color,
    required this.actionable,
  });
}

class _NotificationTile extends StatelessWidget {
  final _NotificationItem notification;
  final VoidCallback onDismiss;

  const _NotificationTile({
    required this.notification,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(notification.title),
      background: Container(
        color: Colors.red.shade100,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      onDismissed: (_) => onDismiss(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: notification.color.withOpacity(0.2),
                    ),
                    child: Icon(
                      notification.icon,
                      color: notification.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              notification.timestamp,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.description,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (notification.actionable) ...[
                const SizedBox(height: 12),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Dismiss'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          notification.type == 'challenge'
                              ? 'Accept'
                              : notification.type == 'friend_request'
                                  ? 'Accept'
                                  : 'View',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
