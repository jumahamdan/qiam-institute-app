# Islamic Features Plan - Qiam Institute App

> **Status:** In Progress
> **Created:** January 28, 2026
> **Last Updated:** January 28, 2026
> **Priority:** High

---

## Overview

| Feature | Package | Screen | Status |
|---------|---------|--------|--------|
| 1. Quran Reader | `quran` + `just_audio` | Full screen with surah list + reader + audio | ✅ Complete |
| 2. Tasbih Counter | Custom build | Full screen counter with 9 dhikr presets | ✅ Complete |
| 3. 99 Names of Allah | Custom build | Grid/list view + detail sheet | ✅ Complete |
| 4. Hadith Collection | TBD | Full screen with search + daily hadith | ⏳ Planned |
| 5. Adhan Notifications | TBD | Settings integration + background service | ⏳ Planned |

### Implementation Summary

**Completed Features:**
- **Quran Reader**: Full surah list, verse-by-verse reading with Arabic + English translation, audio playback with 10 reciters
- **Tasbih Counter**: 9 preset dhikr phrases, lifetime stats, haptic feedback, progress tracking
- **99 Names of Allah**: All 99 names with Arabic, transliteration, meaning & description, grid/list toggle, search

**Pending Features:**
- **Hadith Collection**: Browse and search authentic hadith
- **Adhan Notifications**: Prayer time alerts with adhan audio

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
│  ← Al-Fatihah                           🔊   advancement  🔖 │
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
│  Audio: [▶️ advancement advancement advancement advancement advancement advancement advancement advancement advancement]│
│  Reciter: Mishary Rashid Alafasy              [⚙️]         │
└─────────────────────────────────────────────────────────────┘
```

### Package & Dependencies

```yaml
dependencies:
  quran: ^1.4.1           # Quran text, translations, audio URLs
  just_audio: ^0.9.x      # Audio playback
  audio_service: ^0.18.x  # Background audio (optional)
```

### Data Structure

```dart
// From quran package:
- Surah list (114 surahs with metadata)
- Arabic text
- English translation (Saheeh International)
- Audio URLs for each ayah (multiple reciters)
- Juz/Page data
- Sajdah verses
```

### Key Features

- [x] Surah list with search
- [ ] Juz navigation
- [x] Arabic text display (proper RTL font)
- [x] English translation toggle
- [x] Audio playback (verse by verse or continuous)
- [x] Multiple reciters (10 reciters: Alafasy, Abdul Basit, Husary, Sudais, Shuraim, Ghamdi, Ajamy, Maher, Minshawi)
- [ ] Bookmarks
- [ ] Last read position
- [ ] Font size adjustment
- [x] Night mode support (follows app theme)

---

## Feature 2: Adhan Notifications

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
  awqat: ^0.1.10              # Native prayer notifications
  # OR build custom with:
  flutter_local_notifications: ^x.x.x
  android_alarm_manager_plus: ^x.x.x
  just_audio: ^0.9.x          # Play adhan audio
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

## Feature 3: Tasbih Counter

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
- [ ] Sound option (click/beep on tap)
- [x] Preset dhikr with targets (33, 100, etc.) - 9 presets
- [ ] Custom dhikr with custom target
- [x] Visual progress indicator (circle)
- [x] Completion celebration (subtle animation)
- [x] Lifetime statistics tracking
- [x] Reset / Undo last tap
- [ ] Keep screen awake option
- [ ] Works in landscape mode

---

## Feature 4: 99 Names of Allah

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
│  │  ─────────────────────────────────────────────────  │   │
│  │                                                      │   │
│  │  3.  الْمَلِكُ                                           │   │
│  │      Al-Malik                                        │   │
│  │      The King                                        │   │
│  │                                                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  [🔀 Random Name]          [▶️ Play All]                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

```
┌─────────────────────────────────────────────────────────────┐
│                    NAME DETAIL SCREEN                       │
├─────────────────────────────────────────────────────────────┤
│  ←                                               [🔊] [❤️]  │
│                                                             │
│                                                             │
│                        الرَّحْمَنُ                              │
│                                                             │
│                      Ar-Rahman                              │
│                                                             │
│                  The Most Gracious                          │
│                                                             │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  Meaning:                                                   │
│  The One who has plenty of mercy for the believers          │
│  and the disbelievers in this world, and for the           │
│  believers only in the Hereafter.                          │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  Referenced in Quran:                                       │
│  • Surah Al-Fatihah 1:1                                    │
│  • Surah Al-Baqarah 2:163                                  │
│  • Surah Maryam 19:45                                      │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│        [← Previous]                    [Next →]            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Package

