import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/hadith.dart';
import '../../services/hadith/hadith_service.dart';

class HadithDetailScreen extends StatefulWidget {
  final Hadith hadith;
  final VoidCallback? onBookmarkChanged;

  const HadithDetailScreen({
    super.key,
    required this.hadith,
    this.onBookmarkChanged,
  });

  @override
  State<HadithDetailScreen> createState() => _HadithDetailScreenState();
}

class _HadithDetailScreenState extends State<HadithDetailScreen> {
  final HadithService _hadithService = HadithService();
  late bool _isBookmarked;
  double _arabicFontSize = 28.0;
  static const String _fontSizeKey = 'hadith_arabic_font_size';
  static const Color _themeColor = Color(0xFF6D4C41);

  @override
  void initState() {
    super.initState();
    _isBookmarked = _hadithService.isBookmarked(widget.hadith.id);
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSize = prefs.getDouble(_fontSizeKey);
    if (savedSize != null && mounted) {
      setState(() => _arabicFontSize = savedSize);
    }
  }

  Future<void> _saveFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
  }

  Future<void> _toggleBookmark() async {
    await _hadithService.toggleBookmark(widget.hadith.id);
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    widget.onBookmarkChanged?.call();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(_isBookmarked ? 'Added to saved' : 'Removed from saved'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _shareHadith() {
    final shareText = '''
${HadithCollection.getDisplayName(widget.hadith.collection)} - Hadith #${widget.hadith.hadithNumber}

Narrated by: ${widget.hadith.narrator}

${widget.hadith.arabic}

Transliteration: ${widget.hadith.transliteration}

Translation: ${widget.hadith.translation}

Source: ${widget.hadith.source}
Grade: ${HadithGrade.getDisplayName(widget.hadith.grade)}

- Shared from Qiam Institute App
''';

    Share.share(shareText,
        subject:
            '${HadithCollection.getDisplayName(widget.hadith.collection)} #${widget.hadith.hadithNumber}');
  }

  void _copyToClipboard() {
    final text = '''
${widget.hadith.arabic}

${widget.hadith.translation}

- ${widget.hadith.source}
''';

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hadith copied to clipboard'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showRemarks() {
    if (widget.hadith.remarks == null || widget.hadith.remarks!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No additional commentary for this hadith'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_stories, color: _themeColor),
                  const SizedBox(width: 12),
                  Text(
                    'Commentary & Context',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _themeColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.hadith.remarks!,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showFontSizeAdjuster() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.text_fields, color: _themeColor),
                      const SizedBox(width: 12),
                      Text(
                        'Arabic Font Size',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _themeColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Preview
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _themeColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'بِسْمِ اللَّهِ',
                      style: TextStyle(
                        fontSize: _arabicFontSize,
                        fontFamily: 'Amiri',
                        height: 1.8,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Slider
                  Row(
                    children: [
                      const Text('A', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Slider(
                          value: _arabicFontSize,
                          min: 18,
                          max: 48,
                          divisions: 15,
                          activeColor: _themeColor,
                          onChanged: (value) {
                            setSheetState(() {});
                            setState(() => _arabicFontSize = value);
                            _saveFontSize(value);
                          },
                        ),
                      ),
                      const Text('A',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${HadithCollection.getDisplayName(widget.hadith.collection)} #${widget.hadith.hadithNumber}',
        ),
        backgroundColor: _themeColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: _showFontSizeAdjuster,
            tooltip: 'Font size',
          ),
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleBookmark,
            tooltip: _isBookmarked ? 'Remove bookmark' : 'Bookmark',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareHadith,
            tooltip: 'Share',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with collection info and grade
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _themeColor,
                    _themeColor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        HadithCollection.getIcon(widget.hadith.collection),
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              HadithCollection.getDisplayName(
                                  widget.hadith.collection),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Hadith #${widget.hadith.hadithNumber}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color:
                                    HadithGrade.getColor(widget.hadith.grade),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              HadithGrade.getShortName(widget.hadith.grade),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Narrator
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_outline,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.hadith.narrator,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Arabic text
                  GestureDetector(
                    onLongPress: _copyToClipboard,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _themeColor.withValues(alpha: 0.08),
                            _themeColor.withValues(alpha: 0.03),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _themeColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        widget.hadith.arabic,
                        style: TextStyle(
                          fontSize: _arabicFontSize,
                          fontFamily: 'Amiri',
                          height: 1.8,
                          color: Colors.grey[900],
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Long press to copy',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Transliteration
                  _SectionCard(
                    icon: Icons.translate,
                    title: 'Transliteration',
                    content: widget.hadith.transliteration,
                    contentStyle: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Translation
                  _SectionCard(
                    icon: Icons.language,
                    title: 'Translation',
                    content: widget.hadith.translation,
                    contentStyle: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Source
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu_book,
                          color: Colors.amber[700],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.hadith.source,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.amber[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Topic if available
                  if (widget.hadith.topic != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _themeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            HadithTopic.getIcon(widget.hadith.topic!),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            HadithTopic.getDisplayName(widget.hadith.topic!),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _themeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Commentary button if remarks exist
                  if (widget.hadith.remarks != null &&
                      widget.hadith.remarks!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: _showRemarks,
                      icon: const Icon(Icons.auto_stories),
                      label: const Text('View Commentary'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _themeColor,
                        side: BorderSide(color: _themeColor),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final TextStyle? contentStyle;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.content,
    this.contentStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: contentStyle ??
                TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.grey[800],
                ),
          ),
        ],
      ),
    );
  }
}
