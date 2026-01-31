# Explore Page Redesign

> **Status:** ⏳ Planned  
> **Priority:** Medium

---

## Overview

Reorganize the Explore screen from a flat grid to grouped sections with a Quick Access row, improving navigation and reducing visual overwhelm.

---

## Current Issues

- ❌ Too many cards in flat grid (12 cards)
- ❌ No visual hierarchy
- ❌ Icons not intuitive for Islamic features
- ❌ Adhan Settings doesn't belong in Explore
- ❌ Users feel overwhelmed

---

## Proposed Changes

| Change | Before | After |
|--------|--------|-------|
| Layout | Flat 3-column grid | Grouped sections |
| Card count | 12 in one grid | 11 in 3 sections |
| Adhan | In Explore | Moved to Settings |
| Qibla | Only in Prayer screen | Added to Explore |
| Icons | Material Icons only | Custom Islamic SVGs |
| Quick Access | None | Top row for most-used |

---

## Proposed Screen Layout

```
┌─────────────────────────────────────────────────────────────┐
│                    EXPLORE SCREEN                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Explore                                                    │
│  Discover Islamic tools and ways to get involved            │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  🔥 QUICK ACCESS                    (Horizontal Scroll)│   │
│  │  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐              │   │
│  │  │ 📖  │ │ 🤲  │ │ 📿  │ │ 📜  │              │   │
│  │  │Quran │ │ Dua  │ │Tasbih│ │Hadith│              │   │
│  │  └──────┘ └──────┘ └──────┘ └──────┘              │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ▼ 📿 Islamic Tools ─────────────────────────────────────  │
│  ┌───────────┬───────────┬───────────┐                     │
│  │    📖     │    🤲     │    📜     │                     │
│  │  Quran    │   Dua     │  Hadith   │                     │
│  ├───────────┼───────────┼───────────┤                     │
│  │    📿     │    ✨     │    🧭     │                     │
│  │  Tasbih   │ 99 Names  │  Qibla    │                     │
│  └───────────┴───────────┴───────────┘                     │
│                                                             │
│  ▼ 🕌 Qiam Institute ────────────────────────────────────  │
│  ┌───────────┬───────────┬───────────┐                     │
│  │    📅     │    📺     │    🙋     │                     │
│  │  Events   │  Media    │ Volunteer │                     │
│  ├───────────┼───────────┴───────────┘                     │
│  │    ⭐     │                                              │
│  │  Values   │                                              │
│  └───────────┘                                              │
│                                                             │
│  ▼ 📚 Resources ─────────────────────────────────────────  │
│  ┌───────────┬───────────┐                                  │
│  │    📆     │    📍     │                                  │
│  │ Islamic   │  About &  │                                  │
│  │ Calendar  │  Contact  │                                  │
│  └───────────┴───────────┘                                  │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  [Facebook] [Instagram] [YouTube] [TikTok]          │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           [ ❤️ Support Qiam Institute ]              │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Section Breakdown

### Quick Access Row
Horizontal scrollable row with most-used features for quick tap access.

| Card | Icon | Notes |
|------|------|-------|
| Quran | 📖 | Most used |
| Dua | 🤲 | Daily use |
| Tasbih | 📿 | Daily use |
| Hadith | 📜 | Reference |

### Section 1: Islamic Tools (6 cards)

| Card | Icon | Description |
|------|------|-------------|
| Quran | 📖 | Full Quran reader |
| Dua | 🤲 | Hisnul Muslim duas |
| Hadith | 📜 | Hadith collections |
| Tasbih | 📿 | Dhikr counter |
| 99 Names | ✨ | Asma ul Husna |
| Qibla | 🧭 | Qibla direction (NEW in Explore) |

### Section 2: Qiam Institute (4 cards)

| Card | Icon | Description |
|------|------|-------------|
| Events | 📅 | Upcoming events |
| Media | 📺 | Videos & content |
| Volunteer | 🙋 | Volunteer form |
| Values | ⭐ | About our values |

### Section 3: Resources (2 cards)

| Card | Icon | Description |
|------|------|-------------|
| Islamic Calendar | 📆 | Important dates |
| About & Contact | 📍 | Contact info |

---

## Icon Strategy

### Custom Islamic SVG Icons

For authentic Islamic look, use custom SVG icons from free sources.

| Feature | Recommended Icon | SVG Source |
|---------|------------------|------------|
| Quran | Open book with Arabic | [SVGRepo](https://www.svgrepo.com/vectors/quran/) |
| Dua | Raised hands (palms up) | [Flaticon](https://www.flaticon.com/search?word=dua) |
| Hadith | Scroll/manuscript | [SVGRepo](https://www.svgrepo.com/vectors/scroll/) |
| Tasbih | Prayer beads | [Flaticon](https://www.flaticon.com/search?word=tasbih) |
| 99 Names | Star/sparkles or calligraphy | Custom or [SVGRepo](https://www.svgrepo.com/vectors/islamic/) |
| Qibla | Compass with Kaaba | [Flaticon](https://www.flaticon.com/search?word=qibla) |
| Events | Calendar | Material Icon |
| Media | Play button | Material Icon |
| Volunteer | Raised hand/heart | Material Icon |
| Values | Star | Material Icon |
| Islamic Calendar | Calendar with moon | Custom SVG |
| About | Info/Location | Material Icon |

### Icon Implementation

```dart
// Using flutter_svg package (already in project)
import 'package:flutter_svg/flutter_svg.dart';

