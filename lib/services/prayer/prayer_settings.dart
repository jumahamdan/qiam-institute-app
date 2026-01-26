import 'package:shared_preferences/shared_preferences.dart';

class PrayerSettings {
  // Storage keys
  static const String _keyLocationMode = 'location_mode';
  static const String _keyAutoDetectLocation = 'auto_detect_location';
  static const String _keyLatitude = 'latitude';
  static const String _keyLongitude = 'longitude';
  static const String _keyLocationName = 'location_name';
  static const String _keyCalculationMethod = 'calculation_method';
  static const String _keyUseFixedCalculation = 'use_fixed_calculation';
  static const String _keyAsrMethod = 'asr_method';
  static const String _keyHighLatitudeRule = 'high_latitude_rule';
  static const String _keyDaylightSaving = 'daylight_saving';
  static const String _keyImsakMinutes = 'imsak_minutes';

  // Manual correction keys
  static const String _keyFajrCorrection = 'fajr_correction';
  static const String _keyDhuhrCorrection = 'dhuhr_correction';
  static const String _keyAsrCorrection = 'asr_correction';
  static const String _keyMaghribCorrection = 'maghrib_correction';
  static const String _keyIshaCorrection = 'isha_correction';
  static const String _keySunriseCorrection = 'sunrise_correction';

  // Location modes
  static const String locationModeAuto = 'auto';
  static const String locationModeManual = 'manual';

  // Calculation methods with details
  static const Map<String, CalculationMethodInfo> calculationMethods = {
    'isna': CalculationMethodInfo(
      name: 'North America (ISNA)',
      fullName: 'Islamic Society of North America',
      fajrAngle: 15.0,
      ishaAngle: 15.0,
    ),
    'mwl': CalculationMethodInfo(
      name: 'Muslim World League',
      fullName: 'Muslim World League',
      fajrAngle: 18.0,
      ishaAngle: 17.0,
    ),
    'egyptian': CalculationMethodInfo(
      name: 'Egyptian General Authority',
      fullName: 'Egyptian General Authority of Survey',
      fajrAngle: 19.5,
      ishaAngle: 17.5,
    ),
    'karachi': CalculationMethodInfo(
      name: 'Karachi',
      fullName: 'University of Islamic Sciences, Karachi',
      fajrAngle: 18.0,
      ishaAngle: 18.0,
    ),
    'umm_al_qura': CalculationMethodInfo(
      name: 'Umm Al-Qura',
      fullName: 'Umm Al-Qura University, Makkah',
      fajrAngle: 18.5,
      ishaAngle: 0.0,
      ishaMinutes: 90,
    ),
    'dubai': CalculationMethodInfo(
      name: 'Dubai, UAE',
      fullName: 'Dubai, UAE',
      fajrAngle: 18.2,
      ishaAngle: 18.2,
    ),
    'qatar': CalculationMethodInfo(
      name: 'Qatar',
      fullName: 'Qatar',
      fajrAngle: 18.0,
      ishaAngle: 0.0,
      ishaMinutes: 90,
    ),
    'kuwait': CalculationMethodInfo(
      name: 'Kuwait',
      fullName: 'Kuwait',
      fajrAngle: 18.0,
      ishaAngle: 17.5,
    ),
    'singapore': CalculationMethodInfo(
      name: 'Singapore',
      fullName: 'Singapore',
      fajrAngle: 20.0,
      ishaAngle: 18.0,
    ),
    'tehran': CalculationMethodInfo(
      name: 'Tehran',
      fullName: 'Institute of Geophysics, University of Tehran',
      fajrAngle: 17.7,
      ishaAngle: 14.0,
    ),
    'turkey': CalculationMethodInfo(
      name: 'Turkey',
      fullName: 'Diyanet İşleri Başkanlığı, Turkey',
      fajrAngle: 18.0,
      ishaAngle: 17.0,
    ),
  };

  // Asr methods
  static const Map<String, String> asrMethods = {
    'shafi': 'Shafi\'i / Maliki / Hanbali',
    'hanafi': 'Hanafi',
  };

  // High latitude rules
  static const Map<String, String> highLatitudeRules = {
    'none': 'None (for normal latitudes)',
    'middle_of_night': 'Middle of the Night',
    'one_seventh': 'One-Seventh of the Night',
    'angle_based': 'Angle-Based (recommended)',
  };

  // Daylight saving options
  static const Map<String, String> daylightSavingOptions = {
    'auto': 'Auto (System)',
    'on': 'On',
    'off': 'Off',
  };

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  // ========== Location Settings ==========

  String get locationMode => _prefs?.getString(_keyLocationMode) ?? locationModeAuto;
  set locationMode(String value) => _prefs?.setString(_keyLocationMode, value);

  bool get autoDetectLocation => _prefs?.getBool(_keyAutoDetectLocation) ?? true;
  set autoDetectLocation(bool value) => _prefs?.setBool(_keyAutoDetectLocation, value);

