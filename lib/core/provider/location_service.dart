import 'dart:io';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Ensure location services + permission
  static Future<bool> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Continuous position stream (permission-safe)
  static Stream<Position> positionStream() {
    final LocationSettings settings;

    if (Platform.isIOS || Platform.isMacOS) {
      settings = AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    } else if (Platform.isAndroid) {
      settings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    } else {
      settings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    }

    return Geolocator.getPositionStream(
      locationSettings: settings,
    );
  }

  /// One-time location (used by Near Me switch)
  static Future<Position> getCurrentLocation() async {
    final allowed = await ensurePermission();
    if (!allowed) {
      throw Exception("Location permission not granted");
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
