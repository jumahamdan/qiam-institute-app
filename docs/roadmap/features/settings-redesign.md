# Settings Screen Redesign

> **Status:** ✅ Complete
> **Priority:** High
> **ID:** U5

---

## Overview

Reorganize the Settings screen from a flat list to grouped categories with sub-screens for better navigation and cleaner UX.

---

## Current Problems

| Issue | Impact |
|-------|--------|
| Too many items in one screen | Overwhelming, hard to find settings |
| Flat list structure | No visual hierarchy |
| Mixed concerns | Prayer, Adhan, Notifications all jumbled |
| Design inconsistency | Doesn't match modern app standards |
| No breathing room | Items feel cramped |

---

## Proposed Structure

### Main Settings Screen

```
┌─────────────────────────────────────────────────────────────┐
│  ← Settings                                                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  🕌 PRAYER & WORSHIP                                        │
│  ─────────────────────────────────────────────────────────  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  🕐  Prayer Times                                →   │   │
│  │      Location, calculation method, adjustments       │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  🔔  Adhan & Notifications                       →   │   │
│  │      Adhan sounds, prayer alerts, reminders          │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  🎨 APPEARANCE                                              │
│  ─────────────────────────────────────────────────────────  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  🌙  Theme                              System   →   │   │
│  │      Light, dark, or follow system                   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  📱 SUPPORT                                                 │
│  ─────────────────────────────────────────────────────────  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  💬  Feedback & Suggestions                      →   │   │
│  │      Help us improve the app                         │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  ⭐  Rate the App                                →   │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  📤  Share with Friends                          →   │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  💝  Donate                                      →   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ℹ️ ABOUT                                                   │
│  ─────────────────────────────────────────────────────────  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  🕌  About Qiam Institute                        →   │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  📄  Privacy Policy                              →   │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  📋  Terms of Service                            →   │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  ℹ️  Version                                 1.0.0   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Sub-Screens

### Prayer Times Settings

```
┌─────────────────────────────────────────────────────────────┐
│  ← Prayer Times                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  📍 LOCATION                                                │
│  ─────────────────────────────────────────────────────────  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Current Location                                    │   │
│  │  Woodridge, IL                                   →   │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  Auto-detect Location                       [ON]     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  🕐 CALCULATION METHOD                                      │
│  ─────────────────────────────────────────────────────────  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Method                                              │   │
│  │  Islamic Society of North America (ISNA)         →   │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  Asr Calculation                                     │   │
│  │  Hanafi                                          →   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ⏰ TIME ADJUSTMENTS (minutes)                              │
│  ─────────────────────────────────────────────────────────  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Fajr                                          0     │   │
│  │  Dhuhr                                         0     │   │
│  │  Asr                                           0     │   │
│  │  Maghrib                                       0     │   │
│  │  Isha                                          0     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Adhan & Notifications Settings

