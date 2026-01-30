# Islamic Features Plan - Qiam Institute App

> **Status:** In Progress
> **Created:** January 28, 2026
> **Last Updated:** January 30, 2026
> **Priority:** High

---

## Overview

| Feature | Package | Screen | Status |
|---------|---------|--------|--------|
| 1. Quran Reader | `quran` + `just_audio` | Full screen with surah list + reader + audio | ✅ Complete |
| 2. Tasbih Counter | Custom build | Full screen counter with 9 dhikr presets | ✅ Complete |
| 3. 99 Names of Allah | Custom build | Grid/list view + detail sheet | ✅ Complete |
| 4. Hadith Collection | Custom build | Full screen with tabs, search + bookmarks | ✅ Complete |
| 5. Dua Collection | `muslim_data_flutter` | Hisnul Muslim with categories | ✅ Complete |
| 6. Adhan Notifications | `android_alarm_manager_plus` + `just_audio` | Settings integration + background service | ✅ Complete |

### Implementation Summary

**Completed Features:**
- **Quran Reader**: Full surah list, verse-by-verse reading with Arabic + English translation, audio playback with 10 reciters, bookmarks, last read position
- **Tasbih Counter**: 9 preset dhikr phrases, lifetime stats, haptic feedback, progress tracking
- **99 Names of Allah**: All 99 names with Arabic, transliteration, meaning & description, grid/list toggle, search
- **Hadith Collection**: Tabs for collections (Bukhari, Muslim, Nawawi, Qudsi), search, bookmarks, share functionality
- **Adhan Notifications**: Background audio playback, per-prayer settings, multiple adhan sounds (Makkah, Madinah, Mishary), pre-prayer reminders, volume control, separate Fajr sound option
- **Dua Collection**: Hisnul Muslim content via `muslim_data_flutter`, categories, bookmarks, search, dua of the day

---

## Feature 1: Quran Reader

### Screens

```
┌─────────────────────────────────────────────────────────────┐
│                    QURAN HOME SCREEN                        │
├─────────────────────────────────────────────────────────────┤
│  🔍 Search surah or ayah...                                 │
│                                                             │
│  [Surah Tab]  [Juz Tab]  [Bookmarks Tab]                   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 1. Al-Fatihah (الفاتحة)              7 verses  Makkah│   │
│  │ 2. Al-Baqarah (البقرة)             286 verses  Madinah│   │
│  │ 3. Aal-E-Imran (آل عمران)          200 verses  Madinah│   │
│  │ ...                                                  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  Last Read: Al-Baqarah, Ayah 255         [Continue →]      │
└─────────────────────────────────────────────────────────────┘
```

```
┌─────────────────────────────────────────────────────────────┐
│                    SURAH READER SCREEN                      │
├─────────────────────────────────────────────────────────────┤
│  ← Al-Fatihah                           🔊   ⚙️  🔖         │
│     The Opening • 7 verses • Makkah                         │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                      │   │
│  │              بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ              │   │
│  │                                                      │   │
│  │  In the name of Allah, the Most Gracious,           │   │
│  │  the Most Merciful.                                 │   │
│  │                                                      │   │
│  │  ─────────────────────────────────────────────────  │   │
│  │                                                      │   │
│  │  2.  الرَّحِيمُ                                          │   │
│  │      Ar-Raheem                                       │   │
│  │      The Most Merciful                               │   │
│  │                                                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  Audio: [▶️ advancement advancement advancement advancement]│
│  Reciter: Mishary Rashid Alafasy              [⚙️]         │
└─────────────────────────────────────────────────────────────┘
```

### Package & Dependencies

```yaml
dependencies:
  quran: ^1.4.1           # Quran text, translations, audio URLs
  just_audio: ^0.9.x      # Audio playback
  audio_service: ^0.18.x  # Background audio (optional)
  # Future: alfurqan for Tajweed colors
```

### Data Structure

```dart
// From quran package:
- Surah list (114 surahs with metadata)
- Arabic text
- English translation (Saheeh International)
- Audio URLs for each ayah (multiple reciters)
- Juz/Page data (getJuzNumber() available)
- Sajdah verses
- Revelation type (Makki/Madani via revelationType)
```

### Key Features

