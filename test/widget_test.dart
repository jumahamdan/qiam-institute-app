import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qiam_institute_app/app.dart';

void main() {
  testWidgets('App renders with navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const QiamApp());

    // Allow initial frame to settle (ignore YouTube player errors in test)
    await tester.pump();

    // Verify bottom navigation bar exists
    expect(find.byType(NavigationBar), findsOneWidget);

    // Verify navigation destinations exist (Explore, Timings, More)
    expect(find.byType(NavigationDestination), findsNWidgets(3));
  });

  testWidgets('Navigation tabs show correct labels', (WidgetTester tester) async {
    await tester.pumpWidget(const QiamApp());
    await tester.pump();

    // Check for navigation tab labels
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Timings'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);
  });
}
