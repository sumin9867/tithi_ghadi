import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:tithi_gadhi/core/services/permission_service.dart';
import 'tithi_task_handler.dart';

/// Static service manager for the tithi foreground service.
/// Handles permissions, service lifecycle, and data relay to the background task.
class TithiForegroundService {
  /// Requests notification and battery optimization permissions before starting service.
  static Future<void> _requestPermissions() async {
    // Consolidated permission requests via centralized service
    await PermissionService.requestNotificationPermission();
    await PermissionService.requestIgnoreBatteryOptimizations();
  }

  /// Starts the foreground service with initial notification.
  /// Returns ServiceRequestResult on success.
  static Future<ServiceRequestResult> startService() async {
    // Request required permissions
    await _requestPermissions();

    // If service is already running, restart it
    if (await FlutterForegroundTask.isRunningService) {
      return await FlutterForegroundTask.restartService();
    }

    // Start new foreground service
    return await FlutterForegroundTask.startService(
      serviceId: 1000,
      notificationTitle: 'Tithi Gadhi',
      notificationText: 'Fetching tithi…',
      callback: startTithiTaskCallback,
    );
  }

  /// Stops the foreground service.
  static Future<ServiceRequestResult> stopService() async {
    return await FlutterForegroundTask.stopService();
  }

  /// Sends tithi data from UI isolate to background task.
  /// The background task will update the notification with this data.
  static Future<void> sendTithiData({
    required String tithiName,
    required String tithiEnd,
  }) async {
    if (await FlutterForegroundTask.isRunningService) {
      FlutterForegroundTask.sendDataToTask({
        'tithi_name': tithiName,
        'tithi_end': tithiEnd,
      });
    }
  }

  /// Checks if the foreground service is currently running.
  static Future<bool> get isRunning => FlutterForegroundTask.isRunningService;
}
