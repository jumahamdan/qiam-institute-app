# Feature 3: 99 Names of Allah

> **Status:** ✅ Complete  
> **Branch:** `pr-11`  
> **Package:** Custom build

---

## Overview

Display all 99 names of Allah with Arabic, transliteration, meaning, and detailed explanations.

---

## Implementation Summary

| Feature | Status |
|---------|--------|
| All 99 names displayed | ✅ |
| Arabic text | ✅ |
| Transliteration | ✅ |
| English meaning | ✅ |
| Detail bottom sheet | ✅ |
| Search by name/meaning | ✅ |
| Grid/list view toggle | ✅ |

---

## Screen Mockup

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
│  │  1.  الرَّحْمَنُ                                         │   │
│  │      Ar-Rahman                                       │   │
│  │      The Most Gracious                               │   │
│  │  ─────────────────────────────────────────────────  │   │
│  │  2.  الرَّحِيمُ                                          │   │
│  │      Ar-Raheem                                       │   │
│  │      The Most Merciful                               │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  [🔀 Random Name]          [▶️ Play All]                    │
└─────────────────────────────────────────────────────────────┘
```

---

## Enhancements

| ID | Enhancement | Method/Package | Priority | Status |
|----|-------------|----------------|----------|--------|
| 3.1 | Audio Pronunciation | Audio files or TTS | Low | ⏳ Planned |
| 3.2 | Favorites List | SharedPreferences | Medium | ⏳ Planned |
| 3.3 | Random Name Feature | Daily rotation | Low | ⏳ Planned |
| 3.4 | Share as Image | Screenshot + share | Low | ⏳ Planned |

### 3.1 Audio Pronunciation
- Option A: Pre-recorded audio files for each name
- Option B: Text-to-speech with Arabic support

### 3.2 Favorites List
- Heart icon to favorite names
- Separate favorites tab/section
- Persist with SharedPreferences

### 3.3 Random Name Feature
- "Name of the Day" on home screen
- Random button in list view

### 3.4 Share as Image
- Generate styled image of name
- Share via system share sheet

---

## Files

```
lib/
├── screens/names_of_allah/
│   └── names_screen.dart      ✅
└── services/names_of_allah/
    └── names_service.dart     ✅
```

---

[← Back to Plan](../islamic-features-plan.md)
