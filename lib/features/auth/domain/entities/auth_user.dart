/// Auth user entity
class AuthUser {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? phoneNumber;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  AuthUser({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.phoneNumber,
    this.isEmailVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });
}
