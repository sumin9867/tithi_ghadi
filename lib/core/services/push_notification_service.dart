import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:tithi_gadhi/core/network/dio_client.dart';

/// Service for managing push notifications and sending device info to backend
@injectable
class PushNotificationService {
  final DioClient _dioClient;

  PushNotificationService(this._dioClient);

  /// Register device with backend after user authentication
  /// Include FCM token and device information
  Future<void> registerDeviceWithBackend({
    required String idToken,
    required String? fcmToken,
    String? deviceName,
  }) async {
    try {
      final payload = {
        'idToken': idToken,
        'fcmToken': fcmToken,
        if (deviceName != null) 'deviceName': deviceName,
        'deviceId': _getDeviceId(),
      };

      // Send registration to your backend endpoint
      // Adjust the endpoint path based on your API structure
      await _dioClient.dio.post(
        '/api/mobile-auth/firebase'
, // Update this endpoint
        data: payload,
      );
    } catch (e) {
      // Silently handle - device registration failure shouldn't block user login
    }
  }

  /// Update FCM token when it refreshes
  Future<void> updateFcmTokenOnBackend({
    required String idToken,
    required String newFcmToken,
  }) async {
    try {
      await _dioClient.dio.post(
        '/auth/update-fcm-token', // Update this endpoint
        data: {
          'idToken': idToken,
          'fcmToken': newFcmToken,
        },
      );
    } catch (e) {
      // Silent fail
    }
  }

  /// Cleanup when user logs out
  Future<void> unregisterDeviceFromBackend({
    required String idToken,
  }) async {
    try {
      await _dioClient.dio.post(
        '/auth/unregister-device', // Update this endpoint
        data: {
          'idToken': idToken,
        },
      );
    } catch (e) {
      // Silent fail
    }
  }

  /// Get unique device identifier
  String _getDeviceId() {
    // You can use a package like device_info_plus to get real device ID
    // For now, returning a placeholder
    return 'flutter-device-${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Subscribe user to notification topics based on their preferences
  Future<void> subscribeToUserNotifications(String userId) async {
    try {
      final messaging = FirebaseMessaging.instance;
      // Subscribe to user-specific topic for notifications
      await messaging.subscribeToTopic('user_$userId');
    } catch (e) {
      // Silent fail
    }
  }

  /// Unsubscribe from user-specific notifications
  Future<void> unsubscribeFromUserNotifications(String userId) async {
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.unsubscribeFromTopic('user_$userId');
    } catch (e) {
      // Silent fail
    }
  }
}
