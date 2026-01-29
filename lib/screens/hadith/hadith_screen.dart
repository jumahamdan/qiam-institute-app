import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/hadith.dart';
import '../../services/hadith/hadith_service.dart';
import 'hadith_detail_screen.dart';

class HadithScreen extends StatefulWidget {
  final bool isSearchActive;
  final VoidCallback? onSearchClose;

  const HadithScreen({
    super.key,
    this.isSearchActive = false,
    this.onSearchClose,
  });

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen>
    with SingleTickerProviderStateMixin {
  final HadithService _hadithService = HadithService();
  late TabController _tabController;
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Brown theme color for Hadith
  static const Color _themeColor = Color(0xFF6D4C41);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeService();
  }

  Future<void> _initializeService() async {
    await _hadithService.initialize();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openHadithDetail(Hadith hadith) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HadithDetailScreen(
          hadith: hadith,
          onBookmarkChanged: () => setState(() {}),
        ),
      ),
    );
  }

  void _openBookmarks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _HadithBookmarksScreen(
          hadithService: _hadithService,
          onHadithTap: _openHadithDetail,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void _closeSearch() {
    _searchQuery = '';
    _searchController.clear();
    widget.onSearchClose?.call();
  }

  List<Hadith> _filterHadiths(List<Hadith> hadiths) {
    if (_searchQuery.isEmpty) return hadiths;
    return _hadithService.search(_searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Search Bar (when active from app bar)
        if (widget.isSearchActive)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search hadith...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _closeSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          )
        else
          // Top Cards Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              children: [
                // Hadith of the Day Card
                _HadithOfTheDayCard(
                  hadith: _hadithService.getHadithOfTheDay(),
                  onTap: () =>
                      _openHadithDetail(_hadithService.getHadithOfTheDay()),
                ),
                const SizedBox(height: 12),
                // Bookmarks Card
                _BookmarksCard(
                  count: _hadithService.bookmarkCount,
                  onTap: _openBookmarks,
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),

        // Tab Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: _themeColor,
              borderRadius: BorderRadius.circular(25),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[700],
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Collection'),
              Tab(text: 'Topic'),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _AllHadithsTab(
                hadiths: _filterHadiths(_hadithService.allHadiths),
                hadithService: _hadithService,
                onHadithTap: _openHadithDetail,
                onBookmarkChanged: () => setState(() {}),
                searchQuery: _searchQuery,
              ),
              _CollectionTab(
                groupedHadiths: _searchQuery.isEmpty
                    ? _hadithService.groupedByCollection
                    : _getFilteredGroupedByCollection(),
                hadithService: _hadithService,
                onHadithTap: _openHadithDetail,
                onBookmarkChanged: () => setState(() {}),
                searchQuery: _searchQuery,
              ),
              _TopicTab(
                groupedHadiths: _searchQuery.isEmpty
                    ? _hadithService.groupedByTopic
                    : _getFilteredGroupedByTopic(),
                hadithService: _hadithService,
                onHadithTap: _openHadithDetail,
                onBookmarkChanged: () => setState(() {}),
                searchQuery: _searchQuery,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Map<String, List<Hadith>> _getFilteredGroupedByCollection() {
    final filtered = <String, List<Hadith>>{};
    final searchResults = _hadithService.search(_searchQuery);
    for (final collection in HadithCollection.all) {
      final items =
          searchResults.where((h) => h.collection == collection).toList();
      if (items.isNotEmpty) {
        filtered[collection] = items;
      }
    }
    return filtered;
  }

  Map<String, List<Hadith>> _getFilteredGroupedByTopic() {
    final filtered = <String, List<Hadith>>{};
    final searchResults = _hadithService.search(_searchQuery);
    for (final topic in HadithTopic.all) {
      final items = searchResults.where((h) => h.topic == topic).toList();
      if (items.isNotEmpty) {
        filtered[topic] = items;
      }
    }
    return filtered;
  }
}

class _HadithOfTheDayCard extends StatelessWidget {
  final Hadith hadith;
  final VoidCallback onTap;

  const _HadithOfTheDayCard({
    required this.hadith,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6D4C41),
                Color(0xFF8D6E63),
              ],
            ),
          ),
          child: Row(
            children: [
              _HadithIcon(
                size: 48,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hadith of the Day',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${HadithCollection.getDisplayName(hadith.collection)} #${hadith.hadithNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hadith.translation,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookmarksCard extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _BookmarksCard({
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
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
                    const Text(
                      'Saved Hadith',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      count == 0
                          ? 'No saved hadith'
                          : '$count saved hadith${count == 1 ? '' : 's'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AllHadithsTab extends StatelessWidget {
  final List<Hadith> hadiths;
  final HadithService hadithService;
  final Function(Hadith) onHadithTap;
  final VoidCallback onBookmarkChanged;
  final String searchQuery;

  const _AllHadithsTab({
    required this.hadiths,
    required this.hadithService,
    required this.onHadithTap,
    required this.onBookmarkChanged,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    if (hadiths.isEmpty && searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hadith found for "$searchQuery"',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hadiths.length,
      itemBuilder: (context, index) {
        final hadith = hadiths[index];
        return _HadithListItem(
          hadith: hadith,
          isBookmarked: hadithService.isBookmarked(hadith.id),
          onTap: () => onHadithTap(hadith),
          onBookmarkToggle: () async {
            await hadithService.toggleBookmark(hadith.id);
            onBookmarkChanged();
          },
        );
      },
    );
  }
}

class _CollectionTab extends StatelessWidget {
  final Map<String, List<Hadith>> groupedHadiths;
  final HadithService hadithService;
  final Function(Hadith) onHadithTap;
  final VoidCallback onBookmarkChanged;
  final String searchQuery;

  const _CollectionTab({
    required this.groupedHadiths,
    required this.hadithService,
    required this.onHadithTap,
    required this.onBookmarkChanged,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final collections = groupedHadiths.keys.toList();

    if (collections.isEmpty && searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hadith found for "$searchQuery"',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: collections.length,
      itemBuilder: (context, index) {
        final collection = collections[index];
        final hadiths = groupedHadiths[collection]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6D4C41).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    HadithCollection.getIcon(collection),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${HadithCollection.getDisplayName(collection)} (${hadiths.length})',
                    style: const TextStyle(
                      color: Color(0xFF6D4C41),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...hadiths.map((hadith) {
              return _HadithListItem(
                hadith: hadith,
                isBookmarked: hadithService.isBookmarked(hadith.id),
                onTap: () => onHadithTap(hadith),
                onBookmarkToggle: () async {
                  await hadithService.toggleBookmark(hadith.id);
                  onBookmarkChanged();
                },
              );
            }),
          ],
        );
      },
    );
  }
}

class _TopicTab extends StatelessWidget {
  final Map<String, List<Hadith>> groupedHadiths;
  final HadithService hadithService;
  final Function(Hadith) onHadithTap;
  final VoidCallback onBookmarkChanged;
  final String searchQuery;

  const _TopicTab({
    required this.groupedHadiths,
    required this.hadithService,
    required this.onHadithTap,
    required this.onBookmarkChanged,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final topics = groupedHadiths.keys.toList();

    if (topics.isEmpty && searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hadith found for "$searchQuery"',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics[index];
        final hadiths = groupedHadiths[topic]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6D4C41).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    HadithTopic.getIcon(topic),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${HadithTopic.getDisplayName(topic)} (${hadiths.length})',
                    style: const TextStyle(
                      color: Color(0xFF6D4C41),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...hadiths.map((hadith) {
              return _HadithListItem(
                hadith: hadith,
                isBookmarked: hadithService.isBookmarked(hadith.id),
                onTap: () => onHadithTap(hadith),
                onBookmarkToggle: () async {
                  await hadithService.toggleBookmark(hadith.id);
                  onBookmarkChanged();
                },
              );
            }),
          ],
        );
      },
    );
  }
}

class _HadithListItem extends StatelessWidget {
  final Hadith hadith;
  final bool isBookmarked;
  final VoidCallback onTap;
  final VoidCallback onBookmarkToggle;

  const _HadithListItem({
    required this.hadith,
    required this.isBookmarked,
    required this.onTap,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Number badge
              _HadithNumberBadge(
                number: hadith.id,
                color: const Color(0xFF6D4C41),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${HadithCollection.getDisplayName(hadith.collection)} #${hadith.hadithNumber}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        _GradeBadge(grade: hadith.grade),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hadith.narrator,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hadith.translation,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? Colors.amber[700] : Colors.grey[400],
                  size: 22,
                ),
                onPressed: onBookmarkToggle,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradeBadge extends StatelessWidget {
  final String grade;

  const _GradeBadge({required this.grade});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: HadithGrade.getColor(grade).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        HadithGrade.getShortName(grade),
        style: TextStyle(
          color: HadithGrade.getColor(grade),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HadithNumberBadge extends StatelessWidget {
  final int number;
  final Color color;

  const _HadithNumberBadge({
    required this.number,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: CustomPaint(
        painter: _OctagramPainter(color: color),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: number > 99 ? 10 : 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _OctagramPainter extends CustomPainter {
  final Color color;

  _OctagramPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 * 0.92;
    final innerRadius = outerRadius * 0.55;

    final path = Path();
    const int points = 8;
    const double startAngle = -math.pi / 2;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = startAngle + (i * math.pi / points);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HadithIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _HadithIcon({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _HadithIconPainter(color: color),
      ),
    );
  }
}

class _HadithIconPainter extends CustomPainter {
  final Color color;

  _HadithIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw book shape
    final bookWidth = size.width * 0.7;
    final bookHeight = size.height * 0.5;
    final bookLeft = center.dx - bookWidth / 2;
    final bookTop = center.dy - bookHeight / 2;

    // Book spine
    final spinePath = Path()
      ..moveTo(center.dx, bookTop)
      ..lineTo(center.dx, bookTop + bookHeight);
    canvas.drawPath(spinePath, paint);

    // Left page
    final leftPath = Path()
      ..moveTo(bookLeft, bookTop + size.height * 0.05)
      ..quadraticBezierTo(bookLeft + bookWidth * 0.1, bookTop,
          center.dx, bookTop)
      ..lineTo(center.dx, bookTop + bookHeight)
      ..quadraticBezierTo(bookLeft + bookWidth * 0.1,
          bookTop + bookHeight - size.height * 0.05, bookLeft, bookTop + bookHeight - size.height * 0.05)
      ..close();
    canvas.drawPath(leftPath, paint);

    // Right page
    final rightPath = Path()
      ..moveTo(bookLeft + bookWidth, bookTop + size.height * 0.05)
      ..quadraticBezierTo(bookLeft + bookWidth - bookWidth * 0.1, bookTop,
          center.dx, bookTop)
      ..lineTo(center.dx, bookTop + bookHeight)
      ..quadraticBezierTo(bookLeft + bookWidth - bookWidth * 0.1,
          bookTop + bookHeight - size.height * 0.05, bookLeft + bookWidth, bookTop + bookHeight - size.height * 0.05)
      ..close();
    canvas.drawPath(rightPath, paint);

    // Draw star above book
    final starPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final starCenter = Offset(center.dx, bookTop - size.height * 0.15);
    final starRadius = size.width * 0.1;
    _drawStar(canvas, starCenter, starRadius, starPaint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const int points = 5;
    const double startAngle = -math.pi / 2;
    final innerRadius = radius * 0.4;

    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : innerRadius;
      final angle = startAngle + (i * math.pi / points);
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Simple bookmarks screen
class _HadithBookmarksScreen extends StatefulWidget {
  final HadithService hadithService;
  final Function(Hadith) onHadithTap;

  const _HadithBookmarksScreen({
    required this.hadithService,
    required this.onHadithTap,
  });

  @override
  State<_HadithBookmarksScreen> createState() => _HadithBookmarksScreenState();
}

class _HadithBookmarksScreenState extends State<_HadithBookmarksScreen> {
  @override
  Widget build(BuildContext context) {
    final bookmarked = widget.hadithService.getBookmarkedHadiths();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Hadith'),
        backgroundColor: const Color(0xFF6D4C41),
        foregroundColor: Colors.white,
      ),
      body: bookmarked.isEmpty
          ? Center(
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
                    'No saved hadith yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the bookmark icon to save hadith',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarked.length,
              itemBuilder: (context, index) {
                final hadith = bookmarked[index];
                return _HadithListItem(
                  hadith: hadith,
                  isBookmarked: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HadithDetailScreen(
                          hadith: hadith,
                          onBookmarkChanged: () => setState(() {}),
                        ),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  onBookmarkToggle: () async {
                    await widget.hadithService.toggleBookmark(hadith.id);
                    setState(() {});
                  },
                );
              },
            ),
    );
  }
}
