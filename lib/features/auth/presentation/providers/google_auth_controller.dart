import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/google_sign_in_service.dart';
import '../../data/models/google_sign_in_request_model.dart';
import 'auth_state.dart';

/// Google auth controller using proper GoogleSignInService
class GoogleAuthController extends StateNotifier<AuthState> {
  final AuthRemoteDataSource _authRemoteDataSource;
  final GoogleSignInService _googleSignInService;

  GoogleAuthController(this._authRemoteDataSource, this._googleSignInService)
      : super(const AuthState());

  /// Sign in with Google
  ///
  /// Uses GoogleSignInService for proper error handling and configuration
  Future<void> signIn() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Initialize and get Google user
      final GoogleSignInAccount? googleUser =
          await _googleSignInService.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        state = state.copyWith(isLoading: false);
        return;
      }

      // Get authentication credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw Exception('Failed to get Google ID token');
      }

      // Create request with ID token
      final request = GoogleSignInRequestModel(
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      // Send to backend and authenticate
      final user = await _authRemoteDataSource.googleSignIn(request);
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Sign out with Google
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _googleSignInService.signOut();
      state = state.copyWith(isLoading: false, user: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Check if user is signed in
  Future<bool> isSignedIn() async {
    try {
      return await _googleSignInService.isSignedIn();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

/// Provider for Google auth controller
final googleAuthControllerProvider =
    StateNotifierProvider<GoogleAuthController, AuthState>((ref) {
  final authRemoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final googleSignInService = ref.watch(googleSignInServiceProvider);
  return GoogleAuthController(authRemoteDataSource, googleSignInService);
});
