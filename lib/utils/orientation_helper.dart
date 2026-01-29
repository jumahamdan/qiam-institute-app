import 'package:flutter/services.dart';

/// Utility class for managing screen orientation throughout the app.
///
/// Usage:
/// - App default is portrait-only (set in main.dart)
/// - Screens that need rotation can call [allowAllOrientations] in initState
///   and [lockPortrait] in dispose to restore the default
class OrientationHelper {
  /// Lock the screen to portrait orientation only.
  /// This is the app's default orientation.
  static Future<void> lockPortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Allow all orientations (portrait and landscape).
  /// Use this for screens that benefit from landscape mode (e.g., Qibla compass).
  static Future<void> allowAllOrientations() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Reset to system default (allow all orientations).
  /// Generally not needed - use [lockPortrait] or [allowAllOrientations] instead.
  static Future<void> resetToDefault() async {
    await SystemChrome.setPreferredOrientations([]);
  }
}
