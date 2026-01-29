import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../adhan/adhan_notification_service.dart';
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

  /// Maps setting keys to calculation methods from the adhan package
  static const _calculationMethodMap = {
    'mwl': CalculationMethod.muslim_world_league,
    'egyptian': CalculationMethod.egyptian,
    'karachi': CalculationMethod.karachi,
    'umm_al_qura': CalculationMethod.umm_al_qura,
    'dubai': CalculationMethod.dubai,
    'qatar': CalculationMethod.qatar,
    'kuwait': CalculationMethod.kuwait,
    'singapore': CalculationMethod.singapore,
    'tehran': CalculationMethod.tehran,
    'turkey': CalculationMethod.turkey,
    'isna': CalculationMethod.north_america,
  };

  /// Maps setting keys to high latitude rules
  static const _highLatitudeRuleMap = {
    'middle_of_night': HighLatitudeRule.middle_of_the_night,
    'one_seventh': HighLatitudeRule.seventh_of_the_night,
    'angle_based': HighLatitudeRule.twilight_angle,
  };

  void _updateCalculationParams() {
    // Get calculation method from map or default to north_america
    final method = _calculationMethodMap[_settings.calculationMethod]
        ?? CalculationMethod.north_america;
    _params = method.getParameters();

    // Set Asr madhab
    _params!.madhab = _settings.asrMethod == 'hanafi' ? Madhab.hanafi : Madhab.shafi;

    // Set high latitude rule if configured
    final highLatRule = _highLatitudeRuleMap[_settings.highLatitudeRule];
    if (highLatRule != null) {
      _params!.highLatitudeRule = highLatRule;
    }
  }

  Future<void> updateSettings({
    String? locationMode,
    bool? autoDetectLocation,
    double? latitude,
    double? longitude,
    String? locationName,
    String? calculationMethod,
    bool? useFixedCalculation,
    String? asrMethod,
    String? highLatitudeRule,
    String? daylightSaving,
    int? imsakMinutes,
  }) async {
    if (locationMode != null) _settings.locationMode = locationMode;
    if (autoDetectLocation != null) _settings.autoDetectLocation = autoDetectLocation;
    if (latitude != null) _settings.latitude = latitude;
    if (longitude != null) _settings.longitude = longitude;
    if (locationName != null) _settings.locationName = locationName;
    if (calculationMethod != null) _settings.calculationMethod = calculationMethod;
    if (useFixedCalculation != null) _settings.useFixedCalculation = useFixedCalculation;
    if (asrMethod != null) _settings.asrMethod = asrMethod;
    if (highLatitudeRule != null) _settings.highLatitudeRule = highLatitudeRule;
    if (daylightSaving != null) _settings.daylightSaving = daylightSaving;
    if (imsakMinutes != null) _settings.imsakMinutes = imsakMinutes;

    await _updateLocation();
    _updateCalculationParams();

    // Reschedule adhan notifications with updated prayer times
    if (AdhanNotificationService().isInitialized) {
      await AdhanNotificationService().reschedule();
    }
  }

  Future<void> updateCorrection(String prayer, int minutes) async {
    _settings.setCorrection(prayer, minutes);
  }

  Coordinates get coordinates {
    _coordinates ??= Coordinates(
      AppConstants.defaultLatitude,
      AppConstants.defaultLongitude,
    );
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

  /// Apply manual correction to a prayer time
  DateTime _applyCorrection(DateTime time, String prayer) {
    final correction = _settings.allCorrections[prayer] ?? 0;
    return time.add(Duration(minutes: correction));
  }

  /// Returns the next prayer and time until it
  NextPrayerInfo getNextPrayer() {
    final now = DateTime.now();
    final prayers = todayPrayerTimes;

    final prayerList = [
      ('Fajr', _applyCorrection(prayers.fajr, 'Fajr')),
      ('Dhuhr', _applyCorrection(prayers.dhuhr, 'Dhuhr')),
      ('Asr', _applyCorrection(prayers.asr, 'Asr')),
      ('Maghrib', _applyCorrection(prayers.maghrib, 'Maghrib')),
      ('Isha', _applyCorrection(prayers.isha, 'Isha')),
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
          previousTime = _applyCorrection(yesterdayPrayers.isha, 'Isha');
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
      time: _applyCorrection(tomorrowPrayers.fajr, 'Fajr'),
      timeUntil: _applyCorrection(tomorrowPrayers.fajr, 'Fajr').difference(now),
      previousPrayer: 'Isha',
      previousTime: _applyCorrection(prayers.isha, 'Isha'),
    );
  }

  /// Get all prayer times for today as a list (excluding sunrise/sunset)
  List<PrayerTimeInfo> getTodayPrayerList() {
    final prayers = todayPrayerTimes;
    final nextPrayer = getNextPrayer();

    return [
      PrayerTimeInfo('Fajr', _applyCorrection(prayers.fajr, 'Fajr'), nextPrayer.name == 'Fajr'),
      PrayerTimeInfo('Dhuhr', _applyCorrection(prayers.dhuhr, 'Dhuhr'), nextPrayer.name == 'Dhuhr'),
      PrayerTimeInfo('Asr', _applyCorrection(prayers.asr, 'Asr'), nextPrayer.name == 'Asr'),
      PrayerTimeInfo('Maghrib', _applyCorrection(prayers.maghrib, 'Maghrib'), nextPrayer.name == 'Maghrib'),
      PrayerTimeInfo('Isha', _applyCorrection(prayers.isha, 'Isha'), nextPrayer.name == 'Isha'),
    ];
  }

  /// Get sunrise time
  DateTime get sunrise => _applyCorrection(todayPrayerTimes.sunrise, 'Sunrise');

  /// Get sunset time (same as maghrib)
  DateTime get sunset => _applyCorrection(todayPrayerTimes.maghrib, 'Maghrib');

  /// Get Imsak time (minutes before Fajr)
  DateTime get imsak {
    final fajr = _applyCorrection(todayPrayerTimes.fajr, 'Fajr');
    return fajr.subtract(Duration(minutes: _settings.imsakMinutes));
  }

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

  /// Get prayer times for a specific date as a list
  List<PrayerTimeInfo> getPrayerListForDate(DateTime date) {
    final prayers = getPrayerTimesForDate(date);
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;

    String? nextPrayerName;
    if (isToday) {
      nextPrayerName = getNextPrayer().name;
    }

    return [
      PrayerTimeInfo('Fajr', _applyCorrection(prayers.fajr, 'Fajr'), nextPrayerName == 'Fajr'),
      PrayerTimeInfo('Dhuhr', _applyCorrection(prayers.dhuhr, 'Dhuhr'), nextPrayerName == 'Dhuhr'),
      PrayerTimeInfo('Asr', _applyCorrection(prayers.asr, 'Asr'), nextPrayerName == 'Asr'),
      PrayerTimeInfo('Maghrib', _applyCorrection(prayers.maghrib, 'Maghrib'), nextPrayerName == 'Maghrib'),
      PrayerTimeInfo('Isha', _applyCorrection(prayers.isha, 'Isha'), nextPrayerName == 'Isha'),
    ];
  }

  /// Get sunrise for a specific date
  DateTime getSunriseForDate(DateTime date) {
    final prayers = getPrayerTimesForDate(date);
    return _applyCorrection(prayers.sunrise, 'Sunrise');
  }

  /// Get sunset for a specific date
  DateTime getSunsetForDate(DateTime date) {
    final prayers = getPrayerTimesForDate(date);
    return _applyCorrection(prayers.maghrib, 'Maghrib');
  }

  /// Get all prayer times for a month
  Future<List<DailyPrayerTimes>> getMonthPrayerTimes(int year, int month) async {
    final List<DailyPrayerTimes> monthTimes = [];
    final daysInMonth = DateTime(year, month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final prayers = getPrayerTimesForDate(date);

      monthTimes.add(DailyPrayerTimes(
        date: date,
        fajr: _applyCorrection(prayers.fajr, 'Fajr'),
        sunrise: _applyCorrection(prayers.sunrise, 'Sunrise'),
        dhuhr: _applyCorrection(prayers.dhuhr, 'Dhuhr'),
        asr: _applyCorrection(prayers.asr, 'Asr'),
        maghrib: _applyCorrection(prayers.maghrib, 'Maghrib'),
        isha: _applyCorrection(prayers.isha, 'Isha'),
      ));
    }

    return monthTimes;
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

/// Data class for daily prayer times (used in monthly/yearly tables)
class DailyPrayerTimes {
  final DateTime date;
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  DailyPrayerTimes({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });
}
