import 'dart:async';
import 'dart:math' as math;
import 'package:adhan/adhan.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../location/location_service.dart';

class QiblaService {
  static final QiblaService _instance = QiblaService._internal();
  factory QiblaService() => _instance;
  QiblaService._internal();

  final LocationService _locationService = LocationService();

  StreamSubscription<CompassEvent>? _compassSubscription;
  final _compassController = StreamController<QiblaData>.broadcast();

  Stream<QiblaData> get compassStream => _compassController.stream;

  double? _qiblaDirection;
  bool _hasCompass = true;

  /// Initialize the Qibla service
  Future<void> initialize() async {
    await _locationService.initialize();
    // Get the user's actual GPS location
    await _locationService.getCurrentLocation();
    _calculateQiblaDirection();
    await _checkCompassAvailability();
  }

  void _calculateQiblaDirection() {
    final coordinates = Coordinates(
      _locationService.latitude,
      _locationService.longitude,
    );
    final qibla = Qibla(coordinates);
    _qiblaDirection = qibla.direction;
  }

  Future<void> _checkCompassAvailability() async {
    try {
      _hasCompass = FlutterCompass.events != null;
    } catch (e) {
      _hasCompass = false;
    }
  }

  /// Start listening to compass updates
  void startListening() {
    if (!_hasCompass) {
      // Emit static data if no compass
      _compassController.add(QiblaData(
        qiblaDirection: _qiblaDirection ?? 0,
        compassHeading: 0,
        accuracy: null,
        hasCompass: false,
      ));
      return;
    }

    _compassSubscription?.cancel();
    _compassSubscription = FlutterCompass.events?.listen((event) {
      final heading = event.heading ?? 0;
      _compassController.add(QiblaData(
        qiblaDirection: _qiblaDirection ?? 0,
        compassHeading: heading,
        accuracy: event.accuracy,
        hasCompass: true,
      ));
    });
  }

  /// Stop listening to compass updates
  void stopListening() {
    _compassSubscription?.cancel();
    _compassSubscription = null;
  }

  /// Get current Qibla direction (degrees from North)
  double get qiblaDirection => _qiblaDirection ?? 0;

  /// Check if device has compass
  bool get hasCompass => _hasCompass;

  /// Get Qibla direction as cardinal direction (e.g., "NE")
  String get qiblaCardinalDirection {
    final direction = _qiblaDirection ?? 0;
    if (direction >= 337.5 || direction < 22.5) return 'N';
    if (direction >= 22.5 && direction < 67.5) return 'NE';
    if (direction >= 67.5 && direction < 112.5) return 'E';
    if (direction >= 112.5 && direction < 157.5) return 'SE';
    if (direction >= 157.5 && direction < 202.5) return 'S';
    if (direction >= 202.5 && direction < 247.5) return 'SW';
    if (direction >= 247.5 && direction < 292.5) return 'W';
    return 'NW';
  }

  /// Approximate distance to Makkah in km
  double getDistanceToMakkah() {
    // Makkah coordinates
    const makkahLat = 21.4225;
    const makkahLng = 39.8262;

    final lat = _locationService.latitude;
    final lng = _locationService.longitude;

    // Haversine formula for distance
    const earthRadius = 6371.0; // km
    final dLat = _toRadians(makkahLat - lat);
    final dLng = _toRadians(makkahLng - lng);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat)) *
            math.cos(_toRadians(makkahLat)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * math.pi / 180;

  void dispose() {
    stopListening();
    _compassController.close();
  }
}

class QiblaData {
  final double qiblaDirection;
  final double compassHeading;
  final double? accuracy;
  final bool hasCompass;

  QiblaData({
    required this.qiblaDirection,
    required this.compassHeading,
    this.accuracy,
    required this.hasCompass,
  });

  /// The angle to rotate the Qibla indicator
  /// When this is 0, the indicator points to Qibla
  double get qiblaFromNorth => qiblaDirection - compassHeading;

  /// Check if compass needs calibration (low accuracy)
  bool get needsCalibration => accuracy != null && accuracy! < 15;
}
