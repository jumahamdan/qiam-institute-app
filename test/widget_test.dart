import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qiam_institute_app/screens/explore/explore_screen.dart';
import 'package:qiam_institute_app/screens/prayer/prayer_screen.dart';

void main() {
  testWidgets('Explore screen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ExploreScreen()));
    await tester.pump();

    // Verify explore screen title
    expect(find.text('Explore'), findsOneWidget);

    // Verify quick links exist
    expect(find.text('Events'), findsOneWidget);
    expect(find.text('Our Values'), findsOneWidget);
    expect(find.text('Volunteer'), findsOneWidget);
    expect(find.text('Media'), findsOneWidget);
  });

  testWidgets('Prayer screen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrayerScreen()));
    await tester.pump();

    // Verify prayer screen title
    expect(find.text('Timings'), findsOneWidget);

    // Verify prayer names exist
    expect(find.text('Fajr'), findsOneWidget);
    expect(find.text('Dhuhr'), findsOneWidget);
    expect(find.text('Asr'), findsOneWidget);
    expect(find.text('Maghrib'), findsOneWidget);
    expect(find.text('Isha'), findsOneWidget);
  });
}
