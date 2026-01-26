class Duaa {
  final int id;
  final String duaNumber; // e.g., "43.1", "60.2"
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;
  final String category;
  final String? remarks; // Additional notes or context

  const Duaa({
    required this.id,
    required this.duaNumber,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
    required this.category,
    this.remarks,
  });

  Duaa copyWith({
    int? id,
    String? duaNumber,
    String? title,
    String? arabic,
    String? transliteration,
    String? translation,
    String? source,
    String? category,
    String? remarks,
  }) {
    return Duaa(
      id: id ?? this.id,
      duaNumber: duaNumber ?? this.duaNumber,
      title: title ?? this.title,
      arabic: arabic ?? this.arabic,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      source: source ?? this.source,
      category: category ?? this.category,
      remarks: remarks ?? this.remarks,
    );
  }

  /// Get formatted dua number display (e.g., "Dua no : 1.1")
  String get formattedDuaNumber => 'Dua no : $duaNumber';
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