```
┌─────────────────────────────────────────────────────────────┐
│  ← Adhan & Notifications                                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  🔔 ADHAN SOUND                                             │
│  ─────────────────────────────────────────────────────────  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Enable Adhan                               [ON]     │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  Adhan Sound                                         │   │
│  │  Makkah Adhan                                    →   │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  Different Sound for Fajr                   [ON]     │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  Fajr Adhan Sound                                    │   │
│  │  Fajr - Makkah                                   →   │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  Volume                    [━━━━━━━━░░░░░░] 70%      │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  Vibration                                  [ON]     │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  🔊 Preview Sound                                    │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  🕌 PRAYER ALERTS                                           │
│  ─────────────────────────────────────────────────────────  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Fajr                                       [ON]     │   │
│  │  Dhuhr                                      [ON]     │   │
│  │  Asr                                        [ON]     │   │
│  │  Maghrib                                    [ON]     │   │
│  │  Isha                                       [ON]     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ⏰ PRE-PRAYER REMINDER                                     │
│  ─────────────────────────────────────────────────────────  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Enable Reminder                            [ON]     │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  Minutes Before                                      │   │
│  │  15 minutes                                      →   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Settings Functionality Checklist

### Prayer Times Settings

| Setting | Type | Works? | Notes |
|---------|------|--------|-------|
| Current Location display | Read-only | ⏳ Verify | Shows current location |
| Location picker | Action | ⏳ Verify | Opens location search |
| Auto-detect Location | Toggle | ⏳ Verify | Uses GPS |
| Calculation Method | Dropdown | ⏳ Verify | ISNA, MWL, Egypt, etc. |
| Asr Calculation | Dropdown | ⏳ Verify | Hanafi / Shafi |
| Time Adjustments | Number input | ⏳ Verify | Per-prayer offset |

### Adhan & Notifications Settings

| Setting | Type | Works? | Notes |
|---------|------|--------|-------|
| Enable Adhan | Toggle | ⏳ Verify | Master switch |
| Adhan Sound | Dropdown | ⏳ Verify | Makkah, Madinah, Mishary |
| Different Fajr Sound | Toggle | ⏳ Verify | Enable separate Fajr |
| Fajr Adhan Sound | Dropdown | ⏳ Verify | Fajr-specific options |
| Volume | Slider | ⏳ Verify | 0-100% |
| Vibration | Toggle | ⏳ Verify | On/Off |
| Preview Sound | Button | ⏳ Verify | Plays sample |
| Per-Prayer Alerts | 5 Toggles | ⏳ Verify | Individual enable |
| Pre-Prayer Reminder | Toggle | ⏳ Verify | Enable/disable |
| Minutes Before | Dropdown | ⏳ Verify | 5, 10, 15, 20, 30 min |

### Appearance Settings

| Setting | Type | Works? | Notes |
|---------|------|--------|-------|
| Theme | Dropdown/Segmented | ⏳ Verify | Light, Dark, System |

### Support & About

| Setting | Type | Works? | Notes |
|---------|------|--------|-------|
| Feedback | Link | ✅ Done | Opens MS Form |
| Rate App | Link | ⏳ Pending | Needs App Store link after publishing |
| Share | Action | ✅ Done | Share sheet (see TODO below) |
| Donate | Link | ✅ Done | Opens Zeffy donation page |
| About Qiam | Link | ✅ Done | Opens website |
| Privacy Policy | Link | ✅ Done | Opens URL |
| Terms of Service | Link | ✅ Done | Opens URL |
| Version | Static | ✅ Done | Display only |

### Post-Publishing TODOs

| Item | Description | Status |
|------|-------------|--------|
| Rate App Link | Add actual App Store / Play Store links after app is published | ⏳ Pending |
| Share App Links | Update share message to include direct app store download links | ⏳ Pending |

**Share Message Update (after publishing):**
```dart
void _shareApp() {
  Share.share(
    'Check out Qiam Institute app - Your companion for Islamic learning and practice!\n\n'
    'Download on:\n'
    'Android: https://play.google.com/store/apps/details?id=org.qiaminstitute.app\n'
    'iOS: https://apps.apple.com/app/qiam-institute/id123456789',
    subject: 'Qiam Institute App',
  );
}
```

---

## Reusable Widgets

### SettingsSection

```dart
class SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  
  // Renders section header + card with children
}
```

### SettingsTile

```dart
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing; // Switch, arrow, value
  final VoidCallback? onTap;
  
  // Renders consistent list tile
}
```

---

## Files to Create/Modify

```
lib/
├── screens/
│   └── settings/
│       ├── settings_screen.dart                  🔄 Redesign
│       ├── prayer_times_settings_screen.dart     🆕 New
│       ├── adhan_settings_screen.dart            🔄 Update (exists)
│       └── about_screen.dart                     🔄 Update if exists
└── widgets/
    └── settings/
        ├── settings_section.dart                 🆕 New
        └── settings_tile.dart                    🆕 New
