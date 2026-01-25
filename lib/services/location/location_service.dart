import 'package:geolocator/geolocator.dart';
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

  Future<void> setLocationName(String name) async {
    _locationName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
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
