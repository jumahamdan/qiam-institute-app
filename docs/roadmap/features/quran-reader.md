# Feature 1: Quran Reader

> **Status:** ✅ Complete (Base + Enhancements)
> **Branch:** `feature/quran-reader-enhancements`  
> **Package:** `quran` + `just_audio`

---

## Overview

Full-featured Quran reader with surah list, verse-by-verse reading, audio playback, and bookmarks.

---

## Current Implementation ✅

| Feature                           | Status |
| --------------------------------- | ------ |
| Surah list with search            | ✅      |
| Arabic text display (RTL)         | ✅      |
| English translation toggle        | ✅      |
| Audio playback (verse/continuous) | ✅      |
| Multiple reciters (10)            | ✅      |
| Bookmarks                         | ✅      |
| Last read position                | ✅      |
| Night mode support                | ✅      |
| Playback speed control            | ✅      |

### Reciters Available
Alafasy, Abdul Basit, Husary, Sudais, Shuraim, Ghamdi, Ajamy, Maher, Minshawi, and more

### Data Sources
| Type        | Source                    | Offline? |
| ----------- | ------------------------- | -------- |
| Quran Text  | `quran` package (bundled) | ✅ Yes    |
| Translation | `quran` package (English) | ✅ Yes    |
| Audio       | EveryAyah.com (streaming) | ❌ No     |

---

## Enhancements Roadmap

| ID       | Enhancement                      | Priority | Status        | Difficulty |
| -------- | -------------------------------- | -------- | ------------- | ---------- |
| **1.7**  | **Reading Mode** (Mushaf layout) | 🔴 High   | ✅ Complete    | Medium     |
| **1.8**  | **Verse Repeat** (1x, 2x, 3x, ∞) | 🔴 High   | ✅ Complete    | Easy       |
| **1.9**  | **Range Repeat** (loop verses)   | 🟡 Medium | ✅ Complete    | Medium     |
| **1.6**  | **Audio Offline Cache**          | 🔴 High   | ✅ Complete    | Medium     |
| 1.3      | Tajweed Colors                   | 🟡 Medium | ⏳ Planned     | Easy       |
| 1.1      | Juz Navigation Tab               | 🟡 Medium | ⏳ Planned     | Easy       |
| 1.4      | Bookmarks Tab UI                 | 🟡 Medium | ⏳ Planned     | Easy       |
| 1.5      | Font Size Adjustment             | 🟢 Low    | ⏳ Planned     | Easy       |
| 1.2      | Makki/Madani Badge               | 🟢 Low    | ⏳ Planned     | Easy       |
| **1.10** | **Quran.com API Integration**    | 🟢 Low    | ⏳ Future      | Medium     |

---

## Enhancement Details

### 1.7 Reading Mode (Mushaf Layout) 🔴 HIGH

Two viewing modes like Quran.com:

```
┌─────────────────────────────────────────────────────────────┐
│      [Verse by Verse ✓]    [Reading Mode]                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  VERSE BY VERSE (Current):                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ ١  بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ                      │   │
│  │    In the name of Allah...                          │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ ٢  الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ                       │   │
│  │    All praise is due to Allah...                    │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  READING MODE (New):                                        │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ                        │   │
│  │                                                      │   │
│  │  تَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ  │   │
│  │  قَدِيرٌ ① الَّذِي خَلَقَ الْمَوْتَ وَالْحَيَاةَ           │   │
│  │  لِيَبْلُوَكُمْ أَيُّكُمْ أَحْسَنُ عَمَلًا ۚ وَهُوَ الْعَزِيزُ │   │
│  │  الْغَفُورُ ②                                        │   │
│  │  (Continuous flow with inline verse numbers)        │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Implementation:**
- Add toggle button in reader screen header
- Reading mode: `RichText` with inline verse markers
- Verse-by-verse: Current `ListView` implementation
- Persist preference in SharedPreferences

---

### 1.8 Verse Repeat (Memorization Mode) 🔴 HIGH

Repeat current verse N times before moving to next - essential for Hifz (memorization):

```
┌─────────────────────────────────────────────────────────────┐
│                    AUDIO PLAYER CONTROLS                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [⏮️] [⏪] [▶️/⏸️] [⏩] [⏭️]                               │
│       ○────────────●──────────○     00:45 / 02:15          │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Repeat Verse:  [Off] [1] [2] [3] [5] [10] [∞]     │   │
│  │                              ▲                       │   │
│  │                         (selected)                   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  Speed: [0.75x] [1x ✓] [1.25x] [1.5x] [2x]                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Implementation:**
- Add `verseRepeatCount` to QuranAudioService (int, -1 = infinite)
- Track `currentRepeatIteration` 
- On verse complete: if iterations < count, replay same verse
- UI: Row of chips or segmented button

---

### 1.9 Range Repeat (Loop Selection) 🟡 MEDIUM

