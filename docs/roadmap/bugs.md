# Bug Tracker - Qiam Institute App

> **Last Updated:** January 30, 2026

---

## 📊 Bug Summary

| Priority | Total | 🔴 Open | 🟡 In Progress | ✅ Fixed |
|----------|-------|---------|----------------|----------|
| High | 1 | 0 | 0 | 1 |
| Medium | 1 | 0 | 0 | 1 |
| Low | 0 | 0 | 0 | 0 |
| **Total** | **2** | **0** | **0** | **2** |

---

## 🔴 Open Bugs

*No open bugs.*

---

## 🟡 In Progress

*No bugs currently in progress.*

---

## ✅ Fixed Bugs

### BUG-001: Quran Auto-Scroll Hides Ayah Behind Navigation Bar

| Field | Value |
|-------|-------|
| **ID** | BUG-001 |
| **Status** | ✅ Fixed |
| **Priority** | High |
| **Screen** | Surah Detail (Quran Reader) |
| **Reported** | January 30, 2026 |
| **Fixed** | January 30, 2026 |
| **Device** | Samsung (with gesture navigation) |

#### Description
When audio recitation plays ayah-by-ayah and auto-scrolls to the next verse, the next ayah goes behind Samsung's bottom navigation bar (gesture area), making it partially or fully hidden.

#### Solution Applied
- Added GlobalKeys to verse cards for precise scrolling
- Changed from `ScrollController.animateTo()` to `Scrollable.ensureVisible()` with `alignment: 0.3`
- Added dynamic bottom padding to ListView accounting for audio player height (~140px) and safe area
- Verse now positions at 30% from viewport top, avoiding bottom navigation bar

#### Files Modified
- `lib/screens/quran/surah_detail_screen.dart`

---

### BUG-002: Insufficient Bottom Padding on Scrollable Screens

| Field | Value |
|-------|-------|
| **ID** | BUG-002 |
| **Status** | ✅ Fixed |
| **Priority** | Medium |
| **Screen** | Multiple screens with lists |
| **Reported** | January 30, 2026 |
| **Fixed** | January 30, 2026 |
| **Device** | Samsung (with gesture navigation) |

#### Description
On screens with lots of data/content, there isn't enough padding between the bottom of the scrollable content and Samsung's navigation buttons, causing the last items to be cut off or hard to tap.

#### Solution Applied
Added `MediaQuery.of(context).padding.bottom` to all scrollable list paddings:
```dart
padding: EdgeInsets.only(
  top: 16,
  left: 16,
  right: 16,
  bottom: 16 + MediaQuery.of(context).padding.bottom,
),
```

#### Files Modified
| Screen | File |
|--------|------|
| Quran Surah List | `lib/screens/quran/quran_screen.dart` |
| Surah Detail | `lib/screens/quran/surah_detail_screen.dart` |
| Hadith List | `lib/screens/hadith/hadith_screen.dart` |
| Dua List | `lib/screens/dua/dua_screen.dart` |
| Dua Detail | `lib/screens/dua/dua_detail_screen.dart` |
| Dua Bookmarks | `lib/screens/dua/dua_bookmarks_screen.dart` |
| Settings | `lib/screens/settings/settings_screen.dart` |
| Events | `lib/screens/events/events_screen.dart` |

---

## 📝 Bug Report Template

When adding new bugs, use this template:

```markdown
### BUG-XXX: [Short Title]

| Field | Value |
|-------|-------|
| **ID** | BUG-XXX |
| **Status** | 🔴 Open |
| **Priority** | High/Medium/Low |
| **Screen** | [Screen Name] |
| **Reported** | [Date] |
| **Device** | [Device/OS if relevant] |

#### Description
[Detailed description of the bug]

#### Steps to Reproduce
1. Step 1
2. Step 2
3. Observe: [What happens]

#### Expected Behavior
[What should happen]

#### Probable Cause
[Technical analysis if known]

#### Proposed Fix
[Code or approach to fix]

#### Files to Check
[List of relevant files]
```

---

## 🔗 Related Documentation

- [Islamic Features Plan](./islamic-features-plan.md)
- [Quran Reader Details](./features/quran-reader.md)

---

[← Back to Plan](./islamic-features-plan.md)