```yaml
dependencies:
  asmaulhusna: ^0.0.3     # 99 Names data
```

### Key Features

- [x] List all 99 names with Arabic, transliteration, meaning
- [x] Detail screen with extended explanation (bottom sheet)
- [ ] Audio pronunciation (optional)
- [x] Search by name or meaning
- [ ] Favorites list
- [ ] Random name widget (for home screen or daily)
- [ ] Share name as image
- [x] Grid/list view toggle

---

## Feature 5: Hadith Collection

### Screens

```
┌─────────────────────────────────────────────────────────────┐
│                    HADITH COLLECTION                        │
├─────────────────────────────────────────────────────────────┤
│  🔍 Search hadith...                                        │
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
│  Browse by Collection:                                      │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 📚 Sahih Bukhari                          7,563    →│   │
│  │ 📚 Sahih Muslim                           5,362    →│   │
│  │ 📚 40 Hadith Nawawi                          42    →│   │
│  │ 📚 Riyad as-Salihin                       1,896    →│   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  Browse by Topic:                                           │
│  [Prayer] [Fasting] [Charity] [Character] [Family] [More]  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Package

```yaml
dependencies:
  dorar_hadith: ^0.3.1      # Dorar.net hadith database
  # OR
  hadith_nawawi: ^0.0.4     # Just 40 Nawawi hadiths (simpler)
```

### Key Features

- [ ] Daily hadith (rotating)
- [ ] Search by keyword
- [ ] Browse by collection (Bukhari, Muslim, etc.)
- [ ] Browse by topic
- [ ] Hadith detail with explanation (sharh)
- [ ] Authenticity grading (Sahih, Hasan, Da'if)
- [ ] Bookmark favorites
- [ ] Share hadith
- [ ] 40 Nawawi collection (featured)

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
│  │   📜        │   🔔        │   📅        │               │
│  │  Hadith    │   Adhan    │  Events     │               │
│  │            │  Settings  │             │               │
│  ├─────────────┼─────────────┼─────────────┤               │
│  │   🤲        │   📺        │   🙋        │               │
│  │  Daily     │   Media    │  Volunteer  │               │
│  │  Duaa      │            │             │               │
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
| **2** | Tasbih Counter | ✅ Complete | `feature/islamic-features` |
| **3** | 99 Names of Allah | ✅ Complete | `pr-11` |
| **4** | Hadith Collection | ⏳ Planned | TBD |
| **5** | Adhan Notifications | ⏳ Planned | TBD |

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
  services/
    quran/
      quran_audio_service.dart    ✅ 10 reciters, playlist support
    tasbih/
      tasbih_service.dart         ✅ Progress & stats tracking
    names_of_allah/
      names_service.dart          ✅ All 99 names with descriptions
```

## Files to Create (for remaining features)

```
lib/
  screens/
    hadith/
      hadith_home_screen.dart     ⏳
      hadith_detail_screen.dart   ⏳
  services/
    hadith/
      hadith_service.dart         ⏳
    adhan/
      adhan_notification_service.dart ⏳
assets/
  audio/
    adhan_makkah.mp3              ⏳
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
  # Hadith (to be added)
  # dorar_hadith: ^0.3.1

  # Adhan Notifications (to be added)
  # flutter_local_notifications (already have)
  # android_alarm_manager_plus for background scheduling
```

---

## Notes

- All features should support dark mode
- Arabic text should use proper RTL rendering
- Consider offline support for Quran and Hadith
- Audio features need background playback consideration
