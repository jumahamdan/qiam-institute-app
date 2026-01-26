# Qiam Institute App

A mobile app for [Qiam Institute](https://qiaminstitute.org/) — a home of learning, belonging, healing, and growth rooted in faith.

## About

This app provides essential features for the Qiam Institute community, helping Muslims stay connected with their faith through prayer times, Qibla direction, daily duas, and community events.

## Features

### Core Features

- **Home Screen** — Quick access to next prayer time, featured video, community values, and navigation to all features
- **Events** — View upcoming events with details, dates, locations, and registration links
- **Updates** — Stay informed with community announcements and news
- **Prayer Times** — Accurate daily and weekly prayer schedules with offline support (calculated using the Adhan library)
- **Qibla Compass** — Precise compass for prayer direction with beautiful UI and calibration support
- **Daily Duas** — Comprehensive collection of 52+ authentic duas with proper hadith references

### Daily Duas Feature

The app includes an extensive collection of Islamic supplications organized by category:

| Category | Duas | Description |
|----------|------|-------------|
| Morning & Evening | 5 | Daily adhkar for morning and evening |
| Sleep | 4 | Before sleeping and upon waking |
| Masjid | 3 | Entering, leaving, and after adhan |
| Food | 5 | Before eating, after eating, breaking fast |
| Forgiveness & Guidance | 4 | Seeking forgiveness and guidance |
| Travel | 4 | Starting journey, returning, entering town |
| Home | 3 | Leaving and entering the home |
| Bathroom | 2 | Before entering and after leaving |
| Wudu | 3 | Before and after ablution |
| Anxiety & Distress | 4 | For anxiety, distress, and hardship |
| Protection | 3 | Seeking Allah's protection |
| Health & Sickness | 4 | For the sick and for good health |
| Clothing | 2 | When wearing new clothes |
| Quranic Duas | 6 | Popular duas from the Quran |

**Features:**
- Arabic text with diacritical marks
- Transliteration for easy pronunciation
- English translation
- Authentic hadith references (e.g., "Sahih Al-Bukhari 6306", "Sahih Muslim 2708")
- Contextual remarks explaining when and how to recite
- Dua of the Day feature
- Bookmark favorite duas
- Adjustable Arabic font size
- Share duas with others

### Prayer Times Feature

- Accurate calculation using the Adhan library
- Today's view with all 5 daily prayers + sunrise
- 7-day weekly view
- Countdown to next prayer
- Works offline
- Location-based with auto-detection or manual search

### Qibla Compass Feature

- Real-time compass pointing to Makkah
- Beautiful themed UI matching app design
- Haptic feedback when aligned with Qibla
- Calibration guidance
- Mini compass widget on prayer screen

## Tech Stack

- **Framework:** Flutter (iOS + Android from single codebase)
- **Language:** Dart
- **Prayer Times:** Adhan library for accurate calculations
- **Compass:** flutter_compass + geolocator
- **State Management:** Provider
- **Storage:** SharedPreferences for local data persistence
- **Video:** youtube_player_flutter
- **Sharing:** share_plus

## Getting Started

### Prerequisites

- Flutter SDK 3.10.7 or higher
- Android Studio or VS Code with Flutter extension
- For iOS: macOS with Xcode

### Installation

```bash
# Clone the repository
git clone https://github.com/jumahamdan/qiam-institute-app.git
cd qiam-institute-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Building

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (requires macOS)
flutter build ios --release
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── duaa.dart            # Dua model and categories
├── screens/
│   ├── home/                # Home screen
│   ├── events/              # Events list and detail
│   ├── updates/             # Updates/announcements
│   ├── prayer/              # Prayer times
│   ├── qibla/               # Qibla compass
│   ├── duaa/                # Duas screens
│   │   ├── duaa_screen.dart
│   │   ├── duaa_detail_screen.dart
│   │   └── duaa_bookmarks_screen.dart
│   └── settings/            # App settings
├── services/
│   ├── prayer/              # Prayer time calculations
│   ├── qibla/               # Qibla direction service
│   ├── location/            # Location services
│   └── duaa/                # Dua service and data
│       ├── duaa_service.dart
│       └── duaa_data.dart   # 52+ authentic duas
├── widgets/                 # Reusable components
└── config/                  # App configuration
```

## Links

- **Website:** https://qiaminstitute.org/
- **Events:** https://qiaminstitute.org/events/
- **Facebook:** https://www.facebook.com/p/Qiam-Institute-61573449077244/
- **Donate:** https://qiaminstitute.org/support-us/

## Data Sources

### Duas & Hadith References

All duas in this app are sourced from authentic hadith collections:
- Sahih Al-Bukhari
- Sahih Muslim
- Sunan Abu Dawud
- Sunan At-Tirmidhi
- Sunan Ibn Majah
- Musnad Ahmad
- Al-Hakim's Mustadrak

References include specific book/hadith numbers for verification (e.g., "Sahih Al-Bukhari 6306").

### Prayer Times

Prayer times are calculated using the [Adhan](https://pub.dev/packages/adhan) library with configurable calculation methods supporting various madhabs and regional conventions.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is proprietary software for Qiam Institute.

## Acknowledgments

- Qiam Institute for their mission and vision
- The Flutter team for the excellent framework
- Contributors to the Adhan library
- Islamic scholars whose works inform the hadith references
