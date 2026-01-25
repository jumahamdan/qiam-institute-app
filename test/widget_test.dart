import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qiam_institute_app/screens/explore/explore_screen.dart';
import 'package:qiam_institute_app/screens/prayer/prayer_screen.dart';

void main() {
  testWidgets('Explore screen renders title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ExploreScreen()));
    await tester.pumpAndSettle();

    // Verify explore screen title exists
    expect(find.text('Explore'), findsOneWidget);
  });

  testWidgets('Prayer screen renders title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrayerScreen()));
    await tester.pumpAndSettle();

    // Verify prayer screen title exists
    expect(find.text('Timings'), findsOneWidget);
  });
}
