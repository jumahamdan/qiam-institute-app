import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/dua/dua_service.dart';

class DuaDetailScreen extends StatefulWidget {
  final AzkarChapter chapter;
  final VoidCallback? onBookmarkChanged;

  const DuaDetailScreen({
    super.key,
    required this.chapter,
    this.onBookmarkChanged,
  });

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  final DuaService _duaService = DuaService();
  late bool _isBookmarked;
  double _arabicFontSize = 28.0;
  static const String _fontSizeKey = 'dua_arabic_font_size';

  List<AzkarItem> _items = [];
  bool _isLoading = true;
  int _currentItemIndex = 0;

  @override
  void initState() {
    super.initState();
    _isBookmarked = _duaService.isBookmarked(widget.chapter.id);
    _loadFontSize();
    _loadItems();
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

  Future<void> _loadItems() async {
    final items = await _duaService.getChapterItems(widget.chapter.id);
    if (mounted) {
      setState(() {
        _items = items;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    await _duaService.toggleBookmark(widget.chapter.id);
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    widget.onBookmarkChanged?.call();

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

  void _shareDua() {
    if (_items.isEmpty) return;

    final item = _items[_currentItemIndex];
    final shareText = '''
${widget.chapter.name}

${item.item}

${item.translation}

${item.reference}

- Shared from Qiam Institute App
''';

    Share.share(shareText, subject: widget.chapter.name);
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
    if (_items.isEmpty) return;

    final item = _items[_currentItemIndex];
    final text = '''
${item.item}

${item.translation}
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          'Dua',
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
      body: _buildBody(primaryColor),
    );
  }

  Widget _buildBody(Color primaryColor) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_items.isEmpty) {
      return _buildEmptyState();
    }
    return _buildContent(primaryColor);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No dua content available',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Color primaryColor) {
    return Column(
      children: [
        // Chapter title header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withValues(alpha: 0.1),
                primaryColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.chapter.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),

        // Item navigation (if multiple items)
        if (_items.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _currentItemIndex > 0
                      ? () => setState(() => _currentItemIndex--)
                      : null,
                ),
                Text(
                  '${_currentItemIndex + 1} / ${_items.length}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _currentItemIndex < _items.length - 1
                      ? () => setState(() => _currentItemIndex++)
                      : null,
                ),
              ],
            ),
          ),

        // Dua content
        Expanded(
          child: Builder(
            builder: (context) {
              final bottomSafeArea = MediaQuery.of(context).padding.bottom;
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 16 + bottomSafeArea,
                ),
                child: _buildDuaCard(primaryColor, _items[_currentItemIndex]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDuaCard(Color primaryColor, AzkarItem item) {
    final hasArabic = item.item.isNotEmpty;
    final hasTranslation = item.translation.isNotEmpty;
    final hasReference = item.reference.isNotEmpty;

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
            // Header Row - Actions
            _buildHeaderRow(primaryColor),
            const SizedBox(height: 20),

            // Arabic Text
            if (hasArabic) _buildArabicSection(primaryColor, item.item),

            if (hasArabic) const SizedBox(height: 20),

            // Translation/Meaning
            if (hasTranslation) _buildMeaningSection(primaryColor, item.translation),

            if (hasTranslation) const SizedBox(height: 20),

            // Reference
            if (hasReference) _buildSourceSection(primaryColor, item.reference),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Bookmark
        _ActionIconButton(
          icon: _isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
          color: _isBookmarked ? Colors.amber : Colors.grey[600]!,
          onTap: _toggleBookmark,
          tooltip: _isBookmarked ? 'Remove bookmark' : 'Add bookmark',
        ),
        const SizedBox(width: 4),

        // Copy
        _ActionIconButton(
          icon: Icons.copy_outlined,
          color: Colors.grey[600]!,
          onTap: _copyToClipboard,
          tooltip: 'Copy to clipboard',
        ),
        const SizedBox(width: 4),

        // Share
        _ActionIconButton(
          icon: Icons.share_outlined,
          color: Colors.grey[600]!,
          onTap: _shareDua,
          tooltip: 'Share dua',
        ),
      ],
    );
  }

  Widget _buildArabicSection(Color primaryColor, String arabicText) {
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
          arabicText,
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

  Widget _buildMeaningSection(Color primaryColor, String translation) {
    return _DetailSection(
      label: 'Meaning:',
      child: Text(
        translation,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[800],
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildSourceSection(Color primaryColor, String reference) {
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
                'Reference:',
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
            reference,
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
