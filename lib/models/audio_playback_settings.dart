// Audio playback settings model for Quran reader
// Supports verse repeat and range repeat functionality for Hifz (memorization)

/// Repeat count options for verse/range repetition
enum RepeatCount {
  off(0, 'Off'),
  one(1, '1'),
  two(2, '2'),
  three(3, '3'),
  five(5, '5'),
  ten(10, '10'),
  infinite(-1, '∞');

  final int value;
  final String label;

  const RepeatCount(this.value, this.label);

  /// Check if repeat is enabled
  bool get isEnabled => value != 0;

  /// Check if infinite repeat
  bool get isInfinite => value == -1;

  /// Get RepeatCount from int value
  static RepeatCount fromValue(int value) {
    return RepeatCount.values.firstWhere(
      (r) => r.value == value,
      orElse: () => RepeatCount.off,
    );
  }
}

/// Model for audio playback range (loop a selection of verses)
class AudioPlaybackRange {
  final int startVerse;
  final int endVerse;
  final RepeatCount rangeRepeatCount;
  final bool enforceBounds;

  const AudioPlaybackRange({
    required this.startVerse,
    required this.endVerse,
    this.rangeRepeatCount = RepeatCount.off,
    this.enforceBounds = true,
  });

  /// Check if range is active (has valid range and repeat enabled)
  bool get isActive =>
      startVerse > 0 &&
      endVerse >= startVerse &&
      rangeRepeatCount.isEnabled;

  /// Get total verses in range
  int get verseCount => endVerse - startVerse + 1;

  /// Check if a verse is within the range
  bool containsVerse(int verse) => verse >= startVerse && verse <= endVerse;

  /// Copy with new values
  AudioPlaybackRange copyWith({
    int? startVerse,
    int? endVerse,
    RepeatCount? rangeRepeatCount,
    bool? enforceBounds,
  }) {
    return AudioPlaybackRange(
      startVerse: startVerse ?? this.startVerse,
      endVerse: endVerse ?? this.endVerse,
      rangeRepeatCount: rangeRepeatCount ?? this.rangeRepeatCount,
      enforceBounds: enforceBounds ?? this.enforceBounds,
    );
  }

  /// Create disabled range
  static const AudioPlaybackRange disabled = AudioPlaybackRange(
    startVerse: 0,
    endVerse: 0,
    rangeRepeatCount: RepeatCount.off,
  );

  @override
  String toString() =>
      'AudioPlaybackRange(start: $startVerse, end: $endVerse, repeat: ${rangeRepeatCount.label}, enforce: $enforceBounds)';
}

/// Complete audio playback settings
class AudioPlaybackSettings {
  final RepeatCount verseRepeatCount;
  final AudioPlaybackRange range;
  final double playbackSpeed;

  const AudioPlaybackSettings({
    this.verseRepeatCount = RepeatCount.off,
    this.range = AudioPlaybackRange.disabled,
    this.playbackSpeed = 1.0,
  });

  /// Check if any repeat is enabled
  bool get hasRepeat => verseRepeatCount.isEnabled || range.isActive;

  /// Copy with new values
  AudioPlaybackSettings copyWith({
    RepeatCount? verseRepeatCount,
    AudioPlaybackRange? range,
    double? playbackSpeed,
  }) {
    return AudioPlaybackSettings(
      verseRepeatCount: verseRepeatCount ?? this.verseRepeatCount,
      range: range ?? this.range,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
    );
  }

  /// Default settings
  static const AudioPlaybackSettings defaults = AudioPlaybackSettings();
}