import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../location/location_service.dart';
import 'prayer_settings.dart';

class PrayerService {
  static final PrayerService _instance = PrayerService._internal();
  factory PrayerService() => _instance;
  PrayerService._internal();

  final PrayerSettings _settings = PrayerSettings();
  final LocationService _locationService = LocationService();
  Coordinates? _coordinates;
  CalculationParameters? _params;
  String _locationName = AppConstants.defaultLocationName;
  String _timezone = '';
  bool _isInitialized = false;

  PrayerSettings get settings => _settings;
  String get locationName => _locationName;
  String get timezone => _timezone;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    await _settings.init();
    await _updateLocation();
    _updateCalculationParams();
    _isInitialized = true;
  }

  Future<void> _updateLocation() async {
    if (_settings.locationMode == PrayerSettings.locationModeAuto) {
      // Use shared LocationService (prevents duplicate GPS calls)
      await _locationService.initialize();
      await _locationService.ensureLocationAvailable();

      // Only use and persist location if GPS was successful
      if (_locationService.hasLocation) {
        final lat = _locationService.latitude;
        final lng = _locationService.longitude;

        _coordinates = Coordinates(lat, lng);
        _settings.latitude = lat;
        _settings.longitude = lng;
        _locationName = _locationService.locationName;
        _settings.locationName = _locationName;
      } else {
        // GPS failed - fall back to stored/default without overwriting settings
        _useStoredOrDefaultLocation();
      }
    } else {
      _useStoredOrDefaultLocation();
    }

    // Set timezone
    _timezone = DateTime.now().timeZoneName;
  }

  void _useStoredOrDefaultLocation() {
    final lat = _settings.latitude ?? AppConstants.defaultLatitude;
    final lng = _settings.longitude ?? AppConstants.defaultLongitude;
    _coordinates = Coordinates(lat, lng);
    _locationName = _settings.locationName ?? AppConstants.defaultLocationName;
  }

  void _updateCalculationParams() {
    switch (_settings.calculationMethod) {
      case 'mwl':
        _params = CalculationMethod.muslim_world_league.getParameters();
        break;
      case 'egyptian':
        _params = CalculationMethod.egyptian.getParameters();
        break;
      case 'karachi':
        _params = CalculationMethod.karachi.getParameters();
        break;
      case 'umm_al_qura':
        _params = CalculationMethod.umm_al_qura.getParameters();
        break;
      case 'dubai':
        _params = CalculationMethod.dubai.getParameters();
        break;
      case 'qatar':
        _params = CalculationMethod.qatar.getParameters();
        break;
      case 'kuwait':
        _params = CalculationMethod.kuwait.getParameters();
        break;
      case 'singapore':
        _params = CalculationMethod.singapore.getParameters();
        break;
      case 'isna':
      default:
        _params = CalculationMethod.north_america.getParameters();
    }

    // Set Asr madhab
    _params!.madhab = _settings.asrMethod == 'hanafi' ? Madhab.hanafi : Madhab.shafi;
  }

  Future<void> updateSettings({
    String? locationMode,
    double? latitude,
    double? longitude,
    String? locationName,
    String? calculationMethod,
    String? asrMethod,
  }) async {
    if (locationMode != null) _settings.locationMode = locationMode;
    if (latitude != null) _settings.latitude = latitude;
    if (longitude != null) _settings.longitude = longitude;
    if (locationName != null) _settings.locationName = locationName;
    if (calculationMethod != null) _settings.calculationMethod = calculationMethod;
    if (asrMethod != null) _settings.asrMethod = asrMethod;

    await _updateLocation();
    _updateCalculationParams();
  }

  Coordinates get coordinates {
    if (_coordinates == null) {
      _coordinates = Coordinates(
        AppConstants.defaultLatitude,
        AppConstants.defaultLongitude,
      );
    }
    return _coordinates!;
  }

  CalculationParameters get params {
    if (_params == null) {
      _updateCalculationParams();
    }
    return _params!;
  }

  PrayerTimes getPrayerTimesForDate(DateTime date) {
    final dateComponents = DateComponents.from(date);
    return PrayerTimes(coordinates, dateComponents, params);
  }

  PrayerTimes get todayPrayerTimes => getPrayerTimesForDate(DateTime.now());

  /// Returns the next prayer and time until it
  NextPrayerInfo getNextPrayer() {
    final now = DateTime.now();
    final prayers = todayPrayerTimes;

    final prayerList = [
      ('Fajr', prayers.fajr),
      ('Dhuhr', prayers.dhuhr),
      ('Asr', prayers.asr),
      ('Maghrib', prayers.maghrib),
      ('Isha', prayers.isha),
    ];

    // Find previous prayer for progress calculation
    String? previousPrayer;
    DateTime? previousTime;

    for (int i = 0; i < prayerList.length; i++) {
      final (name, time) = prayerList[i];
      if (time.isAfter(now)) {
        if (i > 0) {
          previousPrayer = prayerList[i - 1].$1;
          previousTime = prayerList[i - 1].$2;
        } else {
          // Before Fajr, previous is yesterday's Isha
          final yesterday = DateTime.now().subtract(const Duration(days: 1));
          final yesterdayPrayers = getPrayerTimesForDate(yesterday);
          previousPrayer = 'Isha';
          previousTime = yesterdayPrayers.isha;
        }

        return NextPrayerInfo(
          name: name,
          time: time,
          timeUntil: time.difference(now),
          previousPrayer: previousPrayer,
          previousTime: previousTime,
        );
      }
    }

    // If all prayers have passed, return tomorrow's Fajr
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowPrayers = getPrayerTimesForDate(tomorrow);
    return NextPrayerInfo(
      name: 'Fajr',
      time: tomorrowPrayers.fajr,
      timeUntil: tomorrowPrayers.fajr.difference(now),
      previousPrayer: 'Isha',
      previousTime: prayers.isha,
    );
  }

  /// Get all prayer times for today as a list (excluding sunrise/sunset)
  List<PrayerTimeInfo> getTodayPrayerList() {
    final prayers = todayPrayerTimes;
    final nextPrayer = getNextPrayer();

    return [
      PrayerTimeInfo('Fajr', prayers.fajr, nextPrayer.name == 'Fajr'),
      PrayerTimeInfo('Dhuhr', prayers.dhuhr, nextPrayer.name == 'Dhuhr'),
      PrayerTimeInfo('Asr', prayers.asr, nextPrayer.name == 'Asr'),
      PrayerTimeInfo('Maghrib', prayers.maghrib, nextPrayer.name == 'Maghrib'),
      PrayerTimeInfo('Isha', prayers.isha, nextPrayer.name == 'Isha'),
    ];
  }

  /// Get sunrise time
  DateTime get sunrise => todayPrayerTimes.sunrise;

  /// Get sunset time (same as maghrib)
  DateTime get sunset => todayPrayerTimes.maghrib;

  /// Get prayer times for the next 7 days
  List<DayPrayerTimes> getWeekPrayerTimes() {
    final List<DayPrayerTimes> week = [];
    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      final prayers = getPrayerTimesForDate(date);
      week.add(DayPrayerTimes(date, prayers));
    }

    return week;
  }

  /// Format time for display
  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  /// Format duration for display (e.g., "2h 34m")
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class NextPrayerInfo {
  final String name;
  final DateTime time;
  final Duration timeUntil;
  final String? previousPrayer;
  final DateTime? previousTime;

  NextPrayerInfo({
    required this.name,
    required this.time,
    required this.timeUntil,
    this.previousPrayer,
    this.previousTime,
  });

  String get formattedTime => PrayerService.formatTime(time);
  String get formattedTimeUntil => PrayerService.formatDuration(timeUntil);

  /// Progress from 0.0 to 1.0 between previous and next prayer
  double get progress {
    if (previousTime == null) return 0.0;
    final totalDuration = time.difference(previousTime!);
    final elapsed = DateTime.now().difference(previousTime!);
    return (elapsed.inSeconds / totalDuration.inSeconds).clamp(0.0, 1.0);
  }
}

class PrayerTimeInfo {
  final String name;
  final DateTime time;
  final bool isNext;

  PrayerTimeInfo(this.name, this.time, this.isNext);

  String get formattedTime => PrayerService.formatTime(time);
}

class DayPrayerTimes {
  final DateTime date;
  final PrayerTimes prayers;

  DayPrayerTimes(this.date, this.prayers);

  String get dayName => DateFormat('EEE').format(date);
  String get shortDate => DateFormat('M/d').format(date);
}
