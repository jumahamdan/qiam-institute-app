# Islamic Features Plan - Qiam Institute App

> **Status:** In Progress
> **Created:** January 28, 2026
> **Last Updated:** January 29, 2026
> **Priority:** High

---

## Overview

| Feature | Package | Screen | Status |
|---------|---------|--------|--------|
| 1. Quran Reader | `quran` + `just_audio` | Full screen with surah list + reader + audio | ✅ Complete |
| 2. Tasbih Counter | Custom build | Full screen counter with 9 dhikr presets | ✅ Complete |
| 3. 99 Names of Allah | Custom build | Grid/list view + detail sheet | ✅ Complete |
| 4. Hadith Collection | Custom build | Full screen with tabs, search + bookmarks | ✅ Complete |
| 5. Dua Collection | `muslim_data_flutter` | Hisnul Muslim with categories | 🔄 Content Revamp Planned |
| 6. Adhan Notifications | TBD | Settings integration + background service | ⏳ **Next Major Feature** |

### Implementation Summary

**Completed Features:**
- **Quran Reader**: Full surah list, verse-by-verse reading with Arabic + English translation, audio playback with 10 reciters, bookmarks, last read position
- **Tasbih Counter**: 9 preset dhikr phrases, lifetime stats, haptic feedback, progress tracking
- **99 Names of Allah**: All 99 names with Arabic, transliteration, meaning & description, grid/list toggle, search
- **Hadith Collection**: Tabs for collections (Bukhari, Muslim, Nawawi, Qudsi), search, bookmarks, share functionality

**In Progress:**
- **Dua Collection**: Exists but needs content revamp using `muslim_data_flutter` (Hisnul Muslim)

**Pending Features:**
- **Adhan Notifications**: Prayer time alerts with adhan audio (Next Priority)

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
│  │              الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ                │   │
│  │                                                      │   │
│  │  All praise is due to Allah, Lord of the worlds.   │   │
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

## Feature 5: Dua Collection 🔄 CONTENT REVAMP

### Current Status: Exists but needs content upgrade

### Planned Changes

**Replace hardcoded `duaa_data.dart` with `muslim_data_flutter` package**

```yaml
dependencies:
  muslim_data_flutter: ^x.x.x  # Hisnul Muslim content
```

### Benefits of `muslim_data_flutter`:
- ✅ Authentic Hisnul Muslim content
- ✅ Organized by categories/chapters
- ✅ 5 languages: Arabic, English, Kurdish, Farsi, Russian
- ✅ Maintained package with proper sourcing

### Rename Tasks (Duaa → Dua)

| Current | New |
|---------|-----|
| `duaa_model.dart` | `dua_model.dart` |
| `services/duaa/` | `services/dua/` |
| `screens/duaa/` | `screens/dua/` |
| Class `Duaa` | Class `Dua` |
| Class `DuaaCategory` | Class `DuaCategory` |

---

## Feature 6: Adhan Notifications ⏳ NEXT MAJOR FEATURE

### Priority: **HIGH - Next to Implement**

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    ADHAN SYSTEM                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Prayer times calculated (already done ✅)               │
│                                                             │
│  2. Schedule native alarms for each prayer                  │
│     └── Uses AlarmManager (Android) / UNNotification (iOS) │
│                                                             │
│  3. When alarm fires:                                       │
│     └── Play adhan audio file (even if app closed)         │
│     └── Show notification with prayer name                 │
│                                                             │
│  4. User can customize:                                     │
│     └── Enable/disable per prayer                          │
│     └── Choose adhan sound (Makkah, Madinah, etc.)        │
│     └── Set pre-adhan reminder (5 min before)              │
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

### Key Features

- [ ] Schedule notifications for all 5 prayers
- [ ] Play actual adhan audio (full or short version)
- [ ] Work when app is closed/killed
- [ ] Per-prayer enable/disable
- [ ] Multiple adhan sounds to choose from
- [ ] Fajr special adhan option
- [ ] Pre-adhan reminder option
- [ ] Iqamah reminder (X minutes after adhan)
- [ ] Do Not Disturb awareness

---

## Audio Offline Mode

### Quran Audio Caching

**Status:** ⏳ Planned

Two approaches for offline Quran audio:

#### Option 1: Using `just_audio` Cache (Recommended)

The `just_audio` package already supports caching via `LockCachingAudioSource`. Verses played once can be replayed offline.

```dart
// Example implementation
import 'package:just_audio/just_audio.dart';

// Use LockCachingAudioSource for automatic caching
final audioSource = LockCachingAudioSource(
  Uri.parse(verseAudioUrl),
  cacheFile: File('${cacheDir.path}/surah_${surahNumber}_ayah_${ayahNumber}.mp3'),
);

await audioPlayer.setAudioSource(audioSource);
```

#### Option 2: Using `flutter_cache_manager`

Download and cache audio files with expiry control.

```dart
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Download and cache with custom expiry
final file = await DefaultCacheManager().getSingleFile(
  verseAudioUrl,
  key: 'surah_${surahNumber}_ayah_${ayahNumber}',
);
```

#### Offline Features Roadmap

- [ ] Cache audio on first play
- [ ] Download entire surah for offline
- [ ] Download progress indicator
- [ ] Manage cached audio (clear cache option)
- [ ] Show offline indicator on cached surahs

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

### Licensing Checklist

- [ ] Verify EveryAyah.com terms for app distribution
- [ ] Source Creative Commons adhan recordings
- [ ] Add attribution where required
- [ ] Document all audio sources in app credits

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
| **1c** | Audio Offline Caching | ⏳ Planned | TBD |
| **2** | Tasbih Counter | ✅ Complete | `feature/islamic-features` |
| **3** | 99 Names of Allah | ✅ Complete | `pr-11` |
| **4** | Hadith Collection | ✅ Complete | merged |
| **5** | Dua Content Revamp | 🔄 In Progress | TBD |
| **6** | Adhan Notifications | ⏳ **Next Priority** | TBD |
| **7** | Qibla Calibration | ⏳ Planned | TBD |

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
```

## Files to Create/Modify (for remaining features)

```
lib/
  models/
    dua_model.dart                🔄 Rename from duaa_model.dart
  screens/
    dua/                          🔄 Rename from duaa/
      dua_screen.dart             🔄 Update with muslim_data_flutter
  services/
    dua/                          🔄 Rename from duaa/
      dua_service.dart            🔄 Integrate muslim_data_flutter
    adhan/
      adhan_notification_service.dart ⏳
assets/
  audio/
    adhan_makkah.mp3              ⏳ Need to source/license
    adhan_madinah.mp3             ⏳
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
```

## Future Dependencies (for remaining features)

```yaml
dependencies:
  # Dua content (to be added)
  muslim_data_flutter: ^x.x.x     # Hisnul Muslim content

  # Tajweed (to be added)
  alfurqan: ^x.x.x                # Tajweed color rendering

  # Tasbih screen awake (to be added)
  wakelock_plus: ^x.x.x           # Keep screen on

  # Adhan Notifications (to be added)
  # flutter_local_notifications (already have)
  android_alarm_manager_plus: ^x.x.x  # Background scheduling
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
