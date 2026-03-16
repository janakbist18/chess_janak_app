# Firebase & Google Sign-In Complete Setup Guide

## 🚀 Quick Overview

This guide will fix the **"UnimplementedError: Google Sign-In"** by setting up Firebase and Google Sign-In properly across all platforms (Android, iOS, Web).

### Error You Were Seeing

```
Error: UnimplementedError: Google Sign-In: Complete integration with google_sign_in package
```

### Why This Happens

The error occurs because:

1. Firebase configuration files are missing (google-services.json for Android)
2. Gradle plugins aren't properly configured
3. Platform-specific setup hasn't been completed

---

## 📋 Step-by-Step Setup

### STEP 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **"Add project"** or select existing project
3. Project Name: `chess-janak` (or your choice)
4. Click **Create**
5. Wait for project to initialize

---

### STEP 2: Register Android App in Firebase

1. In Firebase Console, click **⚙️ Settings** > **Project Settings**
2. Click **"Add app"** button
3. Select **Android**
4. Fill in app details:
   - **Package name**: `com.example.chess_janak_app`
   - **App nickname**: `Chess Janak Android`
   - **Debug signing certificate SHA-1**: See STEP 3 below
5. Click **Register app**

#### Getting SHA-1 Certificate Fingerprint

Run this command to get your debug certificate's SHA-1:

```bash
# Windows (PowerShell)
cd android
./gradlew signingReport

# macOS/Linux
cd android
./gradlew signingReport
```

Look for output like:

```
Variant: debug
Config: debug
  SHA1: AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12
```

Copy the SHA1 value (without colons) when registering the app.

---

### STEP 3: Download google-services.json

1. In Firebase Console, on the Android app page
2. Click **"Download google-services.json"**
3. Move the file to: `android/app/google-services.json`

```bash
# From your project root
# Place the downloaded file here:
chess_janak_app/
└── android/
    └── app/
        └── google-services.json  # <<< Place file here
```

---

### STEP 4: Register iOS App in Firebase (Optional but Recommended)

1. In Firebase Console, click **"Add app"**
2. Select **iOS**
3. Fill in:
   - **Bundle ID**: Check in `ios/Runner/Info.plist` for `CFBundleIdentifier`
   - **App nickname**: `Chess Janak iOS`
   - **Team ID**: Not required for development
4. Click **Register app**

---

### STEP 5: Download GoogleService-Info.plist (iOS)

1. Click **"Download GoogleService-Info.plist"**
2. Open Xcode: `open ios/Runner.xcworkspace`
3. In Xcode, drag **GoogleService-Info.plist** to **Runner** folder
4. Check **"Copy items if needed"** and **"Runner"** target
5. Click **Add**

```
ios/
└── Runner/
    ├── Runner/
    │   └── GoogleService-Info.plist  # << Add here
    └── Runner.xcworkspace/
```

---

### STEP 6: Update Android Build Configuration

The files have been automatically updated with Google Services plugin:

**File: `android/build.gradle.kts`** (Root level)

- Added: `id("com.google.gms.google-services") version "4.4.0" apply false`

**File: `android/app/build.gradle.kts`** (App level)

- Added: `id("com.google.gms.google-services")`

✅ **These are already done!** No manual updates needed.

---

### STEP 7: Create OAuth 2.0 Web Client ID

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select your Firebase project
3. Go to **Credentials** in the left menu
4. Click **Create Credentials** > **OAuth client ID**
5. Choose **Web application**
6. Add authorized JavaScript origins:
   ```
   http://localhost:3000
   http://localhost:8080
   https://yourdomain.com
   ```
7. Add authorized redirect URIs:
   ```
   http://localhost:3000/callback
   http://localhost:8080/callback
   https://yourdomain.com/callback
   ```
