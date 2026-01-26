class AppConstants {
  // App info
  static const String appName = 'Qiam Institute';
  static const String appVersion = '0.1.0';

  // URLs
  static const String websiteUrl = 'https://qiaminstitute.org';
  static const String eventsUrl = 'https://qiaminstitute.org/events/';
  static const String donateUrl = 'https://qiaminstitute.org/donate-now/';
  static const String valuesUrl = 'https://qiaminstitute.org/our-values/';
  static const String introVideoUrl = 'https://www.youtube.com/watch?v=9qcNe2NSThE';
  static const String introVideoThumbnail = 'https://img.youtube.com/vi/9qcNe2NSThE/hqdefault.jpg';

  // Directions
  static const String directionsUrl = 'https://www.google.com/maps/dir/?api=1&destination=900+S+Frontage+Rd+Suite+110+Woodridge+IL+60517';
  static const String mapsUrl = 'https://www.google.com/maps/place/900+S+Frontage+Rd+Suite+110,+Woodridge,+IL+60517';

  // Social Media
  static const String facebookUrl = 'https://www.facebook.com/profile.php?id=61573449077244';
  static const String instagramUrl = 'https://www.instagram.com/qiaminstitute/';
  static const String youtubeUrl = 'https://www.youtube.com/@qiaminstitute';
  static const String twitterUrl = 'https://twitter.com/qiaminstitute';
  static const String tiktokUrl = 'https://www.tiktok.com/@qiaminstitute';
  static const String flickrUrl = 'https://www.flickr.com/photos/qiaminstitute';
  static const String whatsappUrl = 'https://chat.whatsapp.com/EbYUte2kXpW1LFTbUH1rBi';

  // Contact
  static const String contactEmail = 'info@qiaminstitute.org';
  static const String contactPhone = '630-541-7432';
  static const String address = '900 S Frontage Rd Suite 110, Woodridge, IL 60517';

  // Form submission endpoint (Formspree)
  // Create a free form at https://formspree.io and paste your form ID here
  static const String formspreeEndpoint = 'https://formspree.io/f/YOUR_FORM_ID';

  // Google Places API Key (optional - app uses free OpenStreetMap by default)
  // Only needed if you want to use Google Places instead of OpenStreetMap
  static const String googlePlacesApiKey = 'YOUR_GOOGLE_PLACES_API_KEY';

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
