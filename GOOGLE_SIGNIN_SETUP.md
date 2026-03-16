# Google Sign-In Setup Guide

## Overview

Google Sign-In in Flutter requires platform-specific configuration files and OAuth 2.0 credentials. Follow these steps to complete the integration.

## Prerequisites

1. Firebase project set up in [Firebase Console](https://console.firebase.google.com)
2. Android and/or iOS apps registered in Firebase
3. OAuth 2.0 credentials created

## Step 1: Get Your OAuth 2.0 Credentials

### For Android:

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select your project
3. Navigate to **Credentials** > **Create Credentials** > **OAuth 2.0 Client ID**
4. Choose **Android**
5. You'll need your app's **package name** and **SHA-1 certificate fingerprint**

To get SHA-1 fingerprint:

```bash
# For debug keystore
cd android
./gradlew signingReport
# Look for "SHA1:" value
```

### For iOS:

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select your project
3. Create OAuth 2.0 Client ID for **iOS**
4. You'll need your app's **Bundle ID** and **Team ID**

### For Web:

1. Create OAuth 2.0 Client ID for **Web application**
2. Save the **Client ID** (Web Client ID) - you'll need this in the next step

## Step 2: Download Configuration Files

### Android - google-services.json

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to **Project Settings**
4. Click **Download google-services.json** under Android apps
5. Copy the file to: `android/app/google-services.json`

### iOS - GoogleService-Info.plist

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to **Project Settings**
4. Click **Download GoogleService-Info.plist** under iOS apps
5. Open Xcode: `open ios/Runner.xcworkspace`
6. Right-click **Runner** in Xcode > **Add Files to "Runner"**
7. Select **GoogleService-Info.plist** and check "Copy items if needed"
8. Ensure the file is added to the target **Runner**

## Step 3: Update Android Configuration

### Update android/build.gradle.kts

Add Google Services plugin (if not already present):

```kotlin
plugins {
    id("com.google.gms.google-services") version "4.4.0" apply false
}
```

### Update android/app/build.gradle.kts

Add the plugin and necessary dependencies:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // Add this
}

dependencies {
    implementation("com.google.firebase:firebase-core")
    implementation("com.google.firebase:firebase-auth")
    // Other existing dependencies...
}
```

## Step 4: Update iOS Configuration

### Update ios/Podfile

Ensure you have the minimum iOS version set (11.0 or higher):

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'FIREBASE_ANALYTICS_COLLECTION_ENABLED=1',
      ]
    end
  end
end
```

### Update ios/Runner/Info.plist

Add the following to your `Info.plist` for Google Sign-In URL schemes:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>googlechrome</string>
    <string>itms-apps</string>
</array>
```

Replace `YOUR_CLIENT_ID` with your actual Google OAuth client ID (the part before `.apps.googleusercontent.com`).

## Step 5: Update the Google Sign-In Service

### Update lib/features/auth/data/datasources/google_sign_in_service.dart

Replace the `YOUR_WEB_CLIENT_ID.apps.googleusercontent.com` with your actual Web Client ID:

```dart
String _getWebClientId() {
  // Get this from your Google OAuth 2.0 credentials
  return 'YOUR_ACTUAL_WEB_CLIENT_ID.apps.googleusercontent.com';
}
```

## Step 6: Clean and Run

```bash
# Clean previous builds
flutter clean

# Clean gradle cache (Android)
cd android && ./gradlew clean && cd ..

# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Troubleshooting

### Error: "UnimplementedError: Google Sign-In"

This means the platform configuration files are missing. Follow steps 2-5 above.

### Android: Error executing aapt

Make sure `google-services.json` is in the correct location: `android/app/google-services.json`

### iOS: Pod installation failed

```bash
cd ios
pod install --repo-update
cd ..
```

### iOS: Could not find GoogleService-Info.plist

Make sure:

1. File is added to Xcode project
2. File is added to **Runner** target (check in "Add Files" dialog)
3. File path is correct in Xcode's file tree

### Web: CORS errors in development

Use the Web OAuth Client ID in development mode.

## Testing Google Sign-In

1. Run your app: `flutter run`
2. Navigate to the Login screen
3. Tap "Continue with Google" button
4. A Google Sign-In dialog should appear
5. Select a test account and complete sign-in

## Common Issues

| Issue                              | Solution                                                  |
| ---------------------------------- | --------------------------------------------------------- |
| Google Sign-In button does nothing | Platform configuration files missing                      |
| "UnimplementedError"               | See Step 2-5 above                                        |
| SHA-1 mismatch on Android          | Regenerate SHA-1 and update in Google Cloud Console       |
| iOS app won't compile              | Run `pod install --repo-update`                           |
| Web Client ID error                | Update `_getWebClientId()` in google_sign_in_service.dart |

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Google Sign-In Flutter Package](https://pub.dev/packages/google_sign_in)
- [Google Cloud Console](https://console.cloud.google.com)
- [Firebase Console](https://console.firebase.google.com)

## Next Steps

After completing this setup, your Google Sign-In should work. If you still experience issues:

1. Check the debug console for detailed error messages
2. Verify all configuration files are in the correct locations
3. Ensure your OAuth credentials are correctly configured
4. Try testing on a different platform (Android/iOS/Web)
