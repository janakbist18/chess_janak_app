import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';

/// Google auth controller
class GoogleAuthController extends StateNotifier<AuthState> {
  GoogleAuthController() : super(const AuthState());

  Future<void> signIn() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: Implement Google sign-in logic
      throw UnimplementedError();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// Provider for Google auth controller
final googleAuthControllerProvider =
    StateNotifierProvider<GoogleAuthController, AuthState>((ref) {
      return GoogleAuthController();
    });
