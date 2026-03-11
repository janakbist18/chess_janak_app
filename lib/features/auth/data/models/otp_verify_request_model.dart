/// OTP verification request model
class OtpVerifyRequestModel {
  final String email;
  final String otp;

  OtpVerifyRequestModel({required this.email, required this.otp});

  Map<String, dynamic> toJson() => {'email': email, 'otp': otp};
}
