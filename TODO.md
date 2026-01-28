# Qiam Institute App — Development Status

**Last Updated:** 2026-01-28

## Project Goal

Ship a mobile app for Qiam Institute that provides Events, Prayer Times, Qibla Compass, Daily Duas, Quran Reader, Tasbih Counter, 99 Names of Allah, and Push Notifications for iOS and Android.

> **Note:** Development is currently Android-first. iOS build will be addressed after Android release.

---

## Completed Features

### Core App
- [x] Flutter project setup with proper structure
- [x] Main navigation with bottom nav bar
- [x] App theming with Qiam Institute branding
- [x] App icon and splash screen

### Home Screen
- [x] Featured YouTube video with replay functionality (muted by default)
- [x] Next prayer time countdown
- [x] Quick navigation cards
- [x] Community values showcase
- [x] Contact information

### Events
- [x] Events list from WordPress API
- [x] Event detail screen with full information
- [x] Registration links
- [x] Share functionality

### Prayer Times
- [x] Accurate prayer time calculation using Adhan library
- [x] Today's view with all 5 prayers + sunrise
- [x] 7-day weekly view
- [x] Countdown to next prayer
- [x] Offline support (cached calculations)
- [x] Mini Qibla compass on prayer screen
- [x] Location-based calculations

### Qibla Compass
- [x] Real-time compass pointing to Makkah
- [x] Beautiful themed UI (matches app theme)
- [x] Haptic feedback when aligned
- [x] Calibration guidance for inaccurate sensors
- [x] Error handling for devices without compass
- [x] Distance to Makkah display
- [x] 16-point cardinal direction display
- [x] Landscape orientation support
- [x] User guidance text ("Turn left/right")

### Daily Duas
- [x] 52+ authentic duas with proper hadith references
- [x] 14 categories (Morning/Evening, Sleep, Masjid, Food, Travel, Home, etc.)
- [x] Arabic text with diacritical marks
- [x] Transliteration for pronunciation
- [x] English translation
- [x] Hadith sources (e.g., "Sahih Al-Bukhari 6306")
- [x] Contextual remarks/explanations
- [x] Dua of the Day feature
- [x] Bookmark/favorite duas
- [x] Adjustable Arabic font size (persisted)
- [x] Share duas functionality
- [x] Subject-wise (by category) view
- [x] All duas list view

### Settings
- [x] Location settings (auto-detect or manual search)
- [x] Google Places API integration with Nominatim fallback
- [x] Reverse geocoding for auto-detected locations
- [x] Prayer calculation method selection
- [x] Notification preferences (events, announcements, live)
- [x] About section

### Push Notifications (FCM)
- [x] Firebase Cloud Messaging integration
- [x] Android notification channel configuration
- [x] Topic-based subscriptions (events, announcements, live)
- [x] Notification settings UI in Settings screen
- [x] Background message handler
- [x] Foreground notification display

### Quran Reader
- [x] Full 114 surahs with metadata
- [x] Arabic text with proper RTL rendering
- [x] English translation (Saheeh International)
- [x] Surah search by name or number
- [x] Audio recitation with 10 popular reciters
- [x] Verse-by-verse and continuous playback
- [x] Adjustable font sizes (Arabic & translation)
- [x] Share and copy verses
- [x] Auto-scroll to playing verse

### Tasbih Counter
- [x] 9 preset dhikr phrases with hadith references
- [x] Visual progress ring
- [x] Haptic feedback on tap
- [x] Customizable targets (33, 66, 99, 100, etc.)
- [x] Lifetime statistics tracking
- [x] Completion celebration animation
- [x] Reset functionality

### 99 Names of Allah
- [x] Complete 99 names with Arabic text
- [x] Transliteration and English meaning
- [x] Detailed description for each name
- [x] Grid and list view toggle
- [x] Search functionality
- [x] Detail bottom sheet

### Islamic Calendar
- [x] Hijri date display
- [x] Important Islamic dates

### UI/UX
- [x] Consistent theming across all screens
- [x] Theme-aware backgrounds (not dark)
- [x] Proper overflow handling
- [x] Error states and loading indicators
- [x] All lint warnings resolved
- [x] Responsive grid layout on Explore screen
- [x] Custom icons for Quran and Tasbih features