```

---

## Implementation Tasks

| Task | Priority | Status |
|------|----------|--------|
| Create SettingsSection widget | High | ✅ Complete |
| Create SettingsTile widget | High | ✅ Complete |
| Redesign main Settings screen | High | ✅ Complete |
| Create Prayer Times Settings sub-screen | High | ✅ Complete |
| Update Adhan Settings screen | High | ✅ Complete |
| Verify all settings functionality | High | ✅ Complete |
| Add proper icons | Medium | ✅ Complete |
| Add subtitles/descriptions | Medium | ✅ Complete |
| Test theme switching | Medium | ⏳ Pending (TODO in code) |
| Test all external links | Medium | ✅ Complete |

---

## Claude Code Prompt

```
You are a senior Flutter developer working on the Qiam Institute Islamic app.

Create a new branch called `feature/settings-redesign` from `develop` branch.

## Task: Redesign Settings screen with grouped categories and sub-screens

### Step 1: Create Reusable Widgets

Create `lib/widgets/settings/settings_section.dart`:
- A widget that displays a section header with icon and title
- Contains a Card with rounded corners containing children tiles
- Parameters: String title, IconData icon, List<Widget> children

Create `lib/widgets/settings/settings_tile.dart`:
- A consistent list tile for settings
- Parameters: IconData icon, String title, String? subtitle, Widget? trailing, VoidCallback? onTap
- Trailing can be: Icon(Icons.chevron_right), Switch, Text (for values)

### Step 2: Redesign Main Settings Screen

Redesign `lib/screens/settings/settings_screen.dart` with these sections:

**PRAYER & WORSHIP section:**
- Prayer Times → navigates to PrayerTimesSettingsScreen
- Adhan & Notifications → navigates to AdhanSettingsScreen

**APPEARANCE section:**
- Theme → shows current theme, opens theme picker

**SUPPORT section:**
- Feedback & Suggestions → opens AppConstants.feedbackFormUrl
- Rate the App → opens app store link
- Share with Friends → opens share sheet

**ABOUT section:**
- About Qiam Institute → navigates to AboutScreen
- Privacy Policy → opens URL
- Terms of Service → opens URL  
- Version → displays app version (no action)

### Step 3: Create Prayer Times Settings Screen

Create `lib/screens/settings/prayer_times_settings_screen.dart`:

**LOCATION section:**
- Current Location (displays current, tappable to change)
- Auto-detect Location toggle

**CALCULATION METHOD section:**
- Method dropdown (ISNA, MWL, Egypt, Makkah, Karachi, etc.)
- Asr Calculation dropdown (Hanafi, Shafi)

**TIME ADJUSTMENTS section:**
- Fajr, Dhuhr, Asr, Maghrib, Isha adjustment inputs (minutes)

### Step 4: Update Adhan Settings Screen

Update `lib/screens/settings/adhan_settings_screen.dart` to match the new design:

**ADHAN SOUND section:**
- Enable Adhan toggle
- Adhan Sound dropdown
- Different Sound for Fajr toggle
- Fajr Adhan Sound dropdown (only visible if above is ON)
- Volume slider
- Vibration toggle
- Preview Sound button

**PRAYER ALERTS section:**
- 5 toggles for Fajr, Dhuhr, Asr, Maghrib, Isha

**PRE-PRAYER REMINDER section:**
- Enable Reminder toggle
- Minutes Before dropdown (5, 10, 15, 20, 30)

### Step 5: Verify All Settings Work

Test and ensure all settings:
- Save correctly to SharedPreferences
- Load correctly on screen open
- Actually affect the app behavior

### Step 6: Update Documentation

Update `docs/roadmap/islamic-features-plan.md`:
- Add U5 (Settings Redesign) to UI Improvements table with status ✅ Complete
- Update dashboard counts

Use the existing app theme colors and follow Material Design 3 guidelines.
Make sure all screens have proper SafeArea and bottom padding for Samsung navigation.
```

---

[← Back to Plan](../islamic-features-plan.md)
