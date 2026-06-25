# Teksage - Technical Documentation

## Project Overview

Teksage is a Flutter-based mobile application that combines voice AI technology with Vedic astrology (Jyotish) to provide personalized astrological consultations and predictions.

---

## Tech Stack

### Core Framework
- **Framework:** Flutter 3.35.7 (Channel stable)
- **Language:** Dart 3.9.2
- **State Management:** GetX
- **Architecture:** Clean Architecture with separation of concerns

### Key Technologies

#### Voice & AI
- **Speech Recognition:** `speech_to_text: ^7.3.0` - Converts user voice to text
- **Text-to-Speech:** `flutter_tts: ^4.2.3` - Converts AI responses to natural voice
- **Audio Recording:** `record: ^6.1.1` - Voice message recording
- **Audio Playback:** `just_audio: ^0.10.5` - Audio player for voice messages
- **Audio Session:** `audio_session: ^0.2.2` - Audio session management
- **AI Engine:** Custom AI integration powered by AstroPrompt backend

#### Astronomy & Calculations
- **Ephemeris:** Swiss Ephemeris (DE431) for planetary position calculations
- **Precision:** 0.001-arc-second accuracy for astronomical data
- **Vedic Calculations:** Custom algorithms for Panchang, Dasha, and compatibility
- **Timezone:** `flutter_timezone: ^4.1.1` - For accurate location-based calculations
- **Date/Time:** `intl: ^0.20.2` - Internationalization and date formatting

#### Real-time Communication
- **WebSocket:** `web_socket_channel: ^3.0.3` - Real-time chat communication
- **HTTP Client:** `http: ^1.3.0` - RESTful API integration
- **HTTP Parser:** `http_parser: ^4.1.2` - HTTP parsing utilities
- **Push Notifications:** Firebase Cloud Messaging (`firebase_messaging: ^15.2.5`)
- **Local Notifications:** `flutter_local_notifications: ^19.1.0`

#### Location Services
- **Geolocator:** `geolocator: ^14.0.0` - Device location tracking
- **Geocoding:** `geocoding: ^3.0.0` - Address to coordinates conversion
- **Purpose:** Location-based Panchang and auspicious timing calculations

#### Payments & Monetization
- **Payment Gateway:** `razorpay_flutter: ^1.4.0` - Razorpay integration
- **In-App Purchases:** `in_app_purchase: ^3.2.3` - Cross-platform IAP
- **iOS StoreKit:** `in_app_purchase_storekit: ^0.4.6` - iOS specific IAP
- **Supported:** UPI, Cards, Wallets, Net Banking

#### UI/UX & Animations
- **SVG Support:** `flutter_svg: ^2.0.17` - Scalable vector graphics
- **Page Indicators:** `smooth_page_indicator: ^1.2.0+3` - Onboarding indicators
- **Scroll Animations:** `flutter_animate_on_scroll: ^0.3.0` - Scroll-based animations
- **Loading Animations:** `loading_animation_widget: ^1.3.0` - Loading indicators
- **Progress Indicators:** `percent_indicator: ^4.2.4` - Circular/Linear progress bars
- **Custom Stack:** `eq_indexd_stack: ^0.0.9` - Enhanced indexed stack
- **Custom Fonts:** Urbanist font family (Regular, Medium, SemiBold, Bold, ExtraBold)

#### Utilities & Tools
- **Screenshot:** `screenshot: ^3.0.0` - Capture and save reports
- **Share:** `share_plus: ^11.0.0` - Share predictions and reports
- **File Operations:** `file_saver: ^0.2.14` - Save files to device
- **File Viewer:** `open_file: ^3.5.10` - Open saved files
- **Path Provider:** `path_provider: ^2.1.5` - Access device directories
- **Path Utils:** `path: ^1.9.1` - Path manipulation utilities
- **Local Storage:** `shared_preferences: ^2.5.2` - Persistent key-value storage
- **Device Info:** `device_info_plus: ^11.4.0` - Device information
- **Permissions:** `permission_handler: ^12.0.0+1` - Runtime permissions

