/// Google sign-in request model
class GoogleSignInRequestModel {
  final String idToken;
  final String? username;

  GoogleSignInRequestModel({required this.idToken, this.username});

  Map<String, dynamic> toJson() => {'idToken': idToken, 'username': username};
}