- [x] Surah list with search
- [ ] Juz navigation tab (data exists, UI needed)
- [x] Arabic text display (proper RTL font)
- [x] English translation toggle
- [x] Audio playback (verse by verse or continuous)
- [x] Multiple reciters (10 reciters: Alafasy, Abdul Basit, Husary, Sudais, Shuraim, Ghamdi, Ajamy, Maher, Minshawi)
- [x] Bookmarks ✅
- [x] Last read position ✅
- [ ] Font size adjustment
- [x] Night mode support (follows app theme)
- [ ] Makki/Madani badge (data exists via `revelationType`)
- [ ] Tajweed colors (use `alfurqan` package)
- [ ] Offline audio caching (see Audio Offline Mode section)

### Planned Enhancements

| Enhancement | Package/Method | Priority |
|-------------|----------------|----------|
| Juz Tab | `getJuzNumber()` from quran package | Medium |
| Makki/Madani Badge | `revelationType` already available | Low |
| Tajweed Colors | `alfurqan` package (`VerseMode.uthmani_tajweed`) | Medium |
| Bookmarks Tab UI | Backend exists in `quran_bookmark_service.dart` | Medium |
| Audio Offline Cache | `LockCachingAudioSource` from just_audio | High |

### Tajweed Implementation Recommendation

**Recommended: `alfurqan` package**
- ✅ Offline, ready-made tajweed mode
- ✅ No GetX dependency (compatible with Provider architecture)
- ✅ Can run alongside current `quran` package
- ❌ Avoid `quran_library` - requires GetX which conflicts with app architecture

---

## Feature 2: Tasbih Counter

### Screen Design

