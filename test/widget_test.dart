import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qiam_institute_app/app.dart';

void main() {
  testWidgets('App renders with navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const QiamApp());

    // Verify bottom navigation bar exists
    expect(find.byType(NavigationBar), findsOneWidget);

    // Verify navigation destinations exist
    expect(find.byType(NavigationDestination), findsNWidgets(4));

    // Verify home screen content
    expect(find.text('NEXT PRAYER'), findsOneWidget);
    expect(find.text('Quick Links'), findsOneWidget);
  });
}
