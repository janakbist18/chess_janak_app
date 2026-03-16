# Google Sign-In Integration Checklist

## Required Setup Tasks

### Firebase & OAuth Setup

- [ ] Firebase project created and apps registered
- [ ] OAuth 2.0 credentials created in Google Cloud Console
- [ ] Web Client ID obtained
- [ ] Android Client ID obtained (with SHA-1 fingerprint)
- [ ] iOS Client ID obtained (with Bundle ID and Team ID)

### Android Configuration

- [ ] Downloaded `google-services.json` from Firebase Console
- [ ] Placed `google-services.json` in `android/app/` directory
- [ ] Updated `android/build.gradle.kts` with Google Services plugin
- [ ] Updated `android/app/build.gradle.kts` with Google Services plugin ID
- [ ] Added Firebase dependencies to `android/app/build.gradle.kts`

### iOS Configuration

- [ ] Downloaded `GoogleService-Info.plist` from Firebase Console
- [ ] Added `GoogleService-Info.plist` to Xcode project (`ios/Runner/`)
- [ ] Updated `ios/Runner/Info.plist` with URL schemes
- [ ] Updated `Podfile` with correct iOS version and Firebase settings
- [ ] Ran `pod install --repo-update` in `ios/` directory

### Code Updates

- [ ] Updated web client ID in `lib/features/auth/data/datasources/google_sign_in_service.dart`
- [ ] Verified `auth_provider.dart` is using the `GoogleSignInService`
- [ ] Reviewed error handling and user messages

### Testing

- [ ] Ran `flutter clean`
- [ ] Ran `flutter pub get`
- [ ] Tested on Android emulator/device
- [ ] Tested on iOS simulator/device
- [ ] Verified Google Sign-In button works on login screen
- [ ] Verified authentication completes successfully

## Useful Commands

```bash
# View SHA-1 fingerprint for Android
cd android && ./gradlew signingReport && cd ..

# Clean everything
flutter clean
cd android && ./gradlew clean && cd ..
cd ios && rm -rf Pods && rm Podfile.lock && cd ..

# Fresh build
flutter pub get
cd ios && pod install --repo-update && cd ..
flutter run

# Debug Google Sign-In
adb shell setprop log.tag.GoogleSignIn DEBUG  # Android
```

## File Locations Checklist

- [ ] `android/app/google-services.json` - Configuration file for Android
- [ ] `ios/Runner/GoogleService-Info.plist` - Configuration file for iOS
- [ ] `android/build.gradle.kts` - Root-level Gradle configuration
- [ ] `android/app/build.gradle.kts` - App-level Gradle configuration
- [ ] `ios/Runner/Info.plist` - iOS app configuration
- [ ] `lib/features/auth/data/datasources/google_sign_in_service.dart` - Web Client ID

## Next Steps After This Checklist

1. Run the app: `flutter run`
2. Navigate to login screen
3. Tap "Continue with Google"
4. Complete the sign-in flow
5. Verify successful authentication

## Getting Help

If you encounter issues:

1. Read [GOOGLE_SIGNIN_SETUP.md](./GOOGLE_SIGNIN_SETUP.md) for detailed instructions
2. Check the Flutter console output for error messages
3. Review [Google Sign-In Flutter Package Docs](https://pub.dev/packages/google_sign_in)
4. Check [Firebase Documentation](https://firebase.google.com/docs)

---

**Status**: Not Started
**Last Updated**: 2026-03-15