```
┌─────────────────────────────────────────────────────────────┐
│                    TASBIH COUNTER                           │
├─────────────────────────────────────────────────────────────┤
│  ←                                               [⚙️] [📊]  │
│                                                             │
│              سُبْحَانَ اللَّهِ                                    │
│              SubhanAllah                                    │
│              "Glory be to Allah"                            │
│                                                             │
│                                                             │
│                    ┌─────────┐                              │
│                    │         │                              │
│                    │   33    │                              │
│                    │         │                              │
│                    └─────────┘                              │
│                     / 33 ✓                                  │
│                                                             │
│              ┌───────────────────────┐                      │
│              │                       │                      │
│              │      TAP TO COUNT     │    ← Large tap area  │
│              │                       │                      │
│              │         👆            │                      │
│              │                       │                      │
│              └───────────────────────┘                      │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  [SubhanAllah] [Alhamdulillah] [AllahuAkbar] [Custom]      │
│       33            33             33                       │
│                                                             │
│        [🔄 Reset]              [✓ Complete Set]            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Features

```dart
// Preset dhikr options
List<Dhikr> presets = [
  Dhikr(arabic: 'سُبْحَانَ اللَّهِ', transliteration: 'SubhanAllah', meaning: 'Glory be to Allah', target: 33),
  Dhikr(arabic: 'الْحَمْدُ لِلَّهِ', transliteration: 'Alhamdulillah', meaning: 'Praise be to Allah', target: 33),
  Dhikr(arabic: 'اللَّهُ أَكْبَرُ', transliteration: 'Allahu Akbar', meaning: 'Allah is the Greatest', target: 33),
  Dhikr(arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ', transliteration: 'La ilaha illallah', meaning: 'None worthy of worship except Allah', target: 100),
  Dhikr(arabic: 'أَسْتَغْفِرُ اللَّهَ', transliteration: 'Astaghfirullah', meaning: 'I seek forgiveness from Allah', target: 100),
];
```

### Key Features

- [x] Large tap area (whole screen tappable)
- [x] Haptic feedback on each tap
- [x] **No sound by design** (haptic only - intentional)
- [x] Preset dhikr with targets (33, 100, etc.) - 9 presets
- [ ] Custom dhikr with custom target input
- [x] Visual progress indicator (circle)
- [x] Completion celebration (subtle animation)
- [x] Lifetime statistics tracking
- [x] Reset count
- [ ] Keep screen awake option (`wakelock_plus` package)
- [ ] Works in landscape mode

### Planned Enhancements

| Enhancement | Package/Method | Priority |
|-------------|----------------|----------|
| Screen Awake | `wakelock_plus` package | High |
| Custom Dhikr Input | Text input + custom target | Medium |

---

## Feature 3: 99 Names of Allah

### Screens

```
┌─────────────────────────────────────────────────────────────┐
│                    99 NAMES OF ALLAH                        │
├─────────────────────────────────────────────────────────────┤
│  ← Asma ul Husna                              🔍            │
│                                                             │
│  "And to Allah belong the most beautiful names"             │
│                           — Quran 7:180                     │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                      │   │
│  │  1.  الرَّحْمَنُ                                         │   │
│  │      Ar-Rahman                                       │   │
│  │      The Most Gracious                               │   │
│  │                                                      │   │
│  │  ─────────────────────────────────────────────────  │   │
│  │                                                      │   │
│  │  2.  الرَّحِيمُ                                          │   │
│  │      Ar-Raheem                                       │   │
│  │      The Most Merciful                               │   │
│  │                                                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  [🔀 Random Name]          [▶️ Play All]                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Key Features

- [x] List all 99 names with Arabic, transliteration, meaning
- [x] Detail screen with extended explanation (bottom sheet)
- [ ] Audio pronunciation (requires audio files or TTS)
- [x] Search by name or meaning
- [ ] Favorites list (local storage)
- [ ] Random name widget (for home screen or daily)
- [ ] Share name as image
- [x] Grid/list view toggle

### Planned Enhancements

| Enhancement | Method | Priority |
|-------------|--------|----------|
| Audio Pronunciation | Audio files or TTS | Low |
| Favorites List | SharedPreferences | Medium |
| Random Name Feature | Daily rotation widget | Low |
| Share as Image | Screenshot + share | Low |

---

## Feature 4: Hadith Collection ✅ COMPLETE

### Status: ✅ Fully Implemented

### Screens

```
┌─────────────────────────────────────────────────────────────┐
│                    HADITH COLLECTION                        │
├─────────────────────────────────────────────────────────────┤
│  🔍 Search hadith...                                        │
│                                                             │
│  [Bukhari] [Muslim] [Nawawi] [Qudsi] [Bookmarks]           │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  📖 HADITH OF THE DAY                                │   │
│  │                                                      │   │
│  │  "The best among you are those who have the best    │   │
│  │   manners and character."                           │   │
│  │                                                      │   │
│  │                    — Sahih Bukhari                   │   │
│  │                                                      │   │
│  │  [Read More]                         [Share]        │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Implemented Features

- [x] Tabs for collections (Bukhari, Muslim, Nawawi, Qudsi)
- [x] Search by keyword
- [x] Hadith detail view
- [x] Bookmark favorites
- [x] Share hadith
- [x] 40 Nawawi collection
- [x] Hadith Qudsi collection

---

## Feature 5: Dua Collection ✅ COMPLETE

### Status: ✅ Fully Implemented

### Implementation

**Using `muslim_data_flutter` package v1.5.0 for Hisnul Muslim content**

```yaml
dependencies:
  muslim_data_flutter: ^1.5.0  # Hisnul Muslim content
```

### Benefits of `muslim_data_flutter`:
- ✅ Authentic Hisnul Muslim content
- ✅ Organized by categories/chapters
- ✅ 5 languages: Arabic, English, Kurdish, Farsi, Russian
- ✅ Maintained package with proper sourcing

### Implemented Features:
- [x] Hisnul Muslim duas with categories
- [x] Dua of the Day feature
- [x] Bookmarks (by chapter ID)
- [x] Search functionality
- [x] Multi-item navigation (for chapters with multiple duas)
- [x] Arabic text with adjustable font size
- [x] Translation display
- [x] Reference/source display
- [x] Share and copy functionality
- [x] Renamed codebase from `duaa` → `dua`

---

## Feature 6: Adhan Notifications ✅ COMPLETE

### Status: ✅ Fully Implemented

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    ADHAN SYSTEM                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Prayer times calculated (PrayerService ✅)              │
│                                                             │
│  2. Schedule alarms via AlarmManager                        │
│     └── Survives app kill & device reboot                   │
│     └── Reschedules daily at 3:00 AM                       │
│                                                             │
│  3. When alarm fires:                                       │
│     └── Start foreground service (audio keeps playing)     │
│     └── Play adhan audio via just_audio                    │
│     └── Show notification with prayer name                 │
│                                                             │
│  4. User can customize:                                     │
│     └── Enable/disable globally or per prayer              │
│     └── Choose adhan sound (Makkah, Madinah, Mishary)     │
│     └── Set pre-adhan reminder (5-30 min before)          │
│     └── Separate Fajr adhan sound option                   │
│     └── Volume and vibration controls                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Settings Screen Addition

```
┌─────────────────────────────────────────────────────────────┐
│                    ADHAN SETTINGS                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  🔔 Adhan Notifications                          [  ON  ]   │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  Prayer Alerts:                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Fajr                              [🔔] [🔊 Adhan ▼] │   │
│  │ Dhuhr                             [🔔] [🔊 Adhan ▼] │   │
│  │ Asr                               [🔔] [🔊 Adhan ▼] │   │
│  │ Maghrib                           [🔔] [🔊 Adhan ▼] │   │
│  │ Isha                              [🔔] [🔊 Adhan ▼] │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  Adhan Sound:                           [Makkah Adhan ▼]   │
│                                                             │
│  Pre-Adhan Reminder:                    [5 minutes ▼]      │
│                                                             │
│  [🔊 Preview Adhan Sound]                                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Package & Dependencies

```yaml
dependencies:
  flutter_local_notifications: ^x.x.x  # Already have
  android_alarm_manager_plus: ^x.x.x   # Background scheduling
  just_audio: ^0.9.x                   # Play adhan audio
```

### Adhan Audio Files

```
assets/
  audio/
    adhan_makkah.mp3          # ~3-4 MB
    adhan_madinah.mp3
    adhan_mishary.mp3
    adhan_fajr.mp3            # Different adhan for Fajr
    notification_short.mp3    # Short beep option
```

### Implemented Features

- [x] Schedule notifications for all 5 prayers
- [x] Play actual adhan audio (Makkah, Madinah, Mishary)
- [x] Work when app is closed/killed (foreground service)
- [x] Per-prayer enable/disable
- [x] Multiple adhan sounds to choose from
- [x] Fajr special adhan option
- [x] Pre-adhan reminder option (5, 10, 15, 20, 30 min)
- [x] Volume control
- [x] Vibration toggle
- [x] Sound preview in settings
- [x] Survives device reboot
- [x] Android 14+ SCHEDULE_EXACT_ALARM permission handling
- [ ] Iqamah reminder (X minutes after adhan)
- [ ] Do Not Disturb awareness

---

## Audio Offline Mode

### Quran Audio Caching

**Status:** 🔄 Phase 1 In Progress

### Phase 1: Basic Caching (Auto-cache on play) - HIGH PRIORITY

| Task | Description | Status |
|------|-------------|--------|
| 1.1 | Add `flutter_cache_manager` package | ⏳ Todo |
| 1.2 | Modify `quran_audio_service.dart` to use `LockCachingAudioSource` | ⏳ Todo |
| 1.3 | Cache verses automatically as they're played | ⏳ Todo |
| 1.4 | Add cache indicator icon on cached verses | ⏳ Todo |

#### Implementation Details

```dart
// Example implementation for quran_audio_service.dart
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class QuranAudioService {
  // Use LockCachingAudioSource for automatic caching
  Future<AudioSource> _getCachedAudioSource(String url, int surahNumber, int ayahNumber) async {
    final cacheDir = await getTemporaryDirectory();
    final cacheFile = File('${cacheDir.path}/quran_audio/surah_${surahNumber}_ayah_${ayahNumber}.mp3');
    
    // Create directory if it doesn't exist
    await cacheFile.parent.create(recursive: true);
    
    return LockCachingAudioSource(
      Uri.parse(url),
      cacheFile: cacheFile,
    );
  }
}
```

#### Dependencies to Add

```yaml
dependencies:
  flutter_cache_manager: ^3.3.1  # For cache management
  path_provider: ^2.1.1          # Already have (for cache directory)
```

### Phase 2: Download Surah (Manual download) - MEDIUM PRIORITY

| Task | Description | Status |
|------|-------------|--------|
| 2.1 | Add "Download Surah" button in surah detail screen | ⏳ Planned |
| 2.2 | Download all verses of a surah with progress indicator | ⏳ Planned |
| 2.3 | Show download status (downloaded/partial/not downloaded) | ⏳ Planned |
| 2.4 | Store download state in SharedPreferences | ⏳ Planned |

### Phase 3: Cache Management - LOW PRIORITY

| Task | Description | Status |
|------|-------------|--------|
| 3.1 | Add "Manage Downloads" screen in settings | ⏳ Planned |
| 3.2 | Show total cache size | ⏳ Planned |
| 3.3 | Clear cache option (all or per surah) | ⏳ Planned |
| 3.4 | Set max cache size limit | ⏳ Planned |

---

## Audio Licensing & Sources

> ⚠️ **Important:** Audio licensing must be verified before distribution.

### Quran Recitation Sources

| Source | Type | Notes |
|--------|------|-------|
| [EveryAyah.com](https://everyayah.com) | Free for apps | ✅ Already used by `quran` package for recitation URLs |
| [QuranicAudio.com](https://quranicaudio.com) | Free | Large collection, check terms |
| Islamic archives | Varies | Some Creative Commons |
| Makkah/Madinah official | Requires permission | Contact Saudi authorities |

### Adhan Audio Sources

| Source | License | Notes |
|--------|---------|-------|
| Public domain recordings | Free | Some classic recordings |
| Creative Commons | Attribution required | Check each recording |
| Makkah/Madinah muezzins | Requires permission | Most authentic |
| Self-recorded | Full rights | Consider hiring a muezzin |

### Current Audio Implementation

```
✅ Quran Recitation: Using EveryAyah.com URLs (via quran package)
   - 10 reciters available
   - Streaming from CDN
   - No local files required

⏳ Adhan Audio: To be added
   - Need to source licensed recordings
   - Will be stored in assets/audio/
```

### Licensing Status

| Source | Verified | Notes |
|--------|----------|-------|
| EveryAyah.com | ✅ Yes | Free for apps, attribution recommended |
| Adhan files (current) | ⚠️ Check | Need to document sources for each file |

**Recommendation:** Add attribution in About/Credits section:
> "Quran audio recitations provided by EveryAyah.com"

---

## Offline Mode Status

### Current Offline Capabilities ✅

| Feature | Offline? | Notes |
|---------|----------|-------|
| Quran Text | ✅ Yes | Bundled with app |
| Quran Audio | ❌ No | Streaming only (caching planned) |
| 99 Names | ✅ Yes | Local data |
| Hadith | ✅ Yes | Local data |
| Tasbih Stats | ✅ Yes | SharedPreferences |
| Prayer Times | ✅ Yes | Calculated locally |
| Bookmarks | ✅ Yes | Local storage |
| Events | ❌ No | WordPress API required |
| Live Stream | ❌ No | YouTube API required |

### Planned Offline Enhancements

- [ ] Quran audio download/caching
- [ ] Events caching (last fetched)

---

## Qibla Calibration Improvements

### Current Issue
Qibla accuracy is slightly off. Current implementation detects when accuracy < 15 but only shows text "Move in figure-8."

### Planned Improvements

- [ ] Animated figure-8 calibration guide
- [ ] Accuracy percentage display bar
- [ ] Calibration tutorial overlay
- [ ] Visual feedback when calibration improves

---

## Prayer Times Calendar Redesign

### Status: ⏳ Planned

### Design Goals
- Clean, scannable daily prayer time cards
- Clear date hierarchy with Gregorian dates
- Sunrise/Sunset times prominently displayed
- Easy PDF export functionality
- **Uses existing Qiam app theme** (colors, typography, spacing)

### What's Changing vs Current
| Element | Current | New |
|---------|---------|-----|
| Daily layout | Table/list rows | Card per day |
| Date format | Various | "DD MMM, YYYY" |
| Sunrise/Sunset | Hidden or separate | On each card |
| Location display | Shown | ❌ Removed |

### Proposed Screen Layout

```
┌─────────────────────────────────────────────────────────────┐
│  ← Prayer Times - 2026                                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  📄 Export PDF                                       │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Calculation Method: ISNA                            │   │
│  │  Asr Calculation: Hanafi                             │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  01 Jan, 2026           Sunrise: 7:19 AM             │   │
│  │                         Sunset: 4:32 PM              │   │
│  │  ───────────────────────────────────────────────────│   │
│  │  Fajr      Dhuhr      Asr      Maghrib      Isha    │   │
│  │  5:56 AM   11:57 AM   2:51 PM   4:32 PM    5:56 PM  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  02 Jan, 2026           Sunrise: 7:19 AM             │   │
│  │                         Sunset: 4:33 PM              │   │
│  │  ───────────────────────────────────────────────────│   │
│  │  Fajr      Dhuhr      Asr      Maghrib      Isha    │   │
│  │  5:56 AM   11:57 AM   2:52 PM   4:33 PM    5:56 PM  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ... (scrollable list for full year)                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Daily Card Structure

```
┌──────────────────────────────────────────────────────────┐
│  [Date - Left]                    [Sunrise/Sunset - Right]│
│  01 Jan, 2026                     Sunrise: 7:19 AM        │
│                                   Sunset: 4:32 PM         │
│  ─────────────────────────────────────────────────────────│
│  Fajr      Dhuhr      Asr       Maghrib      Isha        │
│  5:56 AM   11:57 AM   2:51 PM   4:32 PM      5:56 PM     │
└──────────────────────────────────────────────────────────┘
```

### Design Specifications

#### Header Section
| Element | Description |
|---------|-------------|
| Back arrow | Navigate to previous screen |
| Title | "Prayer Times - [Year]" |
| ❌ No location | Removed per requirements |

#### Export Button
| Element | Description |
|---------|-------------|
| Style | Full-width outlined button |
| Icon | PDF document icon |
| Text | "Export PDF" |

#### Calculation Info Card
| Element | Description |
|---------|-------------|
| Content | Calculation Method + Asr Method |
| Style | Subtle card (follows app theme) |
| ❌ Removed | Location line |

#### Daily Prayer Card
| Element | Description |
|---------|-------------|
| **Top Row Left** | Date in "DD MMM, YYYY" format |
| **Top Row Right** | Sunrise + Sunset times |
| **Divider** | Horizontal line |
| **Bottom Row** | 5 prayer times, evenly spaced |
| **Time Format** | 12-hour with AM/PM |

### Typography (Using Qiam Theme)
| Element | Style |
|---------|-------|
| Screen title | AppBar title style |
| Date | Semi-bold, body text |
| Sunrise/Sunset | Regular, caption size |
| Prayer labels | Regular, caption, muted |
| Prayer times | Medium, body text |

### Interaction Behaviors
| Action | Behavior |
|--------|----------|
| Scroll | Smooth vertical scroll through days |
| Export PDF | Generate and share PDF |
| Open screen | Auto-scroll to today's date |
| Today's card | Optional: Highlight with accent border |

### Implementation Tasks

| Task | Description | Priority |
|------|-------------|----------|
| 8.1 | Create daily prayer card widget | High |
| 8.2 | Update screen layout with new cards | High |
| 8.3 | Remove location display | High |
| 8.4 | Add Sunrise/Sunset to each card | High |
| 8.5 | Update date format to "DD MMM, YYYY" | High |
| 8.6 | Auto-scroll to today on open | Medium |
| 8.7 | Update Export PDF button styling | Medium |
| 8.8 | Optional: Add today highlight | Low |

### Files to Modify

```
lib/
  screens/
    prayer_times/
      prayer_times_calendar_screen.dart  🔄 Redesign
  widgets/
    prayer_time_day_card.dart            🆕 New widget (optional)
```

---

## New Explore Page Layout

```
┌─────────────────────────────────────────────────────────────┐
│                    EXPLORE SCREEN                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Explore                                                    │
│  Discover programs, events, and ways to get involved        │
│                                                             │
│  ┌─────────────┬─────────────┬─────────────┐               │
│  │   📖        │   📿        │   🕌        │               │
│  │  Quran     │  Tasbih    │  99 Names   │               │
│  │            │  Counter   │  of Allah   │               │
│  ├─────────────┼─────────────┼─────────────┤               │
│  │   📜        │   🤲        │   📅        │               │
│  │  Hadith    │   Dua      │  Events     │               │
│  │            │            │             │               │
│  ├─────────────┼─────────────┼─────────────┤               │
│  │   🔔        │   📺        │   🙋        │               │
│  │  Adhan     │   Media    │  Volunteer  │               │
│  │  Settings  │            │             │               │
│  ├─────────────┼─────────────┼─────────────┤               │
│  │   ⭐        │   📆        │   📍        │               │
│  │  Values    │  Islamic   │   About/    │               │
│  │            │  Calendar  │   Contact   │               │
│  └─────────────┴─────────────┴─────────────┘               │
│                                                             │
│  [Facebook] [Instagram] [YouTube] [Twitter] [TikTok]       │
│                                                             │
│        [ ❤️ Support Qiam Institute ]                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Implementation Progress

| Phase | Feature | Status | Branch |
|-------|---------|--------|--------|
| **1** | Quran Reader + Audio | ✅ Complete | `feature/islamic-features` |
| **1b** | Quran Bookmarks & Last Read | ✅ Complete | `feature/islamic-features` |
| **1c** | Quran Audio Caching - Phase 1 | 🔄 In Progress | TBD |
| **2** | Tasbih Counter | ✅ Complete | `feature/islamic-features` |
| **3** | 99 Names of Allah | ✅ Complete | `pr-11` |
| **4** | Hadith Collection | ✅ Complete | merged |
| **5** | Dua Collection (muslim_data_flutter) | ✅ Complete | `feature/dua-collection` |
| **6** | Adhan Notifications | ✅ Complete | `feature/adhan-notifications` (PR #18) |
| **6b** | Adhan Settings UI Improvement | ⏳ Planned | TBD |
| **7** | Qibla Calibration | ⏳ Planned | TBD |
| **8** | Prayer Times Calendar Redesign | ⏳ Planned | TBD |

---

## Files Created

```
lib/
  screens/
    quran/
      quran_screen.dart           ✅ Surah list + search
      surah_detail_screen.dart    ✅ Verse reader + audio player
    tasbih/
      tasbih_screen.dart          ✅ Full counter with dhikr selector
    names_of_allah/
      names_screen.dart           ✅ Grid/list view + detail sheet
    hadith/
      hadith_screen.dart          ✅ Tabs + search + bookmarks
    dua/
      dua_screen.dart             ✅ Categories + all duas + bookmarks
      dua_detail_screen.dart      ✅ Dua content with multi-item navigation
      dua_bookmarks_screen.dart   ✅ Saved duas list
    settings/
      adhan_settings_screen.dart  ✅ Advanced adhan settings UI
  services/
    quran/
      quran_audio_service.dart    ✅ 10 reciters, playlist support
      quran_bookmark_service.dart ✅ Bookmark management
    tasbih/
      tasbih_service.dart         ✅ Progress & stats tracking
    names_of_allah/
      names_service.dart          ✅ All 99 names with descriptions
    hadith/
      hadith_service.dart         ✅ Hadith data management
    dua/
      dua_service.dart            ✅ muslim_data_flutter wrapper + bookmarks
    adhan/
      adhan_notification_service.dart ✅ Main orchestrator
      adhan_scheduler.dart            ✅ AlarmManager scheduling
      adhan_audio_service.dart        ✅ Foreground service + audio
      adhan_settings.dart             ✅ SharedPreferences persistence
      adhan_sounds.dart               ✅ Sound catalog

assets/
  audio/
    adhan/
      makkah.mp3                  ✅ Ahmad al Nafees (3.3 MB)
      madinah.mp3                 ✅ Hafiz Mustafa Özcan (3.7 MB)
      mishary.mp3                 ✅ Mishary Rashid Alafasy (5.2 MB)
      fajr_makkah.mp3             ✅ Traditional Fajr melody (3.8 MB)
      fajr_madinah.mp3            ✅ Traditional Fajr melody (3.8 MB)
      beep.mp3                    ✅ Short notification (17 KB)
```

---

## Dependencies Added

```yaml
# pubspec.yaml - Packages added for Islamic features

dependencies:
  # Quran text and data
  quran: ^1.4.1

  # Audio player for Quran recitation
  just_audio: ^0.9.40
  audio_session: ^0.1.21

  # Tasbih & 99 Names (no extra packages needed)
  # - shared_preferences (already have)
  # - HapticFeedback (built-in Flutter)

  # Dua content (Hisnul Muslim)
  muslim_data_flutter: ^1.5.0
```

## Future Dependencies (for remaining features)

```yaml
dependencies:
  # Tajweed (to be added)
  alfurqan: ^x.x.x                # Tajweed color rendering

  # Tasbih screen awake (to be added)
  wakelock_plus: ^x.x.x           # Keep screen on
```

---

## Future Considerations (Low Priority)

| Feature | Description | Priority |
|---------|-------------|----------|
| Home Screen Widget | Native widget showing next prayer time | Low |
| Bookmark Sync | Cloud backup via Firebase (requires auth) | Low |
| Dynamic Hijri Date | Show today's Hijri date using `hijri` package | Low |

---

## Notes

- All features should support dark mode
- Arabic text should use proper RTL rendering
- ✅ Offline support exists for most features (Quran text, Hadith, 99 Names, Prayer times)
- Audio features need background playback consideration
- Adhan audio requires proper licensing before distribution
