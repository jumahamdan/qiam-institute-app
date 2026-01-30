import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../config/theme.dart';
import 'adhan_audio_service.dart';
import 'adhan_scheduler.dart';
import 'adhan_settings.dart';
import 'adhan_sounds.dart';

/// Main service for adhan notifications.
/// Orchestrates scheduling, audio playback, and settings.
class AdhanNotificationService {
  static final AdhanNotificationService _instance =
      AdhanNotificationService._internal();
  factory AdhanNotificationService() => _instance;
  AdhanNotificationService._internal();

  final AdhanScheduler _scheduler = AdhanScheduler();
  final AdhanSettings _settings = AdhanSettings();
  final AdhanAudioService _audioService = AdhanAudioService();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // Notification channel IDs
  static const String _adhanChannelId = 'adhan_notifications';
  static const String _reminderChannelId = 'adhan_reminders';

  // Deterministic notification IDs to avoid collision
  static const Map<String, int> _notificationIds = {
    'Fajr': 3001,
    'Dhuhr': 3002,
    'Asr': 3003,
    'Maghrib': 3004,
    'Isha': 3005,
  };

  static int _getNotificationId(String prayer) =>
      _notificationIds[prayer] ?? 3001;

  static int _getReminderNotificationId(String prayer) =>
      (_notificationIds[prayer] ?? 3001) + 100;

  /// Whether the service is initialized.
  bool get isInitialized => _isInitialized;

  /// Initialize the adhan notification service.
  Future<void> initialize() async {
    if (_isInitialized) return;

    debugPrint('AdhanNotificationService: Initializing...');

    // Initialize components
    await _settings.init();
    await _scheduler.initialize();
    await _audioService.initialize();

    // Create notification channels
    await _createNotificationChannels();

    // Set up alarm callback
    AdhanScheduler.onAdhanAlarm = _onAdhanAlarm;

    // Set up audio completion callback
    _audioService.onPlaybackComplete = _onPlaybackComplete;

    // Schedule adhans for today if enabled
    if (_settings.isGlobalEnabled) {
      await _scheduler.scheduleAllAdhans();
    }

    _isInitialized = true;
    debugPrint('AdhanNotificationService: Initialized');
  }

