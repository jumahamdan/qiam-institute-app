# Audio Offline Mode

> **Status:** 🔄 Phase 1 In Progress

---

## Overview

Enable offline playback of Quran audio by caching verses as they're played.

---

## Phase 1: Auto-cache on Play (HIGH PRIORITY)

| Task | Status |
|------|--------|
| Add `flutter_cache_manager` package | ⏳ |
| Modify `quran_audio_service.dart` with `LockCachingAudioSource` | ⏳ |
| Cache verses automatically as played | ⏳ |
| Add cache indicator icon on cached verses | ⏳ |

### Implementation Example

```dart
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class QuranAudioService {
  Future<AudioSource> _getCachedAudioSource(
    String url, 
    int surahNumber, 
    int ayahNumber
  ) async {
    final cacheDir = await getTemporaryDirectory();
    final cacheFile = File(
      '${cacheDir.path}/quran_audio/surah_${surahNumber}_ayah_${ayahNumber}.mp3'
    );
    
    await cacheFile.parent.create(recursive: true);
    
    return LockCachingAudioSource(
      Uri.parse(url),
      cacheFile: cacheFile,
    );
  }
}
```

### Dependencies

```yaml
dependencies:
  flutter_cache_manager: ^3.3.1
  path_provider: ^2.1.1  # Already have
```

---

## Phase 2: Manual Download (MEDIUM PRIORITY)

| Task | Status |
|------|--------|
| Add "Download Surah" button in surah detail screen | ⏳ |
| Download all verses with progress indicator | ⏳ |
| Show download status (downloaded/partial/none) | ⏳ |
| Store download state in SharedPreferences | ⏳ |

---

## Phase 3: Cache Management (LOW PRIORITY)

| Task | Status |
|------|--------|
| "Manage Downloads" screen in settings | ⏳ |
| Show total cache size | ⏳ |
| Clear cache option (all or per surah) | ⏳ |
| Set max cache size limit | ⏳ |

---

[← Back to Plan](../islamic-features-plan.md)
