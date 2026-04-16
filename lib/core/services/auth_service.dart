import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import '../../core/network/dio_client.dart';
import 'push_notification_service.dart';
import 'fcm_service.dart';

class AuthService {
  static Future<void> signOut() async {
    // 0. Stop foreground service
    try {
      await FlutterForegroundTask.stopService();
    } catch (_) {}

    // 1. Unregister device from backend (before signing out)
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final idToken = await currentUser.getIdToken();
        log('I am IdToken $idToken');
        if (idToken != null) {
          final dioClient = GetIt.instance.get<DioClient>();
          // await PushNotificationService(dioClient)
          //     .unregisterDeviceFromBackend(idToken: idToken);
        }
      }
    } catch (_) {}

    // 2. Delete FCM token locally
    try {
      await FcmService().deleteToken();
    } catch (_) {}

    // 3. Clear panchang cache
    try {
      await Hive.box<String>('panchang_cache').clear();
    } catch (_) {}

    // 4. Delete auth token from secure storage
    await const FlutterSecureStorage().delete(key: 'auth_token');

    // 5. Sign out Firebase + Google
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    // Note: isOnboardingDone in SharedPreferences is intentionally NOT cleared
  }
}
