import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Model for a Dhikr/Tasbih phrase
class Dhikr {
  final String id;
  final String arabic;
  final String transliteration;
  final String translation;
  final String virtue;
  final int defaultTarget;

  const Dhikr({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.virtue,
    this.defaultTarget = 33,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'arabic': arabic,
        'transliteration': transliteration,
        'translation': translation,
        'virtue': virtue,
        'defaultTarget': defaultTarget,
      };

  factory Dhikr.fromJson(Map<String, dynamic> json) => Dhikr(
        id: json['id'],
        arabic: json['arabic'],
        transliteration: json['transliteration'],
        translation: json['translation'],
        virtue: json['virtue'],
        defaultTarget: json['defaultTarget'] ?? 33,
      );
}

/// Model for saved Tasbih progress
class TasbihProgress {
  final String dhikrId;
  int count;
  int target;
  int totalCount; // Lifetime count
  DateTime lastUpdated;

  TasbihProgress({
    required this.dhikrId,
    this.count = 0,
    this.target = 33,
    this.totalCount = 0,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'dhikrId': dhikrId,
        'count': count,
        'target': target,
        'totalCount': totalCount,
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  factory TasbihProgress.fromJson(Map<String, dynamic> json) => TasbihProgress(
        dhikrId: json['dhikrId'],
        count: json['count'] ?? 0,
        target: json['target'] ?? 33,
        totalCount: json['totalCount'] ?? 0,
        lastUpdated: json['lastUpdated'] != null
            ? DateTime.parse(json['lastUpdated'])
            : DateTime.now(),
      );
}

/// Service for managing Tasbih/Dhikr counting
class TasbihService {
  static final TasbihService _instance = TasbihService._internal();
  factory TasbihService() => _instance;
  TasbihService._internal();

  static const String _progressKey = 'tasbih_progress';
  static const String _lastDhikrKey = 'last_dhikr_id';

  /// Predefined list of common dhikr phrases
  static const List<Dhikr> dhikrList = [
    Dhikr(
      id: 'subhanallah',
      arabic: 'سُبْحَانَ اللّٰهِ',
      transliteration: 'SubhanAllah',
      translation: 'Glory be to Allah',
      virtue: 'The Prophet (ﷺ) said: "Whoever says SubhanAllah 33 times, Alhamdulillah 33 times, and Allahu Akbar 33 times after every prayer will have his sins forgiven even if they were like the foam of the sea." (Muslim)',
      defaultTarget: 33,
    ),
    Dhikr(
      id: 'alhamdulillah',
      arabic: 'الْحَمْدُ لِلّٰهِ',
      transliteration: 'Alhamdulillah',
      translation: 'Praise be to Allah',
      virtue: 'The Prophet (ﷺ) said: "Alhamdulillah fills the scale of good deeds." (Muslim)',
      defaultTarget: 33,
    ),
    Dhikr(
      id: 'allahuakbar',
      arabic: 'اللّٰهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
      translation: 'Allah is the Greatest',
      virtue: 'The Prophet (ﷺ) said: "Two words are light on the tongue, heavy on the Scale, and beloved to the Most Merciful: SubhanAllahi wa bihamdihi, SubhanAllahil Adheem." (Bukhari & Muslim)',
      defaultTarget: 33,
    ),
    Dhikr(
      id: 'lailahaillallah',
      arabic: 'لَا إِلٰهَ إِلَّا اللّٰهُ',
      transliteration: 'La ilaha illAllah',
      translation: 'There is no god but Allah',
      virtue: 'The Prophet (ﷺ) said: "The best dhikr is La ilaha illAllah." (Tirmidhi)',
      defaultTarget: 100,
    ),
    Dhikr(
      id: 'astaghfirullah',
      arabic: 'أَسْتَغْفِرُ اللّٰهَ',
      transliteration: 'Astaghfirullah',
      translation: 'I seek forgiveness from Allah',
      virtue: 'The Prophet (ﷺ) said: "I seek Allah\'s forgiveness and repent to Him more than 70 times a day." (Bukhari)',
      defaultTarget: 100,
    ),
    Dhikr(
      id: 'subhanallahwabihamdihi',
      arabic: 'سُبْحَانَ اللّٰهِ وَبِحَمْدِهِ',
      transliteration: 'SubhanAllahi wa bihamdihi',
      translation: 'Glory and praise be to Allah',
      virtue: 'The Prophet (ﷺ) said: "Whoever says SubhanAllahi wa bihamdihi 100 times a day will have his sins forgiven even if they were like the foam of the sea." (Bukhari & Muslim)',
      defaultTarget: 100,
    ),
    Dhikr(
      id: 'lahawalawala',
      arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللّٰهِ',
      transliteration: 'La hawla wa la quwwata illa billah',
      translation: 'There is no power or strength except with Allah',
      virtue: 'The Prophet (ﷺ) said: "It is a treasure from the treasures of Paradise." (Bukhari & Muslim)',
      defaultTarget: 33,
    ),
    Dhikr(
      id: 'subhanallahiladheem',
      arabic: 'سُبْحَانَ اللّٰهِ الْعَظِيمِ',
      transliteration: 'SubhanAllahil Adheem',
      translation: 'Glory be to Allah, the Magnificent',
      virtue: 'The Prophet (ﷺ) said: "Two words are light on the tongue, heavy on the Scale: SubhanAllahi wa bihamdihi, SubhanAllahil Adheem." (Bukhari & Muslim)',
      defaultTarget: 33,
    ),
    Dhikr(
      id: 'salawat',
      arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
      transliteration: 'Allahumma salli ala Muhammad',
      translation: 'O Allah, send blessings upon Muhammad',
      virtue: 'The Prophet (ﷺ) said: "Whoever sends blessings upon me once, Allah will send blessings upon him tenfold." (Muslim)',
      defaultTarget: 100,
    ),
  ];

  /// Get all dhikr phrases
  List<Dhikr> getAllDhikr() => dhikrList;

  /// Get dhikr by ID
  Dhikr getDhikr(String id) {
    return dhikrList.firstWhere(
      (d) => d.id == id,
      orElse: () => dhikrList.first,
    );
  }

  /// Save progress for a dhikr
  Future<void> saveProgress(TasbihProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    final allProgress = await getAllProgress();

    allProgress[progress.dhikrId] = progress;

    final jsonMap = allProgress.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_progressKey, jsonEncode(jsonMap));
  }

  /// Get progress for a specific dhikr
  Future<TasbihProgress> getProgress(String dhikrId) async {
    final allProgress = await getAllProgress();
    return allProgress[dhikrId] ??
        TasbihProgress(
          dhikrId: dhikrId,
          target: getDhikr(dhikrId).defaultTarget,
        );
  }

  /// Get all saved progress
  Future<Map<String, TasbihProgress>> getAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_progressKey);
    if (jsonString == null) return {};

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return jsonMap.map((k, v) => MapEntry(k, TasbihProgress.fromJson(v)));
  }

