import 'package:shared_preferences/shared_preferences.dart';
import '../../models/hadith.dart';
import 'hadith_data.dart';

class HadithService {
  static final HadithService _instance = HadithService._internal();
  factory HadithService() => _instance;
  HadithService._internal();

  static const String _bookmarksKey = 'hadith_bookmarks';

  SharedPreferences? _prefs;
  Set<int> _bookmarkedIds = {};
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();
    _loadBookmarks();
    _isInitialized = true;
  }

  void _loadBookmarks() {
    final List<String>? saved = _prefs?.getStringList(_bookmarksKey);
    if (saved != null) {
      _bookmarkedIds =
          saved.map((s) => int.tryParse(s) ?? 0).where((id) => id > 0).toSet();
    }
  }

  Future<void> _saveBookmarks() async {
    await _prefs?.setStringList(
      _bookmarksKey,
      _bookmarkedIds.map((id) => id.toString()).toList(),
    );
  }

  /// Get all hadith
  List<Hadith> get allHadiths => HadithData.allHadiths;

  /// Get Hadith of the Day (changes daily based on day of year)
  Hadith getHadithOfTheDay() {
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final index = dayOfYear % HadithData.allHadiths.length;
    return HadithData.allHadiths[index];
  }

  /// Check if a hadith is bookmarked
  bool isBookmarked(int id) => _bookmarkedIds.contains(id);

  /// Toggle bookmark status
  Future<void> toggleBookmark(int id) async {
    if (_bookmarkedIds.contains(id)) {
      _bookmarkedIds.remove(id);
    } else {
      _bookmarkedIds.add(id);
    }
    await _saveBookmarks();
  }

  /// Get all bookmarked hadith
  List<Hadith> getBookmarkedHadiths() {
    return HadithData.allHadiths
        .where((h) => _bookmarkedIds.contains(h.id))
        .toList();
  }

  /// Get count of bookmarked hadith
  int get bookmarkCount => _bookmarkedIds.length;

  /// Get hadith by collection
  List<Hadith> getByCollection(String collection) =>
      HadithData.getByCollection(collection);

  /// Get hadith by topic
  List<Hadith> getByTopic(String topic) => HadithData.getByTopic(topic);

  /// Get all hadith grouped by collection
  Map<String, List<Hadith>> get groupedByCollection =>
      HadithData.groupedByCollection;

  /// Get all hadith grouped by topic
  Map<String, List<Hadith>> get groupedByTopic => HadithData.groupedByTopic;

  /// Get hadith by ID
  Hadith? getHadithById(int id) => HadithData.getById(id);

  /// Search hadith by query
  List<Hadith> search(String query) {
    if (query.isEmpty) return allHadiths;

    final lowerQuery = query.toLowerCase();
    return allHadiths.where((hadith) {
      return hadith.arabic.contains(query) ||
          hadith.transliteration.toLowerCase().contains(lowerQuery) ||
          hadith.translation.toLowerCase().contains(lowerQuery) ||
          hadith.narrator.toLowerCase().contains(lowerQuery) ||
          hadith.source.toLowerCase().contains(lowerQuery) ||
          (hadith.remarks?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Get collection count
  int getCollectionCount(String collection) =>
      getByCollection(collection).length;

  /// Get total hadith count
  int get totalCount => allHadiths.length;
}
