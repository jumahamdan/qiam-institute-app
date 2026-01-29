import 'package:flutter_test/flutter_test.dart';
import 'package:qiam_institute_app/models/hadith.dart';
import 'package:qiam_institute_app/services/hadith/hadith_data.dart';

void main() {
  group('Hadith model', () {
    test('should create valid instance with all required fields', () {
      const hadith = Hadith(
        id: 1,
        hadithNumber: '1',
        narrator: 'Umar ibn Al-Khattab (RA)',
        arabic: 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ',
        transliteration: 'Innamal-a\'malu bin-niyyat',
        translation: 'Actions are judged by intentions',
        source: 'Sahih Al-Bukhari 1',
        collection: HadithCollection.nawawi,
        grade: HadithGrade.sahih,
      );

      expect(hadith.id, 1);
      expect(hadith.hadithNumber, '1');
      expect(hadith.narrator, 'Umar ibn Al-Khattab (RA)');
      expect(hadith.topic, isNull);
      expect(hadith.remarks, isNull);
    });

    test('should create valid instance with optional fields', () {
      const hadith = Hadith(
        id: 1,
        hadithNumber: '1',
        narrator: 'Test Narrator',
        arabic: 'Arabic text',
        transliteration: 'Transliteration',
        translation: 'Translation',
        source: 'Test Source',
        collection: HadithCollection.bukhari,
        grade: HadithGrade.sahih,
        topic: HadithTopic.intentions,
        remarks: 'Test remarks',
      );

      expect(hadith.topic, HadithTopic.intentions);
      expect(hadith.remarks, 'Test remarks');
    });

    test('formattedNumber should return correct format', () {
      const hadith = Hadith(
        id: 1,
        hadithNumber: '42',
        narrator: 'Test',
        arabic: '',
        transliteration: '',
        translation: '',
        source: '',
        collection: HadithCollection.nawawi,
        grade: HadithGrade.sahih,
      );

      expect(hadith.formattedNumber, 'Hadith #42');
    });

    test('copyWith should create new instance with updated fields', () {
      const original = Hadith(
        id: 1,
        hadithNumber: '1',
        narrator: 'Original Narrator',
        arabic: 'Original Arabic',
        transliteration: 'Original',
        translation: 'Original translation',
        source: 'Original source',
        collection: HadithCollection.nawawi,
        grade: HadithGrade.sahih,
      );

      final copied = original.copyWith(
        narrator: 'Updated Narrator',
        remarks: 'New remarks',
      );

      expect(copied.id, 1); // Unchanged
      expect(copied.narrator, 'Updated Narrator'); // Changed
      expect(copied.remarks, 'New remarks'); // Added
      expect(copied.arabic, 'Original Arabic'); // Unchanged
    });
  });

  group('HadithCollection', () {
    test('should have at least 3 collections', () {
      expect(HadithCollection.all.length, greaterThanOrEqualTo(3));
    });

    test('getDisplayName should return human-readable names', () {
      expect(HadithCollection.getDisplayName(HadithCollection.nawawi),
          '40 Nawawi');
      expect(HadithCollection.getDisplayName(HadithCollection.bukhari),
          'Sahih Bukhari');
      expect(HadithCollection.getDisplayName(HadithCollection.muslim),
          'Sahih Muslim');
    });

    test('getDisplayName should return collection itself for unknown', () {
      expect(HadithCollection.getDisplayName('unknown'), 'unknown');
    });

    test('getArabicName should return Arabic names', () {
      expect(HadithCollection.getArabicName(HadithCollection.nawawi),
          'الأربعون النووية');
      expect(HadithCollection.getArabicName(HadithCollection.bukhari),
          'صحيح البخاري');
      expect(HadithCollection.getArabicName(HadithCollection.muslim),
          'صحيح مسلم');
    });

    test('getIcon should return emoji for each collection', () {
      expect(HadithCollection.getIcon(HadithCollection.nawawi), '📜');
      expect(HadithCollection.getIcon(HadithCollection.bukhari), '📗');
      expect(HadithCollection.getIcon(HadithCollection.muslim), '📕');
    });

    test('getIcon should return default emoji for unknown', () {
      expect(HadithCollection.getIcon('unknown'), '📖');
    });

    test('all collections should have display names', () {
      for (final collection in HadithCollection.all) {
        final displayName = HadithCollection.getDisplayName(collection);
        expect(displayName.isNotEmpty, true,
            reason: 'Collection $collection should have display name');
        expect(displayName != collection, true,
            reason: 'Collection $collection display name should differ from key');
      }
    });
  });

  group('HadithGrade', () {
    test('should have at least 3 grades', () {
      expect(HadithGrade.all.length, greaterThanOrEqualTo(3));
    });

    test('getDisplayName should return human-readable names', () {
      expect(HadithGrade.getDisplayName(HadithGrade.sahih), 'Sahih (Authentic)');
      expect(HadithGrade.getDisplayName(HadithGrade.hasan), 'Hasan (Good)');
      expect(HadithGrade.getDisplayName(HadithGrade.daif), 'Da\'if (Weak)');
    });

    test('getShortName should return short names', () {
      expect(HadithGrade.getShortName(HadithGrade.sahih), 'Sahih');
      expect(HadithGrade.getShortName(HadithGrade.hasan), 'Hasan');
      expect(HadithGrade.getShortName(HadithGrade.daif), 'Da\'if');
    });

    test('getColor should return color for each grade', () {
      expect(HadithGrade.getColor(HadithGrade.sahih), isNotNull);
      expect(HadithGrade.getColor(HadithGrade.hasan), isNotNull);
      expect(HadithGrade.getColor(HadithGrade.daif), isNotNull);
    });
  });

  group('HadithTopic', () {
    test('should have at least 10 topics', () {
      expect(HadithTopic.all.length, greaterThanOrEqualTo(10));
    });

    test('getDisplayName should return human-readable names', () {
      expect(HadithTopic.getDisplayName(HadithTopic.intentions), 'Intentions');
      expect(HadithTopic.getDisplayName(HadithTopic.faith), 'Faith (Iman)');
      expect(HadithTopic.getDisplayName(HadithTopic.prayer), 'Prayer (Salah)');
      expect(HadithTopic.getDisplayName(HadithTopic.fasting), 'Fasting (Sawm)');
    });

    test('getIcon should return emoji for each topic', () {
      expect(HadithTopic.getIcon(HadithTopic.intentions), '💭');
      expect(HadithTopic.getIcon(HadithTopic.faith), '💎');
      expect(HadithTopic.getIcon(HadithTopic.prayer), '🤲');
      expect(HadithTopic.getIcon(HadithTopic.fasting), '🌙');
    });

    test('getIcon should return default emoji for unknown', () {
      expect(HadithTopic.getIcon('unknown'), '📿');
    });

    test('all topics should have display names', () {
      for (final topic in HadithTopic.all) {
        final displayName = HadithTopic.getDisplayName(topic);
        expect(displayName.isNotEmpty, true,
            reason: 'Topic $topic should have display name');
      }
    });

    test('all topics should have icons', () {
      for (final topic in HadithTopic.all) {
        final icon = HadithTopic.getIcon(topic);
        expect(icon.isNotEmpty, true,
            reason: 'Topic $topic should have icon');
        expect(icon != '📿', true,
            reason: 'Topic $topic should have specific icon');
      }
    });
  });

  group('HadithData', () {
    test('should have at least 60 hadiths', () {
      expect(HadithData.allHadiths.length, greaterThanOrEqualTo(60));
    });

    test('all hadiths should have unique IDs', () {
      final ids = HadithData.allHadiths.map((h) => h.id).toSet();
      expect(ids.length, HadithData.allHadiths.length);
    });

    test('all hadiths should have required fields populated', () {
      for (final hadith in HadithData.allHadiths) {
        expect(hadith.id > 0, true, reason: 'Hadith should have positive ID');
        expect(hadith.hadithNumber.isNotEmpty, true,
            reason: 'Hadith ${hadith.id} should have hadith number');
        expect(hadith.narrator.isNotEmpty, true,
            reason: 'Hadith ${hadith.id} should have narrator');
        expect(hadith.arabic.isNotEmpty, true,
            reason: 'Hadith ${hadith.id} should have Arabic text');
        expect(hadith.transliteration.isNotEmpty, true,
            reason: 'Hadith ${hadith.id} should have transliteration');
        expect(hadith.translation.isNotEmpty, true,
            reason: 'Hadith ${hadith.id} should have translation');
        expect(hadith.source.isNotEmpty, true,
            reason: 'Hadith ${hadith.id} should have source');
      }
    });

    test('getByCollection should return hadiths for valid collection', () {
      final nawawi = HadithData.getByCollection(HadithCollection.nawawi);
      expect(nawawi.isNotEmpty, true);
      expect(
        nawawi.every((h) => h.collection == HadithCollection.nawawi),
        true,
      );
    });

    test('getByCollection should return empty for invalid collection', () {
      final invalid = HadithData.getByCollection('invalid_collection');
      expect(invalid, isEmpty);
    });

    test('getByTopic should return hadiths for valid topic', () {
      final intentions = HadithData.getByTopic(HadithTopic.intentions);
      expect(intentions.isNotEmpty, true);
      expect(
        intentions.every((h) => h.topic == HadithTopic.intentions),
        true,
      );
    });

    test('getById should return correct hadith', () {
      final hadith = HadithData.getById(1);
      expect(hadith, isNotNull);
      expect(hadith!.id, 1);
    });

    test('getById should return null for invalid ID', () {
      final hadith = HadithData.getById(-1);
      expect(hadith, isNull);

      final hadith999 = HadithData.getById(9999);
      expect(hadith999, isNull);
    });

    test('groupedByCollection should have collections with hadiths', () {
      final grouped = HadithData.groupedByCollection;
      expect(grouped.isNotEmpty, true);

      for (final entry in grouped.entries) {
        expect(entry.value.isNotEmpty, true,
            reason: 'Collection ${entry.key} should have hadiths');
      }
    });

    test('groupedByTopic should have topics with hadiths', () {
      final grouped = HadithData.groupedByTopic;
      expect(grouped.isNotEmpty, true);

      for (final entry in grouped.entries) {
        expect(entry.value.isNotEmpty, true,
            reason: 'Topic ${entry.key} should have hadiths');
      }
    });

    test('should have 42 Nawawi hadiths', () {
      final nawawi = HadithData.getByCollection(HadithCollection.nawawi);
      expect(nawawi.length, 42);
    });

    test('should have hadiths from main collections', () {
      final mainCollections = [
        HadithCollection.nawawi,
        HadithCollection.bukhari,
        HadithCollection.muslim,
      ];

      for (final collection in mainCollections) {
        final hadiths = HadithData.getByCollection(collection);
        expect(hadiths.isNotEmpty, true,
            reason: 'Should have hadiths for $collection');
      }
    });
  });
}
