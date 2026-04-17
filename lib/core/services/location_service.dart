import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:tithi_gadhi/core/services/permission_service.dart';

class UserLocation {
  final double latitude;
  final double longitude;
  final String? name;

  UserLocation({
    required this.latitude,
    required this.longitude,
    this.name,
  });
}

class LocationService {
  /// Fetches the current location and tries to reverse geocode a city name.
  static Future<UserLocation?> getCurrentLocation() async {
    // Use centralized permission service
    final hasPermission = await PermissionService.requestLocationPermission();
    if (!hasPermission) {
      return null;
    }

    try {
      // Get current position with a timeout
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5),
      );

      // Try to get a city name
      final cityName = await getCityName(position.latitude, position.longitude);

      return UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        name: cityName,
      );
    } catch (e) {
      // Timeout or other error
      return null;
    }
  }

  /// Reverse geocoding using Nominatim (OpenStreetMap)
  static Future<String?> getCityName(double lat, double lon) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$lon',
      );
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'TithiGhadiApp/1.0'},
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];
        if (address != null) {
          return address['city'] ??
              address['town'] ??
              address['village'] ??
              address['suburb'] ??
              address['municipality'] ??
              address['state_district'];
        }
      }
    } catch (_) {
      // Ignore network errors for city name
    }
    return null;
  }
}