#### Connectivity & Network
- **Connectivity:** `connectivity_plus: ^6.1.4` - Network connectivity detection
- **Connection Checker:** `internet_connection_checker_plus: ^2.7.2` - Internet availability check
- **URL Launcher:** `url_launcher: ^6.3.1` - Open external URLs

#### WebView & External Content
- **WebView:** `webview_flutter: ^4.10.0` - In-app browser functionality

#### Platform-Specific Features
- **Android Intents:** `android_intent_plus: ^5.3.0` - Android intent handling
- **Firebase Core:** `firebase_core: ^3.13.0` - Firebase initialization

#### User Engagement
- **App Rating:** `rate_my_app: ^2.3.2` - Prompt users to rate the app
- **Month Picker:** `month_picker_dialog: ^6.0.2` - Custom month selection dialog

#### Development & Splash Screen
- **Native Splash:** `flutter_native_splash: ^2.4.4` - Custom splash screen
- **Linting:** `flutter_lints: ^5.0.0` - Code quality and best practices

---

## Prerequisites

### Development Environment
- **Flutter SDK:** 3.35.7 (Channel stable)
- **Dart SDK:** 3.9.2
- **DevTools:** 2.48.0
- **IDE:** Android Studio 2025.1, VS Code 1.105.1, or IntelliJ IDEA
- **Git:** For version control
- **Operating System:** macOS 15.6 or compatible

### Platform-Specific Requirements

#### Android Development
- Android Studio 2025.1 (or latest version)
- Android SDK 36.0.0
- Build Tools: 36.0.0
- Android Emulator: 36.1.9.0
- NDK Version: 27.0.12077973
- Java Development Kit (JDK) 21 (OpenJDK Runtime Environment build 21.0.8)
- Gradle 8.9
- All Android licenses accepted

#### iOS Development
- macOS 15.6 or higher
- Xcode 16.4 (Build 16F6)
- CocoaPods 1.16.2
- iOS deployment target: 12.0 or higher
- Apple Developer Account (for deployment)


---

## Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/venzo-tech/AstroPrompt_MobileApp.git
cd AstroPrompt_MobileApp
```

### 2. Install Flutter Dependencies
```bash
flutter pub get
```

### 3. Setup Signing (Android)
- Create/update `android/key.properties` with keystore details
- Ensure keystore file is in the correct location

---

## Running the App

### Development Mode
```bash
# Run on connected device/emulator
flutter run

# Run with specific flavor
flutter run --flavor dev
flutter run --flavor prod

# Run with debug logging
flutter run --verbose
```

### Build & Release

#### Android

**Debug APK:**
```bash
flutter build apk --debug
```

**Release APK:**
```bash
flutter build apk --release
```

**Release App Bundle (recommended for Play Store):**
```bash
flutter build appbundle --release
```

#### iOS

**Debug:**
```bash
flutter build ios --debug
```

**Release:**
```bash
flutter build ios --release
```

**Create IPA:**
```bash
flutter build ipa --release
```

---

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── testScreen.dart          # Test/debug screens
├── Components/              # Reusable UI components
├── config/                  # App configuration
├── Model/                   # Data models
├── Screens/                 # UI screens
│   ├── auth/               # Authentication screens
│   ├── intro/              # Onboarding screens
│   ├── Home/               # Home and navigation
│   ├── Chat/               # AI chat interface
│   ├── Astrologer/         # Astrologer booking
│   ├── ConsultationUser/   # User consultations
│   ├── Horoscope/          # Horoscope screens
│   ├── MatchMaking/        # Compatibility reports
│   ├── Panchang/           # Panchang interface
│   ├── prediction/         # Predictions
│   ├── settings/           # App settings
│   └── Notification/       # Notifications
├── Services/               # Business logic & API calls
├── Utility/                # Helper functions & constants

assets/
├── fonts/                  # Custom fonts (Urbanist family)
├── images/                 # PNG/JPG images
└── svg/                    # SVG icons and graphics
```

---

## Firebase Cloud Messaging (FCM) Implementation

### Overview
FCM is integrated to deliver real-time push notifications for:
- **Daily Wisdom** - Personalized daily astrological predictions
- **Weekly Insights** - Weekly astrological forecasts
- **General Notifications** - Chat messages, promotional alerts, and updates

