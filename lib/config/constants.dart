class AppConstants {
  // App info
  static const String appName = 'Qiam Institute';
  static const String appVersion = '0.1.0';

  // URLs
  static const String websiteUrl = 'https://qiaminstitute.org';
  static const String eventsUrl = 'https://qiaminstitute.org/events/';
  static const String donateUrl = 'https://qiaminstitute.org/donate-now/';
  static const String valuesUrl = 'https://qiaminstitute.org/our-values/';

  // Social Media
  static const String facebookUrl = 'https://www.facebook.com/profile.php?id=61573449077244';
  static const String instagramUrl = 'https://www.instagram.com/qiaminstitute/';
  static const String youtubeUrl = 'https://www.youtube.com/@qiaminstitute';

  // Contact
  static const String contactEmail = 'info@qiaminstitute.org';
  static const String contactPhone = '630-541-7432';
  static const String address = '900 S Frontage Rd Suite 110, Woodridge, IL 60517';

  // Location (Woodridge, IL - default)
  static const double defaultLatitude = 41.7508;
  static const double defaultLongitude = -88.0484;
  static const String defaultLocationName = 'Woodridge, IL';

  // Prayer calculation settings
  static const String calculationMethod = 'ISNA'; // North America
  static const String asrCalculation = 'Hanafi';

  // Iqamah times (minutes after adhan) - configurable
  static const Map<String, int> iqamahOffsets = {
    'Fajr': 20,
    'Dhuhr': 15,
    'Asr': 15,
    'Maghrib': 5,
    'Isha': 15,
  };
}