  /// Increment count for a dhikr
  Future<TasbihProgress> increment(String dhikrId) async {
    final progress = await getProgress(dhikrId);
    progress.count++;
    progress.totalCount++;
    progress.lastUpdated = DateTime.now();
    await saveProgress(progress);
    return progress;
  }

  /// Reset count for a dhikr
  Future<TasbihProgress> resetCount(String dhikrId) async {
    final progress = await getProgress(dhikrId);
    progress.count = 0;
    progress.lastUpdated = DateTime.now();
    await saveProgress(progress);
    return progress;
  }

  /// Set target for a dhikr
  Future<TasbihProgress> setTarget(String dhikrId, int target) async {
    final progress = await getProgress(dhikrId);
    progress.target = target;
    await saveProgress(progress);
    return progress;
  }

  /// Save last used dhikr
  Future<void> saveLastDhikr(String dhikrId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastDhikrKey, dhikrId);
  }

  /// Get last used dhikr ID
  Future<String?> getLastDhikr() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastDhikrKey);
  }

  /// Get total lifetime count across all dhikr
  Future<int> getTotalLifetimeCount() async {
    final allProgress = await getAllProgress();
    int total = 0;
    for (final p in allProgress.values) {
      total += p.totalCount;
    }
    return total;
  }
}
