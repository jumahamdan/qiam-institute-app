import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

/// Service for managing Quran audio playback
class QuranAudioService {
  static final QuranAudioService _instance = QuranAudioService._internal();
  factory QuranAudioService() => _instance;
  QuranAudioService._internal();

  static const String _selectedReciterKey = 'selected_reciter';
  static const String _playbackSpeedKey = 'playback_speed';

  final AudioPlayer _audioPlayer = AudioPlayer();

  // Current playback state
  int? _currentSurah;
  int? _currentVerse;
  bool _isPlaying = false;

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
      baseUrl: 'https://everyayah.com/data/MasharRasheed_192kbps',
      // Note: MasharRasheed folder is used as a placeholder; verify against everyayah.com
    ),
  ];

  AudioPlayer get audioPlayer => _audioPlayer;

  bool get isPlaying => _isPlaying;
  int? get currentSurah => _currentSurah;
  int? get currentVerse => _currentVerse;

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

  /// Play a specific verse
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
    } catch (e) {
      _isPlaying = false;
      rethrow;
    }
  }

  /// Play entire surah from a specific verse
  Future<void> playSurah(int surahNumber, int startVerse, int totalVerses) async {
    final reciter = await getSelectedReciter();

    // Create a playlist of all verses from startVerse to end
    final playlist = ConcatenatingAudioSource(
      children: List.generate(
        totalVerses - startVerse + 1,
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
    } catch (e) {
      _isPlaying = false;
      rethrow;
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

  /// Dispose the audio player
  void dispose() {
    _audioPlayer.dispose();
  }
}
