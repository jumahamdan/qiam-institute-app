import 'package:flutter_test/flutter_test.dart';
import 'package:qiam_institute_app/services/quran/quran_service.dart';

void main() {
  group('QuranService', () {
    late QuranService service;

    setUp(() {
      service = QuranService();
    });

    test('should have 114 surahs', () {
      final surahs = service.getAllSurahs();
      expect(surahs.length, 114);
    });

    test('first surah should be Al-Fatiha', () {
      final surah = service.getSurah(1);
      expect(surah.number, 1);
      expect(surah.nameEnglish, 'The Opening');
      expect(surah.verseCount, 7);
    });

    test('last surah should be An-Nas', () {
      final surah = service.getSurah(114);
      expect(surah.number, 114);
      expect(surah.nameEnglish, 'Mankind');
      expect(surah.verseCount, 6);
    });

    test('getSurah returns correct surah info', () {
      // Al-Baqarah
      final surah2 = service.getSurah(2);
      expect(surah2.number, 2);
      expect(surah2.verseCount, 286); // Longest surah

      // Yasin
      final surah36 = service.getSurah(36);
      expect(surah36.number, 36);
      expect(surah36.nameEnglish, 'Ya Sin');
    });

    test('Al-Kawthar should be shortest surah (3 verses)', () {
      final surah = service.getSurah(108);
      expect(surah.nameEnglish, 'Abundance');
      expect(surah.verseCount, 3);
    });

    test('getSurahVerses returns correct number of verses', () {
      // Al-Fatiha has 7 verses
      final verses = service.getSurahVerses(1);
      expect(verses.length, 7);

      // Al-Ikhlas has 4 verses
      final ikhlas = service.getSurahVerses(112);
      expect(ikhlas.length, 4);
    });

    test('getVerse returns correct verse data', () {
      final verse = service.getVerse(1, 1);
      expect(verse.surahNumber, 1);
      expect(verse.verseNumber, 1);
      expect(verse.textArabic.isNotEmpty, true);
      expect(verse.translation.isNotEmpty, true);
    });

    test('getBasmala returns non-empty string', () {
      final basmala = service.getBasmala();
      expect(basmala.isNotEmpty, true);
      expect(basmala.contains('بِسْمِ'), true);
    });

    test('surahHasBasmala returns false only for At-Tawbah', () {
      // At-Tawbah (surah 9) is the only one without Basmala
      expect(service.surahHasBasmala(9), false);

      // All others should have it
      expect(service.surahHasBasmala(1), true);
      expect(service.surahHasBasmala(2), true);
      expect(service.surahHasBasmala(114), true);
    });

    test('all surahs should have valid revelation type', () {
      final surahs = service.getAllSurahs();
      for (final surah in surahs) {
        // The quran package returns 'Makkah' or 'Madinah'
        expect(
          surah.revelationType == 'Makkah' || surah.revelationType == 'Madinah',
          true,
          reason: 'Surah ${surah.number} should be Makkah or Madinah, got: ${surah.revelationType}',
        );
      }
    });

    test('all surahs should have non-empty names', () {
      final surahs = service.getAllSurahs();
      for (final surah in surahs) {
        expect(surah.nameArabic.isNotEmpty, true,
            reason: 'Surah ${surah.number} should have Arabic name');
        expect(surah.nameEnglish.isNotEmpty, true,
            reason: 'Surah ${surah.number} should have English name');
        expect(surah.nameTransliteration.isNotEmpty, true,
            reason: 'Surah ${surah.number} should have transliteration');
      }
    });

    test('getJuzNumber returns valid juz', () {
      // First verse of Al-Baqarah should be in Juz 1
      expect(service.getJuzNumber(2, 1), 1);

      // Last verse of Al-Baqarah (2:286) should be in Juz 3
      expect(service.getJuzNumber(2, 286), 3);
    });

    test('getPageNumber returns positive page number', () {
      final page = service.getPageNumber(1, 1);
      expect(page > 0, true);
    });
  });

  group('Surah model', () {
    test('should create valid instance', () {
      final surah = Surah(
        number: 1,
        nameArabic: 'الفاتحة',
        nameEnglish: 'The Opening',
        nameTransliteration: 'Al-Fatiha',
        verseCount: 7,
        revelationType: 'Meccan',
      );

      expect(surah.number, 1);
      expect(surah.nameArabic, 'الفاتحة');
      expect(surah.nameEnglish, 'The Opening');
      expect(surah.verseCount, 7);
    });
  });

  group('Verse model', () {
    test('should create valid instance', () {
      final verse = Verse(
        surahNumber: 1,
        verseNumber: 1,
        textArabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        translation: 'In the name of Allah, the Most Gracious, the Most Merciful',
        isSajdah: false,
        juzNumber: 1,
      );

      expect(verse.surahNumber, 1);
      expect(verse.verseNumber, 1);
      expect(verse.isSajdah, false);
      expect(verse.juzNumber, 1);
    });
  });
}
