# Islamic Features Plan - Qiam Institute App

> **Last Updated:** January 30, 2026

---

## 📊 Status Dashboard

### Overall Progress

| Category | Total | ✅ Complete | 🔄 In Progress | ⏳ Planned |
|----------|-------|-------------|----------------|------------|
| Core Features | 6 | 6 | 0 | 0 |
| Feature Enhancements | 15 | 0 | 1 | 14 |
| New Features | 4 | 2 | 0 | 2 |
| UI Improvements | 4 | 0 | 0 | 4 |
| 🐛 Bug Fixes | 2 | 2 | 0 | 0 |
| 🔧 Config Updates | 1 | 1 | 0 | 0 |
| **Total** | **32** | **11** | **1** | **20** |

---

## 🐛 Bug Fixes

| ID | Bug | Screen | Priority | Status | Details |
|----|-----|--------|----------|--------|---------|
| BUG-001 | Quran Auto-Scroll Hides Ayah | Surah Detail | High | ✅ Fixed | [→](./bugs.md#bug-001-quran-auto-scroll-hides-ayah-behind-navigation-bar) |
| BUG-002 | Insufficient Bottom Padding | Multiple | Medium | ✅ Fixed | [→](./bugs.md#bug-002-insufficient-bottom-padding-on-scrollable-screens) |

[View All Bugs →](./bugs.md)

---

## 🎯 Core Features

| # | Feature | Status | Details |
|---|---------|--------|---------|
| 1 | Quran Reader | ✅ Complete | [View Details](./features/quran-reader.md) |
| 2 | Tasbih Counter | ✅ Complete | [View Details](./features/tasbih-counter.md) |
| 3 | 99 Names of Allah | ✅ Complete | [View Details](./features/99-names.md) |
| 4 | Hadith Collection | ✅ Complete | [View Details](./features/hadith-collection.md) |
| 5 | Dua Collection | ✅ Complete | [View Details](./features/dua-collection.md) |
| 6 | Adhan Notifications | ✅ Complete | [View Details](./features/adhan-notifications.md) |

---

## 🚀 Feature Enhancements

### Quran Reader

| ID | Enhancement | Priority | Status | Details |
|----|-------------|----------|--------|---------|
| 1.1 | Juz Navigation Tab | Medium | ⏳ Planned | [→](./features/quran-reader.md#enhancements) |
| 1.2 | Makki/Madani Badge | Low | ⏳ Planned | [→](./features/quran-reader.md#enhancements) |
| 1.3 | Tajweed Colors | Medium | ⏳ Planned | [→](./features/quran-reader.md#enhancements) |
| 1.4 | Bookmarks Tab UI | Medium | ⏳ Planned | [→](./features/quran-reader.md#enhancements) |
| 1.5 | Font Size Adjustment | Low | ⏳ Planned | [→](./features/quran-reader.md#enhancements) |
| 1.6 | Audio Offline Cache | High | 🔄 In Progress | [→](./technical/audio-offline-mode.md) |

### Tasbih Counter

| ID | Enhancement | Priority | Status | Details |
|----|-------------|----------|--------|---------|
| 2.1 | Keep Screen Awake | High | ⏳ Planned | [→](./features/tasbih-counter.md#enhancements) |
| 2.2 | Custom Dhikr Input | Medium | ⏳ Planned | [→](./features/tasbih-counter.md#enhancements) |
| 2.3 | Landscape Mode | Low | ⏳ Planned | [→](./features/tasbih-counter.md#enhancements) |

### 99 Names of Allah

| ID | Enhancement | Priority | Status | Details |
|----|-------------|----------|--------|---------|
| 3.1 | Audio Pronunciation | Low | ⏳ Planned | [→](./features/99-names.md#enhancements) |
| 3.2 | Favorites List | Medium | ⏳ Planned | [→](./features/99-names.md#enhancements) |
| 3.3 | Random Name Feature | Low | ⏳ Planned | [→](./features/99-names.md#enhancements) |
| 3.4 | Share as Image | Low | ⏳ Planned | [→](./features/99-names.md#enhancements) |

### Adhan Notifications

| ID | Enhancement | Priority | Status | Details |
|----|-------------|----------|--------|---------|
| 6.1 | Iqamah Reminder | Low | ⏳ Planned | [→](./features/adhan-notifications.md#enhancements) |
| 6.2 | Do Not Disturb Awareness | Low | ⏳ Planned | [→](./features/adhan-notifications.md#enhancements) |

---

## 🆕 New Features

| # | Feature | Location | Priority | Status | Details |
|---|---------|----------|----------|--------|---------|
| 7 | Qibla Calibration Improvements | Prayer Screen | Medium | ⏳ Planned | [View Details](./features/qibla-calibration.md) |
| 8 | Prayer Times Calendar Redesign | Prayer Screen | Medium | ⏳ Planned | [View Details](./features/prayer-calendar-redesign.md) |
| 9 | Feedback Form | Settings | High | ✅ Complete | [View Details](./features/feedback-volunteer-forms.md) |
| 10 | Volunteer Form | Explore | High | ✅ Complete | [View Details](./features/feedback-volunteer-forms.md) |

---

## 🎨 UI Improvements

| ID | Improvement | Screen | Priority | Status | Details |
|----|-------------|--------|----------|--------|---------|
| U1 | Adhan Settings - Combine Fajr Section | Settings | Medium | ⏳ Planned | [→](./features/adhan-notifications.md#ui-improvements) |
| U2 | Prayer Times Calendar Cards | Prayer Times | Medium | ⏳ Planned | [→](./features/prayer-calendar-redesign.md) |
| U3 | Explore Page Redesign | Explore | Medium | ⏳ Planned | [→](./reference/explore-layout.md) |
| U4 | Custom Islamic Icons | Explore | Medium | ⏳ Planned | [→](./reference/explore-layout.md#icon-strategy) |

### U3 & U4: Explore Page Redesign Summary

**Key Changes:**
- Grouped sections (Islamic Tools / Qiam Institute / Resources)
- Quick Access row for most-used features
- Custom SVG icons for Islamic features
- Move Adhan from Explore to Settings
- Add Qibla to Explore

[View Full Details →](./reference/explore-layout.md)

---

## 🔧 Configuration Updates

| ID | Update | File | Status |
|----|--------|------|--------|
| CFG-001 | Update Donation URL to Zeffy | `lib/config/constants.dart` | ✅ Complete |

---

## 📋 Implementation Phases

### 🔴 Phase 1: High Priority (Next Sprint)

| Task ID | Task | Feature | Status |
|---------|------|---------|--------|
| 1.6 | Quran Audio Caching | Quran | 🔄 In Progress |
| 2.1 | Tasbih Keep Screen Awake | Tasbih | ⏳ Planned |
| 9 | Feedback Form | Forms | ✅ Complete |
| 10 | Volunteer Form | Forms | ✅ Complete |

### 🟡 Phase 2: Medium Priority

| Task ID | Task | Feature | Status |
|---------|------|---------|--------|
| 1.1 | Juz Navigation Tab | Quran | ⏳ Planned |
| 1.3 | Tajweed Colors | Quran | ⏳ Planned |
| 1.4 | Bookmarks Tab UI | Quran | ⏳ Planned |
| 2.2 | Custom Dhikr Input | Tasbih | ⏳ Planned |
| 3.2 | 99 Names Favorites | 99 Names | ⏳ Planned |
| 7 | Qibla Calibration | Prayer | ⏳ Planned |
| 8 | Prayer Calendar Redesign | Prayer | ⏳ Planned |
| U1 | Adhan Settings UI Fix | Settings | ⏳ Planned |
| U3 | Explore Page Redesign | Explore | ⏳ Planned |
| U4 | Custom Islamic Icons | Explore | ⏳ Planned |

### 🟢 Phase 3: Low Priority

| Task ID | Task | Feature | Status |
|---------|------|---------|--------|
| 1.2 | Makki/Madani Badge | Quran | ⏳ Planned |
| 1.5 | Font Size Adjustment | Quran | ⏳ Planned |
| 2.3 | Landscape Mode | Tasbih | ⏳ Planned |
| 3.1 | Audio Pronunciation | 99 Names | ⏳ Planned |
| 3.3 | Random Name Feature | 99 Names | ⏳ Planned |
| 3.4 | Share as Image | 99 Names | ⏳ Planned |
| 6.1 | Iqamah Reminder | Adhan | ⏳ Planned |
| 6.2 | DND Awareness | Adhan | ⏳ Planned |

---

## 📚 Documentation Index

### Features
- [Quran Reader](./features/quran-reader.md)
- [Tasbih Counter](./features/tasbih-counter.md)
- [99 Names of Allah](./features/99-names.md)
- [Hadith Collection](./features/hadith-collection.md)
- [Dua Collection](./features/dua-collection.md)
- [Adhan Notifications](./features/adhan-notifications.md)
- [Qibla Calibration](./features/qibla-calibration.md)
- [Prayer Calendar Redesign](./features/prayer-calendar-redesign.md)
- [Feedback & Volunteer Forms](./features/feedback-volunteer-forms.md)

### Technical
- [Audio Offline Mode](./technical/audio-offline-mode.md)
- [Audio Licensing](./technical/audio-licensing.md)
- [Dependencies](./technical/dependencies.md)

### Reference
- [Files Structure](./reference/files-structure.md)
- [Explore Page Layout](./reference/explore-layout.md)
- [Future Backlog](./reference/future-backlog.md)

### Tracking
- [🐛 Bug Tracker](./bugs.md)
