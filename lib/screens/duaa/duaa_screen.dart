import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/duaa.dart';
import '../../services/duaa/duaa_service.dart';
import 'duaa_detail_screen.dart';
import 'duaa_bookmarks_screen.dart';

class DuaaScreen extends StatefulWidget {
  final bool isSearchActive;
  final VoidCallback? onSearchClose;

  const DuaaScreen({
    super.key,
    this.isSearchActive = false,
    this.onSearchClose,
  });

  @override
  State<DuaaScreen> createState() => _DuaaScreenState();
}

class _DuaaScreenState extends State<DuaaScreen> with SingleTickerProviderStateMixin {
  final DuaaService _duaaService = DuaaService();
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
    await _duaaService.initialize();
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

  void _openBookmarks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DuaaBookmarksScreen(),
      ),
    ).then((_) => setState(() {}));
  }

  void _closeSearch() {
    _searchQuery = '';
    _searchController.clear();
    widget.onSearchClose?.call();
  }

  List<Duaa> _filterDuaas(List<Duaa> duaas) {
    if (_searchQuery.isEmpty) return duaas;
    final query = _searchQuery.toLowerCase();
    return duaas.where((duaa) {
      return duaa.title.toLowerCase().contains(query) ||
          duaa.arabic.contains(query) ||
          duaa.transliteration.toLowerCase().contains(query) ||
          duaa.translation.toLowerCase().contains(query);
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
                  duaa: _duaaService.getDuaOfTheDay(),
                  onTap: () => _openDuaaDetail(_duaaService.getDuaOfTheDay()),
                ),
                const SizedBox(height: 12),
                // Bookmarks Card
                _BookmarksCard(
                  count: _duaaService.bookmarkCount,
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
              Tab(text: 'Subject wise'),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _AllDuaasTab(
                duaas: _filterDuaas(_duaaService.allDuaas),
                duaaService: _duaaService,
                onDuaaTap: _openDuaaDetail,
                onBookmarkChanged: () => setState(() {}),
                searchQuery: _searchQuery,
              ),
              _SubjectWiseTab(
                groupedDuaas: _searchQuery.isEmpty
                    ? _duaaService.groupedByCategory
                    : _getFilteredGroupedDuaas(),
                duaaService: _duaaService,
                onDuaaTap: _openDuaaDetail,
                onBookmarkChanged: () => setState(() {}),
                searchQuery: _searchQuery,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Map<String, List<Duaa>> _getFilteredGroupedDuaas() {
    final filtered = <String, List<Duaa>>{};
    for (final entry in _duaaService.groupedByCategory.entries) {
      final filteredList = _filterDuaas(entry.value);
      if (filteredList.isNotEmpty) {
        filtered[entry.key] = filteredList;
      }
    }
    return filtered;
  }
}

class _DuaOfTheDayCard extends StatelessWidget {
  final Duaa duaa;
  final VoidCallback onTap;

  const _DuaOfTheDayCard({
    required this.duaa,
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
                      duaa.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      duaa.arabic,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
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
                      'Bookmarks',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      count == 0
                          ? 'No saved duas'
                          : '$count saved dua${count == 1 ? '' : 's'}',
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

class _AllDuaasTab extends StatelessWidget {
  final List<Duaa> duaas;
  final DuaaService duaaService;
  final Function(Duaa) onDuaaTap;
  final VoidCallback onBookmarkChanged;
  final String searchQuery;

  const _AllDuaasTab({
    required this.duaas,
    required this.duaaService,
    required this.onDuaaTap,
    required this.onBookmarkChanged,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    if (duaas.isEmpty && searchQuery.isNotEmpty) {
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: duaas.length,
      itemBuilder: (context, index) {
        final duaa = duaas[index];
        return _DuaaListItem(
          index: duaa.id,
          duaa: duaa,
          isBookmarked: duaaService.isBookmarked(duaa.id),
          onTap: () => onDuaaTap(duaa),
          onBookmarkToggle: () async {
            await duaaService.toggleBookmark(duaa.id);
            onBookmarkChanged();
          },
        );
      },
    );
  }
}

class _SubjectWiseTab extends StatelessWidget {
  final Map<String, List<Duaa>> groupedDuaas;
  final DuaaService duaaService;
  final Function(Duaa) onDuaaTap;
  final VoidCallback onBookmarkChanged;
  final String searchQuery;

  const _SubjectWiseTab({
    required this.groupedDuaas,
    required this.duaaService,
    required this.onDuaaTap,
    required this.onBookmarkChanged,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final categories = groupedDuaas.keys.toList();

    if (categories.isEmpty && searchQuery.isNotEmpty) {
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, categoryIndex) {
        final category = categories[categoryIndex];
        final duaas = groupedDuaas[category]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (categoryIndex > 0) const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                DuaaCategory.getDisplayName(category),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...duaas.asMap().entries.map((entry) {
              final duaa = entry.value;
              return _DuaaListItem(
                index: duaa.id,
                duaa: duaa,
                isBookmarked: duaaService.isBookmarked(duaa.id),
                onTap: () => onDuaaTap(duaa),
                onBookmarkToggle: () async {
                  await duaaService.toggleBookmark(duaa.id);
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

class _DuaaListItem extends StatelessWidget {
  final int index;
  final Duaa duaa;
  final bool isBookmarked;
  final VoidCallback onTap;
  final VoidCallback onBookmarkToggle;

  const _DuaaListItem({
    required this.index,
    required this.duaa,
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
            children: [
              // 8-pointed star (Rub el Hizb) number badge
              _RubElHizbBadge(
                number: index,
                color: Theme.of(context).colorScheme.primary,
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
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      duaa.arabic,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
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
        ),
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

    final starPath = Path();
    const int points = 8;
    const double startAngle = -math.pi / 2;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = startAngle + (i * math.pi / points);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();
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

    // Palm
    final palmWidth = size * 0.6;
    final palmHeight = size * 0.5;

    if (isLeft) {
      // Left hand palm
      path.addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy + size * 0.1), width: palmWidth, height: palmHeight),
        Radius.circular(palmWidth * 0.2),
      ));

      // Fingers (5 rounded rectangles)
      final fingerWidth = palmWidth * 0.18;
      final fingerSpacing = palmWidth * 0.2;
      final fingerHeights = [size * 0.35, size * 0.45, size * 0.5, size * 0.42, size * 0.28];

      for (int i = 0; i < 5; i++) {
        final fingerX = center.dx - palmWidth * 0.4 + (i * fingerSpacing);
        final fingerY = center.dy - palmHeight * 0.3 - fingerHeights[i] * 0.5;
        path.addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(fingerX, fingerY), width: fingerWidth, height: fingerHeights[i]),
          Radius.circular(fingerWidth * 0.5),
        ));
      }
    } else {
      // Right hand palm
      path.addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy + size * 0.1), width: palmWidth, height: palmHeight),
        Radius.circular(palmWidth * 0.2),
      ));

      // Fingers
      final fingerWidth = palmWidth * 0.18;
      final fingerSpacing = palmWidth * 0.2;
      final fingerHeights = [size * 0.28, size * 0.42, size * 0.5, size * 0.45, size * 0.35];

      for (int i = 0; i < 5; i++) {
        final fingerX = center.dx - palmWidth * 0.4 + (i * fingerSpacing);
        final fingerY = center.dy - palmHeight * 0.3 - fingerHeights[i] * 0.5;
        path.addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(fingerX, fingerY), width: fingerWidth, height: fingerHeights[i]),
          Radius.circular(fingerWidth * 0.5),
        ));
      }
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

    // Draw 8-pointed star with alternating outer and inner points
    final path = Path();
    const int points = 8;
    const double startAngle = -math.pi / 2; // Start from top

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
