import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/duaa.dart';
import '../../services/duaa/duaa_service.dart';

class DuaaDetailScreen extends StatefulWidget {
  final Duaa duaa;
  final VoidCallback? onBookmarkChanged;
  final String? collectionName;

  const DuaaDetailScreen({
    super.key,
    required this.duaa,
    this.onBookmarkChanged,
    this.collectionName,
  });

  @override
  State<DuaaDetailScreen> createState() => _DuaaDetailScreenState();
}

class _DuaaDetailScreenState extends State<DuaaDetailScreen> {
  final DuaaService _duaaService = DuaaService();
  late bool _isBookmarked;
  double _arabicFontSize = 28.0;
  static const String _fontSizeKey = 'duaa_arabic_font_size';

  @override
  void initState() {
    super.initState();
    _isBookmarked = _duaaService.isBookmarked(widget.duaa.id);
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
    await _duaaService.toggleBookmark(widget.duaa.id);
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    widget.onBookmarkChanged?.call();

    // Show feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isBookmarked ? 'Added to bookmarks' : 'Removed from bookmarks'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _shareDuaa() {
    final shareText = '''
${widget.duaa.title}

${widget.duaa.arabic}

Transliteration: ${widget.duaa.transliteration}

Meaning: ${widget.duaa.translation}

Source: ${widget.duaa.source}

- Shared from Qiam Institute App
''';

    Share.share(shareText, subject: widget.duaa.title);
  }

  void _showRemarks() {
    if (widget.duaa.remarks == null || widget.duaa.remarks!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No additional remarks for this dua'),
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
        final primaryColor = Theme.of(context).colorScheme.primary;
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_stories, color: primaryColor),
                  const SizedBox(width: 12),
                  Text(
                    'Remarks & Context',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.duaa.remarks!,
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
            final primaryColor = Theme.of(context).colorScheme.primary;
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.text_fields, color: primaryColor),
                      const SizedBox(width: 12),
                      Text(
                        'Arabic Font Size',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Preview
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.05),
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
                          activeColor: primaryColor,
                          label: _arabicFontSize.round().toString(),
                          onChanged: (value) {
                            setSheetState(() {});
                            setState(() => _arabicFontSize = value);
                            _saveFontSize(value);
                          },
                        ),
                      ),
                      const Text('A', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Font size: ${_arabicFontSize.round()}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _copyToClipboard() {
    final text = '''
${widget.duaa.arabic}

${widget.duaa.transliteration}

${widget.duaa.translation}
''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final backgroundColor = primaryColor.withValues(alpha: 0.03);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(Icons.arrow_back, color: primaryColor, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.collectionName ?? DuaaCategory.getDisplayName(widget.duaa.category),
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(Icons.tune, color: primaryColor, size: 20),
            ),
            onPressed: _showFontSizeAdjuster,
            tooltip: 'Adjust font size',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildDuaCard(primaryColor),
      ),
    );
  }

  Widget _buildDuaCard(Color primaryColor) {
    return Card(
      elevation: 2,
      shadowColor: primaryColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row - Dua Number + Actions
            _buildHeaderRow(primaryColor),
            const SizedBox(height: 16),

            // Dua Title
            _buildDuaTitleSection(primaryColor),
            const SizedBox(height: 20),

            // Arabic Text
            _buildArabicSection(primaryColor),
            const SizedBox(height: 20),

            // Transliteration
            _buildTransliterationSection(primaryColor),
            const SizedBox(height: 20),

            // Meaning
            _buildMeaningSection(primaryColor),
            const SizedBox(height: 20),

            // Source
            _buildSourceSection(primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Dua Number
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.duaa.formattedDuaNumber,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),

        // Action Icons
        Row(
          children: [
            // Bookmark
            _ActionIconButton(
              icon: _isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: _isBookmarked ? Colors.amber : Colors.grey[600]!,
              onTap: _toggleBookmark,
              tooltip: _isBookmarked ? 'Remove bookmark' : 'Add bookmark',
            ),
            const SizedBox(width: 4),

            // Remarks/Read
            _ActionIconButton(
              icon: Icons.auto_stories_outlined,
              color: Colors.grey[600]!,
              onTap: _showRemarks,
              tooltip: 'View remarks',
            ),
            const SizedBox(width: 4),

            // Share
            _ActionIconButton(
              icon: Icons.share_outlined,
              color: Colors.grey[600]!,
              onTap: _shareDuaa,
              tooltip: 'Share dua',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDuaTitleSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dua Name:',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.duaa.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildArabicSection(Color primaryColor) {
    return GestureDetector(
      onLongPress: _copyToClipboard,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withValues(alpha: 0.08),
              primaryColor.withValues(alpha: 0.04),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          widget.duaa.arabic,
          style: TextStyle(
            fontSize: _arabicFontSize,
            fontFamily: 'Amiri',
            height: 2.0,
            color: Colors.grey[900],
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  Widget _buildTransliterationSection(Color primaryColor) {
    return _DetailSection(
      label: 'Transliteration:',
      child: Text(
        widget.duaa.transliteration,
        style: TextStyle(
          fontSize: 15,
          fontStyle: FontStyle.italic,
          color: Colors.grey[700],
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildMeaningSection(Color primaryColor) {
    return _DetailSection(
      label: 'Meaning:',
      child: Text(
        widget.duaa.translation,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[800],
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildSourceSection(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, size: 16, color: Colors.amber[800]),
              const SizedBox(width: 6),
              Text(
                'Source:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.duaa.source,
            style: TextStyle(
              fontSize: 14,
              color: Colors.amber[900],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  const _ActionIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String label;
  final Widget child;

  const _DetailSection({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
