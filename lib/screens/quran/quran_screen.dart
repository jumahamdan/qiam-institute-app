import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../services/quran/quran_service.dart';
import '../../services/quran/quran_audio_service.dart';
import '../../services/quran/quran_download_service.dart';
import 'surah_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final QuranService _quranService = QuranService();
  final QuranAudioService _audioService = QuranAudioService();
  final QuranDownloadService _downloadService = QuranDownloadService();
  late List<Surah> _surahs;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Map<String, int>? _lastReadPosition;

  // Download states for surahs
  Map<int, DownloadStatus> _downloadStatuses = {};
  String _currentReciterId = 'alafasy';
  StreamSubscription<DownloadProgress>? _downloadProgressSubscription;

  @override
  void initState() {
    super.initState();
    _surahs = _quranService.getAllSurahs();
    _loadLastReadPosition();
    _loadDownloadStatuses();
    _setupDownloadListener();
  }

  void _setupDownloadListener() {
    _downloadProgressSubscription = _downloadService.progressStream.listen((progress) {
      if (mounted) {
        setState(() {
          _downloadStatuses[progress.surahNumber] = progress.status;
        });
      }
    });
  }

  Future<void> _loadDownloadStatuses() async {
    final reciter = await _audioService.getSelectedReciter();
    _currentReciterId = reciter.id;

    // Load all statuses in parallel using Future.wait
    final statusFutures = _surahs.map((surah) async {
      final status = await _downloadService.getSurahDownloadStatus(
        surah.number,
        _currentReciterId,
      );
      return MapEntry(surah.number, status);
    });

    final entries = await Future.wait(statusFutures);
    final statuses = Map<int, DownloadStatus>.fromEntries(entries);

    if (mounted) {
      setState(() => _downloadStatuses = statuses);
    }
  }

  Future<void> _loadLastReadPosition() async {
    final position = await _quranService.getLastReadPosition();
    if (mounted) {
      setState(() => _lastReadPosition = position);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _downloadProgressSubscription?.cancel();
    super.dispose();
  }

  List<Surah> get _filteredSurahs {
    if (_searchQuery.isEmpty) return _surahs;
    final query = _searchQuery.toLowerCase();
    return _surahs.where((surah) {
      return surah.nameEnglish.toLowerCase().contains(query) ||
          surah.nameTransliteration.toLowerCase().contains(query) ||
          surah.nameArabic.contains(query) ||
          surah.number.toString() == query;
    }).toList();
  }

  void _openSurah(Surah surah, {int? initialVerse}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurahDetailScreen(
          surah: surah,
          initialVerse: initialVerse,
        ),
      ),
    ).then((_) {
      _loadLastReadPosition();
      _loadDownloadStatuses(); // Refresh download statuses when returning
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search surah...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) => setState(() => _searchQuery = value),
              )
            : const Text('Quran'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Last Read Card (only show if not searching and has position)
          if (!_isSearching && _lastReadPosition != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: _LastReadCard(
                surah: _quranService.getSurah(_lastReadPosition!['surah']!),
                verseNumber: _lastReadPosition!['verse']!,
                onTap: () => _openSurah(
                  _quranService.getSurah(_lastReadPosition!['surah']!),
                  initialVerse: _lastReadPosition!['verse'],
                ),
              ),
            ),

          // Surah List
          Expanded(
            child: _filteredSurahs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No surah found for "$_searchQuery"',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : Builder(
                    builder: (context) {
                      final bottomSafeArea = MediaQuery.of(context).padding.bottom;
                      return ListView.builder(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: _isSearching || _lastReadPosition == null ? 16 : 0,
                          bottom: 16 + bottomSafeArea,
                        ),
                        itemCount: _filteredSurahs.length,
                        itemBuilder: (context, index) {
                          final surah = _filteredSurahs[index];
                          final downloadStatus = _downloadStatuses[surah.number] ??
                              DownloadStatus.notDownloaded;
                          return _SurahListItem(
                            surah: surah,
                            primaryColor: primaryColor,
                            downloadStatus: downloadStatus,
                            onTap: () => _openSurah(surah),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _LastReadCard extends StatelessWidget {
  final Surah surah;
  final int verseNumber;
  final VoidCallback onTap;

  const _LastReadCard({
    required this.surah,
    required this.verseNumber,
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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.bookmark,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Continue Reading',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${surah.nameTransliteration} - Verse $verseNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      surah.nameArabic,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
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

class _SurahListItem extends StatelessWidget {
  final Surah surah;
  final Color primaryColor;
  final DownloadStatus downloadStatus;
  final VoidCallback onTap;

  const _SurahListItem({
    required this.surah,
    required this.primaryColor,
    required this.downloadStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              // Surah number in octagram
              _SurahNumberBadge(
                number: surah.number,
                color: primaryColor,
              ),
              const SizedBox(width: 12),
              // Surah info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          surah.nameTransliteration,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        // Download indicator
                        if (downloadStatus == DownloadStatus.downloaded) ...[
                          const SizedBox(width: 6),
                          Icon(
                            Icons.download_done,
                            size: 14,
                            color: Colors.green[600],
                          ),
                        ] else if (downloadStatus == DownloadStatus.downloading) ...[
                          const SizedBox(width: 6),
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          surah.revelationType.toUpperCase(),
                          style: TextStyle(
                            color: surah.revelationType == 'Makkah'
                                ? Colors.orange[700]
                                : Colors.green[700],
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' • ${surah.verseCount} verses',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arabic name
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    surah.nameArabic,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  Text(
                    surah.nameEnglish,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Surah number badge with 8-pointed star (octagram)
class _SurahNumberBadge extends StatelessWidget {
  final int number;
  final Color color;

  const _SurahNumberBadge({
    required this.number,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: _OctagramPainter(color: color),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: number > 99 ? 11 : 13,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the 8-pointed star (octagram)
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
