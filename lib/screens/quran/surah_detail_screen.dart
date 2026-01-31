import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/audio_playback_settings.dart';
import '../../services/quran/quran_service.dart';
import '../../services/quran/quran_audio_service.dart';
import '../../services/quran/quran_download_service.dart';
import 'reading_mode_view.dart';

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
  final QuranDownloadService _downloadService = QuranDownloadService();
  late List<Verse> _verses;
  late ScrollController _scrollController;
  Set<String> _bookmarks = {};
  double _arabicFontSize = 28.0;
  double _translationFontSize = 14.0;

  // GlobalKeys for verse cards to enable precise scrolling
  late Map<int, GlobalKey> _verseKeys;

  // View mode
  static const String _readingModeKey = 'quran_reading_mode';
  bool _isReadingMode = false;

  // Audio state
  Reciter _currentReciter = QuranAudioService.reciters.first;
  bool _isPlaying = false;
  bool _isLoading = false;
  int? _currentPlayingVerse;
  int? _playlistStartVerse;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  // Repeat state
  RepeatCount _verseRepeatCount = RepeatCount.off;
  int _currentRepeatIteration = 0;
  AudioPlaybackRange _range = AudioPlaybackRange.disabled;
  bool _showRepeatControls = false;

  // Download state
  DownloadStatus _downloadStatus = DownloadStatus.notDownloaded;
  DownloadProgress? _downloadProgress;

  // Stream subscriptions
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<int?>? _currentIndexSubscription;
  StreamSubscription<RepeatState>? _repeatStateSubscription;
  StreamSubscription<DownloadProgress>? _downloadProgressSubscription;

  static const String _arabicFontSizeKey = 'quran_arabic_font_size';
  static const String _translationFontSizeKey = 'quran_translation_font_size';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _verses = _quranService.getSurahVerses(widget.surah.number);
    _verseKeys = {for (var v in _verses) v.verseNumber: GlobalKey()};
    _loadSettings();
    _loadBookmarks();
    _loadAudioSettings();
    _setupAudioListeners();
    _checkDownloadStatus();

    if (widget.initialVerse != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToVerse(widget.initialVerse!);
      });
    }
  }

  void _setupAudioListeners() {
    _playerStateSubscription = _audioService.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          _isLoading = state.processingState == ProcessingState.loading ||
              state.processingState == ProcessingState.buffering;
        });

        // Handle verse completion for single verse playback only
        // Playlist playback is handled internally by the audio service
        if (state.processingState == ProcessingState.completed &&
            _currentPlayingVerse != null &&
            _playlistStartVerse == null) {
          _handleVerseComplete();
        }
      }
    });

    _positionSubscription = _audioService.positionStream.listen((position) {
      if (mounted) {
        setState(() => _position = position);
      }
    });

    _durationSubscription = _audioService.durationStream.listen((duration) {
      if (mounted && duration != null) {
        setState(() => _duration = duration);
      }
    });

    _currentIndexSubscription = _audioService.currentIndexStream.listen((index) {
      if (mounted && index != null && _playlistStartVerse != null) {
        setState(() {
          _currentPlayingVerse = _playlistStartVerse! + index;
        });
        _scrollToVerse(_currentPlayingVerse!);
      }
    });

    _repeatStateSubscription = _audioService.repeatStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _verseRepeatCount = state.verseRepeatCount;
          _currentRepeatIteration = state.currentVerseIteration;
          _range = state.range;
        });
      }
    });

    _downloadProgressSubscription = _downloadService.progressStream.listen((progress) {
      if (mounted && progress.surahNumber == widget.surah.number) {
        setState(() {
          _downloadProgress = progress;
          _downloadStatus = progress.status;
        });
      }
    });
  }

  Future<void> _handleVerseComplete() async {
    if (_currentPlayingVerse == null) return;

    final shouldReplay = await _audioService.handleVerseComplete(_currentPlayingVerse!);
    if (shouldReplay && mounted) {
      await _audioService.replayCurrentVerse();
    }
  }

  Future<void> _checkDownloadStatus() async {
    final status = await _downloadService.getSurahDownloadStatus(
      widget.surah.number,
      _currentReciter.id,
    );
    if (mounted) {
      setState(() => _downloadStatus = status);
    }
  }

  Future<void> _loadAudioSettings() async {
    final reciter = await _audioService.getSelectedReciter();
    // Initialize repeat settings in the service (syncs in-memory state)
    await _audioService.initializeRepeatSettings();
    final repeatCount = _audioService.verseRepeatCount;
    if (mounted) {
      setState(() {
        _currentReciter = reciter;
        _verseRepeatCount = repeatCount;
      });
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _arabicFontSize = prefs.getDouble(_arabicFontSizeKey) ?? 28.0;
      _translationFontSize = prefs.getDouble(_translationFontSizeKey) ?? 14.0;
      _isReadingMode = prefs.getBool(_readingModeKey) ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_arabicFontSizeKey, _arabicFontSize);
    await prefs.setDouble(_translationFontSizeKey, _translationFontSize);
  }

  Future<void> _setReadingMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_readingModeKey, value);
    setState(() => _isReadingMode = value);
  }

  Future<void> _loadBookmarks() async {
    final bookmarks = await _quranService.getBookmarks();
    setState(() => _bookmarks = bookmarks.toSet());
  }

  void _scrollToVerse(int verseNumber) {
    if (_isReadingMode) return; // Reading mode handles its own scrolling

    final key = _verseKeys[verseNumber];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
    } else {
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
        _playlistStartVerse = startVerse;
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
                        _checkDownloadStatus();
                        if (!context.mounted) return;
                        Navigator.pop(context);
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

  void _showDownloadDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) {
        return StreamBuilder<DownloadProgress>(
          stream: _downloadService.progressStream,
          builder: (context, snapshot) {
            // Use snapshot data if available and matches this surah
            final progress = snapshot.data?.surahNumber == widget.surah.number
                ? snapshot.data
                : _downloadProgress;
            final status = progress?.status ?? _downloadStatus;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Download ${widget.surah.nameTransliteration}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reciter: ${_currentReciter.name}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  if (status == DownloadStatus.downloading && progress != null) ...[
                    LinearProgressIndicator(
                      value: progress.progress,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      progress.progressText,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        _downloadService.cancelDownload(
                          widget.surah.number,
                          _currentReciter.id,
                        );
                        Navigator.pop(dialogContext);
                      },
                      child: const Text('Cancel'),
                    ),
                  ] else if (status == DownloadStatus.downloaded) ...[
                    Icon(Icons.check_circle, color: Colors.green[600], size: 48),
                    const SizedBox(height: 8),
                    const Text('Downloaded for offline playback'),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () async {
                        await _downloadService.deleteSurahDownload(
                          widget.surah.number,
                          _currentReciter.id,
                        );
                        _checkDownloadStatus();
                        if (dialogContext.mounted) Navigator.pop(dialogContext);
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete Download'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ] else ...[
                    Icon(Icons.download_outlined,
                        color: Theme.of(context).colorScheme.primary, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'Download ${widget.surah.verseCount} verses for offline listening',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        _downloadService.downloadSurah(
                          widget.surah.number,
                          widget.surah.verseCount,
                          _currentReciter.id,
                        );
                        setState(() => _downloadStatus = DownloadStatus.downloading);
                        // Don't close dialog - let StreamBuilder update UI
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Download'),
                    ),
                  ],
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
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _currentIndexSubscription?.cancel();
    _repeatStateSubscription?.cancel();
    _downloadProgressSubscription?.cancel();
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
          // Download button with status indicator
          IconButton(
            icon: Stack(
              children: [
                Icon(
                  _downloadStatus == DownloadStatus.downloaded
                      ? Icons.download_done
                      : Icons.download_outlined,
                ),
                if (_downloadStatus == DownloadStatus.downloading)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: _downloadProgress?.progress,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showDownloadDialog,
            tooltip: 'Download for offline',
          ),
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
          // View mode toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  label: Text('Verse by Verse'),
                  icon: Icon(Icons.list),
                ),
                ButtonSegment(
                  value: true,
                  label: Text('Reading Mode'),
                  icon: Icon(Icons.auto_stories),
                ),
              ],
              selected: {_isReadingMode},
              onSelectionChanged: (selected) {
                _setReadingMode(selected.first);
              },
            ),
          ),

          // Main content
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification && !_isReadingMode) {
                  final visibleVerse = (_scrollController.offset / 150).round() + 1;
                  if (visibleVerse > 0 && visibleVerse <= _verses.length) {
                    _saveLastRead(visibleVerse);
                  }
                }
                return false;
              },
              child: _isReadingMode
                  ? ReadingModeView(
                      verses: _verses,
                      arabicFontSize: _arabicFontSize,
                      currentPlayingVerse: _currentPlayingVerse,
                      primaryColor: primaryColor,
                      scrollController: _scrollController,
                      onVerseTap: (verse) => _playVerse(verse),
                    )
                  : _buildVerseByVerseView(primaryColor),
            ),
          ),

          // Audio player bar
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
              verseRepeatCount: _verseRepeatCount,
              currentRepeatIteration: _currentRepeatIteration,
              range: _range,
              showRepeatControls: _showRepeatControls,
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
              onToggleRepeatControls: () {
                setState(() => _showRepeatControls = !_showRepeatControls);
              },
              onVerseRepeatChanged: (count) async {
                await _audioService.setVerseRepeatCount(count);
              },
              onRangeChanged: (range) {
                _audioService.setRange(range);
              },
              maxVerse: widget.surah.verseCount,
            ),
        ],
      ),
    );
  }

  Widget _buildVerseByVerseView(Color primaryColor) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final audioPlayerHeight = _currentPlayingVerse != null ? 180.0 : 0.0;

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: 16 + bottomSafeArea + audioPlayerHeight,
      ),
      itemCount: _verses.length + 1,
      itemBuilder: (context, index) {
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
          Text(
            '${surah.nameTransliteration} (${surah.nameEnglish})',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${surah.revelationType} • ${surah.verseCount} Verses',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
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
            Row(
              children: [
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
            Divider(color: Colors.grey[200]),
            const SizedBox(height: 12),
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
  final RepeatCount verseRepeatCount;
  final int currentRepeatIteration;
  final AudioPlaybackRange range;
  final bool showRepeatControls;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onReciterTap;
  final VoidCallback onToggleRepeatControls;
  final Function(RepeatCount) onVerseRepeatChanged;
  final Function(AudioPlaybackRange) onRangeChanged;
  final int maxVerse;

  const _AudioPlayerBar({
    required this.reciterName,
    required this.versePlaying,
    required this.totalVerses,
    required this.isPlaying,
    required this.isLoading,
    required this.position,
    required this.duration,
    required this.primaryColor,
    required this.verseRepeatCount,
    required this.currentRepeatIteration,
    required this.range,
    required this.showRepeatControls,
    required this.onPlayPause,
    required this.onStop,
    required this.onPrevious,
    required this.onNext,
    required this.onReciterTap,
    required this.onToggleRepeatControls,
    required this.onVerseRepeatChanged,
    required this.onRangeChanged,
    required this.maxVerse,
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
              // Repeat indicator
              if (verseRepeatCount.isEnabled)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    verseRepeatCount.isInfinite
                        ? '∞ ($currentRepeatIteration)'
                        : '${currentRepeatIteration + 1}/${verseRepeatCount.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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
              IconButton(
                icon: Icon(
                  Icons.repeat,
                  color: verseRepeatCount.isEnabled || showRepeatControls
                      ? Colors.white
                      : Colors.white70,
                ),
                onPressed: onToggleRepeatControls,
                tooltip: 'Repeat options',
              ),
            ],
          ),

          // Repeat controls (expandable)
          if (showRepeatControls) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Verse Repeat (for Hifz)',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: RepeatCount.values.map((count) {
                        final isSelected = verseRepeatCount == count;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(count.label),
                            selected: isSelected,
                            onSelected: (_) => onVerseRepeatChanged(count),
                            selectedColor: Colors.white,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            labelStyle: TextStyle(
                              color: isSelected ? primaryColor : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Range Repeat',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _VerseDropdown(
                          label: 'From',
                          value: range.startVerse > 0 ? range.startVerse : 1,
                          maxVerse: maxVerse,
                          primaryColor: primaryColor,
                          onChanged: (verse) {
                            onRangeChanged(range.copyWith(
                              startVerse: verse,
                              endVerse: verse > range.endVerse ? verse : null,
                            ));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _VerseDropdown(
                          label: 'To',
                          value: range.endVerse > 0 ? range.endVerse : maxVerse,
                          maxVerse: maxVerse,
                          primaryColor: primaryColor,
                          onChanged: (verse) {
                            onRangeChanged(range.copyWith(
                              endVerse: verse,
                              startVerse: verse < range.startVerse ? verse : null,
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        RepeatCount.off,
                        RepeatCount.one,
                        RepeatCount.two,
                        RepeatCount.three,
                        RepeatCount.five,
                        RepeatCount.infinite,
                      ].map((count) {
                        final isSelected = range.rangeRepeatCount == count;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(count.label),
                            selected: isSelected,
                            onSelected: (_) {
                              onRangeChanged(range.copyWith(
                                rangeRepeatCount: count,
                                startVerse: range.startVerse > 0 ? null : 1,
                                endVerse: range.endVerse > 0 ? null : maxVerse,
                              ));
                            },
                            selectedColor: Colors.white,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            labelStyle: TextStyle(
                              color: isSelected ? primaryColor : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VerseDropdown extends StatelessWidget {
  final String label;
  final int value;
  final int maxVerse;
  final Color primaryColor;
  final Function(int) onChanged;

  const _VerseDropdown({
    required this.label,
    required this.value,
    required this.maxVerse,
    required this.primaryColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value.clamp(1, maxVerse),
          isExpanded: true,
          dropdownColor: primaryColor,
          style: const TextStyle(color: Colors.white),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
          items: List.generate(
            maxVerse,
            (index) => DropdownMenuItem(
              value: index + 1,
              child: Text('$label: ${index + 1}'),
            ),
          ),
          onChanged: (v) => onChanged(v ?? 1),
        ),
      ),
    );
  }
}