**Package Version:** `firebase_messaging: ^15.2.5`

### Architecture

#### Token Generation Process
1. **Initialization Phase**
   ```dart
   // In main.dart
   if (Platform.isAndroid) {
     await NotificationService.init();
   }
   ```
   - Firebase is auto-initialized via `google-services.json` (Android) and GoogleService-Info.plist (iOS)
   - `setAutoInitEnabled(true)` enables automatic token refresh

2. **Permission Request**
   - `_requestPermissions()` prompts user for notification permissions
   - Required for both Android 13+ and iOS
   - Requests: alert, sound, badge, announcement

3. **Token Retrieval**
   ```dart
   final fcmToken = await FirebaseMessaging.instance.getToken();
   ```
   - Firebase generates a unique token per device/app installation
   - Token tied to Google Services credentials

4. **Server Registration**
   - Endpoint: `POST /registerFcmToken`
   - Body: `{"fcm_token": "token_value"}`
   - Token stored in PostgreSQL database for push targeting

5. **Local Cache**
   - Token cached in `SharedPreferences` via `fcmToken.dart`
   - Retrieved on subsequent app launches
   - Prevents unnecessary API calls

### Key Files & Methods

**NotificationService** (`Services/NotificationService/notificationService.dart`)
- `init()` - Initialize Firebase messaging and request permissions
- `generateFcmToken()` - Explicitly request and register FCM token
- `_requestPermissions()` - Request user notification permissions  
- `_listenToMessages()` - Setup message listeners for all states
- `_initializeLocalNotifications()` - Configure local notification channel
- `_checkInitialMessage()` - Handle app launch via notification

**NotificationFirebaseService** (`Services/NotificationService/firebaseService.dart`)
- `saveFcmToken(String fcmToken)` - POST token to backend API

**Storage Helper** (`config/LocallySavedData/fcmToken.dart`)
- `saveFCMToken(String name)` - Store token locally
- `getFCMToken()` - Retrieve cached token
- `clearFCMTokenPrefs()` - Clear token on logout

### Message Handling States

| State | Listener | Behavior |
|-------|----------|----------|
| **Foreground** | `FirebaseMessaging.onMessage.listen()` | App handles notification immediately, displays local notification |
| **Background** | `FirebaseMessaging.onMessageOpenedApp.listen()` | User taps notification while app is suspended |
| **Terminated** | `getInitialMessage()` | User taps notification while app is completely closed |

### Notification Routing Logic

```dart
// Based on notification.title
if (title == 'Daily Wisdom') {
  // Navigate to Daily Prediction screen
  Get.to(() => DailyPrediction(...))
} else if (title == 'Weekly Insights') {
  // Navigate to Weekly Prediction screen
  Get.to(() => WeeklyPrediction(...))
} else {
  // Navigate to General Notifications page
  Get.to(() => NotificationPage(...))
}
```

### Platform-Specific Details

#### Android
- ✅ FCM fully integrated and enabled
- ✅ Token synced after user login (`password.dart` lines 273-295)
- ✅ Auto-regeneration if token is missing or mismatched
- ✅ Notification channel: `default_channel` with HIGH importance
- ✅ Requires `google-services.json` in `android/app/`

#### iOS
- ⚠️ FCM setup is **currently disabled** (line 25 in notificationService.dart)
- ℹ️ APNs (Apple Push Notification service) would need separate implementation
- ℹ️ Token handling deferred to iOS-specific APNs certificates
- ⚠️ Requires `GoogleService-Info.plist` configuration for future iOS support

### Configuration Files

**Android Configuration:**
```
android/app/google-services.json  (Firebase project credentials)
android/app/src/main/AndroidManifest.xml  (permissions)
```

**iOS Configuration:**
```
ios/Runner/GoogleService-Info.plist  (Firebase credentials - if enabled)
ios/Podfile  (Firebase pods)
```

### Local Notifications (Foreground Display)

**Channel Configuration:**
- Channel ID: `default_channel`
- Channel Name: `Default`
- Importance: `High` (system notification)
- Features: Alert, Badge, Sound

