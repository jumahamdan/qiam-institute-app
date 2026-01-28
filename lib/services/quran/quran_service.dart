import 'package:quran/quran.dart' as quran;
import 'package:shared_preferences/shared_preferences.dart';

/// Model for a Surah
class Surah {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String nameTransliteration;
  final int verseCount;
  final String revelationType;

  Surah({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTransliteration,
    required this.verseCount,
    required this.revelationType,
  });
}

/// Model for a Verse
class Verse {
  final int surahNumber;
  final int verseNumber;
  final String textArabic;
  final String translation;
  final bool isSajdah;
  final int juzNumber;

  Verse({
    required this.surahNumber,
    required this.verseNumber,
    required this.textArabic,
    required this.translation,
    required this.isSajdah,
    required this.juzNumber,
  });
}

/// Service for Quran data access
class QuranService {
  static final QuranService _instance = QuranService._internal();
  factory QuranService() => _instance;
  QuranService._internal();

  static const String _lastReadSurahKey = 'quran_last_read_surah';
  static const String _lastReadVerseKey = 'quran_last_read_verse';
  static const String _bookmarksKey = 'quran_bookmarks';

  // Total number of surahs in Quran
  static const int totalSurahs = 114;

  /// Get all surahs
  List<Surah> getAllSurahs() {
    final surahs = <Surah>[];
    for (int i = 1; i <= totalSurahs; i++) {
      surahs.add(getSurah(i));
    }
    return surahs;
  }

  /// Get a specific surah
  Surah getSurah(int surahNumber) {
    return Surah(
      number: surahNumber,
      nameArabic: quran.getSurahNameArabic(surahNumber),
      nameEnglish: quran.getSurahNameEnglish(surahNumber),
      nameTransliteration: quran.getSurahName(surahNumber),
      verseCount: quran.getVerseCount(surahNumber),
      revelationType: quran.getPlaceOfRevelation(surahNumber),
    );
  }

  /// Get all verses of a surah
  List<Verse> getSurahVerses(int surahNumber) {
    final verses = <Verse>[];
    final verseCount = quran.getVerseCount(surahNumber);

    for (int i = 1; i <= verseCount; i++) {
      verses.add(getVerse(surahNumber, i));
    }
    return verses;
  }

  /// Get a specific verse
  Verse getVerse(int surahNumber, int verseNumber) {
    return Verse(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
      textArabic: quran.getVerse(surahNumber, verseNumber, verseEndSymbol: true),
      translation: quran.getVerseTranslation(surahNumber, verseNumber),
      isSajdah: quran.isSajdahVerse(surahNumber, verseNumber),
      juzNumber: quran.getJuzNumber(surahNumber, verseNumber),
    );
  }

  /// Get Basmala text
  String getBasmala() {
    return quran.basmala;
  }

  /// Check if surah starts with Basmala (all except At-Tawbah)
  bool surahHasBasmala(int surahNumber) {
    return surahNumber != 9; // At-Tawbah doesn't start with Basmala
  }

  /// Get Juz number for a verse
  int getJuzNumber(int surahNumber, int verseNumber) {
    return quran.getJuzNumber(surahNumber, verseNumber);
  }

  /// Get page number for a verse
  int getPageNumber(int surahNumber, int verseNumber) {
    return quran.getPageNumber(surahNumber, verseNumber);
  }

  /// Save last read position
  Future<void> saveLastReadPosition(int surahNumber, int verseNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastReadSurahKey, surahNumber);
    await prefs.setInt(_lastReadVerseKey, verseNumber);
  }

  /// Get last read position
  Future<Map<String, int>?> getLastReadPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final surah = prefs.getInt(_lastReadSurahKey);
    final verse = prefs.getInt(_lastReadVerseKey);

    if (surah != null && verse != null) {
      return {'surah': surah, 'verse': verse};
    }
    return null;
  }

  /// Get bookmarked verses
  Future<List<String>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_bookmarksKey) ?? [];
  }

  /// Add bookmark (format: "surah:verse")
  Future<void> addBookmark(int surahNumber, int verseNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    final key = '$surahNumber:$verseNumber';
    if (!bookmarks.contains(key)) {
      bookmarks.add(key);
      await prefs.setStringList(_bookmarksKey, bookmarks);
    }
  }

  /// Remove bookmark
  Future<void> removeBookmark(int surahNumber, int verseNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    final key = '$surahNumber:$verseNumber';
    bookmarks.remove(key);
    await prefs.setStringList(_bookmarksKey, bookmarks);
  }

  /// Check if verse is bookmarked
  Future<bool> isBookmarked(int surahNumber, int verseNumber) async {
    final bookmarks = await getBookmarks();
    return bookmarks.contains('$surahNumber:$verseNumber');
  }
}