---

## CI/CD & Distribution

### GitHub Actions Pipeline
- [x] Automated tests on all pushes and PRs
- [x] Release APK build with production signing
- [x] Release AAB build for Play Store
- [x] Firebase App Distribution integration
- [x] Automatic changelog generation from commits
- [x] Branch-based distribution:
  - `develop` -> qiam-developers group
  - `master` -> qiam-testers group

### Android Signing
- [x] Production keystore generated (`upload-keystore.jks`)
- [x] Release signing configured in `build.gradle.kts`
- [x] ProGuard/R8 minification enabled
- [x] Keystore stored securely in GitHub Secrets

### GitHub Secrets Configured
- [x] `KEYSTORE_BASE64` - Upload keystore (base64)
- [x] `KEYSTORE_PASSWORD` - Keystore password
- [x] `KEY_ALIAS` - Key alias
- [x] `GOOGLE_SERVICES_JSON` - Firebase config
- [x] `FIREBASE_APP_ID` - Firebase App ID
- [x] `FIREBASE_SERVICE_ACCOUNT` - Firebase service account

---

## In Progress

### Play Store Deployment
- [ ] Privacy policy creation and hosting
- [ ] Play Store listing assets (screenshots, descriptions)
- [ ] Google Play Console account setup
- [ ] Version bump to 1.0.0

---

## Remaining Tasks

### High Priority
- [ ] Privacy policy page (required for Play Store)
- [ ] Play Store metadata and screenshots
- [ ] iOS build and TestFlight deployment

### Medium Priority
- [ ] Adhan notifications (prayer time alerts with adhan audio)
- [ ] Hadith collection feature
- [ ] Quran bookmarks and last read position
- [ ] Widget for home screen (Android)
- [ ] Dark mode support

### Low Priority / Future
- [ ] iOS APNs + FCM wiring
- [ ] Localization (Arabic language support)
- [ ] Offline event caching
- [ ] User accounts/login
- [ ] Donation integration
- [ ] Community directory
- [ ] Media/podcast section

---

## Technical Debt

- [ ] Add unit tests for services
- [ ] Add widget tests for key screens
- [ ] Code documentation

---

## Reference Links

- **Website:** https://qiaminstitute.org/
- **Events:** https://qiaminstitute.org/events/
- **Facebook:** https://www.facebook.com/p/Qiam-Institute-61573449077244/
- **Donate:** https://qiaminstitute.org/support-us/

---

## Changelog

### 2026-01-28
- Added Quran Reader with full 114 surahs
- Added audio recitation with 10 popular reciters (Alafasy, Abdul Basit, Husary, Sudais, etc.)
- Added Tasbih Counter with 9 dhikr presets and lifetime stats
- Added 99 Names of Allah with grid/list view and search
- Implemented FCM push notifications for Android
- Added notification settings UI with topic subscriptions
- Added custom icons for Quran and Tasbih on Explore screen
- Fixed Copilot review feedback (setState mounted check, notification icon format, stream subscriptions)
- Fixed Maher Al-Muaiqly reciter URL

### 2026-01-27
- Configured Play Store release signing (keystore, build.gradle.kts, proguard)
- Updated CI/CD pipeline to build both APK and AAB
- Added keystore secrets to GitHub for CI builds
- Fixed keystore path issue in CI workflow
- Added GPS refresh throttling to prevent excessive API calls
- Updated location tab labels for clarity
- Improved responsive design across screens

### 2026-01-25
- Expanded Daily Duas from 10 to 52+ authentic duas
- Added 9 new dua categories (Travel, Home, Bathroom, Wudu, Anxiety, Protection, Health, Clothing, Quranic)
- Updated all dua sources with specific hadith references (book + number)
- Added contextual remarks for each dua
- Updated Qibla screen to use app theme colors
- Updated Dua detail screen to use app theme colors
- Fixed settings screen overflow issue
- Added video replay button on home screen
- Improved mini Qibla compass on prayer screen
- Added reverse geocoding for auto-detect location

### 2026-01-24
- Initial app development
- Core features implementation
- Prayer times with Adhan library
- Basic Qibla compass
- Events from WordPress API