  double? get latitude => _prefs?.getDouble(_keyLatitude);
  set latitude(double? value) {
    if (value != null) {
      _prefs?.setDouble(_keyLatitude, value);
    }
  }

  double? get longitude => _prefs?.getDouble(_keyLongitude);
  set longitude(double? value) {
    if (value != null) {
      _prefs?.setDouble(_keyLongitude, value);
    }
  }

  String? get locationName => _prefs?.getString(_keyLocationName);
  set locationName(String? value) {
    if (value != null) {
      _prefs?.setString(_keyLocationName, value);
    }
  }

  // ========== Calculation Settings ==========

  String get calculationMethod => _prefs?.getString(_keyCalculationMethod) ?? 'isna';
  set calculationMethod(String value) => _prefs?.setString(_keyCalculationMethod, value);

  bool get useFixedCalculation => _prefs?.getBool(_keyUseFixedCalculation) ?? false;
  set useFixedCalculation(bool value) => _prefs?.setBool(_keyUseFixedCalculation, value);

  String get asrMethod => _prefs?.getString(_keyAsrMethod) ?? 'hanafi';
  set asrMethod(String value) => _prefs?.setString(_keyAsrMethod, value);

  // ========== Advanced Settings ==========

  String get highLatitudeRule => _prefs?.getString(_keyHighLatitudeRule) ?? 'angle_based';
  set highLatitudeRule(String value) => _prefs?.setString(_keyHighLatitudeRule, value);

  String get daylightSaving => _prefs?.getString(_keyDaylightSaving) ?? 'auto';
  set daylightSaving(String value) => _prefs?.setString(_keyDaylightSaving, value);

  int get imsakMinutes => _prefs?.getInt(_keyImsakMinutes) ?? 0;
  set imsakMinutes(int value) => _prefs?.setInt(_keyImsakMinutes, value);

  // ========== Manual Corrections (in minutes) ==========

  int get fajrCorrection => _prefs?.getInt(_keyFajrCorrection) ?? 0;
  set fajrCorrection(int value) => _prefs?.setInt(_keyFajrCorrection, value);

  int get sunriseCorrection => _prefs?.getInt(_keySunriseCorrection) ?? 0;
  set sunriseCorrection(int value) => _prefs?.setInt(_keySunriseCorrection, value);

  int get dhuhrCorrection => _prefs?.getInt(_keyDhuhrCorrection) ?? 0;
  set dhuhrCorrection(int value) => _prefs?.setInt(_keyDhuhrCorrection, value);

  int get asrCorrection => _prefs?.getInt(_keyAsrCorrection) ?? 0;
  set asrCorrection(int value) => _prefs?.setInt(_keyAsrCorrection, value);

  int get maghribCorrection => _prefs?.getInt(_keyMaghribCorrection) ?? 0;
  set maghribCorrection(int value) => _prefs?.setInt(_keyMaghribCorrection, value);

  int get ishaCorrection => _prefs?.getInt(_keyIshaCorrection) ?? 0;
  set ishaCorrection(int value) => _prefs?.setInt(_keyIshaCorrection, value);

  Map<String, int> get allCorrections => {
    'Fajr': fajrCorrection,
    'Sunrise': sunriseCorrection,
    'Dhuhr': dhuhrCorrection,
    'Asr': asrCorrection,
    'Maghrib': maghribCorrection,
    'Isha': ishaCorrection,
  };

  void setCorrection(String prayer, int minutes) {
    switch (prayer) {
      case 'Fajr': fajrCorrection = minutes; break;
      case 'Sunrise': sunriseCorrection = minutes; break;
      case 'Dhuhr': dhuhrCorrection = minutes; break;
      case 'Asr': asrCorrection = minutes; break;
      case 'Maghrib': maghribCorrection = minutes; break;
      case 'Isha': ishaCorrection = minutes; break;
    }
  }

  // ========== Helper Methods ==========

  CalculationMethodInfo? get currentMethodInfo => calculationMethods[calculationMethod];
  String get calculationMethodName => currentMethodInfo?.name ?? 'ISNA (North America)';
  String get asrMethodName => asrMethods[asrMethod] ?? 'Hanafi';
  String get highLatitudeRuleName => highLatitudeRules[highLatitudeRule] ?? 'Angle-Based';
  String get daylightSavingName => daylightSavingOptions[daylightSaving] ?? 'Auto';
}

class CalculationMethodInfo {
  final String name;
  final String fullName;
  final double fajrAngle;
  final double ishaAngle;
  final int? ishaMinutes; // Some methods use minutes after Maghrib instead of angle

  const CalculationMethodInfo({
    required this.name,
    required this.fullName,
    required this.fajrAngle,
    required this.ishaAngle,
    this.ishaMinutes,
  });

  String get anglesDisplay {
    if (ishaMinutes != null) {
      return 'Fajr: ${fajrAngle.toStringAsFixed(1)}° / Isha: ${ishaMinutes}min';
    }
    return 'Fajr: ${fajrAngle.toStringAsFixed(1)}° / Isha: ${ishaAngle.toStringAsFixed(1)}°';
  }
}
