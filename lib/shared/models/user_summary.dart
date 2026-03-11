/// User summary model for quick display
class UserSummary {
  final String id;
  final String username;
  final String? email;
  final String? avatarUrl;
  final int? rating;
  final bool isOnline;
  final DateTime? lastSeen;

  UserSummary({
    required this.id,
    required this.username,
    this.email,
    this.avatarUrl,
    this.rating,
    this.isOnline = false,
    this.lastSeen,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    return UserSummary(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      rating: json['rating'] as int?,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'avatarUrl': avatarUrl,
    'rating': rating,
    'isOnline': isOnline,
    'lastSeen': lastSeen?.toIso8601String(),
  };
}
