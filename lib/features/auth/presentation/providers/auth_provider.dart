import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/auth_user_model.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/register_request_model.dart';
import '../../data/models/otp_verify_request_model.dart';

/// Current authenticated user state
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthUserModel?>>((ref) {
  final authRemoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthNotifier(authRemoteDataSource);
});

/// Auth state notifier for managing login/register/logout
class AuthNotifier extends StateNotifier<AsyncValue<AuthUserModel?>> {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthNotifier(this._authRemoteDataSource) : super(const AsyncValue.data(null));

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
  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
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
      // Import google_sign_in package and use it here
      // For now, return a placeholder that will be completed when integrated
      throw UnimplementedError(
        'Google Sign-In: Complete integration with google_sign_in package',
      );
    });
  }
}

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
});

/// Get current user ID if authenticated
final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (user) => user?.id,
    orElse: () => null,
  );
});

/// Get current user email if authenticated
final currentUserEmailProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (user) => user?.email,
    orElse: () => null,
  );
});
