# Firebase Push Notifications Setup Guide

This guide walks you through setting up Firebase Cloud Messaging (FCM) for push notifications in the Tithi Gadhi Flutter app.

## Overview of Implementation

The following components have been added:

1. **FCM Service** (`lib/core/services/fcm_service.dart`)
   - Initializes Firebase Cloud Messaging
   - Manages FCM tokens
   - Handles foreground, background, and notification-tap scenarios
   - Subscribes/unsubscribes from notification topics

2. **Push Notification Service** (`lib/core/services/push_notification_service.dart`)
   - Registers device with your backend
   - Sends FCM token to backend during authentication
   - Updates token when it refreshes
   - Unregisters device on logout

3. **Main App Initialization** (`lib/main.dart`)
   - FCM is automatically initialized when app launches

## Backend API Endpoints

Your backend needs to implement these endpoints to support push notifications:

### 1. Register Device
```
POST /auth/register-device
Content-Type: application/json

Request Body:
{
  "idToken": "<Firebase ID token>",
  "fcmToken": "fcm:APA91b...",
  "deviceId": "flutter-device-12345",
  "deviceName": "Pixel 8 Pro" (optional)
}

Response (200 OK):
{
  "status": "success",
  "message": "Device registered successfully"
}
```

### 2. Update FCM Token (when token refreshes)
```
POST /auth/update-fcm-token
Content-Type: application/json

Request Body:
{
  "idToken": "<Firebase ID token>",
  "fcmToken": "fcm:APA91b..."
}

Response (200 OK):
{
  "status": "success",
  "message": "FCM token updated"
}
```

### 3. Unregister Device (on logout)
```
POST /auth/unregister-device
Content-Type: application/json

Request Body:
{
  "idToken": "<Firebase ID token>"
}

Response (200 OK):
{
  "status": "success",
  "message": "Device unregistered"
}
```

## Firebase Console Setup

### Step 1: Create/Select Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project or select existing one: "Tithi Gadhi"
3. Enable Firebase Cloud Messaging

### Step 2: Download Service Accounts
1. Go to **Project Settings** → **Service Accounts**
2. Click **Generate New Private Key**
3. Save this for sending notifications from your backend

## Android Setup

### Step 1: Configure google-services.json
1. In Firebase Console, go to **Project Settings** → **Your apps** → Select Android app
2. Click **google-services.json** download button
3. Place the file in: `android/app/google-services.json`

### Step 2: Update Android Build Files

**android/build.gradle:**
```gradle
buildscript {
  dependencies {
    // Add this line if not present
    classpath 'com.google.gms:google-services:4.3.15'
  }
}
```

**android/app/build.gradle:**
```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    id "com.google.gms.google-services"  // Add this line
}

android {
    // ... existing config ...
    
    targetSdkVersion 34  // Ensure this is 33 or higher
}
```

### Step 3: Configure AndroidManifest.xml

**android/app/src/main/AndroidManifest.xml:**
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    
    <application>
        <!-- ... existing config ... -->
        
        <!-- Firebase notification config -->
        <service
            android:name=".firebase.MyFirebaseMessagingService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.firebase.MESSAGING_EVENT" />
            </intent-filter>
        </service>
    </application>
</manifest>
```

### Step 4: Request Notification Permission (Runtime)
The FCM Service automatically requests notification permissions on Android 13+.

## iOS Setup

### Step 1: Configure google-services.plist
1. In Firebase Console, go to **Project Settings** → **Your apps** → Select iOS app
2. Click **GoogleService-Info.plist** download button
3. In Xcode:
   - Right-click on `ios/Runner` folder
   - Select **Add Files to "Runner"**
   - Select the downloaded `GoogleService-Info.plist`
   - Check **Copy items if needed** and target **Runner**

### Step 2: Configure iOS Capabilities
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner** target
3. Go to **Signing & Capabilities**
4. Click **+ Capability** and add:
   - **Push Notifications**
   - **Background Modes** → Check:
     - Remote notifications
     - Background processing

### Step 3: Configure APNs Certificate
1. Go to Apple Developer Portal → Certificates, Identifiers & Profiles
2. Create/select APNs certificate for your app
3. In Firebase Console:
   - Go to **Project Settings** → **Cloud Messaging**
   - Upload the APNs certificate in **Apple Development Certificate** section

### Step 4: Update Info.plist
**ios/Runner/Info.plist:**
```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
```

Note: We set this to `false` because flutter_local_notifications might handle it differently.

## Integrating with Auth Flow

### When User Signs In

After successful Firebase authentication, send FCM token to backend:

```dart
// In your auth/login service
import 'package:tithi_gadhi/core/services/fcm_service.dart';
import 'package:tithi_gadhi/core/services/push_notification_service.dart';
import 'get_it/get_it.dart';

