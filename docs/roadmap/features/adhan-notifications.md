# Feature 6: Adhan Notifications

> **Status:** ✅ Complete  
> **Branch:** `feature/adhan-notifications` (PR #18)  
> **Package:** `android_alarm_manager_plus` + `just_audio`

---

## Overview

Background adhan notifications with customizable sounds, per-prayer settings, and foreground service for audio playback.

---

## Implementation Summary

| Feature | Status |
|---------|--------|
| Schedule for all 5 prayers | ✅ |
| Multiple adhan sounds | ✅ |
| Separate Fajr adhan option | ✅ |
| Pre-adhan reminder (5-30 min) | ✅ |
| Volume control | ✅ |
| Vibration toggle | ✅ |
| Sound preview in settings | ✅ |
| Works when app closed | ✅ |
| Survives device reboot | ✅ |
| Android 14+ permission handling | ✅ |

---

## Architecture

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

---

## Audio Files

```
assets/audio/adhan/
├── makkah.mp3       (3.3 MB) - Ahmad al Nafees
├── madinah.mp3      (3.7 MB) - Hafiz Mustafa Özcan
├── mishary.mp3      (5.2 MB) - Mishary Rashid Alafasy
├── fajr_makkah.mp3  (3.8 MB) - Traditional Fajr melody
├── fajr_madinah.mp3 (3.8 MB) - Traditional Fajr melody
└── beep.mp3         (17 KB)  - Short notification
```

---

## Enhancements

| ID | Enhancement | Method | Priority | Status |
|----|-------------|--------|----------|--------|
| 6.1 | Iqamah Reminder | X minutes after adhan | Low | ⏳ Planned |
| 6.2 | Do Not Disturb Awareness | System DND check | Low | ⏳ Planned |

---

## UI Improvements

| ID | Improvement | Priority | Status |
|----|-------------|----------|--------|
| U1 | Combine Fajr Section with Main Adhan | Medium | ⏳ Planned |

### Current UI Issue
Fajr adhan settings are in a separate section from other adhans.

**Proposed Fix:** Use dropdowns instead of radio buttons, combine into one section:

```
┌─────────────────────────────────────────────────────────────┐
│  ADHAN SOUND                                                │
├─────────────────────────────────────────────────────────────┤
│  Regular Adhan                          [Makkah        ▼]   │
│  (Dhuhr, Asr, Maghrib, Isha)                               │
│                                                             │
│  Use Different Sound for Fajr           [Toggle ON/OFF]     │
│  Fajr Adhan                             [Fajr-Makkah   ▼]   │
│                                                             │
│  [🔊 Preview Sound]                                         │
└─────────────────────────────────────────────────────────────┘
```

---

## Files

```
lib/
├── screens/settings/
│   └── adhan_settings_screen.dart        ✅
└── services/adhan/
    ├── adhan_notification_service.dart   ✅
    ├── adhan_scheduler.dart              ✅
    ├── adhan_audio_service.dart          ✅
    ├── adhan_settings.dart               ✅
    └── adhan_sounds.dart                 ✅
```

---

## Dependencies

```yaml
dependencies:
  android_alarm_manager_plus: ^x.x.x
  flutter_local_notifications: ^x.x.x
  just_audio: ^0.9.x
```

---

[← Back to Plan](../islamic-features-plan.md)