  Future<void> _createNotificationChannels() async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // Adhan notification channel (high importance, no sound - we play audio separately)
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _adhanChannelId,
          'Adhan Notifications',
          description: 'Prayer time adhan notifications',
          importance: Importance.max,
          playSound: false,
          enableVibration: true,
        ),
      );

      // Reminder notification channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _reminderChannelId,
          'Prayer Reminders',
          description: 'Pre-prayer reminder notifications',
          importance: Importance.high,
          playSound: true,
        ),
      );
    }
  }

  /// Called when an adhan alarm fires.
  void _onAdhanAlarm(String prayer, bool isReminder) {
    debugPrint(
      'AdhanNotificationService: Alarm fired - $prayer (reminder=$isReminder)',
    );

    if (isReminder) {
      _showPreReminder(prayer);
    } else {
      _playAdhan(prayer);
    }
  }

  /// Play adhan for a prayer.
  Future<void> _playAdhan(String prayer) async {
    // Show notification
    await _showAdhanNotification(prayer);

    // Play audio
    await _audioService.playAdhan(prayer);
  }

  /// Called when adhan playback completes.
  void _onPlaybackComplete() {
    debugPrint('AdhanNotificationService: Playback completed');
    // Could dismiss notification or update it
  }

  /// Show the adhan notification.
  Future<void> _showAdhanNotification(String prayer) async {
    const androidDetails = AndroidNotificationDetails(
      _adhanChannelId,
      'Adhan Notifications',
      channelDescription: 'Prayer time adhan notifications',
      importance: Importance.max,
      priority: Priority.max,
      icon: 'ic_notification',
      color: AppTheme.primaryColor,
      ongoing: true,
      autoCancel: false,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
    );

    await _localNotifications.show(
      _getNotificationId(prayer),
      'Adhan - $prayer',
      'It\'s time for $prayer prayer',
      const NotificationDetails(android: androidDetails),
      payload: 'adhan_$prayer',
    );
  }

  /// Show pre-reminder notification.
  Future<void> _showPreReminder(String prayer) async {
    final minutes = _settings.preReminderMinutes;

    const androidDetails = AndroidNotificationDetails(
      _reminderChannelId,
      'Prayer Reminders',
      channelDescription: 'Pre-prayer reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'ic_notification',
      color: AppTheme.primaryColor,
    );

    await _localNotifications.show(
      _getReminderNotificationId(prayer),
      'Prayer Reminder',
      '$prayer prayer in $minutes minutes',
      const NotificationDetails(android: androidDetails),
      payload: 'reminder_$prayer',
    );
  }

  /// Cancel adhan notification for a prayer.
  Future<void> cancelAdhanNotification(String prayer) async {
    await _localNotifications.cancel(_getNotificationId(prayer));
  }

  // ==================== Settings API ====================

  /// Whether adhan notifications are globally enabled.
  bool get isGlobalEnabled => _settings.isGlobalEnabled;

  /// Set whether adhan notifications are globally enabled.
  Future<void> setGlobalEnabled(bool enabled) async {
    await _settings.setGlobalEnabled(enabled);
    await _scheduler.rescheduleAfterSettingsChange();
  }

  /// Whether a specific prayer's adhan is enabled.
  bool isPrayerEnabled(String prayer) => _settings.isPrayerEnabled(prayer);

  /// Set whether a specific prayer's adhan is enabled.
  Future<void> setPrayerEnabled(String prayer, bool enabled) async {
    await _settings.setPrayerEnabled(prayer, enabled);
    await _scheduler.rescheduleAfterSettingsChange();
  }

  /// Get all prayer enable states.
  Map<String, bool> getAllPrayerStates() => _settings.getAllPrayerStates();

  /// Get enabled prayers count.
  int get enabledPrayersCount => _settings.enabledPrayersCount;

  /// Get the selected adhan sound ID.
  String get selectedSoundId => _settings.selectedSoundId;

  /// Get the selected adhan sound.
  AdhanSound get selectedSound => _settings.selectedSound;

  /// Set the selected adhan sound.
  Future<void> setSelectedSound(String soundId) async {
    await _settings.setSelectedSound(soundId);
    await _scheduler.rescheduleAfterSettingsChange();
  }

  /// Whether to use a separate sound for Fajr.
  bool get useSeparateFajrSound => _settings.useSeparateFajrSound;

  /// Get the Fajr-specific sound ID.
  String get fajrSoundId => _settings.fajrSoundId;

  /// Get the Fajr sound.
  AdhanSound get fajrSound => _settings.fajrSound;

  /// Set Fajr sound settings.
  Future<void> setFajrSoundSettings(bool useSeparate, String? soundId) async {
    await _settings.setFajrSoundSettings(useSeparate, soundId);
    await _scheduler.rescheduleAfterSettingsChange();
  }

  /// Whether pre-reminder is enabled.
  bool get preReminderEnabled => _settings.preReminderEnabled;

  /// Get pre-reminder minutes.
  int get preReminderMinutes => _settings.preReminderMinutes;

  /// Set pre-reminder settings.
  Future<void> setPreReminder(bool enabled, int minutes) async {
    await _settings.setPreReminder(enabled, minutes);
    await _scheduler.rescheduleAfterSettingsChange();
  }

  /// Whether vibration is enabled.
  bool get vibrateEnabled => _settings.vibrateEnabled;

  /// Set whether vibration is enabled.
  Future<void> setVibrateEnabled(bool enabled) async {
    await _settings.setVibrateEnabled(enabled);
  }

  /// Get the adhan volume.
  double get volume => _settings.volume;

  /// Set the adhan volume.
  Future<void> setVolume(double volume) async {
    await _settings.setVolume(volume);
    if (_audioService.isPlaying) {
      await _audioService.setVolume(volume);
    }
  }

  // ==================== Audio Control ====================

  /// Whether adhan is currently playing.
  bool get isPlaying => _audioService.isPlaying;

  /// The prayer for which adhan is currently playing.
  String? get currentPrayer => _audioService.currentPrayer;

  /// Stop the currently playing adhan.
  Future<void> stopAdhan() async {
    await _audioService.stopAdhan();
    if (_audioService.currentPrayer != null) {
      await cancelAdhanNotification(_audioService.currentPrayer!);
    }
  }

  /// Preview an adhan sound.
  Future<void> previewSound(AdhanSound sound) async {
    await _audioService.previewSound(sound);
  }

  /// Stop sound preview.
  Future<void> stopPreview() async {
    await _audioService.stopAdhan();
  }

  // ==================== Scheduling ====================

  /// Force reschedule adhans (useful after location/prayer time changes).
  Future<void> reschedule() async {
    await _scheduler.rescheduleAfterSettingsChange();
  }

  /// Cancel all scheduled adhans.
  Future<void> cancelAll() async {
    await _scheduler.cancelAllAdhans();
  }

  // ==================== Lifecycle ====================

  /// Dispose resources.
  Future<void> dispose() async {
    AdhanScheduler.onAdhanAlarm = null;
    _audioService.onPlaybackComplete = null;
    await _scheduler.dispose();
    _audioService.dispose();
  }
}
