import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/user_profile_model.dart';
import '../providers/leaderboard_provider.dart';
import '../../../chat/presentation/providers/chat_provider.dart';
import 'leaderboard_screen.dart';

/// Enhanced user profile screen
class EnhancedProfileScreen extends ConsumerWidget {
  final String? userId; // If null, show current user profile
  final VoidCallback? onEditProfile;

  const EnhancedProfileScreen({super.key, this.userId, this.onEditProfile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrentUser = userId == null;

    // Watch the appropriate provider and get profile
    final UserProfile? profile;
    final bool isLoading;
    final Object? error;

    if (isCurrentUser) {
      profile = ref.watch(currentUserProfileProvider);
      isLoading = false;
      error = null;
    } else {
      final asyncProfile = ref.watch(userProfileProvider(userId!));
      profile = asyncProfile.valueOrNull;
      isLoading = asyncProfile.isLoading;
      error = asyncProfile.hasError ? asyncProfile.error : null;
    }

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(child: Text('Error: $error')),
      );
    }

    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Profile not found')),
      );
    }

    return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
            actions: [
              if (isCurrentUser)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEditProfile,
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Profile header
                _buildProfileHeader(context, ref, profile, isCurrentUser),
                const SizedBox(height: 16),
                // Stats cards
                _buildStatsSection(context, profile),
                const SizedBox(height: 16),
                // Achievements
                if (profile.achievements.isNotEmpty)
                  _buildAchievementsSection(context, profile),
                const SizedBox(height: 16),
                // Action buttons
                _buildActionsSection(context, ref, profile, isCurrentUser),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
    bool isCurrentUser,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.amber[700]!, Colors.amber[900]!],
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Profile image
          CircleAvatar(
            radius: 60,
            backgroundImage: profile.profileImage != null
                ? NetworkImage(profile.profileImage!)
                : null,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: profile.profileImage == null
                ? Text(
                    profile.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          // Name and title
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              profile.title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Online status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 4,
                backgroundColor: profile.isOnline ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                profile.isOnline
                    ? 'Online'
                    : 'Last seen ${_formatDate(profile.lastSeen)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          // Bio
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              profile.bio!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.9),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, UserProfile profile) {
    final stats = [
      {
        'label': 'Rating',
        'value': profile.rating.toString(),
        'icon': Icons.trending_up,
      },
      {
        'label': 'Wins',
        'value': profile.wins.toString(),
        'icon': Icons.emoji_events,
      },
      {
        'label': 'Losses',
        'value': profile.losses.toString(),
        'icon': Icons.close,
      },
      {
        'label': 'Draws',
        'value': profile.draws.toString(),
        'icon': Icons.handshake,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Statistics', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: stats
                .map(
                  (stat) => _buildStatCard(
                    context,
                    stat['label'] as String,
                    stat['value'] as String,
                    stat['icon'] as IconData,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          // Win rate bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Text(
                  'Win Rate',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  '${(profile.winRate * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber[50],
        border: Border.all(color: Colors.amber[700]!, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.amber[700], size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context, UserProfile profile) {
    final achievementsByCategory = <String, List<Achievement>>{};
    for (final achievement in profile.achievements) {
      achievementsByCategory.putIfAbsent(achievement.category, () => []);
      achievementsByCategory[achievement.category]!.add(achievement);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          ...achievementsByCategory.entries.map((entry) {
            final category = entry.key;
            final achievements = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: achievements
                      .map(
                        (achievement) =>
                            _buildAchievementBadge(context, achievement),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(BuildContext context, Achievement achievement) {
    return Tooltip(
      message: '${achievement.name}\n${achievement.description}',
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.amber[50],
          border: Border.all(color: Colors.amber[700]!, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(achievement.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              achievement.name,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
    bool isCurrentUser,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (!isCurrentUser) ...[
            // Message button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.message),
                label: const Text('Send Message'),
                onPressed: () {
                  ref.read(chatProvider.notifier).openConversation(
                        profile.id,
                        profile.name,
                        profile.profileImage,
                      );
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
          // View leaderboard
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.leaderboard),
              label: const Text('View Leaderboard'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
                );
              },
            ),
          ),
          if (!isCurrentUser) ...[
            const SizedBox(height: 12),
            // Follow button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ref
                      .read(currentUserProfileProvider.notifier)
                      .followUser(profile.id);
                },
                child: const Text('Follow'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'never';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return DateFormat('MMM d').format(date);
  }
}
