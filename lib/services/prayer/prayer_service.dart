import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';

class PrayerService {
  static final PrayerService _instance = PrayerService._internal();
  factory PrayerService() => _instance;
  PrayerService._internal();

  Coordinates? _coordinates;
  CalculationParameters? _params;

  void initialize({double? latitude, double? longitude}) {
    _coordinates = Coordinates(
      latitude ?? AppConstants.defaultLatitude,
      longitude ?? AppConstants.defaultLongitude,
    );

    // ISNA calculation method (North America)
    _params = CalculationMethod.north_america.getParameters();
    // Hanafi school for Asr
    _params!.madhab = Madhab.hanafi;
  }

  Coordinates get coordinates {
    if (_coordinates == null) {
      initialize();
    }
    return _coordinates!;
  }

  CalculationParameters get params {
    if (_params == null) {
      initialize();
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
      ('Sunrise', prayers.sunrise),
      ('Dhuhr', prayers.dhuhr),
      ('Asr', prayers.asr),
      ('Maghrib', prayers.maghrib),
      ('Isha', prayers.isha),
    ];

    for (final (name, time) in prayerList) {
      if (time.isAfter(now)) {
        return NextPrayerInfo(
          name: name,
          time: time,
          timeUntil: time.difference(now),
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
    );
  }

  /// Get all prayer times for today as a list
  List<PrayerTimeInfo> getTodayPrayerList() {
    final prayers = todayPrayerTimes;
    final nextPrayer = getNextPrayer();

    return [
      PrayerTimeInfo('Fajr', prayers.fajr, nextPrayer.name == 'Fajr'),
      PrayerTimeInfo('Sunrise', prayers.sunrise, nextPrayer.name == 'Sunrise'),
      PrayerTimeInfo('Dhuhr', prayers.dhuhr, nextPrayer.name == 'Dhuhr'),
      PrayerTimeInfo('Asr', prayers.asr, nextPrayer.name == 'Asr'),
      PrayerTimeInfo('Maghrib', prayers.maghrib, nextPrayer.name == 'Maghrib'),
      PrayerTimeInfo('Isha', prayers.isha, nextPrayer.name == 'Isha'),
    ];
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

  NextPrayerInfo({
    required this.name,
    required this.time,
    required this.timeUntil,
  });

  String get formattedTime => PrayerService.formatTime(time);
  String get formattedTimeUntil => PrayerService.formatDuration(timeUntil);
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
