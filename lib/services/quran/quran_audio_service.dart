import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/audio_playback_settings.dart';

/// Model for a Quran reciter
class Reciter {
  final String id;
  final String name;
  final String nameArabic;
  final String baseUrl;
  final String style;

  const Reciter({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.baseUrl,
    this.style = '',
  });
}

/// Service for managing Quran audio playback with repeat and range support
class QuranAudioService {
  static final QuranAudioService _instance = QuranAudioService._internal();
  factory QuranAudioService() => _instance;
  QuranAudioService._internal();

  static const String _selectedReciterKey = 'selected_reciter';
  static const String _playbackSpeedKey = 'playback_speed';
  static const String _verseRepeatKey = 'verse_repeat_count';

  final AudioPlayer _audioPlayer = AudioPlayer();

  // Current playback state
  int? _currentSurah;
  int? _currentVerse;
  bool _isPlaying = false;
  int _totalVerses = 0;

  // Verse repeat tracking
  RepeatCount _verseRepeatCount = RepeatCount.off;
  int _currentRepeatIteration = 0;

  // Range repeat tracking
  AudioPlaybackRange _range = AudioPlaybackRange.disabled;
  int _currentRangeIteration = 0;

  // Stream controllers for repeat state changes
  final _repeatStateController = StreamController<RepeatState>.broadcast();

  /// Available reciters (using everyayah.com CDN)
  static const List<Reciter> reciters = [
    Reciter(
      id: 'alafasy',
      name: 'Mishary Rashid Alafasy',
      nameArabic: 'مشاري راشد العفاسي',
      baseUrl: 'https://everyayah.com/data/Alafasy_128kbps',
    ),
    Reciter(
      id: 'abdulbasit_mujawwad',
      name: 'Abdul Basit (Mujawwad)',
      nameArabic: 'عبد الباسط عبد الصمد',
      baseUrl: 'https://everyayah.com/data/Abdul_Basit_Mujawwad_128kbps',
      style: 'Mujawwad',
    ),
    Reciter(
      id: 'abdulbasit_murattal',
      name: 'Abdul Basit (Murattal)',
      nameArabic: 'عبد الباسط عبد الصمد',
      baseUrl: 'https://everyayah.com/data/Abdul_Basit_Murattal_192kbps',
      style: 'Murattal',
    ),
    Reciter(
      id: 'husary',
      name: 'Mahmoud Khalil Al-Husary',
      nameArabic: 'محمود خليل الحصري',
      baseUrl: 'https://everyayah.com/data/Husary_128kbps',
    ),
    Reciter(
      id: 'minshawi_mujawwad',
      name: 'Mohamed Siddiq Al-Minshawi',
      nameArabic: 'محمد صديق المنشاوي',
      baseUrl: 'https://everyayah.com/data/Minshawy_Mujawwad_192kbps',
      style: 'Mujawwad',
    ),
    Reciter(
      id: 'sudais',
      name: 'Abdur-Rahman As-Sudais',
      nameArabic: 'عبدالرحمن السديس',
      baseUrl: 'https://everyayah.com/data/Abdurrahmaan_As-Sudais_192kbps',
    ),
    Reciter(
      id: 'shuraim',
      name: 'Saud Al-Shuraim',
      nameArabic: 'سعود الشريم',
      baseUrl: 'https://everyayah.com/data/Saood_ash-Shuraym_128kbps',
    ),
    Reciter(
      id: 'ghamdi',
      name: 'Saad Al-Ghamdi',
      nameArabic: 'سعد الغامدي',
      baseUrl: 'https://everyayah.com/data/Ghamadi_40kbps',
    ),
    Reciter(
      id: 'ajamy',
      name: 'Ahmed Al-Ajamy',
      nameArabic: 'أحمد العجمي',
      baseUrl: 'https://everyayah.com/data/ahmed_ibn_ali_al_ajamy_128kbps',
    ),
    Reciter(
      id: 'maher',
      name: 'Maher Al-Muaiqly',
      nameArabic: 'ماهر المعيقلي',
      baseUrl: 'https://everyayah.com/data/Maher_AlMuaiqly_64kbps',
    ),
  ];

  AudioPlayer get audioPlayer => _audioPlayer;

