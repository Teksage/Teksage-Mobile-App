# Facebook / Meta App Events & Install Analytics — Verification & Testing Guide

## 1. Configuration Summary

- **Meta App ID:** `1568379927830837`
- **Client Token:** `e7f5538a8af219765585e9ecff862090`
- **Android Package:** `com.venzo.astroPrompt` (`android/app/src/main/res/values/strings.xml`)
- **iOS Bundle ID:** `com.app.teksage` (`ios/Runner/Info.plist`)
- **Backend Migration:** `20260827_01_add_app_installs.py` (applied via `alembic upgrade head`)

---

## 2. How to Test Meta App Events (Real-Time in Meta Dashboard)

Meta provides a live **App Event Tester** tool in App Ads Helper:

### Step 2.1: Open the Test Tool
1. Go to **[Meta App Ads Helper](https://developers.facebook.com/tools/app-ads-helper/)** (or Meta Events Manager → Data Sources → Your App → Test Events).
2. Select your App: `1568379927830837`.
3. Scroll down to **App Event Tester**.
4. Make sure your test device or simulator is connected.

### Step 2.2: Run the Mobile App & Trigger Events

Run the mobile app on a physical device or emulator/simulator:
```bash
flutter run
```

Test each action in the app and watch the event appear in real-time in the **App Event Tester**:

| # | Event Name in Meta | How to Trigger in App | Parameters Logged |
|---|--------------------|-----------------------|-------------------|
| 1 | **Activated App** | Launch / open the app | Automated on startup |
| 2 | **CompleteRegistration** (`fb_mobile_complete_registration`) | Enter OTP and log in successfully | `fb_registration_method: "otp"` |
| 3 | **ViewContent** (`fb_mobile_content_view`) | Navigate to Astrologer Profile / Detail page | `fb_content_id: "<astro_id>"`, `fb_content_type: "astrologer"` |
| 4 | **InitiateCheckout** (`fb_mobile_initiated_checkout`) | Tap Proceed / Book on Ask Astrologer, Consultation, or Subscription summary | `fb_content_type`, `_valueToSum` (price), `fb_currency` |
| 5 | **Purchase** (`fb_mobile_purchase`) | Complete a successful payment via Razorpay / StoreKit | `_valueToSum` (amount), `fb_currency` |
| 6 | **Subscribe** (`Subscribe`) | Complete a subscription plan payment | `fb_currency`, `fb_order_id`, `_valueToSum` |
| 7 | **Schedule** (`Schedule`) | Complete a consultation booking | `name: "Schedule"` |
| 8 | **Rated** (`fb_mobile_rate`) | Submit rating after appointment | `_valueToSum: <rating>` |

---

## 3. How to Test Teksage Admin Acquisition Dashboard

Your Admin dashboard tracks **First Open Installs** and **Signups/Logins** attributed to `facebook`, `organic`, or `unknown`.

### Step 3.1: Open Admin Dashboard
1. Log in to your Teksage Admin panel.
2. Navigate to **Analytics** (`/dashboard/analytics`).
3. Click on the **Acquisition** tab.

### Step 3.2: Verify Organic / Unknown First Launch
1. On a fresh app install (or after clearing app data):
   - Open the app.
   - The app calls `POST /api/analytics/install` with a generated `install_id` and `source: "unknown"`.
2. Check Admin → Analytics → **Acquisition**:
   - **Total installs** increments by 1.
   - **Unknown installs** increments by 1.
3. Log in via OTP:
   - The app calls `POST /api/analytics/install/attach-user`.
   - Admin → Acquisition **Total signups** increments by 1.

### Step 3.3: Simulate a Facebook Ad Install (Deep Link / Campaign)
To test Facebook attribution before running live ads:

1. Launch the app using a simulated Facebook campaign URL / deep link containing `fbclid` or `utm_source=facebook`:
   ```bash
   # Android adb deep link test (stop and re-run `flutter run` first if you just added intent-filters):
   adb shell am start -a android.intent.action.VIEW -d "https://my.teksage.app/?utm_source=facebook&utm_campaign=diwali_ad_2026&fbclid=test_fb_click_999" -n com.venzo.astroPrompt/.MainActivity

   # Or via custom scheme:
   adb shell am start -a android.intent.action.VIEW -d "teksage://app?utm_source=facebook&utm_campaign=diwali_ad_2026&fbclid=test_fb_click_999"
   ```
2. The app's `InstallAttributionService` captures `source: "facebook"` and `campaign: "diwali_promo"` and posts it to `/api/analytics/install`.
3. Complete OTP login.
4. Refresh Admin → Analytics → **Acquisition**:
   - **Facebook installs** increments by 1.
   - **Facebook signups** increments by 1.
   - **Facebook install → signup conversion rate** updates dynamically.
   - **Installs by source (monthly)** line chart plots Facebook data.

---

## 4. Troubleshooting Checklist

| Issue | What to check |
|-------|---------------|
| Events not showing in Meta App Event Tester | Verify Client Token (`e7f5538a8af219765585e9ecff862090`) in `strings.xml` and `Info.plist`. Ensure your test device has an active internet connection. |
| Acquisition tab in Admin shows 0 | Ensure the backend database migration `20260827_01_add_app_installs.py` has been applied via `alembic upgrade head`. |
| Android build issues with Facebook SDK | Ensure `android/app/src/main/res/values/strings.xml` contains `facebook_app_id`, `facebook_client_token`, and `fb_login_protocol_scheme`. |
| iOS build issues | Ensure `Info.plist` contains `FacebookAppID`, `FacebookClientToken`, `FacebookDisplayName`, and the `fb1568379927830837` URL scheme. |
