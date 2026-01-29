import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:just_audio/just_audio.dart';

import 'adhan_settings.dart';
import 'adhan_sounds.dart';

/// Handles adhan audio playback with foreground service support.
class AdhanAudioService {
  static final AdhanAudioService _instance = AdhanAudioService._internal();
  factory AdhanAudioService() => _instance;
  AdhanAudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AdhanSettings _settings = AdhanSettings();

  bool _isPlaying = false;
  String? _currentPrayer;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  /// Whether adhan is currently playing.
  bool get isPlaying => _isPlaying;

  /// The prayer for which adhan is currently playing.
  String? get currentPrayer => _currentPrayer;

  /// Callback when adhan playback completes.
  void Function()? onPlaybackComplete;

  /// Initialize the audio service.
  Future<void> initialize() async {
    await _settings.init();
    await _initForegroundTask();
  }

  Future<void> _initForegroundTask() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'adhan_playback',
        channelName: 'Adhan Playback',
        channelDescription: 'Playing adhan for prayer time',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
        iconData: const NotificationIconData(
          resType: ResourceType.drawable,
          resPrefix: ResourcePrefix.ic,
          name: 'notification',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );
  }

  /// Play adhan for a specific prayer.
  Future<void> playAdhan(String prayer) async {
    if (_isPlaying) {
      await stopAdhan();
    }

    _currentPrayer = prayer;
    final sound = _settings.getSoundForPrayer(prayer);

    debugPrint('AdhanAudioService: Playing adhan for $prayer (${sound.name})');

    try {
      // Start foreground service
      await _startForegroundService(prayer);

      // Set up audio player
      await _audioPlayer.setAsset(sound.assetPath);
      await _audioPlayer.setVolume(_settings.volume);

      // Listen for completion
      _playerStateSubscription?.cancel();
      _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _onPlaybackComplete();
        }
      });

      // Start playback
      _isPlaying = true;
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('AdhanAudioService: Error playing adhan: $e');
      await _cleanup();
    }
  }

  /// Preview an adhan sound (short preview without foreground service).
  Future<void> previewSound(AdhanSound sound, {Duration? maxDuration}) async {
    await stopAdhan();

    try {
      await _audioPlayer.setAsset(sound.assetPath);
      await _audioPlayer.setVolume(_settings.volume);

      // Play for max duration or until stopped
      final previewDuration = maxDuration ?? const Duration(seconds: 10);

      _isPlaying = true;
      await _audioPlayer.play();

      // Auto-stop after preview duration
      Future.delayed(previewDuration, () {
        if (_isPlaying) {
          stopAdhan();
        }
      });
    } catch (e) {
      debugPrint('AdhanAudioService: Error previewing sound: $e');
      _isPlaying = false;
    }
  }

  /// Stop the currently playing adhan.
  Future<void> stopAdhan() async {
    if (!_isPlaying && _currentPrayer == null) return;

    debugPrint('AdhanAudioService: Stopping adhan');
    await _cleanup();
  }

  Future<void> _onPlaybackComplete() async {
    debugPrint('AdhanAudioService: Playback completed');
    await _cleanup();
    onPlaybackComplete?.call();
  }

  Future<void> _cleanup() async {
    _isPlaying = false;
    _currentPrayer = null;

    _playerStateSubscription?.cancel();
    _playerStateSubscription = null;

    try {
      await _audioPlayer.stop();
    } catch (_) {}

    await _stopForegroundService();
  }

  Future<void> _startForegroundService(String prayer) async {
    await FlutterForegroundTask.startService(
      notificationTitle: 'Adhan - $prayer',
      notificationText: 'Playing adhan. Tap to open app.',
    );
  }

  Future<void> _stopForegroundService({int retryCount = 3}) async {
    var attempt = 0;

    while (attempt < retryCount) {
      try {
        await FlutterForegroundTask.stopService();
        return;
      } catch (e) {
        attempt++;
        debugPrint(
          'AdhanAudioService: Failed to stop foreground service '
          '(attempt $attempt of $retryCount): $e',
        );

        if (attempt >= retryCount) {
          debugPrint(
            'AdhanAudioService: Giving up on stopping foreground service '
            'after $retryCount attempts.',
          );
          return;
        }

        // Small delay before retrying to handle transient issues.
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
  }

  /// Update volume during playback.
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Dispose resources.
  void dispose() {
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    _stopForegroundService();
  }
}