Loop a range of verses (e.g., verses 1-5 repeatedly):

```
┌─────────────────────────────────────────────────────────────┐
│                    RANGE REPEAT CONTROLS                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  From: [Verse 1  ▼]    To: [Verse 7  ▼]            │   │
│  │                                                      │   │
│  │  Repeat Range:  [Off] [1] [2] [3] [5] [∞]          │   │
│  │                                                      │   │
│  │  □ Stay within selection (enforce bounds)           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Implementation:**
- Add `AudioPlaybackRange` model: { startVerse, endVerse, repeatCount }
- On range end: restart from startVerse
- `enforceBounds`: prevent scrolling past selection

---

### 1.6 Audio Offline Cache 🔴 HIGH

Download audio for offline playback:

```
┌─────────────────────────────────────────────────────────────┐
│                    SURAH DOWNLOAD                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Al-Mulk (67)                                               │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 75%                    │
│  Downloading verse 23 of 30...                              │
│                                                             │
│  Downloaded Surahs:                                         │
│  ✅ Al-Fatihah (1.2 MB)        [🗑️ Delete]                 │
│  ✅ Yasin (8.5 MB)             [🗑️ Delete]                 │
│  🔄 Al-Mulk (downloading...)                                │
│                                                             │
│  Total: 9.7 MB / 50 MB limit                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Implementation:**
See [Audio Offline Mode](../technical/audio-offline-mode.md) for full details.
- Use `LockCachingAudioSource` from just_audio
- Store in app documents directory
- Track download progress per surah

---

### 1.3 Tajweed Colors 🟡 MEDIUM

Color-coded tajweed rules using `alfurqan` package:

```yaml
dependencies:
  alfurqan: ^latest
```

- ✅ Offline, ready-made tajweed mode
- ✅ No GetX dependency (compatible with Provider)
- ✅ Can run alongside current `quran` package

---

### 1.10 Quran.com API Integration 🟢 FUTURE

**Status:** API access requested, awaiting approval

Hybrid architecture with offline fallback:

```
┌─────────────────────────────────────────────────────────────┐
│                  HYBRID DATA LAYER                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   Request verse → Has internet?                             │
│                      │                                      │
│              YES ────┴──── NO                               │
│               │            │                                │
│       Quran.com API    quran package                        │
│       (Full features)  (Offline backup)                     │
│               │            │                                │
│       • 100+ translations  • Arabic + English               │
│       • Tafsir             • Basic metadata                 │
│       • Word-by-word       • Always works                   │
│       • Transliteration                                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**API Credentials (pending):**
```
x-auth-token: [awaiting approval]
x-client-id: [awaiting approval]
```

**Features unlocked with API:**
- 🌍 100+ translations (Urdu, French, Turkish, etc.)
- 📚 Tafsir (Ibn Kathir, Jalalayn, etc.)
- 🔤 Word-by-word translation
- ✨ Transliteration

---

## Screen Mockups

### Quran Home Screen

```
┌─────────────────────────────────────────────────────────────┐
│                    QURAN HOME SCREEN                        │
├─────────────────────────────────────────────────────────────┤
│  🔍 Search surah or ayah...                                 │
│                                                             │
│  [Surah Tab]  [Juz Tab]  [Bookmarks Tab]                   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 1. Al-Fatihah (الفاتحة)     7 verses  Makkah  📥    │   │
│  │ 2. Al-Baqarah (البقرة)    286 verses  Madinah       │   │
│  │ 3. Aal-E-Imran (آل عمران)  200 verses  Madinah      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                 📥 = downloaded offline     │
│  Last Read: Al-Baqarah, Ayah 255         [Continue →]      │
└─────────────────────────────────────────────────────────────┘
```

### Enhanced Surah Reader Screen

```
┌─────────────────────────────────────────────────────────────┐
│  ← Al-Fatihah                           🔊  📥  ⚙️  🔖      │
│     The Opening • 7 verses • Makkah                         │
│                                                             │
│  [Verse by Verse ✓]  [Reading Mode]                        │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ ① بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ                      │   │
│  │                                                      │   │
│  │   In the name of Allah, the Most Gracious,          │   │
│  │   the Most Merciful.                                │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  [⏮️] [▶️] [⏭️]     ○─────●─────○  00:12 / 00:45   │   │
│  │                                                      │   │
│  │  Repeat Verse: [Off] [1] [2] [3✓] [5] [∞]          │   │
│  │  Speed: [0.75] [1x✓] [1.25] [1.5]                   │   │
│  │                                                      │   │
│  │  Reciter: Mishary Alafasy                    [⚙️]   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Files

