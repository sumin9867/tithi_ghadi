# Push Notifications Quick Start Guide

## What's Already Done ✅

1. ✅ Added `firebase_messaging: ^16.2.0` to pubspec.yaml
2. ✅ Created `FCMService` - handles Firebase Cloud Messaging initialization and token management
3. ✅ Created `PushNotificationService` - handles communication with your backend
4. ✅ Updated `main.dart` - FCM initializes automatically on app startup
5. ✅ Added comprehensive documentation files

## What You Need To Do 📋

### 1. **Firebase Console Setup** (Priority: 🔴 Critical)

```
1. Go to https://console.firebase.google.com
2. Create or select "Tithi Gadhi" project
3. Enable Cloud Messaging
4. Generate credentials for your platforms (see steps 2 & 3 below)
```

### 2. **Android Configuration** (Priority: 🔴 Critical)

```bash
# Download google-services.json:
# Firebase Console → Project Settings → Your Apps → Android app → Download google-services.json
# Place it at: android/app/google-services.json

# Update android/build.gradle:
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.3.15'  # Add if not present
  }
}

# Update android/app/build.gradle:
# Add at the end of plugins block:
id "com.google.gms.google-services"

# Ensure targetSdkVersion is 33 or higher
targetSdkVersion 34
```

### 3. **iOS Configuration** (Priority: 🔴 Critical)

```
1. Download GoogleService-Info.plist:
   Firebase Console → Project Settings → Your Apps → iOS app → Download GoogleService-Info.plist

2. In Xcode:
   - Open ios/Runner.xcworkspace (NOT .xcodeproj)
   - Right-click on Runner folder
   - Select "Add Files to Runner"
   - Select GoogleService-Info.plist
   - Check "Copy items if needed" and target "Runner"

3. Add Capabilities:
   - Select Runner target
   - Go to Signing & Capabilities
   - Click "+ Capability" and add:
     ✓ Push Notifications
     ✓ Background Modes → Remote notifications

4. Upload APNs Certificate to Firebase:
   - Get APNs certificate from Apple Developer Portal
   - Firebase Console → Project Settings → Cloud Messaging
   - Upload certificate in "Apple Development Certificate" section
```

### 4. **Backend API Implementation** (Priority: 🔴 Critical)

Implement these three endpoints in your backend:

```
POST /auth/register-device
  - Called when user logs in
  - Receives: idToken, fcmToken, deviceId, deviceName
  - Stores mapping: userId → fcmToken

POST /auth/update-fcm-token
  - Called when FCM token refreshes
  - Updates the fcmToken for the user

POST /auth/unregister-device
  - Called when user logs out
  - Removes the device from your system
```

See `FIREBASE_PUSH_NOTIFICATIONS_SETUP.md` for exact endpoint specifications.

### 5. **Integrate with Your Auth Flow** (Priority: 🟡 Important)

In your authentication service/cubit, add calls to `PushNotificationService`:

**After successful login:**
```dart
final fcmToken = FcmService().fcmToken;
await pushNotificationService.registerDeviceWithBackend(
  idToken: idToken,
  fcmToken: fcmToken,
);
await pushNotificationService.subscribeToUserNotifications(userId);
```

**On logout:**
```dart
await pushNotificationService.unregisterDeviceFromBackend(idToken: idToken);
await pushNotificationService.unsubscribeFromUserNotifications(userId);
await FcmService().deleteToken();
```

See `lib/core/services/auth_with_push_notifications_example.dart` for complete example.

### 6. **Update Service Endpoints** (Priority: 🟡 Important)

In `lib/core/services/push_notification_service.dart`, update the endpoint paths to match your backend:

```dart
// Line 28: Change /auth/register-device to your actual endpoint
// Line 47: Change /auth/update-fcm-token to your actual endpoint
// Line 66: Change /auth/unregister-device to your actual endpoint
```

### 7. **Test Everything** (Priority: 🟢 Can Test Now)

```bash
# 1. Build and run on Android
flutter run

# 2. Build and run on iOS
flutter run -d ios

# 3. Check console for FCM token:
   # Should see: "FCM Token: fcm:APA91b..."

# 4. Send test notification from Firebase Console:
   - Firebase Console → Messaging → Create campaign
   - Select "Firebase Notification messages"
   - Add title and body
   - Click "Send test message"
   - Paste your FCM token
   - Click "Test"
   - Notification should appear on device
```

## File Structure

```
lib/
├── core/
│   └── services/
│       ├── fcm_service.dart                              ✅ Created
│       ├── push_notification_service.dart                ✅ Created
│       └── auth_with_push_notifications_example.dart     ✅ Created (reference)
└── main.dart                                              ✅ Updated

FIREBASE_PUSH_NOTIFICATIONS_SETUP.md                       ✅ Complete guide
PUSH_NOTIFICATIONS_QUICK_START.md                          ✅ This file
```

## Key Classes

### FcmService
- **Location**: `lib/core/services/fcm_service.dart`
- **Purpose**: Manages Firebase Cloud Messaging
- **Usage**: 
  ```dart
  FcmService().initialize();  // Auto-called in main.dart
  String? token = FcmService().fcmToken;  // Get token
  await FcmService().deleteToken();  // Clean up on logout
  ```

### PushNotificationService
- **Location**: `lib/core/services/push_notification_service.dart`
- **Purpose**: Communicate with backend about device registration
- **Usage**:
  ```dart
  final service = PushNotificationService(dioClient);
  await service.registerDeviceWithBackend(idToken: token, fcmToken: fcm);
  await service.subscribeToUserNotifications(userId);
  ```

## Common Issues & Solutions

### "FCM Token is null"
- ❌ Missing google-services.json (Android)
- ❌ Missing GoogleService-Info.plist (iOS)
- ❌ Internet permission not granted
- ✅ Solution: Re-download and add the config files

### "Notifications not appearing"
- ❌ Backend endpoint not implemented
- ❌ Permissions not granted (Android)
- ❌ APNs certificate not uploaded (iOS)
- ✅ Solution: Follow the setup steps above

### "Build fails"
```bash
# Try these:
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..  # Android
rm -rf ios/Pods ios/Podfile.lock && flutter pub get  # iOS
```

## Next Steps

1. ☐ Download google-services.json and GoogleService-Info.plist from Firebase Console
2. ☐ Add configuration files to Android and iOS projects
3. ☐ Update Android and iOS build files
4. ☐ Implement backend API endpoints
5. ☐ Integrate PushNotificationService into auth flow
6. ☐ Run and test on both platforms
7. ☐ Send test notification from Firebase Console
8. ☐ Monitor notification delivery in Firebase Console

## Useful Links

- 📚 [Complete Setup Guide](FIREBASE_PUSH_NOTIFICATIONS_SETUP.md)
- 📝 [Firebase Messaging Docs](https://firebase.google.com/docs/messaging)
- 🔧 [firebase_messaging Package](https://pub.dev/packages/firebase_messaging)
- 🎯 [Firebase Console](https://console.firebase.google.com)
- 🍎 [Apple Developer Portal](https://developer.apple.com)

## Support

If you run into issues:

1. Check the [Complete Setup Guide](FIREBASE_PUSH_NOTIFICATIONS_SETUP.md)
2. Review the [example integration](lib/core/services/auth_with_push_notifications_example.dart)
3. Check Firebase Console → Messaging → Sent messages for delivery logs
4. Verify all config files are properly placed and formatted

---

**Status**: ✅ Ready for integration with backend and platform-specific setup
