import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/google_sign_in_service.dart';
import '../../data/models/auth_user_model.dart';
import '../../data/models/google_sign_in_request_model.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/register_request_model.dart';
import '../../data/models/otp_verify_request_model.dart';

/// Current authenticated user state
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthUserModel?>>((ref) {
  final authRemoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final googleSignInService = ref.watch(googleSignInServiceProvider);
  return AuthNotifier(authRemoteDataSource, googleSignInService);
});

/// Auth state notifier for managing login/register/logout
class AuthNotifier extends StateNotifier<AsyncValue<AuthUserModel?>> {
  final AuthRemoteDataSource _authRemoteDataSource;
  final GoogleSignInService _googleSignInService;

  AuthNotifier(this._authRemoteDataSource, this._googleSignInService)
      : super(const AsyncValue.data(null));

  /// Login user with email and password
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final request = LoginRequestModel(email: email, password: password);
      return await _authRemoteDataSource.login(request);
    });
  }

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    required String username,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final request = RegisterRequestModel(
        email: email,
        password: password,
        username: username,
      );
      return await _authRemoteDataSource.register(request);
    });
  }

  /// Verify OTP during registration
  Future<void> verifyOtp({required String email, required String otp}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final request = OtpVerifyRequestModel(email: email, otp: otp);
      return await _authRemoteDataSource.verifyOtp(request);
    });
  }

  /// Get current user profile
  Future<void> getCurrentUser() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _authRemoteDataSource.getCurrentUser();
    });
  }

  /// Logout user
  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _authRemoteDataSource.logout();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      // Still clear user even if logout fails
      state = const AsyncValue.data(null);
    }
  }

  /// Forgot password
  Future<void> forgotPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      await _authRemoteDataSource.forgotPassword(email);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Reset password
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _authRemoteDataSource.resetPassword(email, otp, newPassword);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Google sign-in
  Future<void> googleSignIn() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final GoogleSignInAccount? googleUser =
            await _googleSignInService.signIn();
        if (googleUser == null) {
          // User cancelled sign-in or popup was closed
          // Return current state without error
          state = const AsyncValue.data(null);
          return null;
        }

        print('Google user signed in: ${googleUser.email}');

        // Get authentication - this may take a moment on web
        GoogleSignInAuthentication? googleAuth;
        try {
          googleAuth = await googleUser.authentication;
          print('Got authentication object');
          print('Has idToken: ${googleAuth.idToken != null}');
          print('Has accessToken: ${googleAuth.accessToken != null}');
        } catch (authError) {
          print('Error getting authentication: $authError');
          throw Exception(
            'Failed to get authentication from Google: $authError',
          );
        }

        if (googleAuth.idToken == null) {
          print('ERROR: idToken is null after authentication');
          print('This usually means Google didnt return an ID token');
          throw Exception(
            'Failed to get Google ID token.\n\n'
            'This can happen if:\n'
            '1. Google People API is not enabled\n'
            '2. OAuth consent screen is not configured\n'
            '3. ID token scope is not requested\n\n'
            'To fix:\n'
            '1. Enable Google People API\n'
            '2. Configure OAuth consent screen (add yourself as test user)\n'
            '3. Check that email and profile scopes are requested',
          );
        }

        print('Got ID token successfully');

        final request = GoogleSignInRequestModel(
          idToken: googleAuth.idToken!,
          accessToken: googleAuth.accessToken,
        );

        return await _authRemoteDataSource.googleSignIn(request);
      } catch (e) {
        print('Google sign-in failed: $e');
        // Re-throw with better error message
        rethrow;
      }
    });
  }
}

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(data: (user) => user != null, orElse: () => false);
});

/// Get current user ID if authenticated
final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(data: (user) => user?.id, orElse: () => null);
});

/// Get current user email if authenticated
final currentUserEmailProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(data: (user) => user?.email, orElse: () => null);
});
