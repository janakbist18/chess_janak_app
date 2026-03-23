/// Reset password request model
class ResetPasswordRequestModel {
  final String token;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequestModel({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        'token': token,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
}
