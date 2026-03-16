# Web Google Sign-In Configuration Guide

## Error You're Seeing

```
Error: Exception: Google Sign-In error: Assertion failed
"ClientID not set. Either set it on a <meta name=\"google-signin-client_id\"
content=\"CLIENT_ID\" /> tag, or pass clientId when initializing GoogleSignIn"
```

## What Happened

You tried to run the Flutter app on **web platform**, but the Web Client ID wasn't configured.

## Quick Fix (2 minutes)

### Option 1: Update web/index.html (Easiest)

**File:** `web/index.html`

Replace:

```html
<meta
  name="google-signin-client_id"
  content="YOUR_WEB_CLIENT_ID.apps.googleusercontent.com"
/>
```

With your actual Web Client ID:

```html
<meta
  name="google-signin-client_id"
  content="123456789-abcdefghijklmnop.apps.googleusercontent.com"
/>
```

### Option 2: Update google_sign_in_service.dart

**File:** `lib/features/auth/data/datasources/google_sign_in_service.dart`

Replace:

```dart
static const String _webClientId =
    'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
```

With your actual Web Client ID:

```dart
static const String _webClientId =
    '123456789-abcdefghijklmnop.apps.googleusercontent.com';
```

**Recommended:** Use Option 1 (web/index.html) - it's the standard way.

---

## How to Get Your Web Client ID

### Step 1: Go to Google Cloud Console

Visit: https://console.cloud.google.com

### Step 2: Select Your Project

- Click on the project dropdown at the top
- Select your Firebase project

### Step 3: Create OAuth 2.0 Credentials (If Not Done)

1. Go to **Credentials** in the left sidebar
2. Click **Create Credentials**
3. Select **OAuth client ID**
4. Choose **Web application**
5. Add authorized JavaScript origins:
   ```
   http://localhost:3000
   http://localhost:5000
   http://localhost:8080
   https://yourdomain.com (for production)
   ```
6. Add authorized redirect URIs:
   ```
   http://localhost:3000/callback
   http://localhost:5000/callback
   http://localhost:8080/callback
   https://yourdomain.com/callback (for production)
   ```
7. Click **Create**

### Step 4: Copy the Client ID

In the popup that appears, you'll see your **Client ID**:

```
Client ID: 123456789-abcdefghijklmnop.apps.googleusercontent.com
```

Copy this value.

---

## Complete Setup Instructions

### For Web Development

1. **Get Web Client ID** from [Google Cloud Console](https://console.cloud.google.com)

2. **Update `web/index.html`:**

```html
<meta
  name="google-signin-client_id"
  content="YOUR_ACTUAL_CLIENT_ID.apps.googleusercontent.com"
/>
```

3. **Run on web:**

```bash
flutter run -d chrome
```

### For Web Production

1. **Create production OAuth credentials** in Google Cloud Console
2. **Update `web/index.html`** with production Client ID
3. **Build for web:**

```bash
flutter build web --release
```

---

## Configuration Locations

### Method 1: HTML Meta Tag (Recommended)

**File:** `web/index.html`

```html
<head>
  ...
  <meta name="google-signin-client_id" content="YOUR_WEB_CLIENT_ID" />
  ...
</head>
```

**Pros:**

- ✅ Standard way
- ✅ Easy to manage
- ✅ Good for different environments
- ✅ No code changes needed

**Cons:**

- ❌ Must be set before app runs

### Method 2: Dart Code

**File:** `lib/features/auth/data/datasources/google_sign_in_service.dart`

```dart
static const String _webClientId =
    'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
```

**Pros:**

- ✅ Centralized configuration
- ✅ Can use environment variables

**Cons:**

- ❌ Requires code change
- ❌ Harder to manage multiple environments

---

## Environment-Specific Setup

### Development Environment

**Client ID from:** Google Cloud Console (Dev Project)

**Where to add:**

- `web/index.html` development version

### Production Environment

**Client ID from:** Google Cloud Console (Production Project)

**Where to add:**

- `web/index.html` production version (via build script)

### Recommended Approach

Use environment variables with code generation:

1. **Create `.env` file:**

```env
WEB_CLIENT_ID=123456789-abc...apps.googleusercontent.com
```

2. **Install `flutter_dotenv`:**

```bash
flutter pub add flutter_dotenv
```

3. **Load in `main.dart`:**

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(const App());
}
```

4. **Use in service:**

```dart
static String get _webClientId =>
    dotenv.env['WEB_CLIENT_ID'] ?? 'YOUR_WEB_CLIENT_ID';
