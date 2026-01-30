import 'package:flutter/material.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';
import '../../services/dua/dua_service.dart';
import 'dua_detail_screen.dart';

class DuaBookmarksScreen extends StatefulWidget {
  const DuaBookmarksScreen({super.key});

  @override
  State<DuaBookmarksScreen> createState() => _DuaBookmarksScreenState();
}

class _DuaBookmarksScreenState extends State<DuaBookmarksScreen> {
  final DuaService _duaService = DuaService();
  List<AzkarChapter> _bookmarkedChapters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final chapters = await _duaService.getBookmarkedChapters();
    if (mounted) {
      setState(() {
        _bookmarkedChapters = chapters;
        _isLoading = false;
      });
    }
  }

  void _openDuaDetail(AzkarChapter chapter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DuaDetailScreen(
          chapter: chapter,
          onBookmarkChanged: () {
            _loadBookmarks();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_bookmarkedChapters.isEmpty) {
      return _buildEmptyState();
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _bookmarkedChapters.length,
      itemBuilder: (context, index) {
        final chapter = _bookmarkedChapters[index];
        return _BookmarkDuaCard(
          chapter: chapter,
          onTap: () => _openDuaDetail(chapter),
          onRemove: () async {
            await _duaService.toggleBookmark(chapter.id);
            _loadBookmarks();
          },
        );
      },
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
              'Tap the bookmark icon on any dua to save it here for quick access.',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BookmarkDuaCard extends StatelessWidget {
  final AzkarChapter chapter;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _BookmarkDuaCard({
    required this.chapter,
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
                child: Text(
                  chapter.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
