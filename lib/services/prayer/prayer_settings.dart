import 'package:shared_preferences/shared_preferences.dart';

class PrayerSettings {
  static const String _keyLocationMode = 'location_mode';
  static const String _keyLatitude = 'latitude';
  static const String _keyLongitude = 'longitude';
  static const String _keyLocationName = 'location_name';
  static const String _keyCalculationMethod = 'calculation_method';
  static const String _keyAsrMethod = 'asr_method';

  // Location modes
  static const String locationModeAuto = 'auto';
  static const String locationModeManual = 'manual';

  // Calculation methods
  static const Map<String, String> calculationMethods = {
    'isna': 'ISNA (North America)',
    'mwl': 'Muslim World League',
    'egyptian': 'Egyptian General Authority',
    'karachi': 'University of Islamic Sciences, Karachi',
    'umm_al_qura': 'Umm al-Qura University, Makkah',
    'dubai': 'Dubai',
    'qatar': 'Qatar',
    'kuwait': 'Kuwait',
    'singapore': 'Singapore',
  };

  // Asr methods
  static const Map<String, String> asrMethods = {
    'hanafi': 'Hanafi',
    'shafi': 'Shafi\'i / Hanbali / Maliki',
  };

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  // Location mode
  String get locationMode => _prefs?.getString(_keyLocationMode) ?? locationModeAuto;
  set locationMode(String value) => _prefs?.setString(_keyLocationMode, value);

  // Coordinates
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

  // Location name
  String? get locationName => _prefs?.getString(_keyLocationName);
  set locationName(String? value) {
    if (value != null) {
      _prefs?.setString(_keyLocationName, value);
    }
  }

  // Calculation method
  String get calculationMethod => _prefs?.getString(_keyCalculationMethod) ?? 'isna';
  set calculationMethod(String value) => _prefs?.setString(_keyCalculationMethod, value);

  // Asr method
  String get asrMethod => _prefs?.getString(_keyAsrMethod) ?? 'hanafi';
  set asrMethod(String value) => _prefs?.setString(_keyAsrMethod, value);

  // Get display name for current calculation method
  String get calculationMethodName => calculationMethods[calculationMethod] ?? 'ISNA (North America)';

  // Get display name for current asr method
  String get asrMethodName => asrMethods[asrMethod] ?? 'Hanafi';
}
