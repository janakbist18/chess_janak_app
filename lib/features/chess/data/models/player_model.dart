class PlayerModel {
  final String playerId;
  final String username;
  final String email;
  final String? avatar;
  final int gamesPlayed;
  final int wins;
  final int losses;
  final int draws;
  final double rating;
  final DateTime createdAt;

  PlayerModel({
    required this.playerId,
    required this.username,
    required this.email,
    this.avatar,
    this.gamesPlayed = 0,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
    this.rating = 1200.0,
    required this.createdAt,
  });

  double get winRate => gamesPlayed == 0 ? 0 : (wins / gamesPlayed) * 100;

  PlayerModel copyWith({
    String? playerId,
    String? username,
    String? email,
    String? avatar,
    int? gamesPlayed,
    int? wins,
    int? losses,
    int? draws,
    double? rating,
    DateTime? createdAt,
  }) {
    return PlayerModel(
      playerId: playerId ?? this.playerId,
      username: username ?? this.username,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      playerId: json['playerId'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      gamesPlayed: json['gamesPlayed'] ?? 0,
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
      draws: json['draws'] ?? 0,
      rating: (json['rating'] ?? 1200.0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'username': username,
      'email': email,
      'avatar': avatar,
      'gamesPlayed': gamesPlayed,
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerModel &&
          runtimeType == other.runtimeType &&
          playerId == other.playerId;

  @override
  int get hashCode => playerId.hashCode;
}