8. Click **Create**
9. Copy the **Client ID** (you'll need this)

---

### STEP 8: Configure URL Schemes (iOS Only)

Edit `ios/Runner/Info.plist` and add Google URL schemes:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Replace with your actual Google OAuth Client ID -->
            <!-- For example: 123456789-abcdefghijklmnop.apps.googleusercontent.com -->
            <string>com.googleusercontent.apps.YOUR_APP_ID</string>
        </array>
    </dict>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>googlechrome</string>
            <string>itms-apps</string>
        </array>
    </dict>
</array>

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>googlechrome</string>
    <string>itms-apps</string>
</array>
```

---

### STEP 9: Run the App

Now everything should be configured! Run your Flutter app:

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Run on Android
flutter run --device-id=android-device-id

# Run on iOS
flutter run --device-id=iphone

# Run on Web (requires Web Client ID)
flutter run -d chrome
```

---

## 🔍 Verification Checklist

Before running the app, verify:

- [ ] `android/app/google-services.json` exists and has content
- [ ] `firebase_core` package is in `pubspec.yaml`
- [ ] `google_sign_in: ^7.2.0` is in `pubspec.yaml`
- [ ] Android build files have Google Services plugin
- [ ] Firebase project is created and active
- [ ] Android app is registered in Firebase
- [ ] `GoogleService-Info.plist` is in iOS project (if building for iOS)
- [ ] URL schemes are added to `Info.plist` (iOS)

---

## 🎯 File Locations Summary

### Android

```
android/
├── build.gradle.kts          ← Google Services plugin added
└── app/
    ├── build.gradle.kts      ← Google Services plugin added
    └── google-services.json  ← Download from Firebase & place here
```

### iOS

```
ios/
└── Runner/
    ├── GoogleService-Info.plist  ← Download from Firebase & place here
    └── Info.plist                ← Add URL schemes here
```

### Flutter Code

```
lib/features/auth/
├── data/datasources/
│   ├── google_sign_in_service.dart     ← Already configured ✅
│   └── auth_remote_datasource.dart     ← Handles API calls ✅
└── presentation/providers/
    ├── google_auth_controller.dart      ← Updated to use service ✅
    └── auth_provider.dart               ← Has Google Sign-In method ✅
```

---

## 🚨 Troubleshooting

### Error: "google-services.json not found"

**Solution:** Download from Firebase Console and place at `android/app/google-services.json`

### Error: "Plugin with id 'com.google.gms.google-services' not found"

**Solution:** Check `android/build.gradle.kts` has the plugin declaration and `android/app/build.gradle.kts` applies it

### Error: "GoogleService-Info.plist not found" (iOS)

**Solution:** Download from Firebase and add to Xcode project at `ios/Runner/GoogleService-Info.plist`

### Android Build Fails

```bash
# Try clean rebuild
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter run
```

### Error: "SHA1 certificate not registered"

**Solution:** Generate SHA1 from `./gradlew signingReport` in android folder and register in Firebase

### iOS Pod Install Fails

```bash
cd ios
rm Podfile.lock
pod install --repo-update
cd ..
flutter run
```

---

## 📱 Backend Integration

Your backend already has the Google Sign-In endpoint ready:

**Backend Endpoint:** `POST /api/auth/google_signin/`

**Request:**

```json
{
  "id_token": "google_id_token_from_flutter_app"
}
```

**Response:**

```json
{
  "message": "Google authentication successful",
  "user": {
    "id": 1,
    "email": "user@gmail.com",
    "username": "username",
    "name": "User Name",
    "is_verified": true,
    "is_google_account": true
  },
  "tokens": {
    "access": "jwt_access_token",
    "refresh": "jwt_refresh_token"
  }
}
```

See [GOOGLE_SIGNIN_INTEGRATION.md](../GOOGLE_SIGNIN_INTEGRATION.md) for backend details.

---

## 🔗 Useful Links

- [Firebase Console](https://console.firebase.google.com)
- [Google Cloud Console](https://console.cloud.google.com)
- [Flutter Google Sign-In Docs](https://pub.dev/packages/google_sign_in)
- [Firebase CLI Setup](https://firebase.google.com/docs/cli)
- [Android Signing Documentation](https://developer.android.com/studio/publish/app-signing)

---

## ✅ What's Been Done For You

1. ✅ Created `GoogleSignInService` with proper error handling
2. ✅ Updated `GoogleAuthController` to use the service
3. ✅ Added `googleSignIn()` method to `AuthNotifier`
4. ✅ Updated Android build files with Google Services plugin
5. ✅ Backend Google Sign-In endpoint is ready

## 🎬 Next Steps

1. **Create Firebase project** (if you haven't already)
2. **Register Android app** and download `google-services.json`
3. **Place `google-services.json`** in `android/app/`
4. **Run the app**: `flutter run`
5. **Test Google Sign-In** button in your app
6. **Register iOS app** (optional for iOS development)

---

## 💡 Pro Tips

- Keep your `google-services.json` and `GoogleService-Info.plist` in `.gitignore` for security
- Use separate Firebase projects for development and production
- Test on actual devices (emulator/simulator can sometimes have issues with Google Sign-In)
- Backend API must be accessible from your device (use your actual IP for emulator testing)

---

**Questions?** Check the troubleshooting section or refer to official Firebase documentation.

Happy coding! 🎉
