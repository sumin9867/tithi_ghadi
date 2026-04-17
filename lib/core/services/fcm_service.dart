import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tithi_gadhi/core/services/permission_service.dart';

class FcmService {
  static final FcmService _instance = FcmService._internal();

  factory FcmService() {
    return _instance;
  }

  FcmService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  /// Initialize Firebase Cloud Messaging
  Future<void> initialize() async {
    try {
      // Initialize local notifications
      await _initializeLocalNotifications();

      // Request user permission for location and notifications centralized
      await PermissionService.requestNotificationPermission();

      // Get FCM token
      _fcmToken = await _firebaseMessaging.getToken();

      // Handle token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _sendTokenToBackend(newToken);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages (when app is in background)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Handle notification tap when app is terminated
      final initialMessage =
          await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }
    } catch (e) {
      // Silent fail - initialization error shouldn't crash app
    }
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _localNotifications.initialize(initSettings);

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      enableVibration: true,
      enableLights: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Handle foreground messages (when app is in foreground)
  void _handleForegroundMessage(RemoteMessage message) {
    _showLocalNotification(message);
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
      payload: _encodePayload(message.data),
    );
  }

  /// Handle message when app is opened from a notification
  void _handleMessageOpenedApp(RemoteMessage message) {
    _navigateToScreen(message.data);
  }

  /// Navigate to screen based on message data
  void _navigateToScreen(Map<String, dynamic> data) {
    // Implement navigation logic based on your app structure
    // Example:
    // if (data.containsKey('screen')) {
    //   String screen = data['screen'];
    //   // Navigate to the screen
    // }
  }

  /// Send FCM token to backend
  Future<void> _sendTokenToBackend(String token) async {
    // This will be called from your auth service
    // when the user logs in
  }

  /// Encode payload for notification
  String _encodePayload(Map<String, dynamic> data) {
    return data.entries.map((e) => '${e.key}=${e.value}').join('&');
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
    } catch (e) {
      // Silent fail
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    } catch (e) {
      // Silent fail
    }
  }

  /// Delete FCM token (use when user logs out)
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
    } catch (e) {
      // Silent fail
    }
  }
}
