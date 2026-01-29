import 'package:shared_preferences/shared_preferences.dart';

import 'adhan_sounds.dart';

/// Manages adhan notification settings persistence.
class AdhanSettings {
  static final AdhanSettings _instance = AdhanSettings._internal();
  factory AdhanSettings() => _instance;
  AdhanSettings._internal();

  // SharedPreferences keys
  static const String _keyGlobalEnabled = 'adhan_global_enabled';
  static const String _keyFajrEnabled = 'adhan_fajr_enabled';
  static const String _keyDhuhrEnabled = 'adhan_dhuhr_enabled';
  static const String _keyAsrEnabled = 'adhan_asr_enabled';
  static const String _keyMaghribEnabled = 'adhan_maghrib_enabled';
  static const String _keyIshaEnabled = 'adhan_isha_enabled';

  static const String _keySelectedSound = 'adhan_selected_sound';
  static const String _keyFajrSound = 'adhan_fajr_sound';
  static const String _keyUseSeparateFajrSound = 'adhan_use_separate_fajr';

  static const String _keyPreReminderEnabled = 'adhan_pre_reminder_enabled';
  static const String _keyPreReminderMinutes = 'adhan_pre_reminder_minutes';

  static const String _keyVibrateEnabled = 'adhan_vibrate_enabled';
  static const String _keyVolume = 'adhan_volume';

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  /// Initialize the settings service.
  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  /// Global enable/disable for all adhan notifications.
  bool get isGlobalEnabled => _prefs?.getBool(_keyGlobalEnabled) ?? false;

  Future<void> setGlobalEnabled(bool value) async {
    await _prefs?.setBool(_keyGlobalEnabled, value);
  }

  /// Check if a specific prayer's adhan is enabled.
  bool isPrayerEnabled(String prayer) {
    final key = _getPrayerKey(prayer);
    return _prefs?.getBool(key) ?? true;
  }

  /// Set whether a specific prayer's adhan is enabled.
  Future<void> setPrayerEnabled(String prayer, bool value) async {
    await _prefs?.setBool(_getPrayerKey(prayer), value);
  }

  String _getPrayerKey(String prayer) {
    switch (prayer.toLowerCase()) {
      case 'fajr':
        return _keyFajrEnabled;
      case 'dhuhr':
        return _keyDhuhrEnabled;
      case 'asr':
        return _keyAsrEnabled;
      case 'maghrib':
        return _keyMaghribEnabled;
      case 'isha':
        return _keyIshaEnabled;
      default:
        return _keyFajrEnabled;
    }
  }

  /// Get all prayer enable states.
  Map<String, bool> getAllPrayerStates() {
    return {
      'Fajr': isPrayerEnabled('Fajr'),
      'Dhuhr': isPrayerEnabled('Dhuhr'),
      'Asr': isPrayerEnabled('Asr'),
      'Maghrib': isPrayerEnabled('Maghrib'),
      'Isha': isPrayerEnabled('Isha'),
    };
  }

  /// Get enabled prayers count.
  int get enabledPrayersCount {
    return getAllPrayerStates().values.where((enabled) => enabled).length;
  }

  /// Selected adhan sound ID.
  String get selectedSoundId =>
      _prefs?.getString(_keySelectedSound) ?? AdhanSoundCatalog.defaultSound.id;

  Future<void> setSelectedSound(String soundId) async {
    await _prefs?.setString(_keySelectedSound, soundId);
  }

  /// Get the selected sound object.
  AdhanSound get selectedSound =>
      AdhanSoundCatalog.getById(selectedSoundId) ??
      AdhanSoundCatalog.defaultSound;

  /// Whether to use a separate sound for Fajr.
  bool get useSeparateFajrSound =>
      _prefs?.getBool(_keyUseSeparateFajrSound) ?? false;

  /// Fajr-specific sound ID.
  String get fajrSoundId =>
      _prefs?.getString(_keyFajrSound) ??
      AdhanSoundCatalog.defaultFajrSound.id;

  /// Get the Fajr sound object.
  AdhanSound get fajrSound =>
      AdhanSoundCatalog.getById(fajrSoundId) ??
      AdhanSoundCatalog.defaultFajrSound;

  Future<void> setFajrSoundSettings(bool useSeparate, String? soundId) async {
    await _prefs?.setBool(_keyUseSeparateFajrSound, useSeparate);
    if (soundId != null) {
      await _prefs?.setString(_keyFajrSound, soundId);
    }
  }

  /// Pre-adhan reminder enabled state.
  bool get preReminderEnabled =>
      _prefs?.getBool(_keyPreReminderEnabled) ?? false;

  /// Pre-adhan reminder minutes (5, 10, 15, 20, 30).
  int get preReminderMinutes =>
      _prefs?.getInt(_keyPreReminderMinutes) ?? 10;

  Future<void> setPreReminder(bool enabled, int minutes) async {
    await _prefs?.setBool(_keyPreReminderEnabled, enabled);
    await _prefs?.setInt(_keyPreReminderMinutes, minutes);
  }

  /// Vibration enabled state.
  bool get vibrateEnabled => _prefs?.getBool(_keyVibrateEnabled) ?? true;

  Future<void> setVibrateEnabled(bool value) async {
    await _prefs?.setBool(_keyVibrateEnabled, value);
  }

  /// Adhan volume (0.0 to 1.0).
  double get volume => _prefs?.getDouble(_keyVolume) ?? 1.0;

  Future<void> setVolume(double value) async {
    await _prefs?.setDouble(_keyVolume, value.clamp(0.0, 1.0));
  }

  /// Get the sound ID for a specific prayer.
  String getSoundIdForPrayer(String prayer) {
    if (prayer.toLowerCase() == 'fajr' && useSeparateFajrSound) {
      return fajrSoundId;
    }
    return selectedSoundId;
  }

  /// Get the sound object for a specific prayer.
  AdhanSound getSoundForPrayer(String prayer) {
    final soundId = getSoundIdForPrayer(prayer);
    return AdhanSoundCatalog.getById(soundId) ?? AdhanSoundCatalog.defaultSound;
  }

  /// Available pre-reminder minute options.
  static const List<int> preReminderOptions = [5, 10, 15, 20, 30];
}
