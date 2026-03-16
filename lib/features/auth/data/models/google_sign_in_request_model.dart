/// Google sign-in request model
class GoogleSignInRequestModel {
  final String idToken;
  final String? accessToken;
  final String? username;

  GoogleSignInRequestModel({
    required this.idToken,
    this.accessToken,
    this.username,
  });

  Map<String, dynamic> toJson() => {
        'idToken': idToken,
        'accessToken': accessToken,
        'username': username,
      };
}
