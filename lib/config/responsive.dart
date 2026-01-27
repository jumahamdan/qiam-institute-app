import 'package:flutter/material.dart';

/// Material Design 3 responsive breakpoints and utilities.
///
/// Breakpoints:
/// - Compact: < 600dp (most phones portrait)
/// - Medium: 600-839dp (Z Fold inner, small tablets, phones landscape)
/// - Expanded: >= 840dp (large tablets, desktop)
class Responsive {
  Responsive._();

  // Breakpoint thresholds (Material Design 3)
  static const double compactMaxWidth = 600;
  static const double mediumMaxWidth = 840;

  /// Returns the current breakpoint category
  static ScreenSize screenSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < compactMaxWidth) return ScreenSize.compact;
    if (width < mediumMaxWidth) return ScreenSize.medium;
    return ScreenSize.expanded;
  }

  /// Check if screen is compact (most phones)
  static bool isCompact(BuildContext context) =>
      screenSize(context) == ScreenSize.compact;

  /// Check if screen is medium (Z Fold inner, small tablets)
  static bool isMedium(BuildContext context) =>
      screenSize(context) == ScreenSize.medium;

  /// Check if screen is expanded (large tablets, desktop)
  static bool isExpanded(BuildContext context) =>
      screenSize(context) == ScreenSize.expanded;

  /// Returns a value based on screen size
  static T value<T>(
    BuildContext context, {
    required T compact,
    T? medium,
    T? expanded,
  }) {
    final size = screenSize(context);
    switch (size) {
      case ScreenSize.compact:
        return compact;
      case ScreenSize.medium:
        return medium ?? compact;
      case ScreenSize.expanded:
        return expanded ?? medium ?? compact;
    }
  }

  /// Returns appropriate screen padding based on size
  static EdgeInsets screenPadding(BuildContext context) {
    return value(
      context,
      compact: const EdgeInsets.all(16),
      medium: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      expanded: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
    );
  }

  /// Returns appropriate grid spacing
  static double gridSpacing(BuildContext context) {
    return value(
      context,
      compact: 12.0,
      medium: 16.0,
      expanded: 20.0,
    );
  }

  /// Returns number of grid columns based on screen size
  static int gridColumns(
    BuildContext context, {
    int compact = 2,
    int medium = 3,
    int expanded = 4,
  }) {
    return value(
      context,
      compact: compact,
      medium: medium,
      expanded: expanded,
    );
  }

  /// Returns appropriate card aspect ratio
  static double cardAspectRatio(BuildContext context) {
    return value(
      context,
      compact: 1.1,
      medium: 1.0,
      expanded: 1.1,
    );
  }

  /// Returns appropriate font scale factor
  static double fontScale(BuildContext context) {
    return value(
      context,
      compact: 1.0,
      medium: 1.05,
      expanded: 1.1,
    );
  }

  /// Returns max content width for very large screens
  static double? maxContentWidth(BuildContext context) {
    return value<double?>(
      context,
      compact: null,
      medium: null,
      expanded: 1200,
    );
  }
}

/// Screen size categories based on Material Design 3
enum ScreenSize {
  compact,  // < 600dp
  medium,   // 600-839dp
  expanded, // >= 840dp
}