```

---

## Testing Web Google Sign-In

### Run on Web

```bash
# Chrome (recommended)
flutter run -d chrome

# Firefox
flutter run -d firefox

# Edge
flutter run -d edge

# Safari
flutter run -d safari
```

### Test the Flow

1. Click "Sign in with Google" button
2. Google sign-in dialog should open
3. Complete Google authentication
4. Check app logs for token
5. Verify user is authenticated

### Debugging

Enable web debugging:

```bash
flutter run -d chrome --profile
```

Check browser console for errors:

- Open Chrome DevTools (F12)
- Check Console tab
- Look for "google_sign_in" related errors

---

## Common Issues & Solutions

### Issue 1: "ClientID not set"

**Cause:** Client ID not configured in `web/index.html` or code

**Solution:**

1. Get Web Client ID from Google Cloud Console
2. Add to `web/index.html`:
   ```html
   <meta name="google-signin-client_id" content="YOUR_CLIENT_ID" />
   ```
3. Refresh browser/restart app

### Issue 2: "Origin mismatch"

**Cause:** App running on different URL than registered

**Solution:**

1. Go to Google Cloud Console > Credentials
2. Edit OAuth client
3. Add your current URL to "Authorized JavaScript origins":
   - http://localhost:3000 (default Flutter web)
   - http://localhost:5000
   - http://localhost:8080
   - https://yourdomain.com (production)

### Issue 3: "Redirect URI mismatch"

**Cause:** Callback URL not matching

**Solution:**

1. Add to "Authorized redirect URIs":
   - http://localhost:3000/callback
   - http://localhost:5000/callback
   - https://yourdomain.com/callback

### Issue 4: "Invalid Client ID format"

**Cause:** Wrong Client ID type (copied API key instead of OAuth Client ID)

**Solution:**

1. Go to Google Cloud Console > Credentials
2. Look for OAuth 2.0 Client ID (with green check mark)
3. Must end with `.apps.googleusercontent.com`
4. Copy the **Client ID** field

### Issue 5: CORS Errors

**Cause:** Browser blocking cross-origin requests

**Solution:**

1. Use proper HTTPS in production
2. Configure CORS headers in backend
3. Check Django CORS settings:
   ```python
   CORS_ALLOWED_ORIGINS = [
       "http://localhost:3000",
       "https://yourdomain.com",
   ]
   ```

---

## File Changes Summary

### ✅ `web/index.html` (Updated)

Added Google Sign-In meta tag with placeholder:

```html
<meta
  name="google-signin-client_id"
  content="YOUR_WEB_CLIENT_ID.apps.googleusercontent.com"
/>
```

**Your action:** Replace `YOUR_WEB_CLIENT_ID` with your actual Web Client ID

### ✅ `lib/features/auth/data/datasources/google_sign_in_service.dart` (Updated)

Added Web Client ID support:

```dart
static const String _webClientId =
    'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
```

**Note:** Also update this OR use the `web/index.html` approach (recommended)

---

## Platform Comparison

| Platform    | Configuration            | Location       | Status        |
| ----------- | ------------------------ | -------------- | ------------- |
| **Android** | google-services.json     | android/app/   | ✅ Configured |
| **iOS**     | GoogleService-Info.plist | ios/Runner/    | ✅ Configured |
| **Web**     | Web Client ID            | web/index.html | ✅ Now Fixed  |

---

## Next Steps

1. **Get Web Client ID** from [Google Cloud Console](https://console.cloud.google.com)
2. **Update `web/index.html`** with your Client ID
3. **Run:** `flutter run -d chrome`
4. **Test:** Click Google Sign-In button
5. **Debug:** Check browser console if issues

---

## Useful Links

- [Google Cloud Console](https://console.cloud.google.com)
- [Create OAuth 2.0 Credentials](https://console.cloud.google.com/apis/credentials)
- [Flutter Web Docs](https://docs.flutter.dev/platform-integration/web)
- [Google Sign-In Web Plugin](https://pub.dev/packages/google_sign_in_web)

---

## Summary

**Error Cause:** Web Client ID not set

**Fix:** Add to `web/index.html`:

```html
<meta name="google-signin-client_id" content="YOUR_WEB_CLIENT_ID" />
```

**Time to fix:** ~2 minutes

**Then run:** `flutter run -d chrome`

---

**Done!** Your web app should now support Google Sign-In. 🎉