// Custom Islamic icon
SvgPicture.asset(
  'assets/icons/islamic/quran.svg',
  width: 32,
  height: 32,
  colorFilter: ColorFilter.mode(
    Theme.of(context).colorScheme.primary,
    BlendMode.srcIn,
  ),
)
```

### Asset Structure

```
assets/
└── icons/
    └── islamic/
        ├── quran.svg
        ├── dua_hands.svg
        ├── hadith_scroll.svg
        ├── tasbih_beads.svg
        ├── 99_names.svg
        ├── qibla_compass.svg
        └── islamic_calendar.svg
```

---

## Section Collapsibility (Optional)

Sections can be collapsible to reduce scroll:

```dart
ExpansionTile(
  title: Row(
    children: [
      Icon(Icons.auto_awesome),
      SizedBox(width: 8),
      Text('Islamic Tools'),
    ],
  ),
  initiallyExpanded: true,
  children: [
    // Grid of cards
  ],
)
```

**Default State:**
- Islamic Tools: Expanded
- Qiam Institute: Expanded
- Resources: Collapsed (less frequently used)

---

## Removed from Explore

| Card | New Location | Reason |
|------|--------------|--------|
| Adhan Settings | Settings screen | It's a configuration feature, not content |

---

## Implementation Tasks

| Task | Priority | Status |
|------|----------|--------|
| Create section header widget | High | ⏳ |
| Implement Quick Access horizontal row | High | ⏳ |
| Create grouped grid layout | High | ⏳ |
| Source/create custom Islamic SVG icons | High | ⏳ |
| Add icons to assets folder | High | ⏳ |
| Update pubspec.yaml with icon assets | Medium | ⏳ |
| Move Adhan to Settings | Medium | ⏳ |
| Add Qibla card to Explore | Medium | ⏳ |
| Optional: Add section collapsibility | Low | ⏳ |
| Test scroll performance | Low | ⏳ |

---

## Files to Modify

```
lib/
├── screens/
│   ├── explore/
│   │   └── explore_screen.dart          🔄 Major redesign
│   └── settings/
│       └── settings_screen.dart         🔄 Add Adhan link
├── widgets/
│   ├── explore/
│   │   ├── quick_access_row.dart        🆕 New widget
│   │   ├── explore_section.dart         🆕 New widget
│   │   └── explore_card.dart            🔄 Update for custom icons
assets/
└── icons/
    └── islamic/
        ├── quran.svg                    🆕 New asset
        ├── dua_hands.svg                🆕 New asset
        ├── hadith_scroll.svg            🆕 New asset
        ├── tasbih_beads.svg             🆕 New asset
        ├── 99_names.svg                 🆕 New asset
        ├── qibla_compass.svg            🆕 New asset
        └── islamic_calendar.svg         🆕 New asset
```

---

## Design Specifications

### Quick Access Row
| Property | Value |
|----------|-------|
| Height | 100dp |
| Card width | 80dp |
| Card spacing | 12dp |
| Scroll | Horizontal |
| Background | Subtle accent color |

### Section Header
| Property | Value |
|----------|-------|
| Font | Semi-bold, 16sp |
| Icon size | 20dp |
| Padding | 16dp horizontal |
| Divider | Thin line after title |

### Card Grid
| Property | Value |
|----------|-------|
| Columns | 3 |
| Card aspect ratio | 1:1 (square) |
| Card spacing | 12dp |
| Icon size | 32dp |
| Label | 12sp, center aligned |

### Colors (Qiam Theme)
| Element | Color |
|---------|-------|
| Section header icon | Primary color |
| Card background | Surface color |
| Card icon | Primary or on-surface |
| Quick access background | Primary with 10% opacity |

---

[← Back to Plan](../islamic-features-plan.md)
