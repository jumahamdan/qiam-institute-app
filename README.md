# Qiam Institute App

A mobile app for [Qiam Institute](https://qiaminstitute.org/) — a home of learning, belonging, healing, and growth rooted in faith.

## About

This app provides essential features for the Qiam Institute community, helping Muslims stay connected with their faith through prayer times, Qibla direction, daily duas, Quran recitation, and community events.

## Features

### Core Features

- **Home Screen** — Quick access to next prayer time, featured video, community values, and navigation to all features
- **Events** — View upcoming events with details, dates, locations, and registration links
- **Prayer Times** — Accurate daily and weekly prayer schedules with offline support (calculated using the Adhan library)
- **Qibla Compass** — Precise compass for prayer direction with beautiful UI and calibration support
- **Daily Duas** — Comprehensive collection of 52+ authentic duas with proper hadith references
- **Islamic Calendar** — Hijri calendar with important Islamic dates

### Islamic Features

- **Quran Reader** — Full 114 surahs with Arabic text and English translation, audio recitation with 10 popular reciters
- **Tasbih Counter** — Digital dhikr counter with 9 preset phrases, progress tracking, and lifetime statistics
- **99 Names of Allah** — Complete Asma ul Husna with Arabic, transliteration, meaning, and detailed descriptions

### Notifications

- **Push Notifications** — Firebase Cloud Messaging for events, announcements, and live sessions
- **Topic Subscriptions** — Subscribe to specific notification categories in settings

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

### Quran Reader Feature

- Full 114 surahs with surah info (revelation type, verse count)
- Arabic text with proper RTL rendering
- English translation (Saheeh International)
- Audio recitation with 10 popular reciters:
  - Mishary Rashid Alafasy
  - Abdul Basit (Mujawwad & Murattal)
  - Mahmoud Khalil Al-Husary
  - Mohamed Siddiq Al-Minshawi
  - Abdur-Rahman As-Sudais
  - Saud Al-Shuraim
  - Saad Al-Ghamdi
  - Ahmed Al-Ajamy
  - Maher Al-Muaiqly
- Verse-by-verse or continuous playback
- Adjustable font sizes
- Search surahs by name or number
- Share and copy verses

### Tasbih Counter Feature

- 9 preset dhikr phrases with authentic hadith references
- Visual progress ring with count and target
- Haptic feedback on each tap
- Lifetime statistics tracking
- Customizable targets (33, 66, 99, 100, etc.)
- Completion celebration animation

### 99 Names of Allah Feature

- Complete list of 99 names (Asma ul Husna)
- Arabic name with transliteration
- English meaning and detailed description
- Grid and list view options
- Search by name or meaning
- Beautiful detail sheet for each name

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
- Distance to Makkah and cardinal direction display
- Calibration guidance
- Mini compass widget on prayer screen

## Tech Stack

- **Framework:** Flutter (iOS + Android from single codebase)
- **Language:** Dart
- **Prayer Times:** Adhan library for accurate calculations
- **Compass:** flutter_compass + geolocator
- **Quran:** quran package for text data
- **Audio:** just_audio for Quran recitation
- **Notifications:** Firebase Cloud Messaging + flutter_local_notifications
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

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires macOS)
flutter build ios --release
```

## CI/CD Pipeline

The project uses GitHub Actions for continuous integration and deployment.

### Automated Builds

Every push to a branch triggers:
1. **Test Suite** — Runs all Flutter tests
2. **Release Build** — Builds signed APK and AAB (skipped for pull requests)

### Firebase App Distribution

Builds are automatically distributed to testers:
- **`develop` branch** — Sent to `qiam-developers` group
- **`master` branch** — Sent to `qiam-testers` group

### Required Secrets

For CI/CD to work, configure these GitHub Secrets:

| Secret | Description |
|--------|-------------|
| `KEYSTORE_BASE64` | Base64-encoded upload keystore |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_ALIAS` | Key alias for signing |
| `GOOGLE_SERVICES_JSON` | Firebase config (base64) |
| `FIREBASE_APP_ID` | Firebase App ID |
| `FIREBASE_SERVICE_ACCOUNT` | Firebase service account JSON |

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # App widget and navigation
├── models/
│   └── duaa.dart            # Dua model and categories
├── screens/
│   ├── home/                # Home screen
│   ├── explore/             # Explore/feature grid screen
│   ├── events/              # Events list and detail
│   ├── prayer/              # Prayer times
│   ├── qibla/               # Qibla compass
│   ├── duaa/                # Duas screens
│   ├── quran/               # Quran reader
│   │   ├── quran_screen.dart        # Surah list
│   │   └── surah_detail_screen.dart # Verse reader + audio
│   ├── tasbih/              # Tasbih counter
│   ├── names_of_allah/      # 99 Names of Allah
│   ├── islamic_calendar/    # Hijri calendar
│   └── settings/            # App settings with notifications
├── services/
│   ├── prayer/              # Prayer time calculations
│   ├── qibla/               # Qibla direction service
│   ├── location/            # Location services
│   ├── duaa/                # Dua service and data
│   ├── quran/               # Quran text and audio services
│   ├── tasbih/              # Tasbih counter service
│   ├── names_of_allah/      # 99 Names data service
│   └── notification/        # FCM push notifications
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
