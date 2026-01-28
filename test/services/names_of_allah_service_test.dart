import 'package:flutter_test/flutter_test.dart';
import 'package:qiam_institute_app/services/names_of_allah/names_service.dart';

void main() {
  group('NamesOfAllahService', () {
    late NamesOfAllahService service;

    setUp(() {
      service = NamesOfAllahService();
    });

    test('should have exactly 99 names', () {
      final names = service.getAllNames();
      expect(names.length, 99);
    });

    test('names should be numbered 1 to 99', () {
      final names = service.getAllNames();
      for (int i = 0; i < names.length; i++) {
        expect(names[i].number, i + 1);
      }
    });

    test('first name should be Ar-Rahman', () {
      final names = service.getAllNames();
      expect(names.first.transliteration, 'Ar-Rahman');
      expect(names.first.meaning, 'The Most Gracious');
    });

    test('last name should be As-Sabur', () {
      final names = service.getAllNames();
      expect(names.last.transliteration, 'As-Sabur');
      expect(names.last.meaning, 'The Patient');
      expect(names.last.number, 99);
    });

    test('getName returns correct name', () {
      final name = service.getName(1);
      expect(name.transliteration, 'Ar-Rahman');

      final name50 = service.getName(50);
      expect(name50.number, 50);
    });

    test('getName returns first name for invalid numbers', () {
      // Service returns first name as fallback for invalid numbers
      final invalid = service.getName(0);
      expect(invalid.number, 1); // Falls back to first name
    });

    test('all names have required fields populated', () {
      final names = service.getAllNames();
      for (final name in names) {
        expect(name.arabic.isNotEmpty, true,
            reason: 'Name ${name.number} should have Arabic text');
        expect(name.transliteration.isNotEmpty, true,
            reason: 'Name ${name.number} should have transliteration');
        expect(name.meaning.isNotEmpty, true,
            reason: 'Name ${name.number} should have meaning');
        expect(name.description.isNotEmpty, true,
            reason: 'Name ${name.number} should have description');
      }
    });

    test('searchNames finds matching names', () {
      // Search by meaning - "Gracious" matches Ar-Rahman
      final results = service.searchNames('Gracious');
      expect(results.isNotEmpty, true);
      expect(results.any((n) => n.transliteration == 'Ar-Rahman'), true);
    });

    test('searchNames is case insensitive', () {
      final results1 = service.searchNames('KING');
      final results2 = service.searchNames('king');
      expect(results1.length, results2.length);
    });

    test('searchNames returns empty list for no matches', () {
      final results = service.searchNames('xyz123nonexistent');
      expect(results, isEmpty);
    });
  });

  group('NameOfAllah model', () {
    test('should create valid instance with all fields', () {
      const name = NameOfAllah(
        number: 1,
        arabic: 'الرَّحْمَنُ',
        transliteration: 'Ar-Rahman',
        meaning: 'The Most Gracious',
        description: 'Test description',
      );

      expect(name.number, 1);
      expect(name.arabic, 'الرَّحْمَنُ');
      expect(name.transliteration, 'Ar-Rahman');
      expect(name.meaning, 'The Most Gracious');
      expect(name.description, 'Test description');
    });
  });
}