  bool get isPlaying => _isPlaying;
  int? get currentSurah => _currentSurah;
  int? get currentVerse => _currentVerse;
  RepeatCount get verseRepeatCount => _verseRepeatCount;
  int get currentRepeatIteration => _currentRepeatIteration;
  AudioPlaybackRange get range => _range;
  int get currentRangeIteration => _currentRangeIteration;

  /// Stream of repeat state changes
  Stream<RepeatState> get repeatStateStream => _repeatStateController.stream;

  /// Get the audio URL for a specific verse
  String getVerseAudioUrl(Reciter reciter, int surahNumber, int verseNumber) {
    // Format: SSS + VVV (3 digits each, zero-padded)
    final surahStr = surahNumber.toString().padLeft(3, '0');
    final verseStr = verseNumber.toString().padLeft(3, '0');
    return '${reciter.baseUrl}/$surahStr$verseStr.mp3';
  }

  /// Get saved reciter preference
  Future<Reciter> getSelectedReciter() async {
    final prefs = await SharedPreferences.getInstance();
    final reciterId = prefs.getString(_selectedReciterKey) ?? 'alafasy';
    return reciters.firstWhere(
      (r) => r.id == reciterId,
      orElse: () => reciters.first,
    );
  }

  /// Save reciter preference
  Future<void> setSelectedReciter(String reciterId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedReciterKey, reciterId);
  }

  /// Get saved playback speed
  Future<double> getPlaybackSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_playbackSpeedKey) ?? 1.0;
  }

  /// Save playback speed
  Future<void> setPlaybackSpeed(double speed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_playbackSpeedKey, speed);
    await _audioPlayer.setSpeed(speed);
  }

  /// Get saved verse repeat count
  Future<RepeatCount> getVerseRepeatCount() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_verseRepeatKey) ?? 0;
    return RepeatCount.fromValue(value);
  }

  /// Save verse repeat count
  Future<void> setVerseRepeatCount(RepeatCount count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_verseRepeatKey, count.value);
    _verseRepeatCount = count;
    _currentRepeatIteration = 0;
    _emitRepeatState();
  }

  /// Set range for range repeat
  void setRange(AudioPlaybackRange newRange) {
    _range = newRange;
    _currentRangeIteration = 0;
    _emitRepeatState();
  }

  /// Clear range repeat
  void clearRange() {
    _range = AudioPlaybackRange.disabled;
    _currentRangeIteration = 0;
    _emitRepeatState();
  }

  void _emitRepeatState() {
    _repeatStateController.add(RepeatState(
      verseRepeatCount: _verseRepeatCount,
      currentVerseIteration: _currentRepeatIteration,
      range: _range,
      currentRangeIteration: _currentRangeIteration,
      currentVerse: _currentVerse,
    ));
  }

  /// Play a specific verse with repeat support
  Future<void> playVerse(int surahNumber, int verseNumber) async {
    final reciter = await getSelectedReciter();
    final url = getVerseAudioUrl(reciter, surahNumber, verseNumber);

    try {
      await _audioPlayer.setUrl(url);
      final speed = await getPlaybackSpeed();
      await _audioPlayer.setSpeed(speed);
      await _audioPlayer.play();

      _currentSurah = surahNumber;
      _currentVerse = verseNumber;
      _isPlaying = true;
      _currentRepeatIteration = 0;
      _emitRepeatState();
    } catch (e) {
      _isPlaying = false;
      rethrow;
    }
  }

  /// Play entire surah from a specific verse with repeat support
  Future<void> playSurah(int surahNumber, int startVerse, int totalVerses) async {
    final reciter = await getSelectedReciter();
    _totalVerses = totalVerses;

    // Determine end verse based on range settings
    int endVerse = totalVerses;
    if (_range.isActive && _range.enforceBounds) {
      endVerse = _range.endVerse.clamp(startVerse, totalVerses);
    }

    // Create a playlist of verses
    final playlist = ConcatenatingAudioSource(
      children: List.generate(
        endVerse - startVerse + 1,
        (index) {
          final verseNumber = startVerse + index;
          return AudioSource.uri(
            Uri.parse(getVerseAudioUrl(reciter, surahNumber, verseNumber)),
            tag: {'surah': surahNumber, 'verse': verseNumber},
          );
        },
      ),
    );

    try {
      await _audioPlayer.setAudioSource(playlist);
      final speed = await getPlaybackSpeed();
      await _audioPlayer.setSpeed(speed);
      await _audioPlayer.play();

      _currentSurah = surahNumber;
      _currentVerse = startVerse;
      _isPlaying = true;
      _currentRepeatIteration = 0;
      _emitRepeatState();
    } catch (e) {
      _isPlaying = false;
      rethrow;
    }
  }

  /// Handle verse completion - called when a verse finishes playing
  /// Returns true if the verse should be replayed, false to continue to next
  Future<bool> handleVerseComplete(int verseNumber) async {
    // Check verse repeat first
    if (_verseRepeatCount.isEnabled) {
      _currentRepeatIteration++;

      if (_verseRepeatCount.isInfinite ||
          _currentRepeatIteration < _verseRepeatCount.value) {
        _emitRepeatState();
        return true; // Replay same verse
      }

      // Reset for next verse
      _currentRepeatIteration = 0;
    }

    // Check if we've reached the end of range
    if (_range.isActive && verseNumber >= _range.endVerse) {
      _currentRangeIteration++;

      if (_range.rangeRepeatCount.isInfinite ||
          _currentRangeIteration < _range.rangeRepeatCount.value) {
        // Restart from beginning of range
        _emitRepeatState();
        if (_currentSurah != null) {
          await playSurah(_currentSurah!, _range.startVerse, _totalVerses);
        }
        return true;
      }

      // Range complete, reset
      _currentRangeIteration = 0;
    }

    _emitRepeatState();
    return false; // Continue to next verse
  }

  /// Replay current verse (for manual repeat trigger or verse repeat)
  Future<void> replayCurrentVerse() async {
    if (_currentSurah != null && _currentVerse != null) {
      await playVerse(_currentSurah!, _currentVerse!);
    }
  }

  /// Pause playback
  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  /// Resume playback
  Future<void> resume() async {
    await _audioPlayer.play();
    _isPlaying = true;
  }

  /// Stop playback
  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentSurah = null;
    _currentVerse = null;
    _currentRepeatIteration = 0;
    _currentRangeIteration = 0;
    _emitRepeatState();
  }

  /// Seek to next track in playlist
  Future<void> seekToNext() async {
    await _audioPlayer.seekToNext();
  }

  /// Seek to previous track in playlist
  Future<void> seekToPrevious() async {
    await _audioPlayer.seekToPrevious();
  }

  /// Get current position stream
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  /// Get duration stream
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  /// Get player state stream
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  /// Get current index stream (for playlist tracking)
  Stream<int?> get currentIndexStream => _audioPlayer.currentIndexStream;

  /// Get sequence state stream (for detecting verse completion)
  Stream<SequenceState?> get sequenceStateStream => _audioPlayer.sequenceStateStream;

  /// Dispose the audio player
  void dispose() {
    _repeatStateController.close();
    _audioPlayer.dispose();
  }
}

/// State model for repeat status updates
class RepeatState {
  final RepeatCount verseRepeatCount;
  final int currentVerseIteration;
  final AudioPlaybackRange range;
  final int currentRangeIteration;
  final int? currentVerse;

  RepeatState({
    required this.verseRepeatCount,
    required this.currentVerseIteration,
    required this.range,
    required this.currentRangeIteration,
    this.currentVerse,
  });

  /// Get display text for verse repeat status
  String? get verseRepeatText {
    if (!verseRepeatCount.isEnabled) return null;
    if (verseRepeatCount.isInfinite) {
      return 'Repeating ($currentVerseIteration)';
    }
    return 'Repeat ${currentVerseIteration + 1}/${verseRepeatCount.value}';
  }

  /// Get display text for range repeat status
  String? get rangeRepeatText {
    if (!range.isActive) return null;
    if (range.rangeRepeatCount.isInfinite) {
      return 'Range: ${range.startVerse}-${range.endVerse} (Loop $currentRangeIteration)';
    }
    return 'Range: ${range.startVerse}-${range.endVerse} (${currentRangeIteration + 1}/${range.rangeRepeatCount.value})';
  }
}
