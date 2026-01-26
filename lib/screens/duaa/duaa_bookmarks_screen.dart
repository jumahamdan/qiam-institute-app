import 'package:flutter/material.dart';
import '../../models/duaa.dart';
import '../../services/duaa/duaa_service.dart';
import 'duaa_detail_screen.dart';

class DuaaBookmarksScreen extends StatefulWidget {
  const DuaaBookmarksScreen({super.key});

  @override
  State<DuaaBookmarksScreen> createState() => _DuaaBookmarksScreenState();
}

class _DuaaBookmarksScreenState extends State<DuaaBookmarksScreen> {
  final DuaaService _duaaService = DuaaService();

  void _openDuaaDetail(Duaa duaa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DuaaDetailScreen(
          duaa: duaa,
          onBookmarkChanged: () => setState(() {}),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkedDuaas = _duaaService.getBookmarkedDuaas();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: bookmarkedDuaas.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarkedDuaas.length,
              itemBuilder: (context, index) {
                final duaa = bookmarkedDuaas[index];
                return _BookmarkDuaaCard(
                  duaa: duaa,
                  onTap: () => _openDuaaDetail(duaa),
                  onRemove: () async {
                    await _duaaService.toggleBookmark(duaa.id);
                    setState(() {});
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Bookmarks Yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the bookmark icon on any duaa to save it here for quick access.',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BookmarkDuaaCard extends StatelessWidget {
  final Duaa duaa;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _BookmarkDuaaCard({
    required this.duaa,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.bookmark,
                  color: Colors.amber[700],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      duaa.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      duaa.arabic,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                color: Colors.grey[400],
                onPressed: onRemove,
                tooltip: 'Remove Bookmark',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
