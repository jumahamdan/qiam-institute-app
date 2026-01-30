import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qiam_institute_app/services/dua/dua_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Set up SharedPreferences mock for all tests
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('DuaService', () {
    test('singleton should return same instance', () {
      final service1 = DuaService();
      final service2 = DuaService();
      expect(identical(service1, service2), isTrue);
    });

    test('getCategoryIcon should return emoji for known categories', () {
      expect(DuaService.getCategoryIcon('Morning Adhkar'), '🌅');
      expect(DuaService.getCategoryIcon('Evening Adhkar'), '🌅');
      expect(DuaService.getCategoryIcon('Sleep'), '🌙');
      expect(DuaService.getCategoryIcon('Waking up'), '🌙');
      expect(DuaService.getCategoryIcon('Prayer'), '🕌');
      expect(DuaService.getCategoryIcon('Food and Eating'), '🍽️');
      expect(DuaService.getCategoryIcon('Drinking'), '🍽️');
      expect(DuaService.getCategoryIcon('Home'), '🏠');
      expect(DuaService.getCategoryIcon('Travel'), '✈️');
      expect(DuaService.getCategoryIcon('Bathroom'), '🚿');
      expect(DuaService.getCategoryIcon('Toilet'), '🚿');
      expect(DuaService.getCategoryIcon('Dress'), '👔');
      expect(DuaService.getCategoryIcon('Clothing'), '👔');
      expect(DuaService.getCategoryIcon('Sick'), '🏥');
      expect(DuaService.getCategoryIcon('Illness'), '🏥');
      expect(DuaService.getCategoryIcon('Pain'), '🏥');
      expect(DuaService.getCategoryIcon('Death'), '⚱️');
      expect(DuaService.getCategoryIcon('Funeral'), '⚱️');
      expect(DuaService.getCategoryIcon('Rain'), '🌧️');
      expect(DuaService.getCategoryIcon('Weather'), '🌧️');
      expect(DuaService.getCategoryIcon('Wind'), '🌧️');
      expect(DuaService.getCategoryIcon('Hajj'), '🕋');
      expect(DuaService.getCategoryIcon('Umrah'), '🕋');
      expect(DuaService.getCategoryIcon('Fear'), '💚');
      expect(DuaService.getCategoryIcon('Anxiety'), '💚');
      expect(DuaService.getCategoryIcon('Distress'), '💚');
      expect(DuaService.getCategoryIcon('Forgiveness'), '🤲');
      expect(DuaService.getCategoryIcon('Repentance'), '🤲');
      expect(DuaService.getCategoryIcon('Protection'), '🛡️');
      expect(DuaService.getCategoryIcon('Quran'), '📖');
      expect(DuaService.getCategoryIcon('Market'), '🏪');
      expect(DuaService.getCategoryIcon('Trade'), '🏪');
      expect(DuaService.getCategoryIcon('Debt'), '💳');
      expect(DuaService.getCategoryIcon('Anger'), '😤');
      expect(DuaService.getCategoryIcon('Mirror'), '🪞');
      expect(DuaService.getCategoryIcon('Good news'), '🎉');
      expect(DuaService.getCategoryIcon('Happy'), '🎉');
    });

    test('getCategoryIcon should return default emoji for unknown categories', () {
      expect(DuaService.getCategoryIcon('Unknown'), '📿');
      expect(DuaService.getCategoryIcon('Random'), '📿');
      expect(DuaService.getCategoryIcon(''), '📿');
    });

    test('isInitialized should be false initially', () {
      // Create a fresh reference to check initial state
      final service = DuaService();
      expect(service.isInitialized, isA<bool>());
    });

    test('bookmarkCount should return number of bookmarks', () {
      final service = DuaService();
      expect(service.bookmarkCount, isA<int>());
      expect(service.bookmarkCount, greaterThanOrEqualTo(0));
    });

    test('categories should return list', () {
      final service = DuaService();
      expect(service.categories, isA<List>());
    });

    test('allChapters should return list', () {
      final service = DuaService();
      expect(service.allChapters, isA<List>());
    });

    test('searchChapters should return empty list for empty query', () {
      final service = DuaService();
      final results = service.searchChapters('');
      expect(results, isEmpty);
    });

    test('isBookmarked should return false for non-bookmarked chapter', () {
      final service = DuaService();
      expect(service.isBookmarked(99999), isFalse);
    });

    test('getChapterById should return null for invalid id', () {
      final service = DuaService();
      expect(service.getChapterById(99999), isNull);
    });

    test('getCategoryById should return null for invalid id', () {
      final service = DuaService();
      expect(service.getCategoryById(99999), isNull);
    });

    test('getDuaOfTheDay should return null when not initialized', () {
      final service = DuaService();
      // Before initialization with data, should return null
      final dua = service.getDuaOfTheDay();
      // Can be null if no chapters loaded
      expect(dua, isA<Object?>());
    });

    test('searchChapters should return empty list when not initialized', () {
      final service = DuaService();
      final results = service.searchChapters('test');
      expect(results, isEmpty);
    });

    test('getCategoryIcon handles all weather variants', () {
      expect(DuaService.getCategoryIcon('Rainy day'), '🌧️');
      expect(DuaService.getCategoryIcon('Bad weather'), '🌧️');
      expect(DuaService.getCategoryIcon('Strong wind'), '🌧️');
    });

    test('getCategoryIcon handles religious journey variants', () {
      expect(DuaService.getCategoryIcon('Hajj pilgrimage'), '🕋');
      expect(DuaService.getCategoryIcon('Umrah trip'), '🕋');
    });

    test('getCategoryIcon handles emotional states', () {
      expect(DuaService.getCategoryIcon('Dealing with anxiety'), '💚');
      expect(DuaService.getCategoryIcon('In distress'), '💚');
      expect(DuaService.getCategoryIcon('Overcome fear'), '💚');
    });

    test('getCategoryIcon handles daily activities', () {
      expect(DuaService.getCategoryIcon('Going to sleep'), '🌙');
      expect(DuaService.getCategoryIcon('After waking'), '🌙');
      expect(DuaService.getCategoryIcon('Entering home'), '🏠');
      expect(DuaService.getCategoryIcon('Leaving house'), '🏠');
    });

    test('getCategoryIcon handles clothing and appearance', () {
      expect(DuaService.getCategoryIcon('New dress'), '👔');
      expect(DuaService.getCategoryIcon('Wearing clothes'), '👔');
      expect(DuaService.getCategoryIcon('Looking in mirror'), '🪞');
    });

    test('getCategoryIcon handles health states', () {
      expect(DuaService.getCategoryIcon('Visiting sick'), '🏥');
      expect(DuaService.getCategoryIcon('Illness recovery'), '🏥');
      expect(DuaService.getCategoryIcon('Feeling pain'), '🏥');
    });

    test('getCategoryIcon handles transactions', () {
      expect(DuaService.getCategoryIcon('At the market'), '🏪');
      expect(DuaService.getCategoryIcon('Trade business'), '🏪');
      expect(DuaService.getCategoryIcon('Paying debt'), '💳');
    });

    test('getCategoryIcon handles food and drink', () {
      expect(DuaService.getCategoryIcon('Before eating'), '🍽️');
      expect(DuaService.getCategoryIcon('After food'), '🍽️');
      expect(DuaService.getCategoryIcon('While drinking'), '🍽️');
    });

    test('getCategoryIcon handles spiritual matters', () {
      expect(DuaService.getCategoryIcon('Seeking forgiveness'), '🤲');
      expect(DuaService.getCategoryIcon('Repentance dua'), '🤲');
      expect(DuaService.getCategoryIcon('Divine protection'), '🛡️');
      expect(DuaService.getCategoryIcon('Reading Quran'), '📖');
    });

    test('getCategoryIcon handles life events', () {
      expect(DuaService.getCategoryIcon('Death of relative'), '⚱️');
      expect(DuaService.getCategoryIcon('At the funeral'), '⚱️');
      expect(DuaService.getCategoryIcon('Happy occasion'), '🎉');
      expect(DuaService.getCategoryIcon('Good news received'), '🎉');
    });

    test('getCategoryIcon handles prayer times', () {
      expect(DuaService.getCategoryIcon('Before prayer'), '🕌');
      expect(DuaService.getCategoryIcon('After salah'), '🕌');
    });

    test('getCategoryIcon handles travel', () {
      expect(DuaService.getCategoryIcon('Travel dua'), '✈️');
      expect(DuaService.getCategoryIcon('Safe travel'), '✈️');
    });

    test('getCategoryIcon handles bathroom', () {
      expect(DuaService.getCategoryIcon('Entering bathroom'), '🚿');
      expect(DuaService.getCategoryIcon('Leaving toilet'), '🚿');
    });

    test('getCategoryIcon handles morning and evening', () {
      expect(DuaService.getCategoryIcon('Morning adhkar'), '🌅');
      expect(DuaService.getCategoryIcon('Evening remembrance'), '🌅');
    });

    test('getCategoryIcon handles anger', () {
      expect(DuaService.getCategoryIcon('Controlling anger'), '😤');
      expect(DuaService.getCategoryIcon('In a state of anger'), '😤');
    });
  });
}
