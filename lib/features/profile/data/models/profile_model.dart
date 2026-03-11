/// Profile model
class ProfileModel {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final int rating;
  final int wins;
  final int losses;
  final int draws;
  final DateTime createdAt;
  final DateTime lastPlayedAt;

  ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.rating = 1200,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
    required this.createdAt,
    required this.lastPlayedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      rating: json['rating'] ?? 1200,
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
      draws: json['draws'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      lastPlayedAt: DateTime.parse(json['lastPlayedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'avatarUrl': avatarUrl,
    'bio': bio,
    'rating': rating,
    'wins': wins,
    'losses': losses,
    'draws': draws,
    'createdAt': createdAt.toIso8601String(),
    'lastPlayedAt': lastPlayedAt.toIso8601String(),
  };
}
