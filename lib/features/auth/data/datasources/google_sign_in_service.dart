import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Exception thrown when Google Sign-In is not properly configured
class GoogleSignInConfigurationException implements Exception {
  final String message;

  GoogleSignInConfigurationException(this.message);

  @override
  String toString() => message;
}

/// Google Sign-In service with proper initialization
class GoogleSignInService {
  late GoogleSignIn _googleSignIn;
  bool _isInitialized = false;

  // Web Client ID - Update with your actual Web Client ID from Google Cloud Console
  // Format: your-client-id.apps.googleusercontent.com
  static const String _webClientId =
      '722319935819-41b6jqavu4r5i1s1j1pdtjjhginn2obt.apps.googleusercontent.com';

  /// Initialize Google Sign-In service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Platform-specific configuration
      String? clientId;

      // For web platform, pass the Web Client ID
      if (_isWeb()) {
        clientId = _webClientId;
        if (clientId.startsWith('YOUR_')) {
          throw GoogleSignInConfigurationException(
            'Web Client ID not configured.\n\n'
            'To fix:\n'
            '1. Go to https://console.cloud.google.com\n'
            '2. Create OAuth 2.0 Client ID for Web\n'
            '3. Update _webClientId in google_sign_in_service.dart\n'
            '4. Or add meta tag to web/index.html:\n'
            '   <meta name="google-signin-client_id" content="YOUR_CLIENT_ID" />\n'
            '5. Restart the app',
          );
        }
      }

