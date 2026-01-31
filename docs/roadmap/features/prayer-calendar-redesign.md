# Feature 8: Prayer Times Calendar Redesign

> **Status:** ⏳ Planned  
> **Priority:** Medium

---

## Design Goals

- Clean, scannable daily prayer time cards
- Clear date hierarchy with Gregorian dates
- Sunrise/Sunset times prominently displayed
- Easy PDF export functionality
- **Uses existing Qiam app theme**

---

## What's Changing

| Element | Current | New |
|---------|---------|-----|
| Daily layout | Table/list rows | Card per day |
| Date format | Various | "DD MMM, YYYY" |
| Sunrise/Sunset | Hidden or separate | On each card |
| Location display | Shown | ❌ Removed |

---

## Proposed Screen Layout

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

---

## Daily Card Structure

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

---

## Design Specifications

### Header Section
| Element | Description |
|---------|-------------|
| Back arrow | Navigate to previous screen |
| Title | "Prayer Times - [Year]" |
| ❌ No location | Removed per requirements |

### Daily Prayer Card
| Element | Description |
|---------|-------------|
| **Top Row Left** | Date in "DD MMM, YYYY" format |
| **Top Row Right** | Sunrise + Sunset times |
| **Divider** | Horizontal line |
| **Bottom Row** | 5 prayer times, evenly spaced |
| **Time Format** | 12-hour with AM/PM |

### Typography (Qiam Theme)
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

---

## Implementation Tasks

| Task | Priority | Status |
|------|----------|--------|
| Create daily prayer card widget | High | ⏳ |
| Update screen layout with new cards | High | ⏳ |
| Remove location display | High | ⏳ |
| Add Sunrise/Sunset to each card | High | ⏳ |
| Update date format to "DD MMM, YYYY" | High | ⏳ |
| Auto-scroll to today on open | Medium | ⏳ |
| Update Export PDF button styling | Medium | ⏳ |
| Optional: Add today highlight | Low | ⏳ |

---

## Files to Modify

```
lib/
├── screens/prayer_times/
│   └── prayer_times_calendar_screen.dart  🔄 Redesign
└── widgets/
    └── prayer_time_day_card.dart          🆕 New widget
```

---

[← Back to Plan](../islamic-features-plan.md)