**Used for:**
- Displaying notifications while app is in foreground
- `flutter_local_notifications: ^19.1.0` package

### Token Lifecycle Management

| Event | Action | Location |
|-------|--------|----------|
| App Launch | Generate/retrieve token | `init()` method |
| User Login | Sync token with server | `password.dart` |
| Token Refresh | Auto-handled by Firebase | Background process |
| User Logout | Clear cached token | `clearFCMTokenPrefs()` |
| App Data Clear | Token cleared automatically | OS handles |

### Security & Best Practices

✅ **Implemented:**
- Tokens validated on backend before storing
- Tokens automatically refreshed by Firebase
- Token synced during authentication flow
- Local cache prevents redundant API calls
- Debug logging for troubleshooting
- Error handling with graceful fallbacks

⚠️ **Considerations:**
- FCM tokens can change if app is reinstalled
- Ensure backend validates token format before storing
- Implement token cleanup when users are deleted
- Monitor backend logs for token registration failures

### Debugging FCM Issues

**Check Token Generation:**
```dart
// In terminal while app is running
firebase debug notificationservice
```

**View Firebase Console:**
1. Go to Firebase Console > Your Project
2. Navigate to Cloud Messaging
3. Check delivery statistics

**Common Issues & Solutions:**

| Issue | Cause | Solution |
|-------|-------|----------|
| Token is null | Permissions denied | Ensure user granted notification permission |
| Token mismatch | Old token cached | Implement token refresh on login |
| Notifications not received | Token not registered | Check backend API logs |
| Wrong notification routed | Incorrect data parsing | Verify notification title/type in payload |

---

## Building for Production

### Android Release Checklist
- [ ] Update version code and name in `pubspec.yaml`
- [ ] Update `android/app/build.gradle` version info
- [ ] Ensure signing configuration is correct
- [ ] Test release build on multiple devices
- [ ] Generate app bundle: `flutter build appbundle --release`
- [ ] Upload to Play Store Console

### iOS Release Checklist
- [ ] Update version in `pubspec.yaml`
- [ ] Update iOS version in Xcode
- [ ] Configure certificates and provisioning profiles
- [ ] Test on physical iOS devices
- [ ] Build IPA: `flutter build ipa --release`
- [ ] Upload to App Store Connect via Xcode or Transporter

---

## Troubleshooting

### Common Issues

#### Gradle Cache Issues
```bash
# Clear Gradle cache
rm -rf ~/.gradle/caches/

# Stop Gradle daemon
cd android && ./gradlew --stop

# Clean and rebuild
flutter clean
flutter pub get
```

#### iOS Pod Issues
```bash
cd ios
pod deintegrate
pod repo update
pod install
cd ..
flutter clean
flutter pub get
```

#### Permission Issues (Android)
Ensure `AndroidManifest.xml` includes:
- Internet permission
- Location permissions
- Microphone permission
- Storage permissions

#### Permission Issues (iOS)
Ensure `Info.plist` includes:
- NSMicrophoneUsageDescription
- NSLocationWhenInUseUsageDescription
- NSLocationAlwaysUsageDescription

---

## Deployment

### Play Store
1. Build app bundle: `flutter build appbundle --release`
2. Upload to Play Store Console
3. Fill in store listing details
4. Submit for review

### App Store
1. Build IPA: `flutter build ipa --release`
2. Upload via Xcode or Transporter
3. Configure app metadata in App Store Connect
4. Submit for review

---

## Version Management

### Current Version
- **Version Name:** 2.0.0
- **Version Code:** 20
- **Build Number:** 20

### Versioning Strategy
Follow semantic versioning: MAJOR.MINOR.PATCH
- MAJOR: Breaking changes
- MINOR: New features, backward compatible
- PATCH: Bug fixes

-----

## License

Copyright © 2025 Teksage. All rights reserved.

This is proprietary software. Unauthorized copying, modification, distribution, or use of this software is strictly prohibited.

---

## Contact

**Developer:** Elamparithi B  
**GitHub:** [https://github.com/Elam126](https://github.com/Elam126)

For technical support or queries, please reach out via GitHub.

------

**Last Updated:** October 30, 2025

