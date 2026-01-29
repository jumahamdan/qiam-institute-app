import 'package:flutter_test/flutter_test.dart';
import 'package:qiam_institute_app/models/hadith.dart';
import 'package:qiam_institute_app/services/hadith/hadith_service.dart';
import 'package:qiam_institute_app/services/hadith/hadith_data.dart';

void main() {
  group('HadithService', () {
    late HadithService service;

    setUp(() {
      service = HadithService();
    });

    test('should return all hadiths', () {
      expect(service.allHadiths.length, HadithData.allHadiths.length);
    });

    test('totalCount should match data length', () {
      expect(service.totalCount, HadithData.allHadiths.length);
    });

    test('getHadithOfTheDay should return a hadith', () {
      final hadith = service.getHadithOfTheDay();
      expect(hadith, isNotNull);
      expect(hadith.id, greaterThan(0));
    });

    test('getHadithOfTheDay should be deterministic for the same day', () {
      final hadith1 = service.getHadithOfTheDay();
      final hadith2 = service.getHadithOfTheDay();
      expect(hadith1.id, hadith2.id);
    });

    test('search should find hadiths by Arabic text', () {
      final results = service.search('الْأَعْمَالُ');
      expect(results.isNotEmpty, true);
    });

    test('search should find hadiths by translation', () {
      final results = service.search('intentions');
      expect(results.isNotEmpty, true);
    });

    test('search should find hadiths by narrator', () {
      final results = service.search('Abu Hurairah');
      expect(results.isNotEmpty, true);
    });

    test('search should be case insensitive', () {
      final results1 = service.search('INTENTIONS');
      final results2 = service.search('intentions');
      expect(results1.length, results2.length);
    });

    test('search should return all hadiths for empty query', () {
      final results = service.search('');
      expect(results.length, service.totalCount);
    });

    test('search should return empty for non-matching query', () {
      final results = service.search('xyznonexistentquery123');
      expect(results, isEmpty);
    });

    test('getByCollection should return hadiths for valid collection', () {
      final nawawi = service.getByCollection(HadithCollection.nawawi);
      expect(nawawi.isNotEmpty, true);
      expect(
        nawawi.every((h) => h.collection == HadithCollection.nawawi),
        true,
      );
    });

    test('getByTopic should return hadiths for valid topic', () {
      final faith = service.getByTopic(HadithTopic.faith);
      expect(faith.isNotEmpty, true);
      expect(
        faith.every((h) => h.topic == HadithTopic.faith),
        true,
      );
    });

    test('getCollectionCount should return correct count', () {
      final count = service.getCollectionCount(HadithCollection.nawawi);
      final hadiths = service.getByCollection(HadithCollection.nawawi);
      expect(count, hadiths.length);
    });

    test('groupedByCollection should have all active collections', () {
      final grouped = service.groupedByCollection;
      expect(grouped.containsKey(HadithCollection.nawawi), true);
    });

    test('groupedByTopic should have topics with hadiths', () {
      final grouped = service.groupedByTopic;
      expect(grouped.isNotEmpty, true);
    });

    test('getHadithById should return correct hadith', () {
      final hadith = service.getHadithById(1);
      expect(hadith, isNotNull);
      expect(hadith!.id, 1);
    });

    test('getHadithById should return null for invalid ID', () {
      final hadith = service.getHadithById(-1);
      expect(hadith, isNull);

      final hadith999 = service.getHadithById(9999);
      expect(hadith999, isNull);
    });
  });

  group('HadithService singleton', () {
    test('should return same instance', () {
      final service1 = HadithService();
      final service2 = HadithService();
      expect(identical(service1, service2), true);
    });
  });

  group('HadithService data integrity', () {
    late HadithService service;

    setUp(() {
      service = HadithService();
    });

    test('all hadiths should have valid grades', () {
      for (final hadith in service.allHadiths) {
        expect(
          [HadithGrade.sahih, HadithGrade.hasan, HadithGrade.daif, HadithGrade.unknown]
              .contains(hadith.grade),
          true,
          reason: 'Hadith ${hadith.id} should have valid grade',
        );
      }
    });

    test('Nawawi collection should have 42 hadiths', () {
      final nawawi = service.getByCollection(HadithCollection.nawawi);
      expect(nawawi.length, 42);
    });

    test('hadith numbers should be unique within collections', () {
      final grouped = service.groupedByCollection;
      for (final entry in grouped.entries) {
        final numbers = entry.value.map((h) => h.hadithNumber).toSet();
        expect(
          numbers.length,
          entry.value.length,
          reason: 'Collection ${entry.key} should have unique hadith numbers',
        );
      }
    });

    test('all hadiths with topics should have valid topics', () {
      for (final hadith in service.allHadiths) {
        if (hadith.topic != null) {
          expect(
            HadithTopic.all.contains(hadith.topic),
            true,
            reason: 'Hadith ${hadith.id} should have valid topic',
          );
        }
      }
    });
  });
}
