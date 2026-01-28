import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/quran/quran_service.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;
  final int? initialVerse;

  const SurahDetailScreen({
    super.key,
    required this.surah,
    this.initialVerse,
  });

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final QuranService _quranService = QuranService();
  late List<Verse> _verses;
  late ScrollController _scrollController;
  Set<String> _bookmarks = {};
  double _arabicFontSize = 28.0;
  double _translationFontSize = 14.0;

  static const String _arabicFontSizeKey = 'quran_arabic_font_size';
  static const String _translationFontSizeKey = 'quran_translation_font_size';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _verses = _quranService.getSurahVerses(widget.surah.number);
    _loadSettings();
    _loadBookmarks();

    // Scroll to initial verse after build
    if (widget.initialVerse != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToVerse(widget.initialVerse!);
      });
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _arabicFontSize = prefs.getDouble(_arabicFontSizeKey) ?? 28.0;
      _translationFontSize = prefs.getDouble(_translationFontSizeKey) ?? 14.0;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_arabicFontSizeKey, _arabicFontSize);
    await prefs.setDouble(_translationFontSizeKey, _translationFontSize);
  }

  Future<void> _loadBookmarks() async {
    final bookmarks = await _quranService.getBookmarks();
    setState(() => _bookmarks = bookmarks.toSet());
  }

  void _scrollToVerse(int verseNumber) {
    // Approximate scroll position (each verse is roughly 150px)
    final position = (verseNumber - 1) * 150.0;
    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _toggleBookmark(int verseNumber) async {
    final key = '${widget.surah.number}:$verseNumber';
    if (_bookmarks.contains(key)) {
      await _quranService.removeBookmark(widget.surah.number, verseNumber);
      _bookmarks.remove(key);
    } else {
      await _quranService.addBookmark(widget.surah.number, verseNumber);
      _bookmarks.add(key);
    }
    setState(() {});
  }

  void _saveLastRead(int verseNumber) {
    _quranService.saveLastReadPosition(widget.surah.number, verseNumber);
  }

  void _shareVerse(Verse verse) {
    final text = '''
${verse.textArabic}

${verse.translation}

— Quran ${widget.surah.nameTransliteration} (${widget.surah.number}:${verse.verseNumber})
''';
    Share.share(text);
  }

  void _copyVerse(Verse verse) {
    final text = '''${verse.textArabic}

${verse.translation}

— Quran ${widget.surah.nameTransliteration} (${widget.surah.number}:${verse.verseNumber})''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verse copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showFontSizeDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Font Size',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Arabic Font Size
                  Row(
                    children: [
                      const Text('Arabic'),
                      Expanded(
                        child: Slider(
                          value: _arabicFontSize,
                          min: 20,
                          max: 40,
                          divisions: 20,
                          label: _arabicFontSize.round().toString(),
                          onChanged: (value) {
                            setModalState(() => _arabicFontSize = value);
                            setState(() {});
                          },
                        ),
                      ),
                      Text('${_arabicFontSize.round()}'),
                    ],
                  ),
                  // Translation Font Size
                  Row(
                    children: [
                      const Text('Translation'),
                      Expanded(
                        child: Slider(
                          value: _translationFontSize,
                          min: 12,
                          max: 24,
                          divisions: 12,
                          label: _translationFontSize.round().toString(),
                          onChanged: (value) {
                            setModalState(() => _translationFontSize = value);
                            setState(() {});
                          },
                        ),
                      ),
                      Text('${_translationFontSize.round()}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _saveSettings();
                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.surah.nameTransliteration,
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '${widget.surah.nameArabic} • ${widget.surah.verseCount} verses',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: _showFontSizeDialog,
            tooltip: 'Font Size',
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // Save last read position on scroll
          if (notification is ScrollEndNotification) {
            final visibleVerse = (_scrollController.offset / 150).round() + 1;
            if (visibleVerse > 0 && visibleVerse <= _verses.length) {
              _saveLastRead(visibleVerse);
            }
          }
          return false;
        },
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: _verses.length + 1, // +1 for Basmala header
          itemBuilder: (context, index) {
            // Basmala header (except for At-Tawbah)
            if (index == 0) {
              return _SurahHeader(
                surah: widget.surah,
                showBasmala: _quranService.surahHasBasmala(widget.surah.number),
                basmala: _quranService.getBasmala(),
                primaryColor: primaryColor,
                arabicFontSize: _arabicFontSize,
              );
            }

            final verse = _verses[index - 1];
            final isBookmarked = _bookmarks.contains(
              '${widget.surah.number}:${verse.verseNumber}',
            );

            return _VerseCard(
              verse: verse,
              isBookmarked: isBookmarked,
              arabicFontSize: _arabicFontSize,
              translationFontSize: _translationFontSize,
              primaryColor: primaryColor,
              onBookmarkToggle: () => _toggleBookmark(verse.verseNumber),
              onShare: () => _shareVerse(verse),
              onCopy: () => _copyVerse(verse),
            );
          },
        ),
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  final Surah surah;
  final bool showBasmala;
  final String basmala;
  final Color primaryColor;
  final double arabicFontSize;

  const _SurahHeader({
    required this.surah,
    required this.showBasmala,
    required this.basmala,
    required this.primaryColor,
    required this.arabicFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Surah name in Arabic
          Text(
            surah.nameArabic,
            style: TextStyle(
              color: Colors.white,
              fontSize: arabicFontSize + 8,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          // English name and meaning
          Text(
            '${surah.nameTransliteration} (${surah.nameEnglish})',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          // Revelation type and verse count
          Text(
            '${surah.revelationType} • ${surah.verseCount} Verses',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          // Basmala
          if (showBasmala) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                basmala,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: arabicFontSize - 2,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VerseCard extends StatelessWidget {
  final Verse verse;
  final bool isBookmarked;
  final double arabicFontSize;
  final double translationFontSize;
  final Color primaryColor;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onShare;
  final VoidCallback onCopy;

  const _VerseCard({
    required this.verse,
    required this.isBookmarked,
    required this.arabicFontSize,
    required this.translationFontSize,
    required this.primaryColor,
    required this.onBookmarkToggle,
    required this.onShare,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Verse number and actions row
            Row(
              children: [
                // Verse number badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${verse.verseNumber}',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                // Juz indicator
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Juz ${verse.juzNumber}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                // Sajdah indicator
                if (verse.isSajdah) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Sajdah',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                // Action buttons
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? Colors.amber : Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: onBookmarkToggle,
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Bookmark',
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: Colors.grey[400], size: 20),
                  onPressed: onCopy,
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Copy',
                ),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.grey[400], size: 20),
                  onPressed: onShare,
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Share',
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Arabic text
            Text(
              verse.textArabic,
              style: TextStyle(
                fontSize: arabicFontSize,
                height: 2.0,
                fontWeight: FontWeight.w500,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 16),
            // Divider
            Divider(color: Colors.grey[200]),
            const SizedBox(height: 12),
            // Translation
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
      ),
    );
  }
}
