import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qiam_institute_app/screens/prayer/prayer_screen.dart';
import 'package:qiam_institute_app/screens/islamic_calendar/islamic_calendar_screen.dart';

void main() {
  testWidgets('Islamic Calendar screen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: IslamicCalendarScreen())));
    await tester.pump();

    // Verify Islamic Calendar header exists
    expect(find.text('HIJRI 1447'), findsOneWidget);
  });

  testWidgets('Prayer screen renders loading state', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrayerScreen()));
    // Don't use pumpAndSettle as services won't initialize in test environment
    await tester.pump();

    // Verify loading state is shown (services require platform features not available in tests)
    expect(find.text('Loading prayer times...'), findsOneWidget);
  });
}
