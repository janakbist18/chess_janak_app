import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_user.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/otp_verify_request_model.dart';
import '../models/google_sign_in_request_model.dart';

/// Auth repository
class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Future<AuthUser> login(String email, String password) async {
    final request = LoginRequestModel(email: email, password: password);
    return await _remoteDataSource.login(request);
  }

  Future<AuthUser> register(
    String username,
    String email,
    String password,
  ) async {
    final request = RegisterRequestModel(
      username: username,
      email: email,
      password: password,
    );
    return await _remoteDataSource.register(request);
  }

  Future<AuthUser> verifyOtp(String email, String otp) async {
    final request = OtpVerifyRequestModel(email: email, otp: otp);
    return await _remoteDataSource.verifyOtp(request);
  }

  Future<AuthUser> googleSignIn(String idToken, {String? username}) async {
    final request = GoogleSignInRequestModel(
      idToken: idToken,
      username: username,
    );
    return await _remoteDataSource.googleSignIn(request);
  }

  Future<void> logout() async {
    return await _remoteDataSource.logout();
  }

  Future<AuthUser> getCurrentUser() async {
    return await _remoteDataSource.getCurrentUser();
  }
}

/// Provider for auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepository(remoteDataSource);
});
