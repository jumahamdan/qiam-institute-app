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
  // Original categories
  static const String morningEvening = 'morning_evening';
  static const String sleep = 'sleep';
  static const String masjid = 'masjid';
  static const String food = 'food';
  static const String forgivenessGuidance = 'forgiveness_guidance';

  // New categories
  static const String travel = 'travel';
  static const String home = 'home';
  static const String bathroom = 'bathroom';
  static const String wudu = 'wudu';
  static const String anxietyDistress = 'anxiety_distress';
  static const String protection = 'protection';
  static const String healthSickness = 'health_sickness';
  static const String clothing = 'clothing';
  static const String quranic = 'quranic';

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
      case travel:
        return 'Travel';
      case home:
        return 'Home';
      case bathroom:
        return 'Bathroom';
      case wudu:
        return 'Wudu (Ablution)';
      case anxietyDistress:
        return 'Anxiety & Distress';
      case protection:
        return 'Protection';
      case healthSickness:
        return 'Health & Sickness';
      case clothing:
        return 'Clothing';
      case quranic:
        return 'Quranic Duas';
      default:
        return category;
    }
  }

  /// Get icon for each category
  static String getIcon(String category) {
    switch (category) {
      case morningEvening:
        return '🌅';
      case sleep:
        return '🌙';
      case masjid:
        return '🕌';
      case food:
        return '🍽️';
      case forgivenessGuidance:
        return '🤲';
      case travel:
        return '✈️';
      case home:
        return '🏠';
      case bathroom:
        return '🚿';
      case wudu:
        return '💧';
      case anxietyDistress:
        return '💚';
      case protection:
        return '🛡️';
      case healthSickness:
        return '🏥';
      case clothing:
        return '👔';
      case quranic:
        return '📖';
      default:
        return '📿';
    }
  }

  static List<String> get all => [
        morningEvening,
        sleep,
        masjid,
        food,
        forgivenessGuidance,
        travel,
        home,
        bathroom,
        wudu,
        anxietyDistress,
        protection,
        healthSickness,
        clothing,
        quranic,
      ];
}
