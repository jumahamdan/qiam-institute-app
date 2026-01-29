import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../prayer/prayer_service.dart';
import 'adhan_settings.dart';

/// Unique alarm IDs for each prayer.
class AdhanAlarmIds {
  AdhanAlarmIds._();

  static const int fajr = 1001;
  static const int dhuhr = 1002;
  static const int asr = 1003;
  static const int maghrib = 1004;
  static const int isha = 1005;

  // Pre-reminder IDs (offset by 100)
  static const int fajrReminder = 1101;
  static const int dhuhrReminder = 1102;
  static const int asrReminder = 1103;
  static const int maghribReminder = 1104;
  static const int ishaReminder = 1105;

  // Midnight reschedule
  static const int midnightReschedule = 2000;

  /// Get the alarm ID for a prayer.
  static int getIdForPrayer(String prayer) {
    switch (prayer.toLowerCase()) {
      case 'fajr':
        return fajr;
      case 'dhuhr':
        return dhuhr;
      case 'asr':
        return asr;
      case 'maghrib':
        return maghrib;
      case 'isha':
        return isha;
      default:
        return fajr;
    }
  }

  /// Get the pre-reminder alarm ID for a prayer.
  static int getReminderIdForPrayer(String prayer) {
    return getIdForPrayer(prayer) + 100;
  }

  /// Get prayer name from alarm ID.
  static String? getPrayerFromId(int id) {
    switch (id) {
      case fajr:
      case fajrReminder:
        return 'Fajr';
      case dhuhr:
      case dhuhrReminder:
        return 'Dhuhr';
      case asr:
      case asrReminder:
        return 'Asr';
      case maghrib:
      case maghribReminder:
        return 'Maghrib';
      case isha:
      case ishaReminder:
        return 'Isha';
      default:
        return null;
    }
  }
}

/// Port name for communicating between isolates.
const String adhanPortName = 'adhan_alarm_port';

/// Handles scheduling of adhan alarms.
class AdhanScheduler {
  static final AdhanScheduler _instance = AdhanScheduler._internal();
  factory AdhanScheduler() => _instance;
  AdhanScheduler._internal();

  final AdhanSettings _settings = AdhanSettings();
  bool _isInitialized = false;

  /// Receive port for alarm callbacks.
  static ReceivePort? _receivePort;

  /// Callback when an adhan alarm fires.
  static void Function(String prayer, bool isReminder)? onAdhanAlarm;

  /// Initialize the alarm manager.
  Future<void> initialize() async {
    if (_isInitialized) return;

    await AndroidAlarmManager.initialize();
    await _settings.init();

    // Set up port for receiving alarm callbacks
    _setupAlarmPort();

    _isInitialized = true;
  }

  void _setupAlarmPort() {
    // Remove existing port if any
    IsolateNameServer.removePortNameMapping(adhanPortName);

    // Create new receive port
    _receivePort = ReceivePort();

    // Register the port
    IsolateNameServer.registerPortWithName(
      _receivePort!.sendPort,
      adhanPortName,
    );

    // Listen for alarm callbacks
    _receivePort!.listen((message) {
      if (message is Map<String, dynamic>) {
        final prayer = message['prayer'] as String?;
        final isReminder = message['isReminder'] as bool? ?? false;
        if (prayer != null && onAdhanAlarm != null) {
          onAdhanAlarm!(prayer, isReminder);
        }
      }
    });
  }

  /// Schedule all adhan alarms for today.
  Future<void> scheduleAllAdhans() async {
    if (!_settings.isGlobalEnabled) {
      await cancelAllAdhans();
      return;
    }

    // Ensure prayer service is initialized
    final prayerService = PrayerService();
    if (!prayerService.isInitialized) {
      await prayerService.initialize();
    }

    final prayers = prayerService.getTodayPrayerList();
    final now = DateTime.now();

    for (final prayer in prayers) {
      if (prayer.time.isAfter(now)) {
        await _schedulePrayerAdhan(prayer.name, prayer.time);
      }
    }

    // Schedule midnight reschedule for tomorrow's prayers
    await _scheduleMidnightReschedule();

    debugPrint('AdhanScheduler: Scheduled adhans for today');
  }

