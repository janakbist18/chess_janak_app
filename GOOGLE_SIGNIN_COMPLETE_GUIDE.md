# Google Sign-In: Frontend-Backend Integration Complete Guide

## 🔄 Complete Data Flow

### User Journey: Google Sign-In Process

```
┌─────────────────────────────────────────────────────────────────┐
│                   FLUTTER APP (Frontend)                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  1. User taps "Sign in with Google"                            │
│     ↓                                                            │
│  2. GoogleSignIn.signIn() triggers                             │
│     (Uses native platform: Android/iOS)                        │
│     ↓                                                            │
│  3. User authenticates with Google                             │
│     ↓                                                            │
│  4. Get GoogleSignInAuthentication                             │
│     - idToken (JWT from Google)                                 │
│     - accessToken (for Google APIs)                            │
│     ↓                                                            │
│  5. Send idToken to backend                                     │
│     POST /api/auth/google_signin/                             │
│     ↓                                                            │
└─────────────────────────────────────────────────────────────────┘
                            ↓ Network Request
┌─────────────────────────────────────────────────────────────────┐
│                 DJANGO BACKEND (Server)                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  1. Receive idToken from Flutter app                           │
│     ↓                                                            │
│  2. Verify token signature with Google                         │
│     googleapis.com/.../certs                                   │
│     ↓                                                            │
│  3. Extract user info from token:                              │
│     - email                                                      │
│     - name                                                       │
│     - picture (profile image URL)                              │
│     - email_verified                                           │
│     ↓                                                            │
│  4. Check if user exists in database                           │
│     ↓                                                            │
│     YES: Update user fields                                    │
│     NO: Create new user account                                │
│     ↓                                                            │
│  5. Generate JWT tokens:                                       │
│     - access_token (short-lived, 5 mins)                       │
│     - refresh_token (long-lived, 7 days)                       │
│     ↓                                                            │
│  6. Return response with user & tokens                         │
│     ↓                                                            │
└─────────────────────────────────────────────────────────────────┘
                    ↑ Response with Tokens
┌─────────────────────────────────────────────────────────────────┐
│                   FLUTTER APP (Frontend)                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  1. Receive tokens & user data                                 │
│     ↓                                                            │
│  2. Save to secure storage:                                     │
│     - access_token → flutter_secure_storage                     │
│     - refresh_token → flutter_secure_storage                    │
│     - user_data → shared_preferences                            │
│     ↓                                                            │
│  3. Update auth state (Riverpod)                              │
│     → authStateProvider changes state to authenticated         │
│     ↓                                                            │
│  4. Navigate to dashboard/home                                 │
│     ↓                                                            │
│  5. All subsequent requests include:                           │
│     Authorization: Bearer {access_token}                       │
│     ↓                                                            │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📝 API Request/Response Reference

### Request to Backend

**Endpoint:** `POST /api/auth/google_signin/`

**Headers:**

```http
Content-Type: application/json
```

**Request Body:**

```json
{
  "id_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6Ijbcde8f9a1b2c...",
  "accessToken": "ya29.a0AeTM1idY0GzXVZ..." // Optional, for analytics
}
```

### Successful Response (200 OK)

```json
{
  "message": "Google authentication successful",
  "user": {
    "id": 42,
    "email": "user@gmail.com",
    "username": "user_unique_name",
    "name": "User Full Name",
    "profile_image": null,
    "is_verified": true,
    "is_google_account": true,
    "online_status": "offline"
  },
  "tokens": {
    "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### Error Response (400 Bad Request)

```json
{
  "error": "Google ID token is required"
}
```

### Error Response (401 Unauthorized)

```json
{
  "error": "Google authentication failed: Invalid token signature"
}
```

---

## 🛠️ Flutter Implementation Details

### 1. GoogleSignInService Flow

**File:** `lib/features/auth/data/datasources/google_sign_in_service.dart`

```dart
// Initialize service
final googleSignInService = GoogleSignInService();
await googleSignInService.initialize();

// Sign in (get Google credentials)
final GoogleSignInAccount? googleUser =
    await googleSignInService.signIn();

// Extract ID token
final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
final String idToken = googleAuth.idToken;

// Sign out
await googleSignInService.signOut();
```

### 2. Backend API Call

**File:** `lib/features/auth/data/datasources/auth_remote_datasource.dart`

```dart
Future<AuthUserModel> googleSignIn(
    GoogleSignInRequestModel request) async {

  // POST request to backend
  final response = await dio.post(
    '/auth/google_signin/',  // Backend endpoint
    data: {
      'id_token': request.idToken,
      'accessToken': request.accessToken,
    },
  );

  // Parse response
  return AuthUserModel.fromJson(response.data);
}
```

### 3. State Management with Riverpod

**File:** `lib/features/auth/presentation/providers/auth_provider.dart`

```dart
// Sign in and update auth state
Future<void> googleSignIn() async {
  state = const AsyncValue.loading();
  state = await AsyncValue.guard(() async {

    // Get Google credentials
    final GoogleSignInAccount? googleUser =
        await _googleSignInService.signIn();

    if (googleUser == null) return state.valueOrNull;

    // Get ID token
    final googleAuth = await googleUser.authentication;
    if (googleAuth.idToken == null) {
      throw Exception('Failed to get Google ID token');
    }

    // Send to backend
    final request = GoogleSignInRequestModel(
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );

    // Authenticate with backend
    return await _authRemoteDataSource.googleSignIn(request);
  });
}
```

### 4. Token Storage

**File:** `lib/features/auth/data/repositories/auth_repository.dart`

After successful authentication:

```dart
// Store JWT tokens securely
await FlutterSecureStorage().write(
  key: 'access_token',
  value: tokens['access'],
);

await FlutterSecureStorage().write(
  key: 'refresh_token',
  value: tokens['refresh'],
);

// Store user data in shared preferences
await SharedPreferences.getInstance().then((prefs) {
  prefs.setString('user', jsonEncode(userData));
});
```

### 5. Using Tokens in Requests

Every API request includes the JWT token:

```dart
// DIO interceptor adds token automatically
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await FlutterSecureStorage().read(
        key: 'access_token',
      );

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      return handler.next(options);
    },
  ),
);
```

---

## 🐍 Django Backend Implementation

### 1. Google Token Verification

**File:** `apps/accounts/services/google_auth_service.py`

```python
from google.oauth2 import id_token
from google.auth.transport import requests

def verify_google_id_token(token: str) -> dict:
    """Verify Google ID token signature"""

    # Try each configured client ID
    for client_id in [GOOGLE_WEB_CLIENT_ID, GOOGLE_ANDROID_CLIENT_ID]:
        try:
            # Verify with Google servers
            info = id_token.verify_oauth2_token(
                token,
                requests.Request(),
                client_id,  # Must match one of your OAuth clients
            )
            return info  # Returns: {email, name, email_verified, ...}
        except:
            continue

    raise ValueError("Token verification failed")
```

### 2. User Creation/Update

**File:** `apps/accounts/services/google_auth_service.py`

```python
def get_or_create_google_user(google_data: dict) -> User:
    """Create or update user from Google data"""

    email = google_data.get("email")
    name = google_data.get("name")

    # Check if user exists
    user = User.objects.filter(email__iexact=email).first()

    if user:
        # Update existing user
        user.is_google_account = True
        if google_data.get("email_verified"):
            user.is_verified = True
        user.save()
    else:
        # Create new user
        username = generate_unique_username(email)
        user = User.objects.create_user(
            email=email,
            username=username,
            name=name,
            is_google_account=True,
            is_verified=google_data.get("email_verified", False),
        )

    return user
```

### 3. API View Handler

**File:** `apps/accounts/views_auth.py`

```python
class AuthViewSet(viewsets.ViewSet):

    @action(detail=False, methods=["post"])
    def google_signin(self, request):
        """Handle Google Sign-In"""

        id_token = request.data.get('id_token')

        if not id_token:
            return Response(
                {"error": "Google ID token is required"},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            # Verify token and create/update user
            result = handle_google_login(id_token)
            user = result['user']
            tokens = result['tokens']

            # Return success response
            return Response({
                "message": "Google authentication successful",
                "user": UserSerializer(user).data,
                "tokens": tokens,  # {access, refresh}
            }, status=status.HTTP_200_OK)

        except ValueError as e:
            return Response(
                {"error": str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )
```

### 4. JWT Token Generation

**File:** `apps/accounts/services/jwt_service.py`

```python
def get_tokens_for_user(user: User) -> dict:
    """Generate JWT tokens for authenticated user"""

    from rest_framework_simplejwt.tokens import RefreshToken

    refresh = RefreshToken.for_user(user)

    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }
```

---

## 🔐 Security Considerations

### Token Verification

- ✅ Backend verifies Google token signature with Google servers
- ✅ Token must match one of configured client IDs (Web/Android/iOS)
- ✅ Token expiration is checked by Google library

### Token Storage (Flutter)

- ✅ **JWT Tokens**: Stored in `flutter_secure_storage` (encrypted)
- ✅ **User Data**: Stored in `shared_preferences` (encrypted on some platforms)

### Token Usage

- ✅ **Access Token**: Included in `Authorization: Bearer` header
- ✅ **Refresh Token**: Used to get new access token when expired
- ✅ **Token Expiration**: Access tokens expire in 5 minutes (configured in backend)

### Backend Security

- ✅ **ALLOWED_HOSTS**: Must include your frontend domain/IP
- ✅ **CORS**: Must whitelist your app domain
- ✅ **HTTPS**: Always use HTTPS in production
- ✅ **Client ID Validation**: Multiple client IDs supported (Web/Android/iOS)

---

## 🧪 Testing the Integration

### 1. Test Backend Endpoint (cURL)

```bash
# Get a Google ID token first (use OAuth 2.0 Playground)
# Then test backend:

curl -X POST http://localhost:8000/api/auth/google_signin/ \
  -H "Content-Type: application/json" \
  -d '{
    "id_token": "YOUR_GOOGLE_ID_TOKEN_HERE"
  }'
```

### 2. Test in Flutter App

```dart
// In your Flutter widget or provider
final authProvider = ref.watch(authStateProvider);

// Create button
ElevatedButton(
  onPressed: () {
    // Trigger Google Sign-In
    ref.read(authStateProvider.notifier).googleSignIn();
  },
  child: Text('Sign In with Google'),
)

// Watch for result
authProvider.whenData((user) {
  if (user != null) {
    print('Signed in: ${user.email}');
    // Navigate to dashboard
  }
});

authProvider.whenError((error, stack) {
  print('Error: $error');
  // Show error message
});
```

### 3. Debug Google Sign-In Errors

For detailed debugging, enable verbose logging:

```dart
// In main.dart or before googleSignIn.signIn()
GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
);

// Enable debug logging
import 'package:google_sign_in/google_sign_in.dart';

googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
  print('Google user changed: ${account?.email}');
});
```

---

## 📊 State Diagrams

### Authentication State Flow

```
                     ┌─────────────┐
                     │   NO USER   │ (Initial state)
                     └──────┬──────┘
                            │
                            │ User taps "Sign in with Google"
                            ↓
                     ┌─────────────────┐
                     │   LOADING...    │ (Waiting for user input & API)
                     └────────┬────────┘
                              │
                  ┌───────────┴───────────┐
                  │                       │
         Success  │                       │ Error
                  ↓                       ↓
         ┌──────────────────┐    ┌──────────────┐
         │   AUTHENTICATED  │    │     ERROR    │
         │  (User + Tokens) │    │  (Message)   │
         └────────┬─────────┘    └──────────────┘
                  │                      │
                  │ (Can make API calls)  │
                  │                       │ Retry or back to NO USER
                  ↓
           (User navigates to Dashboard)
```

### Token Lifecycle

```
Backend Issues         Duration         Flutter Uses
Token Birth ─────────────────────────────► Added to Authorization header
  5 minutes pass ──────────────────────────► Token expires
Can't use expired ──────────────────────────► Automatic refresh triggered
  Gets new token ───────────────────────────► Uses new access token
  7 days pass ───────────────────────────────► Refresh token expires
User signed out ───────────────────────────► Must sign in again
```

---

## 🚀 Production Checklist

Before deploying to production:

- [ ] Firebase project is production-ready
- [ ] Separate Firebase project for production (not dev)
- [ ] Google OAuth consent screen configured
- [ ] Production Google Client IDs created
- [ ] Android: Use production signing key SHA-1
- [ ] iOS: Use production Team ID and Bundle ID
- [ ] Backend: Update ALLOWED_HOSTS with production domain
- [ ] Backend: Update CORS settings for production domain
- [ ] Backend: Set DEBUG=False
- [ ] Backend: Use strong SECRET_KEY
- [ ] Backend: HTTPS enabled
- [ ] Update all configuration files (google-services.json, plist, etc.)
- [ ] Test complete flow on actual devices
- [ ] Monitor error logs in Cloud Logging

---

## 📚 Related Documentation

- [Backend Google Sign-In Setup](../GOOGLE_SIGNIN_INTEGRATION.md)
- [Firebase Setup Guide](./FIREBASE_GOOGLE_SIGNIN_SETUP.md)
- [Original Implementation Status](./GOOGLE_SIGNIN_IMPLEMENTATION_STATUS.md)

---

## ❓ FAQ

**Q: What if user cancels Google Sign-In?**
A: The sign-in process completes without error, and the app remains in the same state. No authentication happens.

**Q: Can user sign in with both OTP and Google?**
A: Yes! If a user registers with OTP then signs in with Google using the same email, the account is automatically linked.

**Q: What happens if Google token is invalid?**
A: Backend returns 401 error. Frontend shows error message. User can try again or use OTP.

**Q: How to test without Firebase credentials?**
A: Use emulator/simulator with dummy tokens (won't verify but helps test UI flow).

**Q: Do I need separate credentials for dev and production?**
A: Yes! Create separate Google OAuth client IDs for dev and production.

**Q: How long are tokens valid?**
A: Access token: 5 minutes. Refresh token: 7 days. After expiration, user must sign in again.

---

**Happy coding!** If you have questions, refer to the troubleshooting section in [FIREBASE_GOOGLE_SIGNIN_SETUP.md](./FIREBASE_GOOGLE_SIGNIN_SETUP.md).
