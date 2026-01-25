import 'package:flutter_test/flutter_test.dart';

import 'package:qiam_institute_app/app.dart';

void main() {
  testWidgets('App renders with navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const QiamApp());

    // Verify bottom navigation exists
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Events'), findsOneWidget);
    expect(find.text('Prayer'), findsOneWidget);
    expect(find.text('Qibla'), findsOneWidget);

    // Verify home screen content
    expect(find.text('NEXT PRAYER'), findsOneWidget);
    expect(find.text('Quick Links'), findsOneWidget);
  });
}
