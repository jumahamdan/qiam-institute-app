# Future Backlog

> **Last Updated:** January 30, 2026

This document tracks future enhancements, post-publishing tasks, and ideas that are not yet scheduled for implementation.

---

## 📱 Post-Publishing Tasks

Tasks to complete after the app is published to the app stores.

| ID | Task | Location | Priority | Status |
|----|------|----------|----------|--------|
| PUB-001 | Add App Store rating link | Settings > Rate App | High | ⏳ Pending |
| PUB-002 | Update Share message with store links | Settings > Share | High | ⏳ Pending |
| PUB-003 | Add Play Store rating link | Settings > Rate App | High | ⏳ Pending |

### PUB-001 & PUB-003: Rate App Links

After publishing, add the actual store links to `lib/config/constants.dart`:

```dart
// App Store Links (add after publishing)
static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=org.qiaminstitute.app';
static const String appStoreUrl = 'https://apps.apple.com/app/qiam-institute/id123456789';
```

Then update `lib/screens/settings/settings_screen.dart`:

```dart
SettingsTile.external(
  icon: Icons.star_outline,
  title: 'Rate the App',
  subtitle: 'Share your experience on the store',
  onTap: () => _launchUrl(Platform.isIOS
    ? AppConstants.appStoreUrl
    : AppConstants.playStoreUrl),
),
```

### PUB-002: Share Message Update

Update the share message in `lib/screens/settings/settings_screen.dart`:

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

## 💡 Feature Ideas

Ideas and suggestions for future consideration (not yet planned).

| ID | Idea | Category | Notes |
|----|------|----------|-------|
| IDEA-001 | Quran memorization tracker | Quran | Track memorization progress by surah/juz |
| IDEA-002 | Prayer streak tracking | Prayer | Gamification for consistent prayer |
| IDEA-003 | Islamic calendar events | Calendar | Hijri calendar with Islamic events |
| IDEA-004 | Zakat calculator | Tools | Calculate zakat on assets |
| IDEA-005 | Mosque finder | Location | Find nearby mosques with prayer times |
| IDEA-006 | Daily Islamic quote widget | Home | Rotating quotes from Quran/Hadith |
| IDEA-007 | Ramadan mode | Seasonal | Special features during Ramadan |
| IDEA-008 | Community features | Social | Local community events, announcements |
| IDEA-009 | Home Screen Widget | Home | Native widget showing next prayer (`home_widget` package) |
| IDEA-010 | Bookmark Sync | Cloud | Cloud backup via Firebase (requires auth) |
| IDEA-011 | Dynamic Hijri Date | UI | Show today's Hijri date (`hijri` package) |

---

## 🔧 Technical Debt

Items to address when time permits.

| ID | Item | Priority | Notes |
|----|------|----------|-------|
| TECH-001 | Implement actual theme switching | Medium | Currently shows picker but doesn't persist |
| TECH-002 | Add unit tests for settings | Medium | Improve test coverage |
| TECH-003 | Offline mode for Quran | Low | Cache Quran data locally |

---

## 📝 Notes

- All features should support dark mode
- Arabic text uses proper RTL rendering
- Most features work offline
- Events and Live Stream require internet

---

## 📋 How to Add Items

### Adding a Post-Publishing Task
```markdown
| PUB-XXX | Description | Location | Priority | ⏳ Pending |
```

### Adding a Feature Idea
```markdown
| IDEA-XXX | Short description | Category | Additional notes |
```

### Adding Technical Debt
```markdown
| TECH-XXX | Description | Priority | Notes |
```

---

[← Back to Plan](../islamic-features-plan.md)
