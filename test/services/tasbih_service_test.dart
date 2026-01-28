import 'package:flutter_test/flutter_test.dart';
import 'package:qiam_institute_app/services/tasbih/tasbih_service.dart';

void main() {
  group('TasbihService', () {
    late TasbihService service;

    setUp(() {
      service = TasbihService();
    });

    test('should have 9 predefined dhikr phrases', () {
      final dhikrList = service.getAllDhikr();
      expect(dhikrList.length, 9);
    });

    test('dhikr list should include SubhanAllah', () {
      final dhikrList = service.getAllDhikr();
      final subhanallah = dhikrList.firstWhere((d) => d.id == 'subhanallah');
      expect(subhanallah.transliteration, 'SubhanAllah');
      expect(subhanallah.translation, 'Glory be to Allah');
      expect(subhanallah.defaultTarget, 33);
    });

    test('dhikr list should include Alhamdulillah', () {
      final dhikrList = service.getAllDhikr();
      final alhamdulillah = dhikrList.firstWhere((d) => d.id == 'alhamdulillah');
      expect(alhamdulillah.transliteration, 'Alhamdulillah');
      expect(alhamdulillah.translation, 'Praise be to Allah');
    });

    test('dhikr list should include Allahu Akbar', () {
      final dhikrList = service.getAllDhikr();
      final allahuAkbar = dhikrList.firstWhere((d) => d.id == 'allahuakbar');
      expect(allahuAkbar.transliteration, 'Allahu Akbar');
    });

    test('getDhikr returns correct dhikr by id', () {
      final dhikr = service.getDhikr('subhanallah');
      expect(dhikr.id, 'subhanallah');
      expect(dhikr.transliteration, 'SubhanAllah');
    });

    test('getDhikr returns first dhikr for invalid id', () {
      final dhikr = service.getDhikr('nonexistent');
      // Should fall back to first dhikr
      expect(dhikr.id, 'subhanallah');
    });

    test('all dhikr have required fields populated', () {
      final dhikrList = service.getAllDhikr();
      for (final dhikr in dhikrList) {
        expect(dhikr.id.isNotEmpty, true,
            reason: 'Dhikr should have id');
        expect(dhikr.arabic.isNotEmpty, true,
            reason: 'Dhikr ${dhikr.id} should have Arabic text');
        expect(dhikr.transliteration.isNotEmpty, true,
            reason: 'Dhikr ${dhikr.id} should have transliteration');
        expect(dhikr.translation.isNotEmpty, true,
            reason: 'Dhikr ${dhikr.id} should have translation');
        expect(dhikr.virtue.isNotEmpty, true,
            reason: 'Dhikr ${dhikr.id} should have virtue');
        expect(dhikr.defaultTarget > 0, true,
            reason: 'Dhikr ${dhikr.id} should have positive target');
      }
    });

    test('dhikr with 100 target should be astaghfirullah or similar', () {
      final dhikrList = service.getAllDhikr();
      final dhikrWith100 = dhikrList.where((d) => d.defaultTarget == 100).toList();
      expect(dhikrWith100.isNotEmpty, true);
      // Should include astaghfirullah, la ilaha illAllah, etc.
      expect(dhikrWith100.any((d) => d.id == 'astaghfirullah'), true);
    });
  });

  group('Dhikr model', () {
    test('should create valid instance with all fields', () {
      const dhikr = Dhikr(
        id: 'test',
        arabic: 'تست',
        transliteration: 'Test',
        translation: 'Test translation',
        virtue: 'Test virtue',
        defaultTarget: 33,
      );

      expect(dhikr.id, 'test');
      expect(dhikr.arabic, 'تست');
      expect(dhikr.transliteration, 'Test');
      expect(dhikr.translation, 'Test translation');
      expect(dhikr.virtue, 'Test virtue');
      expect(dhikr.defaultTarget, 33);
    });

    test('toJson should serialize correctly', () {
      const dhikr = Dhikr(
        id: 'test',
        arabic: 'تست',
        transliteration: 'Test',
        translation: 'Test translation',
        virtue: 'Test virtue',
        defaultTarget: 33,
      );

      final json = dhikr.toJson();
      expect(json['id'], 'test');
      expect(json['arabic'], 'تست');
      expect(json['defaultTarget'], 33);
    });

    test('fromJson should deserialize correctly', () {
      final json = {
        'id': 'test',
        'arabic': 'تست',
        'transliteration': 'Test',
        'translation': 'Test translation',
        'virtue': 'Test virtue',
        'defaultTarget': 33,
      };

      final dhikr = Dhikr.fromJson(json);
      expect(dhikr.id, 'test');
      expect(dhikr.arabic, 'تست');
      expect(dhikr.defaultTarget, 33);
    });

    test('fromJson uses default target when not provided', () {
      final json = {
        'id': 'test',
        'arabic': 'تست',
        'transliteration': 'Test',
        'translation': 'Test translation',
        'virtue': 'Test virtue',
      };

      final dhikr = Dhikr.fromJson(json);
      expect(dhikr.defaultTarget, 33); // Default value
    });
  });

  group('TasbihProgress model', () {
    test('should create with default values', () {
      final progress = TasbihProgress(dhikrId: 'test');
      expect(progress.dhikrId, 'test');
      expect(progress.count, 0);
      expect(progress.target, 33);
      expect(progress.totalCount, 0);
    });

    test('toJson and fromJson should be symmetric', () {
      final original = TasbihProgress(
        dhikrId: 'test',
        count: 10,
        target: 99,
        totalCount: 500,
      );

      final json = original.toJson();
      final restored = TasbihProgress.fromJson(json);

      expect(restored.dhikrId, original.dhikrId);
      expect(restored.count, original.count);
      expect(restored.target, original.target);
      expect(restored.totalCount, original.totalCount);
    });
  });
}
