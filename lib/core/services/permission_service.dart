import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class PermissionService {
  /// Unified method to request all necessary permissions for the app startup.
  static Future<void> requestAllNecessaryPermissions() async {
    await requestLocationPermission();
    await requestNotificationPermission();
  }

  /// Handles location permission logic.
  /// Returns [true] if permission is granted.
  static Future<bool> requestLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    PermissionStatus status = await Permission.location.status;

    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      // You might want to show a dialog before opening settings
      // For now, we'll just return false or let the caller handle it
      return false;
    }

    return status.isGranted || status.isLimited;
  }

  /// Handles notification permissions (Firebase and local).
  static Future<bool> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isDenied) {
      status = await Permission.notification.request();
    }

    return status.isGranted;
  }

  /// Handles battery optimization and ignore battery optimization permissions
  /// required for stable foreground tasks.
  static Future<bool> requestIgnoreBatteryOptimizations() async {
    PermissionStatus status =
        await Permission.ignoreBatteryOptimizations.status;

    if (status.isDenied) {
      status = await Permission.ignoreBatteryOptimizations.request();
    }

    return status.isGranted;
  }

  /// Opens the app settings screen to let the user manually enable permissions.
  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
