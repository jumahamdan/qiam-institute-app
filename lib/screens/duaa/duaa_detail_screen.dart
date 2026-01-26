import 'package:flutter/material.dart';
import '../../models/duaa.dart';
import '../../services/duaa/duaa_service.dart';

class DuaaDetailScreen extends StatefulWidget {
  final Duaa duaa;
  final VoidCallback? onBookmarkChanged;

  const DuaaDetailScreen({
    super.key,
    required this.duaa,
    this.onBookmarkChanged,
  });

  @override
  State<DuaaDetailScreen> createState() => _DuaaDetailScreenState();
}

class _DuaaDetailScreenState extends State<DuaaDetailScreen> {
  final DuaaService _duaaService = DuaaService();
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = _duaaService.isBookmarked(widget.duaa.id);
  }

  Future<void> _toggleBookmark() async {
    await _duaaService.toggleBookmark(widget.duaa.id);
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    widget.onBookmarkChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dua Details'),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? Colors.amber : null,
            ),
            onPressed: _toggleBookmark,
            tooltip: _isBookmarked ? 'Remove Bookmark' : 'Add Bookmark',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              widget.duaa.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Category chip
            Center(
              child: Chip(
                label: Text(
                  DuaaCategory.getDisplayName(widget.duaa.category),
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            const SizedBox(height: 24),

            // Arabic
            _SectionCard(
              title: 'Arabic',
              child: Text(
                widget.duaa.arabic,
                style: const TextStyle(
                  fontSize: 28,
                  fontFamily: 'Arial',
                  height: 2.0,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 16),

            // Transliteration
            _SectionCard(
              title: 'Transliteration',
              child: Text(
                widget.duaa.transliteration,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Meaning
            _SectionCard(
              title: 'Meaning',
              child: Text(
                widget.duaa.translation,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Source
            _SectionCard(
              title: 'Source',
              backgroundColor: Colors.amber.shade50,
              child: Text(
                widget.duaa.source,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.amber[900],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? backgroundColor;

  const _SectionCard({
    required this.title,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
