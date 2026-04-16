# Push Notifications Implementation Checklist

Use this checklist to track your progress through the setup process.

---

## Phase 1: Understanding & Planning
- [ ] Read `PUSH_NOTIFICATIONS_QUICK_START.md` 
- [ ] Read `FIREBASE_PUSH_NOTIFICATIONS_SETUP.md`
- [ ] Understand the 3 main services created
- [ ] Review `lib/core/services/auth_with_push_notifications_example.dart`

**Time estimate**: 30 minutes | **Difficulty**: 🟢 Easy

---

## Phase 2: Firebase Console Setup

### Create Firebase Project
- [ ] Go to https://console.firebase.google.com
- [ ] Create new project or select "Tithi Gadhi"
- [ ] Enable Cloud Messaging
- [ ] Enable Cloud Firestore (optional, for advanced features)

### Download Android Configuration
- [ ] Navigate to Project Settings
- [ ] Go to "Your apps" section
- [ ] Click on Android app
- [ ] Download `google-services.json`
- [ ] Save file (don't lose it!)

### Download iOS Configuration  
- [ ] Navigate to Project Settings
- [ ] Go to "Your apps" section
- [ ] Click on iOS app
- [ ] Download `GoogleService-Info.plist`
- [ ] Save file (don't lose it!)

**Time estimate**: 15 minutes | **Difficulty**: 🟢 Easy

---

## Phase 3: Android Configuration

### Add Configuration File
- [ ] Place `google-services.json` in `android/app/`
- [ ] Verify it's in the right location
- [ ] Don't commit this file to git if it contains secrets

### Update `android/build.gradle`
```gradle
buildscript {
  dependencies {
    // Add this line
    classpath 'com.google.gms:google-services:4.3.15'
  }
}
```
- [ ] Added Google services classpath

### Update `android/app/build.gradle`
```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    id "com.google.gms.google-services"  // Add this
}

android {
    // Ensure targetSdkVersion is 33+
    targetSdkVersion 34
}
```
- [ ] Added google-services plugin to plugins block
- [ ] Verified targetSdkVersion is 33 or higher

### Update `android/app/src/main/AndroidManifest.xml`
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <!-- Rest of manifest... -->
</manifest>
```
- [ ] Added POST_NOTIFICATIONS permission

### Build & Test Android
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter build apk
```
- [ ] Android build succeeds without errors
- [ ] APK can be generated

**Time estimate**: 30 minutes | **Difficulty**: 🟡 Medium

---

## Phase 4: iOS Configuration

### Add Configuration File in Xcode
- [ ] Open `ios/Runner.xcworkspace` (NOT .xcodeproj)
- [ ] Right-click on Runner folder
- [ ] Select "Add Files to Runner"
- [ ] Select `GoogleService-Info.plist`
- [ ] Check "Copy items if needed"
- [ ] Verify file appears in Xcode navigator

### Add Push Notifications Capability
- [ ] Select Runner target in Xcode
- [ ] Go to "Signing & Capabilities"
- [ ] Click "+ Capability"
- [ ] Search for "Push Notifications"
- [ ] Add it to the target

### Add Background Modes Capability
- [ ] Click "+ Capability"
- [ ] Search for "Background Modes"
- [ ] Add it to the target
- [ ] Check "Remote notifications"
- [ ] Check "Background processing"

### Upload APNs Certificate
- [ ] Go to Apple Developer Portal
- [ ] Create or select APNs certificate for your app
- [ ] In Firebase Console:
  - [ ] Go to Project Settings
  - [ ] Click Cloud Messaging tab
  - [ ] Upload APNs certificate under "Apple Development Certificate"

### Build & Test iOS
```bash
flutter clean
flutter pub get
cd ios && rm -rf Pods Podfile.lock && cd ..
flutter build ios
```
- [ ] iOS build succeeds without errors
- [ ] Can open Runner.xcworkspace in Xcode

**Time estimate**: 45 minutes | **Difficulty**: 🔴 Hard

---

## Phase 5: Backend Implementation

### Review Specification
- [ ] Read `BACKEND_API_SPECIFICATION.md`
- [ ] Understand the 3 required endpoints
- [ ] Review database schema examples

### Implement `/auth/register-device` Endpoint
```
POST /auth/register-device
- Receives: idToken, fcmToken, deviceId, deviceName
- Stores: user → fcmToken mapping
- Returns: 200 OK or error
```
- [ ] Endpoint created
- [ ] Validates Firebase ID token
- [ ] Stores FCM token in database
- [ ] Returns proper response format
- [ ] Error handling implemented
- [ ] Tested with cURL/Postman

### Implement `/auth/update-fcm-token` Endpoint
```
POST /auth/update-fcm-token
- Receives: idToken, fcmToken (new)
- Updates: user's fcmToken in database
- Returns: 200 OK or error
```
- [ ] Endpoint created
- [ ] Validates Firebase ID token
- [ ] Updates FCM token in database
- [ ] Returns proper response format
- [ ] Error handling implemented
- [ ] Tested with cURL/Postman

### Implement `/auth/unregister-device` Endpoint
```
POST /auth/unregister-device
- Receives: idToken
- Action: Mark device as inactive (or delete)
- Returns: 200 OK or error
```
- [ ] Endpoint created
- [ ] Validates Firebase ID token
- [ ] Removes/marks device as inactive
- [ ] Returns proper response format
- [ ] Error handling implemented
- [ ] Tested with cURL/Postman

### Database Setup
- [ ] Create devices collection/table
- [ ] Add indexes for fast lookups
- [ ] Verify schema matches specification

### Test Endpoints
```bash
# Example with cURL
curl -X POST http://localhost:5000/auth/register-device \
  -H "Content-Type: application/json" \
  -d '{"idToken":"...", "fcmToken":"..."}'
```
- [ ] Can register device
- [ ] Can update token
- [ ] Can unregister device
- [ ] All endpoints return correct format
- [ ] Error cases handled properly

**Time estimate**: 2-3 hours | **Difficulty**: 🔴 Hard

---

## Phase 6: App Integration

### Update Service Endpoints
In `lib/core/services/push_notification_service.dart`:
- [ ] Update `/auth/register-device` endpoint path (line 28)
- [ ] Update `/auth/update-fcm-token` endpoint path (line 47)
- [ ] Update `/auth/unregister-device` endpoint path (line 66)

### Integrate with Auth Service
In your auth service/cubit:
```dart
// On login success
final fcmToken = FcmService().fcmToken;
await pushNotificationService.registerDeviceWithBackend(
  idToken: idToken,
  fcmToken: fcmToken,
);
await pushNotificationService.subscribeToUserNotifications(userId);

// On logout
await pushNotificationService.unregisterDeviceFromBackend(idToken: idToken);
await pushNotificationService.unsubscribeFromUserNotifications(userId);
await FcmService().deleteToken();
```
- [ ] Added registration call after login
- [ ] Added subscription call after login
- [ ] Added unregistration call on logout
- [ ] Added unsubscription call on logout
- [ ] Added token cleanup on logout

### Test Integration
```bash
flutter run
```
- [ ] App builds successfully
- [ ] No compile errors
- [ ] No runtime errors in console
- [ ] FCM token prints on startup: "FCM Token: fcm:APA91b..."

**Time estimate**: 45 minutes | **Difficulty**: 🟡 Medium

---

## Phase 7: Testing

### Manual Testing on Android
```bash
flutter run -d <android-device-id>
```
- [ ] App launches without errors
- [ ] FCM token appears in console
- [ ] User can login
- [ ] Device registers with backend (check backend logs)
- [ ] Can send test notification from Firebase Console
- [ ] Notification appears when app is in foreground
- [ ] Notification appears when app is in background
- [ ] Can tap notification to open app
- [ ] User can logout
- [ ] Device unregisters from backend (check backend logs)

### Manual Testing on iOS
```bash
flutter run -d <ios-device-id>
```
- [ ] App launches without errors
- [ ] FCM token appears in console
- [ ] User can login
- [ ] Device registers with backend (check backend logs)
- [ ] Can send test notification from Firebase Console
- [ ] Notification appears when app is in foreground
- [ ] Notification appears when app is in background
- [ ] Can tap notification to open app
- [ ] User can logout
- [ ] Device unregisters from backend (check backend logs)

### Firebase Console Testing
- [ ] Go to Firebase Console → Messaging
- [ ] Create test message
- [ ] Add your FCM token
- [ ] Send test message
- [ ] Verify notification appears on device

### Backend Testing
```bash
# Check database
# Verify user → fcmToken mapping exists after login
# Verify device is marked inactive after logout
```
- [ ] Device appears in database after login
- [ ] Device removed/marked inactive after logout
- [ ] Multiple devices can be registered per user
- [ ] Token updates work correctly

**Time estimate**: 1 hour | **Difficulty**: 🟡 Medium

---

## Phase 8: Production Preparation

### Code Review
- [ ] Code follows app's style guidelines
- [ ] No hardcoded secrets or API keys
- [ ] Error handling is comprehensive
- [ ] Logging doesn't include sensitive data

### Security Review
- [ ] FCM tokens stored securely
- [ ] ID tokens validated on backend
- [ ] All endpoints require authentication
- [ ] No sensitive data in notification payloads

### Performance
- [ ] App doesn't freeze when registering device
- [ ] API calls happen in background
- [ ] No memory leaks during token refresh
- [ ] Notification handling efficient

### Documentation
- [ ] Update app documentation with push notification info
- [ ] Document backend endpoints
- [ ] Create runbook for operations team
- [ ] Document how to test notifications

### Deployment
- [ ] Create production Firebase project (separate from development)
- [ ] Generate production google-services.json
- [ ] Generate production GoogleService-Info.plist
- [ ] Update APNs certificate for production
- [ ] Test with production credentials
- [ ] Brief QA team on testing process

**Time estimate**: 1-2 hours | **Difficulty**: 🟡 Medium

---

## Phase 9: Launch & Monitoring

### Pre-Launch Checklist
- [ ] Both Android and iOS tested on real devices
- [ ] Push notifications working end-to-end
- [ ] Backend handling all scenarios
- [ ] Error messages are user-friendly
- [ ] No console errors or warnings

### Launch
- [ ] Release app to beta testers first
- [ ] Monitor for errors in Firebase Console
- [ ] Monitor backend logs for issues
- [ ] Check user feedback about notifications
- [ ] Gradually roll out to all users

### Post-Launch Monitoring
- [ ] Monitor Firebase Cloud Messaging delivery rates
- [ ] Monitor backend database for invalid tokens
- [ ] Clean up invalid/inactive tokens periodically
- [ ] Track notification engagement metrics
- [ ] Handle user opt-in/opt-out preferences

**Time estimate**: Ongoing | **Difficulty**: 🟢 Easy

---

## Summary

**Total Estimated Time**: 7-10 hours spread over 1-2 weeks

**Phases by Difficulty**:
- 🟢 Easy: Phases 1, 2, 9 (Understanding, Firebase setup, Monitoring)
- 🟡 Medium: Phases 6, 7, 8 (Integration, Testing, Production)
- 🔴 Hard: Phases 3, 4, 5 (Android, iOS, Backend)

---

## Quick Reference Links

| What | Where |
|------|-------|
| Quick Start | `PUSH_NOTIFICATIONS_QUICK_START.md` |
| Complete Guide | `FIREBASE_PUSH_NOTIFICATIONS_SETUP.md` |
| Backend API | `BACKEND_API_SPECIFICATION.md` |
| Example Code | `lib/core/services/auth_with_push_notifications_example.dart` |
| Setup Summary | `PUSH_NOTIFICATIONS_SETUP_SUMMARY.md` |
| This Checklist | `IMPLEMENTATION_CHECKLIST.md` |

---

## Notes Section

Use this space to track blockers, notes, or decisions:

```
[Blockers]


[Notes]


[Decisions Made]

```

---

**Last Updated**: 2026-04-16
**Project**: Tithi Gadhi
**Status**: In Progress ✅
