class Duaa {
  final int id;
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;
  final String category;

  const Duaa({
    required this.id,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
    required this.category,
  });

  Duaa copyWith({
    int? id,
    String? title,
    String? arabic,
    String? transliteration,
    String? translation,
    String? source,
    String? category,
  }) {
    return Duaa(
      id: id ?? this.id,
      title: title ?? this.title,
      arabic: arabic ?? this.arabic,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      source: source ?? this.source,
      category: category ?? this.category,
    );
  }
}

class DuaaCategory {
  static const String morningEvening = 'morning_evening';
  static const String sleep = 'sleep';
  static const String masjid = 'masjid';
  static const String food = 'food';
  static const String forgivenessGuidance = 'forgiveness_guidance';

  static String getDisplayName(String category) {
    switch (category) {
      case morningEvening:
        return 'Morning & Evening';
      case sleep:
        return 'Sleep';
      case masjid:
        return 'Masjid';
      case food:
        return 'Food';
      case forgivenessGuidance:
        return 'Forgiveness & Guidance';
      default:
        return category;
    }
  }

  static List<String> get all => [
        morningEvening,
        sleep,
        masjid,
        food,
        forgivenessGuidance,
      ];
}