      // Initialize GoogleSignIn with platform-specific config
      _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'profile',
          'https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/userinfo.email',
        ],
        clientId: clientId, // Only used on web, ignored on Android/iOS
        forceCodeForRefreshToken: true, // Required for web to get refresh token
        signInOption: SignInOption.standard, // Standard sign-in popup
      );

      _isInitialized = true;
    } catch (e) {
      if (e is GoogleSignInConfigurationException) rethrow;

      throw GoogleSignInConfigurationException(
        'Failed to initialize Google Sign-In: $e\n\n'
        'Please ensure:\n'
        '1. google-services.json is placed in android/app/\n'
        '2. GoogleService-Info.plist is added to iOS project\n'
        '3. Web Client ID is configured for web platform\n'
        '4. Platform configuration files are properly set up',
      );
    }
  }

  /// Check if running on web platform
  static bool _isWeb() {
    return kIsWeb;
  }

  /// Sign in with Google
  Future<GoogleSignInAccount?> signIn() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      return googleUser;
    } on Exception catch (e) {
      final errorMessage = e.toString().toLowerCase();

      print('Google Sign-In Error: $errorMessage');

      // Handle redirect_uri_mismatch error
      if (errorMessage.contains('redirect_uri_mismatch')) {
        throw GoogleSignInConfigurationException(
          'Google OAuth Error: redirect_uri_mismatch\n\n'
          'This means your Authorized Redirect URIs in Google Cloud Console '
          'don\'t match your app\'s URL.\n\n'
          'TO FIX THIS:\n'
          '1. Go to: https://console.cloud.google.com/apis/credentials\n'
          '2. Click your OAuth 2.0 Client ID (Web Application)\n'
          '3. Click "Edit OAuth client"\n'
          '4. Under "Authorized redirect URIs", ADD:\n'
          '   • http://localhost/\n'
          '   • http://localhost:7357/\n'
          '   • http://127.0.0.1/\n'
          '   • http://127.0.0.1:7357/\n'
          '5. Under "Authorized JavaScript origins", ensure:\n'
          '   • http://localhost\n'
          '   • http://localhost:7357\n'
          '   • http://127.0.0.1\n'
          '   • http://127.0.0.1:7357\n'
          '6. Click "Save"\n'
          '7. Wait 2-3 minutes for changes to propagate\n'
          '8. Clear browser cache: Ctrl+Shift+Delete\n'
          '9. Close Chrome completely\n'
          '10. Restart: flutter run -d chrome',
        );
      }

      // Handle popup_closed error (user cancelled or popup was blocked)
      if (errorMessage.contains('popup_closed') ||
          errorMessage.contains('popup closed') ||
          errorMessage.contains('cancelled')) {
        // Popup was closed by user or blocked by browser - not an error condition
        print('User cancelled sign-in or popup was blocked');
        return null;
      }

      // Handle configuration errors
      if (errorMessage.contains('UnimplementedError')) {
        throw GoogleSignInConfigurationException(
          'Google Sign-In is not properly configured.\n\n'
          'To fix this:\n\n'
          'WEB:\n'
          '1. Go to https://console.cloud.google.com\n'
          '2. Under "Authorized JavaScript origins", add:\n'
          '   - http://localhost\n'
          '   - http://localhost:7357\n'
          '   - http://127.0.0.1\n'
          '   - http://127.0.0.1:7357\n'
          '3. Update _webClientId in this file\n'
          '4. Wait 1-2 minutes for changes to propagate\n'
          '5. Restart the app\n\n'
          'ANDROID:\n'
          '1. Download google-services.json from Firebase Console\n'
          '2. Place it in: android/app/google-services.json\n\n'
          'iOS:\n'
          '1. Download GoogleService-Info.plist from Firebase Console\n'
          '2. Add it to ios/Runner/ in Xcode',
        );
      }

      // Handle invalid Client ID or authorization errors
      if (errorMessage.contains('invalid_client') ||
          errorMessage.contains('unauthorized_client') ||
          errorMessage.contains('access_denied') ||
          errorMessage.contains('not_configured') ||
          errorMessage.contains('invalid_request')) {
        throw GoogleSignInConfigurationException(
          'Google OAuth Error: Invalid request or missing configuration\n\n'
          'This usually means one of:\n'
          '1. Redirect URI mismatch (most common)\n'
          '2. Client ID is wrong\n'
          '3. Origins not authorized\n\n'
          'TO FIX:\n'
          'STEP 1: Verify Client ID\n'
          '  Current: 722319935819-41b6jqavu4r5i1s1j1pdtjjhginn2obt.apps.googleusercontent.com\n'
          '  Go to: https://console.cloud.google.com/apis/credentials\n'
          '  Compare with your OAuth 2.0 Client ID\n\n'
          'STEP 2: Add Authorized Origins (JavaScript Origins)\n'
          '  Add these origins:\n'
          '  • http://localhost\n'
          '  • http://localhost:7357\n'
          '  • http://127.0.0.1\n'
          '  • http://127.0.0.1:7357\n\n'
          'STEP 3: Add Authorized Redirect URIs\n'
          '  Add these redirect URIs:\n'
          '  • http://localhost/\n'
          '  • http://localhost:7357/\n'
          '  • http://127.0.0.1/\n'
          '  • http://127.0.0.1:7357/\n\n'
          'STEP 4: Save and wait\n'
          '  Click Save in Google Cloud Console\n'
          '  Wait 2-3 minutes for changes to apply\n\n'
          'STEP 5: Clear cache\n'
          '  Ctrl+Shift+Delete to open Clear Browsing Data\n'
          '  Select All time and clear\n\n'
          'STEP 6: Restart\n'
          '  Close Chrome entirely\n'
          '  Run: flutter run -d chrome',
        );
      }

      // Handle network errors
      if (errorMessage.contains('network') ||
          errorMessage.contains('timeout')) {
        throw GoogleSignInConfigurationException(
          'Network error connecting to Google Sign-In.\n\n'
          'To fix:\n'
          '1. Check your internet connection\n'
          '2. Try again in a few seconds\n'
          '3. If problem persists, check:\n'
          '   - https://www.google.com (should load)\n'
          '   - https://accounts.google.com (should load)',
        );
      }

      // Handle browser popup blocking
      if (errorMessage.contains('blocked') || errorMessage.contains('block')) {
        throw GoogleSignInConfigurationException(
          'Browser is blocking the Google Sign-In popup.\n\n'
          'To fix:\n'
          '1. Check browser popup blocker settings\n'
          '2. Allow popups for localhost\n'
          '3. Try in incognito/private mode\n'
          '4. Try a different browser (Chrome preferred)',
        );
      }

      // Generic error
      throw GoogleSignInConfigurationException(
        'Google Sign-In failed: $errorMessage\n\n'
        'To fix:\n'
        '1. Verify internet connection\n'
        '2. Check browser console for details (F12)\n'
        '3. Try in incognito mode\n'
        '4. Clear browser cache\n'
        '5. Restart the app',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      if (_isInitialized) {
        await _googleSignIn.signOut();
      }
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  /// Get current signed-in user
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  /// Check if user is signed in
  Future<bool> isSignedIn() async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _googleSignIn.isSignedIn();
  }
}

/// Provider for Google Sign-In service
final googleSignInServiceProvider = Provider<GoogleSignInService>((ref) {
  return GoogleSignInService();
});
