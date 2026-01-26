# Qiam Institute App — Development Status

**Last Updated:** 2026-01-25

## Project Goal

Ship a mobile app for Qiam Institute that provides Events, Updates, Prayer Times, Qibla Compass, Daily Duas, and Notifications for iOS and Android.

---

## Completed Features

### Core App
- [x] Flutter project setup with proper structure
- [x] Main navigation with bottom nav bar
- [x] App theming with Qiam Institute branding
- [x] App icon and splash screen

### Home Screen
- [x] Featured YouTube video with replay functionality
- [x] Next prayer time countdown
- [x] Quick navigation cards
- [x] Community values showcase
- [x] Contact information

### Events
- [x] Events list from WordPress API
- [x] Event detail screen with full information
- [x] Registration links
- [x] Share functionality

### Updates/Announcements
- [x] Updates list from WordPress API
- [x] Update detail screen
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
- [x] About section

### UI/UX
- [x] Consistent theming across all screens
- [x] Theme-aware backgrounds (not dark)
- [x] Proper overflow handling
- [x] Error states and loading indicators

---

## In Progress

### Notifications
- [ ] Firebase project setup
- [ ] Android FCM wiring
- [ ] iOS APNs + FCM wiring
- [ ] Topic-based broadcast notifications

---

## Remaining Tasks

### High Priority
- [ ] Push notifications implementation
- [ ] iOS build and TestFlight deployment
- [ ] Play Store metadata and screenshots
- [ ] Privacy policy page

### Medium Priority
- [ ] Prayer time notifications (optional alerts for each prayer)
- [ ] Widget for home screen (Android)
- [ ] Dark mode support
- [ ] Localization (Arabic language support)

### Low Priority / Future
- [ ] Offline event caching
- [ ] User accounts/login
- [ ] Donation integration
- [ ] Community directory
- [ ] Media/podcast section
- [ ] Advanced theming options

---

## Technical Debt

- [ ] Add unit tests for services
- [ ] Add widget tests for key screens
- [ ] Code documentation
- [ ] CI/CD pipeline setup (GitHub Actions)

---

## Distribution Status

### Android
- [x] Debug builds working
- [x] Release APK builds
- [ ] Firebase App Distribution setup
- [ ] Play Store internal testing track

### iOS
- [ ] iOS build configuration
- [ ] Apple Developer account setup
- [ ] TestFlight distribution

---

## Reference Links

- **Website:** https://qiaminstitute.org/
- **Events:** https://qiaminstitute.org/events/
- **Facebook:** https://www.facebook.com/p/Qiam-Institute-61573449077244/
- **Donate:** https://qiaminstitute.org/support-us/

---

## Changelog

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
- Events and Updates from WordPress API
