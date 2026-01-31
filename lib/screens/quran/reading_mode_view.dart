import 'package:flutter/material.dart';
import '../../services/quran/quran_service.dart';

/// Mushaf-style reading mode with continuous Arabic text and inline verse numbers
class ReadingModeView extends StatelessWidget {
  final List<Verse> verses;
  final double arabicFontSize;
  final int? currentPlayingVerse;
  final Color primaryColor;
  final ScrollController scrollController;
  final Function(int verseNumber)? onVerseTap;

  const ReadingModeView({
    super.key,
    required this.verses,
    required this.arabicFontSize,
    this.currentPlayingVerse,
    required this.primaryColor,
    required this.scrollController,
    this.onVerseTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: _buildContinuousText(context),
      ),
    );
  }

  Widget _buildContinuousText(BuildContext context) {
    // Build rich text with inline verse numbers
    final List<InlineSpan> spans = [];

    for (final verse in verses) {
      final isPlaying = verse.verseNumber == currentPlayingVerse;

      // Add verse text
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            onTap: onVerseTap != null ? () => onVerseTap!(verse.verseNumber) : null,
            child: Container(
              padding: isPlaying
                  ? const EdgeInsets.symmetric(horizontal: 4, vertical: 2)
                  : EdgeInsets.zero,
              decoration: isPlaying
                  ? BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    )
                  : null,
              child: Text(
                verse.textArabic,
                style: TextStyle(
                  fontSize: arabicFontSize,
                  height: 2.2,
                  fontWeight: FontWeight.w500,
                  color: isPlaying ? primaryColor : null,
                ),
              ),
            ),
          ),
        ),
      );

      // Add verse number marker (Arabic-Indic numerals in circle)
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _VerseNumberMarker(
              verseNumber: verse.verseNumber,
              isPlaying: isPlaying,
              primaryColor: primaryColor,
              fontSize: arabicFontSize * 0.5,
            ),
          ),
        ),
      );

      // Add space between verses
      spans.add(const TextSpan(text: ' '));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: TextStyle(
            fontSize: arabicFontSize,
            height: 2.2,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          children: spans,
        ),
      ),
    );
  }
}

/// Circular verse number marker with Arabic-Indic numerals
class _VerseNumberMarker extends StatelessWidget {
  final int verseNumber;
  final bool isPlaying;
  final Color primaryColor;
  final double fontSize;

  const _VerseNumberMarker({
    required this.verseNumber,
    required this.isPlaying,
    required this.primaryColor,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fontSize * 2,
      height: fontSize * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPlaying ? primaryColor : Colors.transparent,
        border: Border.all(
          color: isPlaying ? primaryColor : primaryColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          _toArabicNumerals(verseNumber),
          style: TextStyle(
            fontSize: fontSize * 0.8,
            fontWeight: FontWeight.bold,
            color: isPlaying ? Colors.white : primaryColor,
          ),
        ),
      ),
    );
  }

  /// Convert Western numerals to Arabic-Indic numerals
  String _toArabicNumerals(int number) {
    const arabicNumerals = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number.toString().split('').map((digit) {
      final index = int.tryParse(digit);
      return index != null ? arabicNumerals[index] : digit;
    }).join();
  }
}

/// Widget for displaying translation overlay in reading mode
class ReadingModeTranslationOverlay extends StatelessWidget {
  final List<Verse> verses;
  final double translationFontSize;
  final int? selectedVerse;
  final VoidCallback onClose;

  const ReadingModeTranslationOverlay({
    super.key,
    required this.verses,
    required this.translationFontSize,
    this.selectedVerse,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final verse = selectedVerse != null
        ? verses.firstWhere(
            (v) => v.verseNumber == selectedVerse,
            orElse: () => verses.first,
          )
        : verses.first;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Verse ${verse.verseNumber}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: onClose,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            verse.translation,
            style: TextStyle(
              fontSize: translationFontSize,
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
