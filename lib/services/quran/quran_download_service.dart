import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quran_audio_service.dart';

/// Download status for a surah
enum DownloadStatus {
  notDownloaded,
  downloading,
  downloaded,
  error,
}

/// Progress info for surah download
class DownloadProgress {
  final int surahNumber;
  final String reciterId;
  final int currentVerse;
  final int totalVerses;
  final DownloadStatus status;
  final String? error;

  DownloadProgress({
    required this.surahNumber,
    required this.reciterId,
    required this.currentVerse,
    required this.totalVerses,
    required this.status,
    this.error,
  });

  double get progress =>
      totalVerses > 0 ? currentVerse / totalVerses : 0.0;

  String get progressText => '$currentVerse / $totalVerses verses';
}

/// Service for managing offline Quran audio downloads
class QuranDownloadService {
  static final QuranDownloadService _instance = QuranDownloadService._internal();
  factory QuranDownloadService() => _instance;
  QuranDownloadService._internal();

  static const String _downloadedSurahsKey = 'downloaded_surahs';
  static const String _downloadSizeKey = 'download_total_size';

  final _progressController = StreamController<DownloadProgress>.broadcast();
  final Map<String, bool> _activeDownloads = {};

  /// Stream of download progress updates
  Stream<DownloadProgress> get progressStream => _progressController.stream;