  /// Schedule adhan for a specific prayer.
  Future<void> _schedulePrayerAdhan(String prayer, DateTime time) async {
    if (!_settings.isPrayerEnabled(prayer)) {
      debugPrint('AdhanScheduler: $prayer adhan disabled, skipping');
      return;
    }

    final alarmId = AdhanAlarmIds.getIdForPrayer(prayer);

    // Cancel existing alarm for this prayer
    await AndroidAlarmManager.cancel(alarmId);

    // Store prayer info for the callback
    await _storePrayerInfo(alarmId, prayer, false);

    // Schedule the adhan alarm
    final scheduled = await AndroidAlarmManager.oneShotAt(
      time,
      alarmId,
      _adhanAlarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );

    debugPrint(
      'AdhanScheduler: Scheduled $prayer adhan at $time (id=$alarmId, success=$scheduled)',
    );

    // Schedule pre-reminder if enabled
    if (_settings.preReminderEnabled) {
      final reminderTime = time.subtract(
        Duration(minutes: _settings.preReminderMinutes),
      );

      if (reminderTime.isAfter(DateTime.now())) {
        final reminderId = AdhanAlarmIds.getReminderIdForPrayer(prayer);
        await AndroidAlarmManager.cancel(reminderId);
        await _storePrayerInfo(reminderId, prayer, true);

        await AndroidAlarmManager.oneShotAt(
          reminderTime,
          reminderId,
          _preReminderCallback,
          exact: true,
          wakeup: true,
          rescheduleOnReboot: true,
        );

        debugPrint(
          'AdhanScheduler: Scheduled $prayer reminder at $reminderTime (id=$reminderId)',
        );
      }
    }
  }

  /// Store prayer info for alarm callback to retrieve.
  Future<void> _storePrayerInfo(int alarmId, String prayer, bool isReminder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adhan_alarm_$alarmId', prayer);
    await prefs.setBool('adhan_alarm_${alarmId}_reminder', isReminder);
  }

  /// Schedule midnight reschedule.
  Future<void> _scheduleMidnightReschedule() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    // Schedule at 12:05 AM to ensure date has changed
    final midnight = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 0, 5);

    await AndroidAlarmManager.cancel(AdhanAlarmIds.midnightReschedule);

    await AndroidAlarmManager.oneShotAt(
      midnight,
      AdhanAlarmIds.midnightReschedule,
      _midnightRescheduleCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );

    debugPrint('AdhanScheduler: Scheduled midnight reschedule at $midnight');
  }

  /// Cancel all adhan alarms.
  Future<void> cancelAllAdhans() async {
    for (final prayer in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']) {
      await AndroidAlarmManager.cancel(AdhanAlarmIds.getIdForPrayer(prayer));
      await AndroidAlarmManager.cancel(AdhanAlarmIds.getReminderIdForPrayer(prayer));
    }
    await AndroidAlarmManager.cancel(AdhanAlarmIds.midnightReschedule);
    debugPrint('AdhanScheduler: Cancelled all adhans');
  }

  /// Reschedule after settings change.
  Future<void> rescheduleAfterSettingsChange() async {
    await cancelAllAdhans();
    await scheduleAllAdhans();
  }

  /// Dispose resources.
  void dispose() {
    _receivePort?.close();
    IsolateNameServer.removePortNameMapping(adhanPortName);
  }
}

/// Top-level callback for adhan alarms (must be static/top-level for isolate).
@pragma('vm:entry-point')
Future<void> _adhanAlarmCallback(int id) async {
  debugPrint('AdhanScheduler: Adhan alarm fired (id=$id)');

  // Retrieve prayer info
  final prefs = await SharedPreferences.getInstance();
  final prayer = prefs.getString('adhan_alarm_$id');

  if (prayer != null) {
    // Send message to main isolate
    final port = IsolateNameServer.lookupPortByName(adhanPortName);
    port?.send({
      'prayer': prayer,
      'isReminder': false,
    });
  }
}

/// Top-level callback for pre-reminder alarms.
@pragma('vm:entry-point')
Future<void> _preReminderCallback(int id) async {
  debugPrint('AdhanScheduler: Pre-reminder alarm fired (id=$id)');

  // Retrieve prayer info
  final prefs = await SharedPreferences.getInstance();
  final prayer = prefs.getString('adhan_alarm_$id');

  if (prayer != null) {
    // Send message to main isolate
    final port = IsolateNameServer.lookupPortByName(adhanPortName);
    port?.send({
      'prayer': prayer,
      'isReminder': true,
    });
  }
}

/// Top-level callback for midnight reschedule.
@pragma('vm:entry-point')
Future<void> _midnightRescheduleCallback(int id) async {
  debugPrint('AdhanScheduler: Midnight reschedule triggered');

  // Reinitialize and reschedule
  final scheduler = AdhanScheduler();
  await scheduler.initialize();
  await scheduler.scheduleAllAdhans();
}