Future<void> signInWithGoogle() async {
  // ... existing sign in logic ...
  
  final fcmToken = FcmService().fcmToken;
  final pushNotificationService = getIt<PushNotificationService>();
  
  // Register device with backend
  await pushNotificationService.registerDeviceWithBackend(
    idToken: idToken,
    fcmToken: fcmToken,
    deviceName: 'Mobile Device',
  );
  
  // Subscribe to user-specific notifications
  await pushNotificationService.subscribeToUserNotifications(userId);
}
```

### When User Signs Out

Cleanup device registration:

```dart
// In your logout service
Future<void> logout() async {
  final fcmService = FcmService();
  final pushNotificationService = getIt<PushNotificationService>();
  
  // Unregister device
  await pushNotificationService.unregisterDeviceFromBackend(
    idToken: idToken,
  );
  
  // Delete FCM token
  await fcmService.deleteToken();
  
  // ... rest of logout logic ...
}
```

## Sending Test Notifications from Firebase Console

1. Go to Firebase Console → **Messaging**
2. Click **Create your first campaign** or **New campaign**
3. Select **Firebase Notification messages**
4. Add:
   - **Title**: "Test Notification"
   - **Body**: "This is a test push notification"
5. Click **Send test message**
6. Select or paste your FCM token
7. Click **Test** - notification should appear on your device

## Handling Notifications in App

### Foreground Messages
When app is in foreground, `FcmService._handleForegroundMessage()` is called.
You can show a local notification or update UI.

### Background Messages
When app is in background but running, `FcmService._handleMessageOpenedApp()` is called
when user taps the notification.

### Notification Tapped (App Closed)
The `getInitialMessage()` check ensures you handle notifications
when app is launched from a notification tap.

### Custom Message Handling

To customize how notifications are handled, edit `_handleForegroundMessage()` 
and `_navigateToScreen()` in `lib/core/services/fcm_service.dart`:

```dart
void _handleForegroundMessage(RemoteMessage message) {
  final data = message.data;
  
  if (data.containsKey('action')) {
    String action = data['action'];
    if (action == 'open_panchang') {
      // Navigate to panchang screen
      navigatorKey.currentState?.pushNamed('/panchang');
    }
  }
}
```

## Notification Payload Examples

### Simple Notification
```json
{
  "notification": {
    "title": "Tithi Update",
    "body": "Today's Tithi has changed"
  }
}
```

### Notification with Data
```json
{
  "notification": {
    "title": "Festival Alert",
    "body": "Diwali celebration starts today"
  },
  "data": {
    "action": "open_festival",
    "festivalId": "123"
  }
}
```

### Data-Only Message (Processed in Background)
```json
{
  "data": {
    "action": "sync_data",
    "type": "panchang"
  }
}
```

## Testing Checklist

- [ ] Android build succeeds with `flutter build apk`
- [ ] iOS build succeeds with `flutter build ios`
- [ ] FCM token is printed in console on app launch
- [ ] Can send test notification from Firebase Console
- [ ] Notification appears when app is in foreground
- [ ] Notification appears when app is in background
- [ ] Tapping notification opens app correctly
- [ ] FCM token is sent to backend on login
- [ ] Device is unregistered on logout
- [ ] Token refresh works (wait 1 hour or use Firebase console to delete token)

## Troubleshooting

### Token is null
- Ensure google-services.json (Android) or GoogleService-Info.plist (iOS) is properly added
- Check that internet permission is granted
- On iOS, ensure APNs certificate is uploaded to Firebase

### Notifications not appearing
- Check that permissions are granted (run `adb shell pm grant ...` on Android)
- Verify notification payload is valid JSON
- Check Firebase Console → Messaging for failed notifications
- On iOS, ensure app is in app bundle ID is correct in notification target

### Build fails
- Run `flutter clean` and `flutter pub get`
- Ensure all required SDKs are installed: `flutter doctor`
- On Android: `./gradlew clean` in android directory
- On iOS: `rm -rf ios/Pods ios/Podfile.lock` then `flutter pub get`

## Production Considerations

1. **Token Storage**: Never store FCM tokens in plaintext. Use secure storage.
2. **Token Rotation**: Implement logic to refresh tokens periodically
3. **Error Handling**: Wrap all FCM calls in try-catch
4. **Analytics**: Track notification delivery and user engagement
5. **Opt-in**: Consider allowing users to enable/disable notifications
6. **Rate Limiting**: Implement rate limiting on backend for notification sends

## Next Steps

1. Configure Firebase Console and get google-services.json / GoogleService-Info.plist
2. Update Android and iOS configuration files as per setup instructions
3. Implement backend endpoints for device registration
4. Add calls to `PushNotificationService` in your auth flow
5. Test with Firebase Console's test notification feature
6. Deploy and monitor notification delivery

## Support Files

- [Firebase Documentation](https://firebase.google.com/docs/messaging)
- [FlutterFire Firebase Messaging](https://pub.dev/packages/firebase_messaging)
- [Firebase Cloud Messaging Protocol](https://firebase.google.com/docs/cloud-messaging/concept-options)