  /// Get the local directory for storing Quran audio
  Future<Directory> get _audioDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${appDir.path}/quran_audio');
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    return audioDir;
  }

  /// Get the key for a surah download (surahNumber_reciterId)
  String _getSurahKey(int surahNumber, String reciterId) =>
      '${surahNumber}_$reciterId';

  /// Get download status for a surah
  Future<DownloadStatus> getSurahDownloadStatus(
    int surahNumber,
    String reciterId,
  ) async {
    final key = _getSurahKey(surahNumber, reciterId);

    // Check if currently downloading
    if (_activeDownloads[key] == true) {
      return DownloadStatus.downloading;
    }

    // Check if downloaded
    final prefs = await SharedPreferences.getInstance();
    final downloaded = prefs.getStringList(_downloadedSurahsKey) ?? [];
    if (downloaded.contains(key)) {
      // Verify files still exist
      final exists = await _verifySurahFiles(surahNumber, reciterId);
      if (exists) {
        return DownloadStatus.downloaded;
      }
      // Files were deleted, remove from list
      downloaded.remove(key);
      await prefs.setStringList(_downloadedSurahsKey, downloaded);
    }

    return DownloadStatus.notDownloaded;
  }

  /// Check if all verse files exist for a surah
  Future<bool> _verifySurahFiles(int surahNumber, String reciterId) async {
    final audioDir = await _audioDirectory;
    final surahDir = Directory('${audioDir.path}/$reciterId/$surahNumber');
    if (!await surahDir.exists()) return false;

    // Just check if directory has files (quick check)
    final files = await surahDir.list().toList();
    return files.isNotEmpty;
  }

  /// Get local file path for a verse audio
  Future<String?> getLocalVersePath(
    int surahNumber,
    int verseNumber,
    String reciterId,
  ) async {
    final audioDir = await _audioDirectory;
    final filePath =
        '${audioDir.path}/$reciterId/$surahNumber/${surahNumber}_$verseNumber.mp3';
    final file = File(filePath);
    if (await file.exists()) {
      return filePath;
    }
    return null;
  }

  /// Get verse audio URL - returns local path if downloaded, otherwise remote URL
  Future<String> getVerseAudioUrl(
    int surahNumber,
    int verseNumber,
    Reciter reciter,
  ) async {
    // Check for local file first
    final localPath = await getLocalVersePath(
      surahNumber,
      verseNumber,
      reciter.id,
    );
    if (localPath != null) {
      return 'file://$localPath';
    }

    // Fall back to streaming URL
    final surahStr = surahNumber.toString().padLeft(3, '0');
    final verseStr = verseNumber.toString().padLeft(3, '0');
    return '${reciter.baseUrl}/$surahStr$verseStr.mp3';
  }

  /// Download all verses for a surah
  Future<void> downloadSurah(
    int surahNumber,
    int totalVerses,
    String reciterId,
  ) async {
    final key = _getSurahKey(surahNumber, reciterId);

    // Check if already downloading
    if (_activeDownloads[key] == true) {
      return;
    }

    _activeDownloads[key] = true;

    final reciter = QuranAudioService.reciters.firstWhere(
      (r) => r.id == reciterId,
      orElse: () => QuranAudioService.reciters.first,
    );

    final audioDir = await _audioDirectory;
    final surahDir = Directory('${audioDir.path}/$reciterId/$surahNumber');
    if (!await surahDir.exists()) {
      await surahDir.create(recursive: true);
    }

    int downloadedCount = 0;
    int totalSize = 0;

    try {
      for (int verse = 1; verse <= totalVerses; verse++) {
        // Check if cancelled
        if (_activeDownloads[key] != true) {
          _progressController.add(DownloadProgress(
            surahNumber: surahNumber,
            reciterId: reciterId,
            currentVerse: downloadedCount,
            totalVerses: totalVerses,
            status: DownloadStatus.notDownloaded,
            error: 'Cancelled',
          ));
          return;
        }

        final surahStr = surahNumber.toString().padLeft(3, '0');
        final verseStr = verse.toString().padLeft(3, '0');
        final url = '${reciter.baseUrl}/$surahStr$verseStr.mp3';
        final filePath = '${surahDir.path}/${surahNumber}_$verse.mp3';

        // Check if already downloaded
        final file = File(filePath);
        if (await file.exists()) {
          downloadedCount++;
          totalSize += await file.length();
          continue;
        }

        // Download verse
        try {
          final response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            await file.writeAsBytes(response.bodyBytes);
            downloadedCount++;
            totalSize += response.bodyBytes.length;

            _progressController.add(DownloadProgress(
              surahNumber: surahNumber,
              reciterId: reciterId,
              currentVerse: downloadedCount,
              totalVerses: totalVerses,
              status: DownloadStatus.downloading,
            ));
          } else {
            throw Exception('HTTP ${response.statusCode}');
          }
        } catch (e) {
          // Retry once
          await Future.delayed(const Duration(seconds: 1));
          try {
            final response = await http.get(Uri.parse(url));
            if (response.statusCode == 200) {
              await file.writeAsBytes(response.bodyBytes);
              downloadedCount++;
              totalSize += response.bodyBytes.length;

              _progressController.add(DownloadProgress(
                surahNumber: surahNumber,
                reciterId: reciterId,
                currentVerse: downloadedCount,
                totalVerses: totalVerses,
                status: DownloadStatus.downloading,
              ));
            } else {
              throw Exception('HTTP ${response.statusCode}');
            }
          } catch (retryError) {
            _progressController.add(DownloadProgress(
              surahNumber: surahNumber,
              reciterId: reciterId,
              currentVerse: downloadedCount,
              totalVerses: totalVerses,
              status: DownloadStatus.error,
              error: 'Failed to download verse $verse: $retryError',
            ));
            _activeDownloads.remove(key);
            return;
          }
        }
      }

      // Mark as downloaded
      final prefs = await SharedPreferences.getInstance();
      final downloaded = prefs.getStringList(_downloadedSurahsKey) ?? [];
      if (!downloaded.contains(key)) {
        downloaded.add(key);
        await prefs.setStringList(_downloadedSurahsKey, downloaded);
      }

      // Update total size
      final currentSize = prefs.getInt(_downloadSizeKey) ?? 0;
      await prefs.setInt(_downloadSizeKey, currentSize + totalSize);

      _progressController.add(DownloadProgress(
        surahNumber: surahNumber,
        reciterId: reciterId,
        currentVerse: totalVerses,
        totalVerses: totalVerses,
        status: DownloadStatus.downloaded,
      ));
    } finally {
      _activeDownloads.remove(key);
    }
  }

  /// Cancel ongoing download
  void cancelDownload(int surahNumber, String reciterId) {
    final key = _getSurahKey(surahNumber, reciterId);
    _activeDownloads[key] = false;
  }

  /// Delete downloaded surah
  Future<void> deleteSurahDownload(int surahNumber, String reciterId) async {
    final key = _getSurahKey(surahNumber, reciterId);

    final audioDir = await _audioDirectory;
    final surahDir = Directory('${audioDir.path}/$reciterId/$surahNumber');

    if (await surahDir.exists()) {
      // Calculate size before deleting
      int deletedSize = 0;
      await for (final file in surahDir.list()) {
        if (file is File) {
          deletedSize += await file.length();
        }
      }

      await surahDir.delete(recursive: true);

      // Update preferences
      final prefs = await SharedPreferences.getInstance();
      final downloaded = prefs.getStringList(_downloadedSurahsKey) ?? [];
      downloaded.remove(key);
      await prefs.setStringList(_downloadedSurahsKey, downloaded);

      // Update total size
      final currentSize = prefs.getInt(_downloadSizeKey) ?? 0;
      await prefs.setInt(_downloadSizeKey, (currentSize - deletedSize).clamp(0, currentSize));
    }

    _progressController.add(DownloadProgress(
      surahNumber: surahNumber,
      reciterId: reciterId,
      currentVerse: 0,
      totalVerses: 0,
      status: DownloadStatus.notDownloaded,
    ));
  }

  /// Delete all downloaded audio
  Future<void> deleteAllDownloads() async {
    final audioDir = await _audioDirectory;
    if (await audioDir.exists()) {
      await audioDir.delete(recursive: true);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_downloadedSurahsKey, []);
    await prefs.setInt(_downloadSizeKey, 0);
  }

  /// Get list of downloaded surahs for a reciter
  Future<List<int>> getDownloadedSurahs(String reciterId) async {
    final prefs = await SharedPreferences.getInstance();
    final downloaded = prefs.getStringList(_downloadedSurahsKey) ?? [];

    return downloaded
        .where((key) => key.endsWith('_$reciterId'))
        .map((key) => int.tryParse(key.split('_').first) ?? 0)
        .where((surahNum) => surahNum > 0)
        .toList();
  }

  /// Get total downloaded size in bytes
  Future<int> getTotalDownloadedSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_downloadSizeKey) ?? 0;
  }

  /// Get formatted size string
  String formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Dispose resources
  void dispose() {
    _progressController.close();
  }
}
