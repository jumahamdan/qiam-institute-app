import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import '../../services/quran/quran_service.dart';
import '../../services/quran/quran_audio_service.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;
  final int? initialVerse;

  const SurahDetailScreen({
    super.key,
    required this.surah,
    this.initialVerse,
  });

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final QuranService _quranService = QuranService();
  final QuranAudioService _audioService = QuranAudioService();
  late List<Verse> _verses;
  late ScrollController _scrollController;
  Set<String> _bookmarks = {};
  double _arabicFontSize = 28.0;
  double _translationFontSize = 14.0;

  // GlobalKeys for verse cards to enable precise scrolling
  late Map<int, GlobalKey> _verseKeys;

  // Audio state
  Reciter _currentReciter = QuranAudioService.reciters.first;
  bool _isPlaying = false;
  bool _isLoading = false;
  int? _currentPlayingVerse;
  int? _playlistStartVerse; // Track where playlist started for correct verse calculation
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  // Stream subscriptions (to cancel in dispose)
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<int?>? _currentIndexSubscription;

  static const String _arabicFontSizeKey = 'quran_arabic_font_size';
  static const String _translationFontSizeKey = 'quran_translation_font_size';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _verses = _quranService.getSurahVerses(widget.surah.number);
    // Initialize GlobalKeys for each verse to enable precise scrolling
    _verseKeys = {for (var v in _verses) v.verseNumber: GlobalKey()};
    _loadSettings();
    _loadBookmarks();
    _loadAudioSettings();
    _setupAudioListeners();

    // Scroll to initial verse after build
    if (widget.initialVerse != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToVerse(widget.initialVerse!);
      });
    }
  }

  void _setupAudioListeners() {
    // Listen to player state changes
    _playerStateSubscription = _audioService.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          _isLoading = state.processingState == ProcessingState.loading ||
              state.processingState == ProcessingState.buffering;
        });
      }
    });

    // Listen to position changes
    _positionSubscription = _audioService.positionStream.listen((position) {
      if (mounted) {
        setState(() => _position = position);
      }
    });

    // Listen to duration changes
    _durationSubscription = _audioService.durationStream.listen((duration) {
      if (mounted && duration != null) {
        setState(() => _duration = duration);
      }
    });

    // Listen to current index changes (for playlist)
    _currentIndexSubscription = _audioService.currentIndexStream.listen((index) {
      if (mounted && index != null && _playlistStartVerse != null) {
        // Update current playing verse based on playlist index and start verse
        setState(() {
          _currentPlayingVerse = _playlistStartVerse! + index;
        });
        // Auto-scroll to current verse
        _scrollToVerse(_currentPlayingVerse!);
      }
    });
  }

  Future<void> _loadAudioSettings() async {
    final reciter = await _audioService.getSelectedReciter();
    if (mounted) {
      setState(() => _currentReciter = reciter);
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _arabicFontSize = prefs.getDouble(_arabicFontSizeKey) ?? 28.0;
      _translationFontSize = prefs.getDouble(_translationFontSizeKey) ?? 14.0;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_arabicFontSizeKey, _arabicFontSize);
    await prefs.setDouble(_translationFontSizeKey, _translationFontSize);
  }

  Future<void> _loadBookmarks() async {
    final bookmarks = await _quranService.getBookmarks();
    setState(() => _bookmarks = bookmarks.toSet());
  }

  void _scrollToVerse(int verseNumber) {
    final key = _verseKeys[verseNumber];
    if (key?.currentContext != null) {
      // Use Scrollable.ensureVisible with alignment 0.3 to position verse
      // 30% from top, preventing it from being hidden behind bottom nav/audio bar
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.3, // Position verse 30% from top of viewport
      );
    } else {
      // Fallback to approximate position if key not yet available
      final position = (verseNumber - 1) * 150.0;
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _toggleBookmark(int verseNumber) async {
    final key = '${widget.surah.number}:$verseNumber';
    if (_bookmarks.contains(key)) {
      await _quranService.removeBookmark(widget.surah.number, verseNumber);
      _bookmarks.remove(key);
    } else {
      await _quranService.addBookmark(widget.surah.number, verseNumber);
      _bookmarks.add(key);
    }
    setState(() {});
  }

  void _saveLastRead(int verseNumber) {
    _quranService.saveLastReadPosition(widget.surah.number, verseNumber);
  }

  void _shareVerse(Verse verse) {
    final text = '''
${verse.textArabic}

${verse.translation}

— Quran ${widget.surah.nameTransliteration} (${widget.surah.number}:${verse.verseNumber})
''';
    Share.share(text);
  }

  void _copyVerse(Verse verse) {
    final text = '''${verse.textArabic}

${verse.translation}

— Quran ${widget.surah.nameTransliteration} (${widget.surah.number}:${verse.verseNumber})''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verse copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Audio control methods
  Future<void> _playVerse(int verseNumber) async {
    try {
      setState(() {
        _currentPlayingVerse = verseNumber;
        _isLoading = true;
      });
      await _audioService.playVerse(widget.surah.number, verseNumber);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing audio: $e')),
        );
      }
    }
  }

  Future<void> _playSurahFromVerse(int startVerse) async {
    try {
      setState(() {
        _currentPlayingVerse = startVerse;
        _playlistStartVerse = startVerse; // Track where playlist started
        _isLoading = true;
      });
      await _audioService.playSurah(
        widget.surah.number,
        startVerse,
        widget.surah.verseCount,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing audio: $e')),
        );
      }
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioService.pause();
    } else if (_currentPlayingVerse != null) {
      await _audioService.resume();
    } else {
      await _playSurahFromVerse(1);
    }
  }

  Future<void> _stopAudio() async {
    await _audioService.stop();
    setState(() {
      _currentPlayingVerse = null;
      _playlistStartVerse = null;
      _position = Duration.zero;
      _duration = Duration.zero;
    });
  }

  void _showReciterSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) {
          final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select Reciter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.only(bottom: bottomPadding + 16),
                  itemCount: QuranAudioService.reciters.length,
                  itemBuilder: (context, index) {
                    final reciter = QuranAudioService.reciters[index];
                    final isSelected = reciter.id == _currentReciter.id;
                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      leading: CircleAvatar(
                        backgroundColor: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[200],
                        child: Icon(
                          Icons.person,
                          color: isSelected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                      title: Text(
                        reciter.name,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        reciter.nameArabic +
                            (reciter.style.isNotEmpty
                                ? ' (${reciter.style})'
                                : ''),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary)
                          : null,
                      onTap: () async {
                        await _audioService.setSelectedReciter(reciter.id);
                        setState(() => _currentReciter = reciter);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        // If currently playing, restart with new reciter
                        if (_isPlaying && _currentPlayingVerse != null) {
                          await _playSurahFromVerse(_currentPlayingVerse!);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showFontSizeDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Font Size',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Arabic Font Size
                  Row(
                    children: [
                      const Text('Arabic'),
                      Expanded(
                        child: Slider(
                          value: _arabicFontSize,
                          min: 20,
                          max: 40,
                          divisions: 20,
                          label: _arabicFontSize.round().toString(),
                          onChanged: (value) {
                            setModalState(() => _arabicFontSize = value);
                            setState(() {});
                          },
                        ),
                      ),
                      Text('${_arabicFontSize.round()}'),
                    ],
                  ),
                  // Translation Font Size
                  Row(
                    children: [
                      const Text('Translation'),
                      Expanded(
                        child: Slider(
                          value: _translationFontSize,
                          min: 12,
                          max: 24,
                          divisions: 12,
                          label: _translationFontSize.round().toString(),
                          onChanged: (value) {
                            setModalState(() => _translationFontSize = value);
                            setState(() {});
                          },
                        ),
                      ),
                      Text('${_translationFontSize.round()}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _saveSettings();
                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // Cancel all stream subscriptions
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _currentIndexSubscription?.cancel();
    _scrollController.dispose();
    _audioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.surah.nameTransliteration,
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '${widget.surah.nameArabic} • ${widget.surah.verseCount} verses',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.record_voice_over),
            onPressed: _showReciterSelector,
            tooltip: 'Select Reciter',
          ),
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: _showFontSizeDialog,
            tooltip: 'Font Size',
          ),
        ],
      ),
      body: Column(
        children: [
          // Main content
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                // Save last read position on scroll
                if (notification is ScrollEndNotification) {
                  final visibleVerse = (_scrollController.offset / 150).round() + 1;
                  if (visibleVerse > 0 && visibleVerse <= _verses.length) {
                    _saveLastRead(visibleVerse);
                  }
                }
                return false;
              },
              child: Builder(
                builder: (context) {
                  final bottomSafeArea = MediaQuery.of(context).padding.bottom;
                  // Add extra padding when audio player is visible (~180px) plus safe area
                  final audioPlayerHeight = _currentPlayingVerse != null ? 180.0 : 0.0;
                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: 16 + bottomSafeArea + audioPlayerHeight,
                    ),
                    itemCount: _verses.length + 1, // +1 for Basmala header
                    itemBuilder: (context, index) {
                      // Basmala header (except for At-Tawbah)
                      if (index == 0) {
                        return _SurahHeader(
                          surah: widget.surah,
                          showBasmala: _quranService.surahHasBasmala(widget.surah.number),
                          basmala: _quranService.getBasmala(),
                          primaryColor: primaryColor,
                          arabicFontSize: _arabicFontSize,
                          onPlayFromStart: () => _playSurahFromVerse(1),
                          isPlaying: _isPlaying && _currentPlayingVerse == 1,
                          isLoading: _isLoading && _currentPlayingVerse == 1,
                        );
                      }

                      final verse = _verses[index - 1];
                      final isBookmarked = _bookmarks.contains(
                        '${widget.surah.number}:${verse.verseNumber}',
                      );
                      final isCurrentlyPlaying = _currentPlayingVerse == verse.verseNumber;

                      return _VerseCard(
                        key: _verseKeys[verse.verseNumber],
                        verse: verse,
                        isBookmarked: isBookmarked,
                        arabicFontSize: _arabicFontSize,
                        translationFontSize: _translationFontSize,
                        primaryColor: primaryColor,
                        isPlaying: _isPlaying && isCurrentlyPlaying,
                        isLoading: _isLoading && isCurrentlyPlaying,
                        onBookmarkToggle: () => _toggleBookmark(verse.verseNumber),
                        onShare: () => _shareVerse(verse),
                        onCopy: () => _copyVerse(verse),
                        onPlay: () => _playVerse(verse.verseNumber),
                        onPlayFromHere: () => _playSurahFromVerse(verse.verseNumber),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Audio player bar (show when audio is active)
          if (_currentPlayingVerse != null)
            _AudioPlayerBar(
              reciterName: _currentReciter.name,
              versePlaying: _currentPlayingVerse!,
              totalVerses: widget.surah.verseCount,
              isPlaying: _isPlaying,
              isLoading: _isLoading,
              position: _position,
              duration: _duration,
              primaryColor: primaryColor,
              onPlayPause: _togglePlayPause,
              onStop: _stopAudio,
              onPrevious: () async {
                if (_currentPlayingVerse! > 1) {
                  await _playSurahFromVerse(_currentPlayingVerse! - 1);
                }
              },
              onNext: () async {
                if (_currentPlayingVerse! < widget.surah.verseCount) {
                  await _playSurahFromVerse(_currentPlayingVerse! + 1);
                }
              },
              onReciterTap: _showReciterSelector,
            ),
        ],
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  final Surah surah;
  final bool showBasmala;
  final String basmala;
  final Color primaryColor;
  final double arabicFontSize;
  final VoidCallback onPlayFromStart;
  final bool isPlaying;
  final bool isLoading;

  const _SurahHeader({
    required this.surah,
    required this.showBasmala,
    required this.basmala,
    required this.primaryColor,
    required this.arabicFontSize,
    required this.onPlayFromStart,
    required this.isPlaying,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Surah name in Arabic
          Text(
            surah.nameArabic,
            style: TextStyle(
              color: Colors.white,
              fontSize: arabicFontSize + 8,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          // English name and meaning
          Text(
            '${surah.nameTransliteration} (${surah.nameEnglish})',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          // Revelation type and verse count
          Text(
            '${surah.revelationType} • ${surah.verseCount} Verses',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          // Play button
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onPlayFromStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primaryColor,
                    ),
                  )
                : Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(isPlaying ? 'Playing...' : 'Play Surah'),
          ),
          // Basmala
          if (showBasmala) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                basmala,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: arabicFontSize - 2,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VerseCard extends StatelessWidget {
  final Verse verse;
  final bool isBookmarked;
  final double arabicFontSize;
  final double translationFontSize;
  final Color primaryColor;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onShare;
  final VoidCallback onCopy;
  final VoidCallback onPlay;
  final VoidCallback onPlayFromHere;

  const _VerseCard({
    super.key,
    required this.verse,
    required this.isBookmarked,
    required this.arabicFontSize,
    required this.translationFontSize,
    required this.primaryColor,
    required this.isPlaying,
    required this.isLoading,
    required this.onBookmarkToggle,
    required this.onShare,
    required this.onCopy,
    required this.onPlay,
    required this.onPlayFromHere,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isPlaying ? primaryColor.withValues(alpha: 0.05) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isPlaying
            ? BorderSide(color: primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Verse number and actions row
            Row(
              children: [
                // Verse number badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isPlaying
                        ? primaryColor
                        : primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${verse.verseNumber}',
                      style: TextStyle(
                        color: isPlaying ? Colors.white : primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                // Juz indicator
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Juz ${verse.juzNumber}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                // Sajdah indicator
                if (verse.isSajdah) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Sajdah',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                // Play button
                IconButton(
                  icon: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primaryColor,
                          ),
                        )
                      : Icon(
                          isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: primaryColor,
                          size: 24,
                        ),
                  onPressed: isLoading ? null : onPlay,
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Play verse',
                ),
                // Action buttons
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? Colors.amber : Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: onBookmarkToggle,
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Bookmark',
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: Colors.grey[400], size: 20),
                  onPressed: onCopy,
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Copy',
                ),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.grey[400], size: 20),
                  onPressed: onShare,
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Share',
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Arabic text
            Text(
              verse.textArabic,
              style: TextStyle(
                fontSize: arabicFontSize,
                height: 2.0,
                fontWeight: FontWeight.w500,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 16),
            // Divider
            Divider(color: Colors.grey[200]),
            const SizedBox(height: 12),
            // Translation
            Text(
              verse.translation,
              style: TextStyle(
                fontSize: translationFontSize,
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioPlayerBar extends StatelessWidget {
  final String reciterName;
  final int versePlaying;
  final int totalVerses;
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration duration;
  final Color primaryColor;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onReciterTap;

  const _AudioPlayerBar({
    required this.reciterName,
    required this.versePlaying,
    required this.totalVerses,
    required this.isPlaying,
    required this.isLoading,
    required this.position,
    required this.duration,
    required this.primaryColor,
    required this.onPlayPause,
    required this.onStop,
    required this.onPrevious,
    required this.onNext,
    required this.onReciterTap,
  });

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reciter and verse info
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onReciterTap,
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          reciterName,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down,
                          color: Colors.white70, size: 16),
                    ],
                  ),
                ),
              ),
              Text(
                'Verse $versePlaying of $totalVerses',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          Row(
            children: [
              Text(
                _formatDuration(position),
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: duration.inMilliseconds > 0
                      ? position.inMilliseconds / duration.inMilliseconds
                      : 0,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDuration(duration),
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.stop, color: Colors.white70),
                onPressed: onStop,
                tooltip: 'Stop',
              ),
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: versePlaying > 1 ? onPrevious : null,
                tooltip: 'Previous verse',
              ),
              const SizedBox(width: 8),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primaryColor,
                          ),
                        )
                      : Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: primaryColor,
                        ),
                  onPressed: isLoading ? null : onPlayPause,
                  tooltip: isPlaying ? 'Pause' : 'Play',
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: versePlaying < totalVerses ? onNext : null,
                tooltip: 'Next verse',
              ),
              const SizedBox(width: 40), // Balance the stop button
            ],
          ),
        ],
      ),
    );
  }
}
