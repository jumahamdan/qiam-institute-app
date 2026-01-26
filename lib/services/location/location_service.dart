import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/constants.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _cachedPosition;
  String? _locationName;

  static const String _latKey = 'cached_latitude';
  static const String _lngKey = 'cached_longitude';
  static const String _nameKey = 'cached_location_name';

  /// Initialize and load cached location
  Future<void> initialize() async {
    await _loadCachedLocation();
  }

  /// Get current location with permission handling
  Future<LocationResult> getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResult.failure('Location services are disabled');
    }

    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationResult.failure('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationResult.failure(
        'Location permissions are permanently denied. Please enable in settings.',
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _cachedPosition = position;
      await _cacheLocation(position);

      // Reverse geocode to get location name
      await _reverseGeocodePosition(position);

      return LocationResult.success(position);
    } catch (e) {
      // Return cached location if available
      if (_cachedPosition != null) {
        return LocationResult.success(_cachedPosition!);
      }
      return LocationResult.failure('Failed to get location: $e');
    }
  }

  /// Get location (cached or default)
  Future<Position> getLocationOrDefault() async {
    if (_cachedPosition != null) {
      return _cachedPosition!;
    }

    final result = await getCurrentLocation();
    if (result.isSuccess) {
      return result.position!;
    }

    // Return default location (Woodridge, IL)
    return Position(
      latitude: AppConstants.defaultLatitude,
      longitude: AppConstants.defaultLongitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  /// Ensure location is fetched (only fetches GPS if not already cached in memory)
  /// This prevents multiple GPS calls when multiple services need location
  Future<void> ensureLocationAvailable() async {
    if (_cachedPosition != null) {
      return; // Already have location in memory
    }
    await getCurrentLocation();
  }

  /// Check if location is already available (no GPS call needed)
  bool get hasLocation => _cachedPosition != null;

  String get locationName => _locationName ?? AppConstants.defaultLocationName;

  double get latitude => _cachedPosition?.latitude ?? AppConstants.defaultLatitude;
  double get longitude => _cachedPosition?.longitude ?? AppConstants.defaultLongitude;

  Future<void> _loadCachedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_latKey);
    final lng = prefs.getDouble(_lngKey);
    _locationName = prefs.getString(_nameKey);

    if (lat != null && lng != null) {
      _cachedPosition = Position(
        latitude: lat,
        longitude: lng,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }
  }

  Future<void> _cacheLocation(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latKey, position.latitude);
    await prefs.setDouble(_lngKey, position.longitude);
  }

  Future<void> _reverseGeocodePosition(Position position) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${position.latitude}&lon=${position.longitude}&format=json&addressdetails=1',
      );

      final response = await http.get(
        uri,
        headers: {'User-Agent': 'QiamInstituteApp/1.0'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final address = data['address'] as Map<String, dynamic>?;

        if (address != null) {
          final city = address['city'] ??
              address['town'] ??
              address['village'] ??
              address['municipality'] ??
              '';
          final state = address['state'] ?? '';

          String name;
          if (city.isNotEmpty && state.isNotEmpty) {
            name = '$city, $state';
          } else if (city.isNotEmpty) {
            name = city;
          } else if (state.isNotEmpty) {
            name = state;
          } else {
            name = 'Current Location';
          }

          await setLocationName(name);
        }
      }
    } catch (e) {
      // Silently fail - keep existing location name
    }
  }

  Future<void> setLocationName(String name) async {
    _locationName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

  /// Get full address via reverse geocoding
  Future<String?> getFullAddress() async {
    try {
      final lat = latitude;
      final lng = longitude;

      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json&addressdetails=1',
      );

      final response = await http.get(
        uri,
        headers: {'User-Agent': 'QiamInstituteApp/1.0'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final address = data['address'] as Map<String, dynamic>?;

        if (address != null) {
          final parts = <String>[];

          // Road/street
          final road = address['road'] ?? address['street'];
          if (road != null) parts.add(road);

          // House number
          final houseNumber = address['house_number'];
          if (houseNumber != null && parts.isNotEmpty) {
            parts[0] = '$houseNumber ${parts[0]}';
          }

          // City/town
          final city = address['city'] ??
              address['town'] ??
              address['village'] ??
              address['municipality'];
          if (city != null) parts.add(city);

          // State
          final state = address['state'];
          if (state != null) parts.add(state);

          // Country
          final country = address['country'];
          if (country != null) parts.add(country);

          if (parts.isNotEmpty) {
            return parts.join(', ');
          }
        }

        // Fallback to display_name
        return data['display_name'] as String?;
      }
    } catch (e) {
      // Silently fail and return null
    }
    return null;
  }
}

class LocationResult {
  final bool isSuccess;
  final Position? position;
  final String? error;

  LocationResult._({required this.isSuccess, this.position, this.error});

  factory LocationResult.success(Position position) {
    return LocationResult._(isSuccess: true, position: position);
  }

  factory LocationResult.failure(String error) {
    return LocationResult._(isSuccess: false, error: error);
  }
}
