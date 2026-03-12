/// Auth tokens model for API responses
class AuthTokensModel {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiresAt': expiresAt.toIso8601String(),
      };
}
