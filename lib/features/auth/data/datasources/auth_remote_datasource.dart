import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_user.dart';
import '../models/auth_user_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/otp_verify_request_model.dart';
import '../models/google_sign_in_request_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/config/api_endpoints.dart';

/// Remote data source for authentication
class AuthRemoteDataSource {
  final ApiClient _apiClient;
  final SecureStorageService _secureStorage;

  AuthRemoteDataSource(this._apiClient, this._secureStorage);

  /// Login with email and password
  Future<AuthUserModel> login(LoginRequestModel request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'email': request.email,
          'password': request.password,
        },
      );

      final authModel = AuthUserModel.fromJson(response.data);

      // Save tokens to secure storage
      if (authModel.accessToken != null) {
        await _secureStorage.saveAccessToken(authModel.accessToken!);
      }
      if (authModel.refreshToken != null) {
        await _secureStorage.saveRefreshToken(authModel.refreshToken!);
      }

      return authModel;
    } catch (e) {
      rethrow;
    }
  }

  /// Register new user
  Future<AuthUserModel> register(RegisterRequestModel request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'email': request.email,
          'password': request.password,
          'username': request.username,
        },
      );

      return AuthUserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Verify OTP
  Future<AuthUserModel> verifyOtp(OtpVerifyRequestModel request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyOtp,
        data: {
          'email': request.email,
          'otp': request.otp,
        },
      );

      final authModel = AuthUserModel.fromJson(response.data);

      // Save tokens to secure storage
      if (authModel.accessToken != null) {
        await _secureStorage.saveAccessToken(authModel.accessToken!);
      }
      if (authModel.refreshToken != null) {
        await _secureStorage.saveRefreshToken(authModel.refreshToken!);
      }

      return authModel;
    } catch (e) {
      rethrow;
    }
  }

  /// Google sign-in
  Future<AuthUserModel> googleSignIn(GoogleSignInRequestModel request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.googleSignIn,
        data: {
          'id_token': request.idToken,
          'access_token': request.accessToken,
        },
      );

      final authModel = AuthUserModel.fromJson(response.data);

      // Save tokens to secure storage
      if (authModel.accessToken != null) {
        await _secureStorage.saveAccessToken(authModel.accessToken!);
      }
      if (authModel.refreshToken != null) {
        await _secureStorage.saveRefreshToken(authModel.refreshToken!);
      }

      return authModel;
    } catch (e) {
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _secureStorage.clearAuthTokens();
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user profile
  Future<AuthUserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.me);
      return AuthUserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      await _apiClient.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword(
      String email, String otp, String newPassword) async {
    try {
      await _apiClient.post(
        ApiEndpoints.resetPassword,
        data: {
          'email': email,
          'otp': otp,
          'new_password': newPassword,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh token
  Future<String> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.tokenRefresh,
        data: {'refresh': refreshToken},
      );

      final accessToken = response.data['access'];
      if (accessToken != null) {
        await _secureStorage.saveAccessToken(accessToken);
      }

      return accessToken;
    } catch (e) {
      rethrow;
    }
  }
}

/// Provider for auth remote data source
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return AuthRemoteDataSource(apiClient, secureStorage);
});
