/// Adhan sound definitions and catalog.
library;

/// Represents an adhan sound option.
class AdhanSound {
  final String id;
  final String name;
  final String nameArabic;
  final String assetPath;
  final Duration approximateDuration;
  final bool isFajrOnly;

  const AdhanSound({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.assetPath,
    required this.approximateDuration,
    this.isFajrOnly = false,
  });
}

/// Catalog of available adhan sounds.
class AdhanSoundCatalog {
  AdhanSoundCatalog._();

  /// Regular adhan sounds for all prayers.
  static const List<AdhanSound> regularSounds = [
    AdhanSound(
      id: 'makkah',
      name: 'Makkah',
      nameArabic: 'مكة المكرمة',
      assetPath: 'assets/audio/adhan/makkah.mp3',
      approximateDuration: Duration(minutes: 3, seconds: 30),
    ),
    AdhanSound(
      id: 'madinah',
      name: 'Madinah',
      nameArabic: 'المدينة المنورة',
      assetPath: 'assets/audio/adhan/madinah.mp3',
      approximateDuration: Duration(minutes: 3, seconds: 45),
    ),
    AdhanSound(
      id: 'mishary',
      name: 'Mishary Rashid Alafasy',
      nameArabic: 'مشاري راشد العفاسي',
      assetPath: 'assets/audio/adhan/mishary.mp3',
      approximateDuration: Duration(minutes: 3, seconds: 20),
    ),
    AdhanSound(
      id: 'beep',
      name: 'Short Notification',
      nameArabic: 'تنبيه قصير',
      assetPath: 'assets/audio/adhan/beep.mp3',
      approximateDuration: Duration(seconds: 5),
    ),
  ];

  /// Special Fajr adhan sounds (traditional Fajr melody).
  static const List<AdhanSound> fajrSounds = [
    AdhanSound(
      id: 'fajr_makkah',
      name: 'Fajr - Makkah',
      nameArabic: 'أذان الفجر - مكة',
      assetPath: 'assets/audio/adhan/fajr_makkah.mp3',
      approximateDuration: Duration(minutes: 4),
      isFajrOnly: true,
    ),
    AdhanSound(
      id: 'fajr_madinah',
      name: 'Fajr - Madinah',
      nameArabic: 'أذان الفجر - المدينة',
      assetPath: 'assets/audio/adhan/fajr_madinah.mp3',
      approximateDuration: Duration(minutes: 4, seconds: 15),
      isFajrOnly: true,
    ),
  ];

  /// Get all available sounds (regular + Fajr).
  static List<AdhanSound> get allSounds => [...regularSounds, ...fajrSounds];

  /// Get a sound by its ID.
  static AdhanSound? getById(String id) {
    try {
      return allSounds.firstWhere((s) => s.id == id);
    } catch (_) {
      return regularSounds.first;
    }
  }

  /// Get the default sound.
  static AdhanSound get defaultSound => regularSounds.first;

  /// Get the default Fajr sound.
  static AdhanSound get defaultFajrSound => fajrSounds.first;
}
