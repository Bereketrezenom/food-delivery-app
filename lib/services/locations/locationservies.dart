// services/locations/locationservies.dart
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Cache for the last known position
  Position? _lastKnownPosition;
  String? _lastKnownAddress;
  DateTime? _lastUpdateTime;
  static const _cacheDuration = Duration(minutes: 5);

  // Get approximate location with low accuracy for faster response
  Future<Position> getApproximateLocation() async {
    try {
      // Check if we have a recent cached position
      if (_lastKnownPosition != null && _lastUpdateTime != null) {
        if (DateTime.now().difference(_lastUpdateTime!) < _cacheDuration) {
          return _lastKnownPosition!;
        }
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled()
          .timeout(const Duration(seconds: 3));
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission()
          .timeout(const Duration(seconds: 3));
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission()
            .timeout(const Duration(seconds: 3));
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get last known position first (very fast)
      Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        _lastKnownPosition = lastKnown;
        _lastUpdateTime = DateTime.now();
        return lastKnown;
      }

      // If no last known position, get current with low accuracy
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 5),
      );

      _lastKnownPosition = position;
      _lastUpdateTime = DateTime.now();
      return position;
    } catch (e) {
      if (_lastKnownPosition != null) {
        return _lastKnownPosition!;
      }
      rethrow;
    }
  }

  // Get precise location with high accuracy
  Future<Position> getCurrentLocation() async {
    // Check if we have a recent cached position
    if (_lastKnownPosition != null && _lastUpdateTime != null) {
      if (DateTime.now().difference(_lastUpdateTime!) < _cacheDuration) {
        return _lastKnownPosition!;
      }
    }

    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if location services are enabled with timeout
      serviceEnabled = await Geolocator.isLocationServiceEnabled()
          .timeout(const Duration(seconds: 5));
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      // Check location permission with timeout
      permission = await Geolocator.checkPermission()
          .timeout(const Duration(seconds: 5));
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission()
            .timeout(const Duration(seconds: 5));
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position with timeout and medium accuracy
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      // Cache the position
      _lastKnownPosition = position;
      _lastUpdateTime = DateTime.now();

      return position;
    } catch (e) {
      // If we have a cached position, return it even if expired
      if (_lastKnownPosition != null) {
        return _lastKnownPosition!;
      }
      rethrow;
    }
  }

  Future<String> getAddressFromCoordinates(Position position) async {
    // Check if we have a cached address for these coordinates
    if (_lastKnownAddress != null &&
        _lastKnownPosition?.latitude == position.latitude &&
        _lastKnownPosition?.longitude == position.longitude) {
      return _lastKnownAddress!;
    }

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(const Duration(seconds: 5));

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Simplified address format for faster display
        final address = '${place.locality}, ${place.subLocality}';

        // Cache the address
        _lastKnownAddress = address;
        return address;
      }
      return 'Unknown Location';
    } catch (e) {
      // If we have a cached address, return it
      if (_lastKnownAddress != null) {
        return _lastKnownAddress!;
      }
      return 'Error getting address';
    }
  }

  Future<void> saveDeliveryAddress(String address) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('delivery_address', address);
    } catch (e) {
      print('Error saving delivery address: $e');
    }
  }

  Future<String?> getSavedDeliveryAddress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('delivery_address');
    } catch (e) {
      print('Error getting saved delivery address: $e');
      return null;
    }
  }
}
