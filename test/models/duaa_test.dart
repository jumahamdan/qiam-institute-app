import 'package:flutter_test/flutter_test.dart';
import 'package:qiam_institute_app/models/duaa.dart';
import 'package:qiam_institute_app/services/duaa/duaa_data.dart';

void main() {
  group('Duaa model', () {
    test('should create valid instance with all required fields', () {
      const duaa = Duaa(
        id: 1,
        duaNumber: '1.1',
        title: 'Test Dua',
        arabic: 'بسم الله',
        transliteration: 'Bismillah',
        translation: 'In the name of Allah',
        source: 'Test Source',
        category: DuaaCategory.morningEvening,
      );

      expect(duaa.id, 1);
      expect(duaa.duaNumber, '1.1');
      expect(duaa.title, 'Test Dua');
      expect(duaa.arabic, 'بسم الله');
      expect(duaa.remarks, isNull);
    });

    test('should create valid instance with remarks', () {
      const duaa = Duaa(
        id: 1,
        duaNumber: '1.1',
        title: 'Test Dua',
        arabic: 'بسم الله',
        transliteration: 'Bismillah',
        translation: 'In the name of Allah',
        source: 'Test Source',
        category: DuaaCategory.morningEvening,
        remarks: 'Test remarks',
      );

      expect(duaa.remarks, 'Test remarks');
    });

    test('formattedDuaNumber should return correct format', () {
      const duaa = Duaa(
        id: 1,
        duaNumber: '1.1',
        title: 'Test',
        arabic: '',
        transliteration: '',
        translation: '',
        source: '',
        category: DuaaCategory.morningEvening,
      );

      expect(duaa.formattedDuaNumber, 'Dua no : 1.1');
    });

    test('copyWith should create new instance with updated fields', () {
      const original = Duaa(
        id: 1,
        duaNumber: '1.1',
        title: 'Original',
        arabic: 'Original Arabic',
        transliteration: 'Original',
        translation: 'Original translation',
        source: 'Original source',
        category: DuaaCategory.morningEvening,
      );

      final copied = original.copyWith(
        title: 'Updated',
        remarks: 'New remarks',
      );

      expect(copied.id, 1); // Unchanged
      expect(copied.title, 'Updated'); // Changed
      expect(copied.remarks, 'New remarks'); // Added
      expect(copied.arabic, 'Original Arabic'); // Unchanged
    });
  });

  group('DuaaCategory', () {
    test('should have 14 categories', () {
      expect(DuaaCategory.all.length, 14);
    });

    test('getDisplayName should return human-readable names', () {
      expect(DuaaCategory.getDisplayName(DuaaCategory.morningEvening),
          'Morning & Evening');
      expect(DuaaCategory.getDisplayName(DuaaCategory.sleep), 'Sleep');
      expect(DuaaCategory.getDisplayName(DuaaCategory.masjid), 'Masjid');
      expect(DuaaCategory.getDisplayName(DuaaCategory.travel), 'Travel');
      expect(DuaaCategory.getDisplayName(DuaaCategory.wudu), 'Wudu (Ablution)');
    });

    test('getDisplayName should return category itself for unknown', () {
      expect(DuaaCategory.getDisplayName('unknown'), 'unknown');
    });

    test('getIcon should return emoji for each category', () {
      expect(DuaaCategory.getIcon(DuaaCategory.morningEvening), '🌅');
      expect(DuaaCategory.getIcon(DuaaCategory.sleep), '🌙');
      expect(DuaaCategory.getIcon(DuaaCategory.masjid), '🕌');
      expect(DuaaCategory.getIcon(DuaaCategory.food), '🍽️');
      expect(DuaaCategory.getIcon(DuaaCategory.travel), '✈️');
    });

    test('getIcon should return default emoji for unknown', () {
      expect(DuaaCategory.getIcon('unknown'), '📿');
    });

    test('all categories should have display names', () {
      for (final category in DuaaCategory.all) {
        final displayName = DuaaCategory.getDisplayName(category);
        expect(displayName.isNotEmpty, true,
            reason: 'Category $category should have display name');
        expect(displayName != category, true,
            reason: 'Category $category display name should differ from key');
      }
    });

    test('all categories should have icons', () {
      for (final category in DuaaCategory.all) {
        final icon = DuaaCategory.getIcon(category);
        expect(icon.isNotEmpty, true,
            reason: 'Category $category should have icon');
        expect(icon != '📿', true,
            reason: 'Category $category should have specific icon');
      }
    });
  });

  group('DuaaData', () {
    test('should have at least 50 duas', () {
      expect(DuaaData.allDuaas.length, greaterThanOrEqualTo(50));
    });

    test('all duas should have unique IDs', () {
      final ids = DuaaData.allDuaas.map((d) => d.id).toSet();
      expect(ids.length, DuaaData.allDuaas.length);
    });

    test('all duas should have required fields populated', () {
      for (final dua in DuaaData.allDuaas) {
        expect(dua.id > 0, true, reason: 'Dua should have positive ID');
        expect(dua.duaNumber.isNotEmpty, true,
            reason: 'Dua ${dua.id} should have dua number');
        expect(dua.title.isNotEmpty, true,
            reason: 'Dua ${dua.id} should have title');
        expect(dua.arabic.isNotEmpty, true,
            reason: 'Dua ${dua.id} should have Arabic text');
        expect(dua.transliteration.isNotEmpty, true,
            reason: 'Dua ${dua.id} should have transliteration');
        expect(dua.translation.isNotEmpty, true,
            reason: 'Dua ${dua.id} should have translation');
        expect(dua.source.isNotEmpty, true,
            reason: 'Dua ${dua.id} should have source');
        expect(DuaaCategory.all.contains(dua.category), true,
            reason: 'Dua ${dua.id} should have valid category');
      }
    });

    test('getByCategory should return duas for valid category', () {
      final morningEvening = DuaaData.getByCategory(DuaaCategory.morningEvening);
      expect(morningEvening.isNotEmpty, true);
      expect(
        morningEvening.every((d) => d.category == DuaaCategory.morningEvening),
        true,
      );
    });

    test('getByCategory should return empty for invalid category', () {
      final invalid = DuaaData.getByCategory('invalid_category');
      expect(invalid, isEmpty);
    });

    test('getById should return correct dua', () {
      final dua = DuaaData.getById(1);
      expect(dua, isNotNull);
      expect(dua!.id, 1);
    });

    test('getById should return null for invalid ID', () {
      final dua = DuaaData.getById(-1);
      expect(dua, isNull);

      final dua999 = DuaaData.getById(9999);
      expect(dua999, isNull);
    });

    test('groupedByCategory should have all categories with duas', () {
      final grouped = DuaaData.groupedByCategory;
      expect(grouped.isNotEmpty, true);

      // Each category in grouped should have at least one dua
      for (final entry in grouped.entries) {
        expect(entry.value.isNotEmpty, true,
            reason: 'Category ${entry.key} should have duas');
      }
    });

    test('should have duas in each main category', () {
      final mainCategories = [
        DuaaCategory.morningEvening,
        DuaaCategory.sleep,
        DuaaCategory.food,
        DuaaCategory.masjid,
      ];

      for (final category in mainCategories) {
        final duas = DuaaData.getByCategory(category);
        expect(duas.isNotEmpty, true,
            reason: 'Should have duas for $category');
      }
    });
  });
}
