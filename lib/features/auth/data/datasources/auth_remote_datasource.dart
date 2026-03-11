import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_user.dart';
import '../models/auth_user_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/otp_verify_request_model.dart';
import '../models/google_sign_in_request_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/config/api_endpoints.dart';

/// Remote data source for authentication
class AuthRemoteDataSource {
  final ApiClient _apiClient;
  final SecureStorageService _secureStorage;

  AuthRemoteDataSource(this._apiClient, this._secureStorage);

  Future<AuthUserModel> login(LoginRequestModel request) async {
    // TODO: Implement login API call
    throw UnimplementedError();
  }

  Future<AuthUserModel> register(RegisterRequestModel request) async {
    // TODO: Implement register API call
    throw UnimplementedError();
  }

  Future<AuthUserModel> verifyOtp(OtpVerifyRequestModel request) async {
    // TODO: Implement OTP verification API call
    throw UnimplementedError();
  }

  Future<AuthUserModel> googleSignIn(GoogleSignInRequestModel request) async {
    // TODO: Implement Google sign-in API call
    throw UnimplementedError();
  }

  Future<void> logout() async {
    // TODO: Implement logout
    await _secureStorage.clearToken();
  }

  Future<AuthUserModel> getCurrentUser() async {
    // TODO: Implement get current user API call
    throw UnimplementedError();
  }
}

/// Provider for auth remote data source
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRemoteDataSource(apiClient, secureStorage);
});
