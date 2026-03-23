import 'package:flutter/material.dart';

/// Profile header widget
class ProfileHeader extends StatelessWidget {
  final String username;
  final String? avatarUrl;
  final int rating;

  const ProfileHeader({
    super.key,
    required this.username,
    this.avatarUrl,
    this.rating = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null ? const Icon(Icons.person) : null,
        ),
        const SizedBox(height: 16),
        Text(username, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Rating: $rating',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