```
lib/
├── screens/quran/
│   ├── quran_screen.dart              ✅ (with download indicators)
│   ├── surah_detail_screen.dart       ✅ (enhanced with all features)
│   └── reading_mode_view.dart         ✅ NEW
├── services/quran/
│   ├── quran_audio_service.dart       ✅ (enhanced with repeat/range)
│   ├── quran_bookmark_service.dart    ✅
│   ├── quran_download_service.dart    ✅ NEW
│   └── quran_api_service.dart         ⏳ FUTURE
└── models/
    └── audio_playback_settings.dart   ✅ NEW
```

---

## Dependencies

```yaml
dependencies:
  quran: ^1.4.1              # Offline Quran text
  just_audio: ^0.9.40        # Audio playback
  audio_session: ^0.1.21     # Audio session management
  alfurqan: ^latest          # Tajweed colors (planned)
  path_provider: ^2.1.1      # For offline storage
  http: ^1.1.0               # For API calls (future)
```

---

## Claude Code Prompts

### Prompt 1: Reading Mode Toggle

```
Add a Reading Mode to the Quran reader that displays continuous Arabic text 
like a mushaf (traditional Quran book) with inline verse numbers.

Current state:
- surah_detail_screen.dart shows verse-by-verse in a ListView
- Each verse is a separate card with Arabic + translation

Requirements:
1. Add toggle in header: [Verse by Verse] [Reading Mode]
2. Verse by Verse (current): Keep existing ListView with verse cards
3. Reading Mode (new): 
   - Display all Arabic text as continuous RichText
   - Inline circled verse numbers (١, ٢, ٣) after each verse
   - Optional: Toggle translation overlay
   - Smooth scrolling
4. Persist preference in SharedPreferences
5. Audio should still work and highlight current verse in both modes

Files to modify:
- lib/screens/quran/surah_detail_screen.dart
- Create: lib/screens/quran/reading_mode_view.dart

Use existing quran package for text data.
```

### Prompt 2: Verse Repeat Controls

```
Add verse repeat functionality for Quran memorization (Hifz).

Current state:
- QuranAudioService in quran_audio_service.dart handles playback
- Uses just_audio with ConcatenatingAudioSource for playlists
- playSurah() method plays verses sequentially

Requirements:
1. Add verseRepeatCount setting (0=off, 1-10, -1=infinite)
2. When a verse finishes:
   - If repeat count not reached, replay same verse
   - If reached, move to next verse
3. Add UI controls in surah_detail_screen.dart:
   - Chips or segmented button: [Off] [1] [2] [3] [5] [10] [∞]
4. Persist setting in SharedPreferences
5. Show visual feedback: "Repeating verse 3 (2/5)"

Files to modify:
- lib/services/quran/quran_audio_service.dart
- lib/screens/quran/surah_detail_screen.dart

Technical: Use just_audio's LoopMode or manual replay with 
playerStateStream listener.
```

### Prompt 3: Range Repeat (Loop Selection)

```
Add range repeat functionality to loop a selection of verses.

Current state:
- QuranAudioService handles sequential verse playback
- Verse repeat already implemented (from previous prompt)

Requirements:
1. Add AudioPlaybackRange model:
   - startVerse, endVerse, rangeRepeatCount, enforceBounds
2. When range ends, restart from startVerse
3. Combine with verse repeat: each verse repeats N times within range
4. UI in expanded audio panel:
   - From: [Verse dropdown] To: [Verse dropdown]
   - Range repeat: [Off] [1] [2] [3] [∞]
   - Checkbox: "Stay within selection"
5. Visual indicator showing current position in range

Files to modify:
- lib/services/quran/quran_audio_service.dart
- lib/screens/quran/surah_detail_screen.dart
- Create: lib/models/audio_playback_settings.dart
```

### Prompt 4: Audio Offline Download

```
Add ability to download surah audio for offline playback.

Current state:
- Audio streams from everyayah.com URLs
- QuranAudioService builds URLs: {baseUrl}/{surah}{verse}.mp3

Requirements:
1. Create QuranDownloadService:
   - downloadSurah(surahNumber, reciterId) 
   - Downloads all verse MP3s to app documents directory
   - Shows progress (verse X of Y)
   - getSurahDownloadStatus() returns: notDownloaded, downloading, downloaded
   - deleteSurahDownload(surahNumber)
   
2. Modify QuranAudioService:
   - Check if verse is downloaded locally first
   - If yes, use local file path
   - If no, stream from URL
   
3. UI:
   - Download icon (📥) on surah list items
   - Download button in surah detail screen
   - Progress indicator during download
   - "Downloaded" badge on offline-available surahs
   - Settings screen: manage downloads, show storage used

4. Storage management:
   - Track total downloaded size
   - Option to delete individual surahs or all downloads

Files to create:
- lib/services/quran/quran_download_service.dart

Files to modify:
- lib/services/quran/quran_audio_service.dart
- lib/screens/quran/quran_screen.dart
- lib/screens/quran/surah_detail_screen.dart
```

---

[← Back to Plan](../islamic-features-plan.md)
