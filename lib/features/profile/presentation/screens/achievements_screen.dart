import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Achievements and Badges Screen
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = [
      _Achievement(
        id: 'first_win',
        name: 'First Victory',
        description: 'Win your first game',
        icon: '🏁',
        rarity: 'Common',
        unlockedDate: DateTime.now().subtract(const Duration(days: 30)),
        progress: 1,
        target: 1,
      ),
      _Achievement(
        id: 'blitz_master',
        name: 'Blitz Master',
        description: 'Win 10 blitz games',
        icon: '⚡',
        rarity: 'Rare',
        unlockedDate: DateTime.now().subtract(const Duration(days: 7)),
        progress: 10,
        target: 10,
      ),
      _Achievement(
        id: 'rating_1800',
        name: 'Rising Star',
        description: 'Reach 1800 rating',
        icon: '⭐',
        rarity: 'Epic',
        unlockedDate: DateTime.now().subtract(const Duration(days: 2)),
        progress: 1,
        target: 1,
      ),
      _Achievement(
        id: 'perfect_game',
        name: 'Flawless Victory',
        description: 'Win a game without losing material',
        icon: '✨',
        rarity: 'Legendary',
        unlockedDate: null,
        progress: 0,
        target: 1,
      ),
      _Achievement(
        id: 'tournament_winner',
        name: 'Champion',
        description: 'Win a tournament',
        icon: '🏆',
        rarity: 'Legendary',
        unlockedDate: null,
        progress: 0,
        target: 1,
      ),
      _Achievement(
        id: 'speed_demon',
        name: 'Speed Demon',
        description: 'Win 5 games in a row',
        icon: '🚀',
        rarity: 'Rare',
        unlockedDate: DateTime.now().subtract(const Duration(days: 15)),
        progress: 5,
        target: 5,
      ),
      _Achievement(
        id: 'endgame_expert',
        name: 'Endgame Expert',
        description: 'Win 20 games in the endgame',
        icon: '🎯',
        rarity: 'Rare',
        unlockedDate: null,
        progress: 12,
        target: 20,
      ),
      _Achievement(
        id: 'social_butterfly',
        name: 'Social Butterfly',
        description: 'Make 50 friends',
        icon: '🦋',
        rarity: 'Uncommon',
        unlockedDate: null,
        progress: 28,
        target: 50,
      ),
    ];

    final unlockedCount =
        achievements.where((a) => a.unlockedDate != null).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏅 Achievements'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Achievement Progress',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$unlockedCount/${achievements.length}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: unlockedCount / achievements.length,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(
                          Colors.blue.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete $unlockedCount out of ${achievements.length} achievements',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(label: 'All', selected: true),
                  _FilterChip(label: 'Unlocked'),
                  _FilterChip(label: 'Locked'),
                  _FilterChip(label: 'Common'),
                  _FilterChip(label: 'Rare'),
                  _FilterChip(label: 'Legendary'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Achievements grid
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: achievements.length,
              itemBuilder: (context, index) =>
                  _AchievementCard(achievement: achievements[index]),
            ),
          ],
        ),
      ),
    );
  }
}

class _Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String rarity;
  final DateTime? unlockedDate;
  final int progress;
  final int target;

  _Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.rarity,
    required this.unlockedDate,
    required this.progress,
    required this.target,
  });

  bool get isUnlocked => unlockedDate != null;
  double get progressPercent =>
      target > 0 ? (progress / target).clamp(0, 1) : 0;
}

class _AchievementCard extends StatelessWidget {
  final _Achievement achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final rarityColor = _getRarityColor(achievement.rarity);

    return Card(
      color: achievement.isUnlocked ? Colors.white : Colors.grey[100],
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: rarityColor.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Text(
                        achievement.icon,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  if (achievement.isUnlocked)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                achievement.name,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                achievement.rarity,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: rarityColor,
                ),
              ),
              const SizedBox(height: 4),
              if (!achievement.isUnlocked)
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: achievement.progressPercent,
                    minHeight: 4,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(rarityColor),
                  ),
                ),
              if (!achievement.isUnlocked)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${achievement.progress}/${achievement.target}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Colors.grey;
      case 'uncommon':
        return Colors.green;
      case 'rare':
        return Colors.blue;
      case 'epic':
        return Colors.purple;
      case 'legendary':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final bool selected;

  const _FilterChip({
    required this.label,
    this.selected = false,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(widget.label),
        selected: _selected,
        onSelected: (selected) {
          setState(() => _selected = selected);
        },
      ),
    );
  }
}
