# Teksage Mobile App

Flutter app for **Teksage** — voice-capable AI astrology companion (predictions, chat, panchang, matchmaking, consultation, Event Planner, subscriptions).

- **Package name:** `astro_prompt`
- **Android applicationId:** `com.venzo.astroPrompt`
- **iOS bundle id:** `com.app.teksage`
- **Play Store:** [Teksage](https://play.google.com/store/apps/details?id=com.venzo.astroPrompt)

Backend: [Teksage-backend-latest](../Teksage-backend-latest). Web parity: [teksage-website](../teksage-website).

For product overview and feature marketing copy, see the sections below. For day-to-day engineering, start with **Quick start** and [README_TECHNICAL.md](README_TECHNICAL.md).

---

## Quick start (developers)

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) with Dart SDK **^3.6.1** (see `pubspec.yaml`)
- Android Studio / Xcode as needed
- A running Teksage API if you want local backend (default port **8000**)

### Install & run

```bash
cd Teksage-Mobile-App
flutter pub get
flutter run
```

Useful:

```bash
flutter devices
flutter run -d <device_id>
flutter clean && flutter pub get
```

### Point the app at your API

Edit [`lib/config/api_endpoints.dart`](lib/config/api_endpoints.dart):

| Target | Example |
|--------|---------|
| Production EC2 | Active `mainUrl` / `chatUrl` in that file |
| Android emulator → host machine | `http://10.0.2.2:8000` and `ws://10.0.2.2:8000/chat` |
| Physical device on same Wi‑Fi | `http://<your-pc-lan-ip>:8000` (from `ipconfig` / `ifconfig`) |
| HTTPS host | Use `https://` / `wss://` variants |

Comment/uncomment the blocks in `api_endpoints.dart` — there is **no** `.env` / product-flavor switch yet.

### Build

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS (macOS)
flutter build ipa
```

Android release signing uses `android/key.properties` when present (do not commit secrets).

---

## Project structure (`lib/`)

```
lib/
  main.dart
  config/           # api_endpoints, localeString (i18n), helpers
  Screens/          # Feature screens (auth, Home, Chat, …)
  Components/       # Reusable widgets
  Services/         # API / domain services
  Model/            # DTOs
  Utility/          # colors, images, snackbars, …
```

### i18n

GetX translations in [`lib/config/localeString.dart`](lib/config/localeString.dart) (`LocalString`), wired in `main.dart`. Locales include `en_US`, `ta`, `hi`, `te_IN`, `kn_IN`, `ml_IN`, `mr_IN`. Use `.tr` for user-facing strings — keep keys in sync with the website message files when adding shared product copy.

### State / navigation

GetX (`get` package) for routing, locale, and much of the app state.

---

## Related docs

| Doc | Purpose |
|-----|---------|
| [README_TECHNICAL.md](README_TECHNICAL.md) | Setup, API config, structure, troubleshooting |
| [TECHNICAL_NOTES.md](TECHNICAL_NOTES.md) | Longer historical notes (some sections may be stale vs current Gradle/pubspec) |
| [RELEASE_NOTES.md](RELEASE_NOTES.md) | Release changelog |

---

## Product overview

Teksage combines Jyotish wisdom with AI and voice: personalized predictions, multilingual chat, panchang, matchmaking, human consultations, and more — in English, Hindi, Tamil, Telugu, Malayalam, Marathi, and Kannada.

### Highlights

- AI-powered, birth-chart–based insights (not sun-sign only)
- Daily / weekly / yearly predictions and life reports
- 24/7 AI astrologer chat + optional human consultations
- Personalized panchang (Thara Bala, Chandra Bala, auspicious timings)
- Voice-first experience (STT / TTS) in supported languages
- Event Planner (Muhurtha) and subscription plans

### Why Teksage

- Chart-based predictions and real-time AI answers
- Avatar / tone personalization
- Privacy-minded handling of sensitive interactions

---

## Connect

- Website: [www.teksage.app](https://www.teksage.app) / [my.teksage.app](https://my.teksage.app)
- Support: support@teksage.com

---

## License

Copyright © Teksage. All rights reserved.
