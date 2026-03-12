import '../../domain/entities/auth_user.dart';

/// Auth user model for API responses
class AuthUserModel extends AuthUser {
  AuthUserModel({
    required super.id,
    required super.username,
    required super.email,
    super.avatarUrl,
    super.phoneNumber,
    super.isEmailVerified,
    required super.createdAt,
    required super.updatedAt,
    super.accessToken,
    super.refreshToken,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      accessToken:
          json['accessToken'] as String? ?? json['access_token'] as String?,
      refreshToken:
          json['refreshToken'] as String? ?? json['refresh_token'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'avatarUrl': avatarUrl,
        'phoneNumber': phoneNumber,
        'isEmailVerified': isEmailVerified,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
}
