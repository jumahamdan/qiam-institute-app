# Feature 2: Tasbih Counter

> **Status:** ✅ Complete  
> **Branch:** `feature/islamic-features`  
> **Package:** Custom build

---

## Overview

Digital dhikr counter with preset phrases, haptic feedback, and lifetime statistics.

---

## Implementation Summary

| Feature | Status |
|---------|--------|
| Large tap area (whole screen) | ✅ |
| Haptic feedback on tap | ✅ |
| No sound (by design) | ✅ |
| 9 preset dhikr phrases | ✅ |
| Visual progress circle | ✅ |
| Completion celebration | ✅ |
| Lifetime statistics | ✅ |
| Reset count | ✅ |

---

## Screen Mockup

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
│                    ┌─────────┐                              │
│                    │   33    │                              │
│                    └─────────┘                              │
│                     / 33 ✓                                  │
│                                                             │
│              ┌───────────────────────┐                      │
│              │      TAP TO COUNT     │                      │
│              └───────────────────────┘                      │
│                                                             │
│  [SubhanAllah] [Alhamdulillah] [AllahuAkbar] [Custom]      │
│        [🔄 Reset]              [✓ Complete Set]            │
└─────────────────────────────────────────────────────────────┘
```

---

## Preset Dhikr Options

```dart
List<Dhikr> presets = [
  Dhikr(arabic: 'سُبْحَانَ اللَّهِ', transliteration: 'SubhanAllah', meaning: 'Glory be to Allah', target: 33),
  Dhikr(arabic: 'الْحَمْدُ لِلَّهِ', transliteration: 'Alhamdulillah', meaning: 'Praise be to Allah', target: 33),
  Dhikr(arabic: 'اللَّهُ أَكْبَرُ', transliteration: 'Allahu Akbar', meaning: 'Allah is the Greatest', target: 33),
  Dhikr(arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ', transliteration: 'La ilaha illallah', meaning: 'None worthy of worship except Allah', target: 100),
  Dhikr(arabic: 'أَسْتَغْفِرُ اللَّهَ', transliteration: 'Astaghfirullah', meaning: 'I seek forgiveness from Allah', target: 100),
  // + 4 more presets
];
```

---

## Enhancements

| ID | Enhancement | Method/Package | Priority | Status |
|----|-------------|----------------|----------|--------|
| 2.1 | Keep Screen Awake | `wakelock_plus` package | High | ⏳ Planned |
| 2.2 | Custom Dhikr Input | Text input + custom target | Medium | ⏳ Planned |
| 2.3 | Landscape Mode | Responsive layout | Low | ⏳ Planned |

### 2.1 Keep Screen Awake
- Add `wakelock_plus` package
- Toggle in settings or auto-enable when counting
- Prevents screen from sleeping during dhikr

### 2.2 Custom Dhikr Input
- Allow user to enter custom Arabic/transliteration
- Set custom target count
- Save to favorites

### 2.3 Landscape Mode
- Responsive layout for horizontal orientation
- Useful when phone is mounted

---

## Files

```
lib/
├── screens/tasbih/
│   └── tasbih_screen.dart    ✅
└── services/tasbih/
    └── tasbih_service.dart   ✅
```

---

## Dependencies to Add

```yaml
dependencies:
  wakelock_plus: ^x.x.x  # For screen awake feature
```

---

[← Back to Plan](../islamic-features-plan.md)
