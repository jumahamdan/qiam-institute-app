import 'package:muslim_data_flutter/muslim_data_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for accessing Hisnul Muslim duas via muslim_data_flutter package.
/// Provides bookmarking, dua of the day, and category-based access.
class DuaService {
  static final DuaService _instance = DuaService._internal();
  factory DuaService() => _instance;
  DuaService._internal();

  static const String _bookmarksKey = 'dua_bookmarks';
  static const String _chapterBookmarksKey = 'dua_chapter_bookmarks';

  SharedPreferences? _prefs;
  MuslimRepository? _muslimRepo;
  List<AzkarCategory>? _categories;
  List<AzkarChapter>? _allChapters;

  Set<int> _bookmarkedChapterIds = {};
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize the service and load data.
  Future<void> initialize() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();
    _muslimRepo = MuslimRepository();

    // Load bookmarks
    _loadBookmarks();

    // Pre-load categories and chapters
    await _loadCategories();

    _isInitialized = true;
  }

  void _loadBookmarks() {
    // Load chapter-based bookmarks (new format)
    final List<String>? savedChapters =
        _prefs?.getStringList(_chapterBookmarksKey);
    if (savedChapters != null) {
      _bookmarkedChapterIds =
          savedChapters.map((s) => int.tryParse(s) ?? 0).where((id) => id > 0).toSet();
    }

    // Migrate old bookmarks if present (one-time migration)
    final List<String>? oldBookmarks = _prefs?.getStringList(_bookmarksKey);
    if (oldBookmarks != null && oldBookmarks.isNotEmpty && _bookmarkedChapterIds.isEmpty) {
      // Old format used sequential IDs, we'll skip migration since data structure changed
      // Users will need to re-bookmark after upgrade
      _prefs?.remove(_bookmarksKey);
    }
  }

  Future<void> _saveBookmarks() async {
    await _prefs?.setStringList(
      _chapterBookmarksKey,
      _bookmarkedChapterIds.map((id) => id.toString()).toList(),
    );
  }

  Future<void> _loadCategories() async {
    _categories = await _muslimRepo?.getAzkarCategories(language: Language.en);
    _allChapters = [];

    if (_categories != null) {
      for (final category in _categories!) {
        final chapters = await _muslimRepo?.getAzkarChapters(
          categoryId: category.id,
          language: Language.en,
        );
        if (chapters != null) {
          _allChapters!.addAll(chapters);
        }
      }
    }
  }

  /// Get all categories.
  List<AzkarCategory> get categories => _categories ?? [];

  /// Get all chapters (duas) across all categories.
  List<AzkarChapter> get allChapters => _allChapters ?? [];

  /// Get chapters for a specific category.
  Future<List<AzkarChapter>> getChaptersByCategory(int categoryId) async {
    return await _muslimRepo?.getAzkarChapters(
          categoryId: categoryId,
          language: Language.en,
        ) ??
        [];
  }

  /// Get items (dua content) for a specific chapter.
  Future<List<AzkarItem>> getChapterItems(int chapterId) async {
    return await _muslimRepo?.getAzkarItems(
          chapterId: chapterId,
          language: Language.en,
        ) ??
        [];
  }

  /// Get a random chapter (Dua of the Day).
  /// Uses day of year to ensure consistency throughout the day.
  AzkarChapter? getDuaOfTheDay() {
    if (_allChapters == null || _allChapters!.isEmpty) return null;

    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final index = dayOfYear % _allChapters!.length;
    return _allChapters![index];
  }

  /// Check if a chapter is bookmarked.
  bool isBookmarked(int chapterId) => _bookmarkedChapterIds.contains(chapterId);

  /// Toggle bookmark status for a chapter.
  Future<void> toggleBookmark(int chapterId) async {
    if (_bookmarkedChapterIds.contains(chapterId)) {
      _bookmarkedChapterIds.remove(chapterId);
    } else {
      _bookmarkedChapterIds.add(chapterId);
    }
    await _saveBookmarks();
  }

  /// Get all bookmarked chapters.
  Future<List<AzkarChapter>> getBookmarkedChapters() async {
    if (_bookmarkedChapterIds.isEmpty) return [];

    return await _muslimRepo?.getAzkarChaptersByIds(
          language: Language.en,
          chapterIds: _bookmarkedChapterIds.toList(),
        ) ??
        [];
  }

  /// Get count of bookmarked chapters.
  int get bookmarkCount => _bookmarkedChapterIds.length;

  /// Search chapters by name.
  List<AzkarChapter> searchChapters(String query) {
    if (_allChapters == null || query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return _allChapters!.where((chapter) {
      return chapter.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get chapter by ID.
  AzkarChapter? getChapterById(int id) {
    if (_allChapters == null || _allChapters!.isEmpty) return null;
    try {
      return _allChapters!.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get category by ID.
  AzkarCategory? getCategoryById(int id) {
    if (_categories == null || _categories!.isEmpty) return null;
    try {
      return _categories!.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get icon for a category based on its name.
  static String getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('morning') || name.contains('evening')) return '🌅';
    if (name.contains('sleep') || name.contains('waking')) return '🌙';
    if (name.contains('prayer') || name.contains('salah')) return '🕌';
    if (name.contains('food') || name.contains('eating') || name.contains('drinking')) return '🍽️';
    if (name.contains('home') || name.contains('house')) return '🏠';
    if (name.contains('travel')) return '✈️';
    if (name.contains('bathroom') || name.contains('toilet')) return '🚿';
    if (name.contains('dress') || name.contains('cloth')) return '👔';
    if (name.contains('sick') || name.contains('ill') || name.contains('pain')) return '🏥';
    if (name.contains('death') || name.contains('funeral')) return '⚱️';
    if (name.contains('rain') || name.contains('weather') || name.contains('wind')) return '🌧️';
    if (name.contains('hajj') || name.contains('umrah')) return '🕋';
    if (name.contains('fear') || name.contains('anxiety') || name.contains('distress')) return '💚';
    if (name.contains('forgive') || name.contains('repent')) return '🤲';
    if (name.contains('protect')) return '🛡️';
    if (name.contains('quran')) return '📖';
    if (name.contains('market') || name.contains('trade')) return '🏪';
    if (name.contains('debt')) return '💳';
    if (name.contains('anger')) return '😤';
    if (name.contains('mirror') || name.contains('see')) return '🪞';
    if (name.contains('good news') || name.contains('happy')) return '🎉';
    return '📿';
  }
}
