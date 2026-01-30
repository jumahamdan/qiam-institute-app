import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';
import '../../services/dua/dua_service.dart';
import 'dua_detail_screen.dart';
import 'dua_bookmarks_screen.dart';

class DuaScreen extends StatefulWidget {
  final bool isSearchActive;
  final VoidCallback? onSearchClose;

  const DuaScreen({
    super.key,
    this.isSearchActive = false,
    this.onSearchClose,
  });

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> with SingleTickerProviderStateMixin {
  final DuaService _duaService = DuaService();
  late TabController _tabController;
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeService();
  }

  Future<void> _initializeService() async {
    await _duaService.initialize();
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

  void _openDuaDetail(AzkarChapter chapter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DuaDetailScreen(
          chapter: chapter,
          onBookmarkChanged: () => setState(() {}),
        ),
      ),
    );
  }

  void _openBookmarks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DuaBookmarksScreen(),
      ),
    ).then((_) => setState(() {}));
  }

  void _closeSearch() {
    _searchQuery = '';
    _searchController.clear();
    widget.onSearchClose?.call();
  }

  List<AzkarChapter> _filterChapters(List<AzkarChapter> chapters) {
    if (_searchQuery.isEmpty) return chapters;
    final query = _searchQuery.toLowerCase();
    return chapters.where((chapter) {
      return chapter.name.toLowerCase().contains(query);
    }).toList();
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
                hintText: 'Search duas...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _closeSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                // Dua of the Day Card
                _DuaOfTheDayCard(
                  chapter: _duaService.getDuaOfTheDay(),
                  onTap: () {
                    final chapter = _duaService.getDuaOfTheDay();
                    if (chapter != null) _openDuaDetail(chapter);
                  },
                ),
                const SizedBox(height: 12),
                // Bookmarks Card
                _BookmarksCard(
                  count: _duaService.bookmarkCount,
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
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(25),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[700],
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'All Dua'),
              Tab(text: 'By Category'),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _AllDuasTab(
                chapters: _filterChapters(_duaService.allChapters),
                duaService: _duaService,
                onDuaTap: _openDuaDetail,
                onBookmarkChanged: () => setState(() {}),
                searchQuery: _searchQuery,
              ),
              _CategoryWiseTab(
                categories: _duaService.categories,
                duaService: _duaService,
                onDuaTap: _openDuaDetail,
                onBookmarkChanged: () => setState(() {}),
                searchQuery: _searchQuery,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DuaOfTheDayCard extends StatelessWidget {
  final AzkarChapter? chapter;
  final VoidCallback onTap;

  const _DuaOfTheDayCard({
    required this.chapter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (chapter == null) {
      return const SizedBox.shrink();
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Row(
            children: [
              _DuaIcon(
                size: 48,
                starColor: Colors.white.withValues(alpha: 0.9),
                handsColor: Colors.white.withValues(alpha: 0.9),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dua of the Day',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chapter!.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  String _getSavedDuasText(int count) {
    if (count == 0) return 'No saved duas';
    if (count == 1) return '1 saved dua';
    return '$count saved duas';
  }

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
                      'Bookmarks',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      _getSavedDuasText(count),
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

class _AllDuasTab extends StatelessWidget {
  final List<AzkarChapter> chapters;
  final DuaService duaService;
  final Function(AzkarChapter) onDuaTap;
  final VoidCallback onBookmarkChanged;
  final String searchQuery;

  const _AllDuasTab({
    required this.chapters,
    required this.duaService,
    required this.onDuaTap,
    required this.onBookmarkChanged,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty && searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No duas found for "$searchQuery"',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (chapters.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return _DuaListItem(
          index: index + 1,
          chapter: chapter,
          isBookmarked: duaService.isBookmarked(chapter.id),
          onTap: () => onDuaTap(chapter),
          onBookmarkToggle: () async {
            await duaService.toggleBookmark(chapter.id);
            onBookmarkChanged();
          },
        );
      },
    );
  }
}

class _CategoryWiseTab extends StatelessWidget {
  final List<AzkarCategory> categories;
  final DuaService duaService;
  final Function(AzkarChapter) onDuaTap;
  final VoidCallback onBookmarkChanged;
  final String searchQuery;

  const _CategoryWiseTab({
    required this.categories,
    required this.duaService,
    required this.onDuaTap,
    required this.onBookmarkChanged,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryCard(
          category: category,
          duaService: duaService,
          onDuaTap: onDuaTap,
          onBookmarkChanged: onBookmarkChanged,
          searchQuery: searchQuery,
        );
      },
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final AzkarCategory category;
  final DuaService duaService;
  final Function(AzkarChapter) onDuaTap;
  final VoidCallback onBookmarkChanged;
  final String searchQuery;

  const _CategoryCard({
    required this.category,
    required this.duaService,
    required this.onDuaTap,
    required this.onBookmarkChanged,
    required this.searchQuery,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isExpanded = false;
  List<AzkarChapter>? _chapters;
  bool _isLoading = false;

  Future<void> _loadChapters() async {
    if (_chapters != null) return;

    setState(() => _isLoading = true);

    final chapters = await widget.duaService.getChaptersByCategory(widget.category.id);

    if (mounted) {
      setState(() {
        _chapters = chapters;
        _isLoading = false;
      });
    }
  }

  List<AzkarChapter> _filterChapters() {
    if (_chapters == null) return [];
    if (widget.searchQuery.isEmpty) return _chapters!;

    final query = widget.searchQuery.toLowerCase();
    return _chapters!.where((c) => c.name.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final icon = DuaService.getCategoryIcon(widget.category.name);
    final filteredChapters = _filterChapters();

    // Hide category if search is active and no matching chapters
    if (widget.searchQuery.isNotEmpty && _chapters != null && filteredChapters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
              if (_isExpanded) _loadChapters();
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(icon, style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.category.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    children: filteredChapters.asMap().entries.map((entry) {
                      final chapter = entry.value;
                      return _DuaListItem(
                        index: entry.key + 1,
                        chapter: chapter,
                        isBookmarked: widget.duaService.isBookmarked(chapter.id),
                        onTap: () => widget.onDuaTap(chapter),
                        onBookmarkToggle: () async {
                          await widget.duaService.toggleBookmark(chapter.id);
                          widget.onBookmarkChanged();
                          setState(() {});
                        },
                        compact: true,
                      );
                    }).toList(),
                  ),
        ],
      ),
    );
  }
}

class _DuaListItem extends StatelessWidget {
  final int index;
  final AzkarChapter chapter;
  final bool isBookmarked;
  final VoidCallback onTap;
  final VoidCallback onBookmarkToggle;
  final bool compact;

  const _DuaListItem({
    required this.index,
    required this.chapter,
    required this.isBookmarked,
    required this.onTap,
    required this.onBookmarkToggle,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 16 : 12,
        vertical: compact ? 8 : 10,
      ),
      child: Row(
        children: [
          // 8-pointed star (Rub el Hizb) number badge
          _RubElHizbBadge(
            number: index,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              chapter.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.star : Icons.star_border,
              color: isBookmarked ? Colors.amber : Colors.grey[400],
              size: 22,
            ),
            onPressed: onBookmarkToggle,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );

    if (compact) {
      return InkWell(
        onTap: onTap,
        child: content,
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: content,
      ),
    );
  }
}

/// Dua icon - 8-pointed star with crescent moon and praying hands
class _DuaIcon extends StatelessWidget {
  final double size;
  final Color starColor;
  final Color handsColor;

  const _DuaIcon({
    required this.size,
    required this.starColor,
    required this.handsColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _DuaIconPainter(
          starColor: starColor,
          handsColor: handsColor,
        ),
      ),
    );
  }
}

/// Creates an 8-pointed star (Rub el Hizb) path
Path _createEightPointedStarPath(Offset center, double outerRadius, double innerRadius) {
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
  return path;
}

/// Custom painter for Dua icon with star, crescent, and hands
class _DuaIconPainter extends CustomPainter {
  final Color starColor;
  final Color handsColor;

  _DuaIconPainter({required this.starColor, required this.handsColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw 8-pointed star outline
    final starPaint = Paint()
      ..color = starColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04;

    final outerRadius = size.width * 0.45;
    final innerRadius = outerRadius * 0.55;

    final starPath = _createEightPointedStarPath(center, outerRadius, innerRadius);
    canvas.drawPath(starPath, starPaint);

    // Draw crescent moon
    final moonPaint = Paint()
      ..color = starColor
      ..style = PaintingStyle.fill;

    final moonRadius = size.width * 0.1;
    final moonCenter = Offset(center.dx, center.dy - size.height * 0.15);

    // Outer circle
    canvas.drawCircle(moonCenter, moonRadius, moonPaint);

    // Inner circle (to create crescent) - erase part
    final erasePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.clear;

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawCircle(moonCenter, moonRadius, moonPaint);
    canvas.drawCircle(
      Offset(moonCenter.dx + moonRadius * 0.4, moonCenter.dy),
      moonRadius * 0.75,
      erasePaint,
    );
    canvas.restore();

    // Draw two open hands
    final handPaint = Paint()
      ..color = handsColor
      ..style = PaintingStyle.fill;

    final handSize = size.width * 0.22;
    final handY = center.dy + size.height * 0.12;

    // Left hand
    _drawOpenHand(canvas, Offset(center.dx - handSize * 0.7, handY), handSize, handPaint, true);

    // Right hand
    _drawOpenHand(canvas, Offset(center.dx + handSize * 0.7, handY), handSize, handPaint, false);
  }

  void _drawOpenHand(Canvas canvas, Offset center, double size, Paint paint, bool isLeft) {
    final path = Path();
    final palmWidth = size * 0.6;
    final palmHeight = size * 0.5;

    // Palm (same for both hands)
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy + size * 0.1), width: palmWidth, height: palmHeight),
      Radius.circular(palmWidth * 0.2),
    ));

    // Fingers - heights differ based on hand orientation
    final fingerWidth = palmWidth * 0.18;
    final fingerSpacing = palmWidth * 0.2;
    final baseHeights = [size * 0.35, size * 0.45, size * 0.5, size * 0.42, size * 0.28];
    final fingerHeights = isLeft ? baseHeights : baseHeights.reversed.toList();

    for (int i = 0; i < 5; i++) {
      final fingerX = center.dx - palmWidth * 0.4 + (i * fingerSpacing);
      final fingerY = center.dy - palmHeight * 0.3 - fingerHeights[i] * 0.5;
      path.addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(fingerX, fingerY), width: fingerWidth, height: fingerHeights[i]),
        Radius.circular(fingerWidth * 0.5),
      ));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 8-pointed star badge (Rub el Hizb / Octagram)
class _RubElHizbBadge extends StatelessWidget {
  final int number;
  final Color color;

  const _RubElHizbBadge({
    required this.number,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: CustomPaint(
        painter: _RubElHizbPainter(color: color),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the 8-pointed star (Rub el Hizb) with outline style
class _RubElHizbPainter extends CustomPainter {
  final Color color;

  _RubElHizbPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 * 0.92;
    final innerRadius = outerRadius * 0.55;

    final path = _createEightPointedStarPath(center, outerRadius, innerRadius);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
