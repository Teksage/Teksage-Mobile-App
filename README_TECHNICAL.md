# Teksage Mobile — Technical README

Engineering guide for the Flutter **Teksage** app (`astro_prompt`). For product overview, see [README.md](README.md).

---

## Stack

| Layer | Choice |
|-------|--------|
| UI | Flutter / Dart (`sdk: ^3.6.1`) |
| State / i18n / routing | GetX |
| Backend | Teksage FastAPI (REST + WebSocket chat) |
| Push | Firebase Cloud Messaging |
| Payments | Razorpay (via backend) |

App version is defined in `pubspec.yaml` (e.g. `3.0.0+47`).

---

## Prerequisites

1. Install Flutter and confirm:

   ```bash
   flutter doctor
   ```

2. Android SDK / Xcode for the platforms you target.
3. Optional: local [Teksage-backend-latest](../Teksage-backend-latest) on port **8000**.

---

## Setup

```bash
git clone <your-fork-or-org-url>/Teksage-Mobile-App.git
cd Teksage-Mobile-App
flutter pub get
```

### Firebase / Google services

- Android: `android/app/google-services.json` (team-provided; do not invent keys).
- iOS: corresponding Firebase / Google config in `ios/` as used by the project.

### API endpoints

Single source of truth: [`lib/config/api_endpoints.dart`](lib/config/api_endpoints.dart).

```dart
// Production example (may already be active in repo)
static const String mainUrl = 'http://…:8000';
static const String chatUrl = 'ws://…:8000/chat';
static const String baseUrl = '$mainUrl/api';
```

**Local backend**

| Client | `mainUrl` | `chatUrl` |
|--------|-----------|-----------|
| Android emulator | `http://10.0.2.2:8000` | `ws://10.0.2.2:8000/chat` |
| iOS simulator | `http://127.0.0.1:8000` | `ws://127.0.0.1:8000/chat` |
| Physical device | `http://<PC_LAN_IP>:8000` | `ws://<PC_LAN_IP>:8000/chat` |

Phone and PC must be on the same network; allow firewall port **8000**.

There are **no** Dart flavors / `.env` files for API switching today — comment and uncomment URL blocks carefully before committing.

---

## Run & build

```bash
flutter run
flutter run -d chrome          # if enabled
flutter build apk --release
flutter build appbundle --release
flutter build ipa              # macOS + Xcode
```

### Platform IDs

| Platform | ID |
|----------|-----|
| Android `applicationId` | `com.venzo.astroPrompt` |
| iOS bundle identifier | `com.app.teksage` |
| iOS deployment target | 13.0 |

Android `compileSdk` / `targetSdk` are set in `android/app/build.gradle` (currently 36).

---

## `lib/` layout

| Folder | Role |
|--------|------|
| `config/` | API URLs, `localeString.dart`, helpers, local storage |
| `Screens/` | Feature screens (auth, Home, Chat, Consultation, EventPlanner, …) |
| `Components/` | Shared widgets |
| `Services/` | HTTP / domain services |
| `Model/` | Request/response models |
| `Utility/` | Theme helpers, assets accessors, UI utilities |

---

## Internationalization

- Translations: `lib/config/localeString.dart` (`class LocalString extends Translations`)
- Wired in `lib/main.dart` via `GetMaterialApp(translations: LocalString(), …)`
- Usage: `'some_key'.tr`
- Locales: `en_US`, `ta`, `te_IN`, `kn_IN`, `ml_IN`, `hi`, `mr_IN`
- Preference persisted under `config/LocallySavedData/`

When adding UI copy for features that also exist on the website, align keys with `teksage-website/src/lib/i18n/messages/` where practical.

---

## Troubleshooting

| Problem | What to try |
|---------|-------------|
| Cannot reach API | Check `api_endpoints.dart`; emulator vs device URL; backend up; HTTP cleartext / ATS if using plain `http://` |
| WebSocket fails | `chatUrl` scheme (`ws` vs `wss`) must match host TLS |
| Plugin / Gradle errors | `flutter clean` → `flutter pub get`; check JDK / NDK versions in `android/` |
| i18n shows raw keys | Missing key in `localeString.dart` for current locale |
| Signing failures | `android/key.properties` and keystore present for release |

Cleartext HTTP to a LAN IP often needs Android network security config — if requests fail only on device with `http://`, confirm cleartext is allowed for debug builds.

---

## Related repositories

| Repo | Role |
|------|------|
| Teksage-backend-latest | FastAPI |
| teksage-website | Next.js customer web |
| Teksage-admin | Vite admin dashboard |

---

## License

Proprietary — Teksage. All rights reserved.
