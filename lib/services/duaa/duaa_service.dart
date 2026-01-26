import 'package:shared_preferences/shared_preferences.dart';
import '../../models/duaa.dart';
import 'duaa_data.dart';

class DuaaService {
  static final DuaaService _instance = DuaaService._internal();
  factory DuaaService() => _instance;
  DuaaService._internal();

  static const String _bookmarksKey = 'duaa_bookmarks';

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
      _bookmarkedIds = saved.map((s) => int.tryParse(s) ?? 0).where((id) => id > 0).toSet();
    }
  }

  Future<void> _saveBookmarks() async {
    await _prefs?.setStringList(
      _bookmarksKey,
      _bookmarkedIds.map((id) => id.toString()).toList(),
    );
  }

  /// Get all duaas
  List<Duaa> get allDuaas => DuaaData.allDuaas;

  /// Get Dua of the Day (changes daily based on day of year)
  Duaa getDuaOfTheDay() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final index = dayOfYear % DuaaData.allDuaas.length;
    return DuaaData.allDuaas[index];
  }

  /// Check if a duaa is bookmarked
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

  /// Get all bookmarked duaas
  List<Duaa> getBookmarkedDuaas() {
    return DuaaData.allDuaas.where((d) => _bookmarkedIds.contains(d.id)).toList();
  }

  /// Get count of bookmarked duaas
  int get bookmarkCount => _bookmarkedIds.length;

  /// Get duaas by category
  List<Duaa> getDuaasByCategory(String category) => DuaaData.getByCategory(category);

  /// Get all duaas grouped by category
  Map<String, List<Duaa>> get groupedByCategory => DuaaData.groupedByCategory;

  /// Get duaa by ID
  Duaa? getDuaaById(int id) => DuaaData.getById(id);
}
