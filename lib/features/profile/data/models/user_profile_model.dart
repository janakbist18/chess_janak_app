/// User profile model with comprehensive stats
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? bio;
  final String? profileImage;
  final int rating;
  final int wins;
  final int losses;
  final int draws;
  final double winRate;
  final DateTime joinedAt;
  final int gamesPlayed;
  final List<Achievement> achievements;
  final int followers;
  final int following;
  final String title; // GM, IM, NM, etc.
  final bool isOnline;
  final DateTime? lastSeen;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.profileImage,
    required this.rating,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.winRate,
    required this.joinedAt,
    required this.gamesPlayed,
    this.achievements = const [],
    this.followers = 0,
    this.following = 0,
    this.title = 'Member',
    this.isOnline = false,
    this.lastSeen,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String?,
      profileImage: json['profile_image'] as String?,
      rating: json['rating'] as int? ?? 1200,
      wins: json['wins'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      draws: json['draws'] as int? ?? 0,
      winRate: json['win_rate'] as double? ?? 0.0,
      joinedAt: DateTime.parse(
        json['joined_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      gamesPlayed: json['games_played'] as int? ?? 0,
      achievements:
          (json['achievements'] as List<dynamic>?)
              ?.map((e) => Achievement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
      title: json['title'] as String? ?? 'Member',
      isOnline: json['is_online'] as bool? ?? false,
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'bio': bio,
    'profile_image': profileImage,
    'rating': rating,
    'wins': wins,
    'losses': losses,
    'draws': draws,
    'win_rate': winRate,
    'joined_at': joinedAt.toIso8601String(),
    'games_played': gamesPlayed,
    'achievements': achievements.map((a) => a.toJson()).toList(),
    'followers': followers,
    'following': following,
    'title': title,
    'is_online': isOnline,
    'last_seen': lastSeen?.toIso8601String(),
  };

  // Copy with method for immutable updates
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
    String? profileImage,
    int? rating,
    int? wins,
    int? losses,
    int? draws,
    double? winRate,
    DateTime? joinedAt,
    int? gamesPlayed,
    List<Achievement>? achievements,
    int? followers,
    int? following,
    String? title,
    bool? isOnline,
    DateTime? lastSeen,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      rating: rating ?? this.rating,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
      winRate: winRate ?? this.winRate,
      joinedAt: joinedAt ?? this.joinedAt,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      achievements: achievements ?? this.achievements,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      title: title ?? this.title,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}

/// Achievement model
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final DateTime unlockedAt;
  final String category; // puzzle_master, tournament_winner, speed_demon, etc.

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.unlockedAt,
    required this.category,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      unlockedAt: DateTime.parse(json['unlocked_at'] as String),
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'icon': icon,
    'unlocked_at': unlockedAt.toIso8601String(),
    'category': category,
  };
}

/// Leaderboard entry
class LeaderboardEntry {
  final int rank;
  final UserProfile player;
  final int rating;
  final int gamesPlayed;
  final int wins;
  final double winRate;

  LeaderboardEntry({
    required this.rank,
    required this.player,
    required this.rating,
    required this.gamesPlayed,
    required this.wins,
    required this.winRate,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] as int,
      player: UserProfile.fromJson(json['player'] as Map<String, dynamic>),
      rating: json['rating'] as int,
      gamesPlayed: json['games_played'] as int,
      wins: json['wins'] as int,
      winRate: json['win_rate'] as double,
    );
  }

  Map<String, dynamic> toJson() => {
    'rank': rank,
    'player': player.toJson(),
    'rating': rating,
    'games_played': gamesPlayed,
    'wins': wins,
    'win_rate': winRate,
  };
}
