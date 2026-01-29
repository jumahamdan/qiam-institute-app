import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qiam_institute_app/utils/orientation_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OrientationHelper', () {
    setUp(() {
      // Reset method channel mock
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          if (methodCall.method == 'SystemChrome.setPreferredOrientations') {
            return null;
          }
          return null;
        },
      );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    test('lockPortrait should complete without error', () async {
      // This test verifies the method runs without throwing
      await expectLater(
        OrientationHelper.lockPortrait(),
        completes,
      );
    });

    test('allowAllOrientations should complete without error', () async {
      await expectLater(
        OrientationHelper.allowAllOrientations(),
        completes,
      );
    });

    test('resetToDefault should complete without error', () async {
      await expectLater(
        OrientationHelper.resetToDefault(),
        completes,
      );
    });

    test('methods should be static', () {
      // Verify these can be called as static methods
      expect(OrientationHelper.lockPortrait, isA<Function>());
      expect(OrientationHelper.allowAllOrientations, isA<Function>());
      expect(OrientationHelper.resetToDefault, isA<Function>());
    });
  });
}
