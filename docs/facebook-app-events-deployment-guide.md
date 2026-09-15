# Facebook App Events & Acquisition Attribution — Deployment & Testing Guide

This document is for the **Marketing Team**, **QA Team**, and **Developers** to test and verify Facebook App Events, Ad Attribution, and Teksage Admin Analytics after deployment.

---

## 1. Overview & Credentials

- **App Name:** Teksage
- **Facebook App ID:** `1568379927830837`
- **Facebook Client Token:** `e7f5538a8af219765585e9ecff862090`
- **Android Package:** `com.venzo.astroPrompt`
- **iOS Bundle Identifier:** `com.venzo.astroPrompt`
- **App Deep Link URL:** `https://my.teksage.app`

---

## 2. Pre-Deployment Developer Checklist

Before releasing or testing on production:

1. **Database Migration:** Ensure the database migration has been run on production:
   ```bash
   alembic upgrade head
   ```
2. **Meta App Status:**
   - Open [Meta for Developers](https://developers.facebook.com/apps/1568379927830837/).
   - Ensure App Mode is set to **"Live"** (top toggle or under *Settings → Basic*).
   - In *Android Settings*, ensure Google Play Package Name and Release Key Hashes are added.

---

## 3. How Marketing & QA Test via Meta Events Manager

Meta provides a live debugging tool to test app events in real-time without spending money on live ads.

### Step-by-step:
1. Open [Meta Events Manager](https://business.facebook.com/events_manager2).
2. Select your App Data Source (**App ID: 1568379927830837**).
3. In the left navigation menu, click **"Test Events"**.
4. Select the **"Test App Events"** tab.
5. Open the installed Teksage app on a physical test device (Android or iOS).
6. Perform the actions listed below and verify they appear live in Meta Events Manager:

| User Action in App | Meta Standard Event Triggered | Parameters Included |
| :--- | :--- | :--- |
| **Open the App** | `fb_mobile_activate_app` | App launch metadata |
| **Complete OTP Login / Signup** | `fb_mobile_complete_registration` | `registration_method: "mobile_otp"`, `user_id` |
| **View Astrologer Profile** | `fb_mobile_content_view` | `fb_content_type: "astrologer"`, `fb_content_id`, `fb_content` |
| **Click "Proceed to Pay" (Consultation / Subscription)** | `fb_mobile_initiated_checkout` | `fb_content_type`, `fb_content_id`, `fb_valueToSum` |
| **Complete Payment** | `fb_mobile_purchase` | `fb_valueToSum`, `fb_currency: "INR"` |
| **Submit Consultation Rating** | `fb_mobile_rate` | `valueToSum: rating_number` |
| **Schedule Consultation Slot** | `Schedule` (Custom Event) | `astrologer_id`, `category` |
| **Subscribe to Plan** | `Subscribe` (Custom Event) | `plan_id`, `valueToSum`, `currency: "INR"` |

> **Note:** Events appear in the Meta Test Events stream within **10–30 seconds**.

---

## 4. How Marketing Tests Facebook Ad Attribution & Campaigns

To track installs, signups, and conversion rates for specific Facebook / Instagram ad campaigns:

### A. Recommended Ad Destination URL Format
When setting up Facebook Ads in **Meta Ads Manager**, format your destination website/app URL with UTM campaign parameters:

```text
https://my.teksage.app/?utm_source=facebook&utm_campaign=diwali_ad_2026&utm_medium=paid
```

### Supported URL Parameters:
- `utm_source=facebook` *(or `utm_source=meta` / `utm_source=fb`)* — Identifies the install source.
- `utm_campaign=<your_campaign_name>` — Tags the specific ad campaign name.
- `utm_medium=paid` — Medium type.
- `fbclid=<click_id>` — Automatically appended by Facebook on ad clicks.

---

### B. Testing the Ad Link on Device (Before Spending Budget)

1. In **Meta Ads Manager**, navigate to your ad creative.
2. Click **Preview** → **Send Notification to Facebook App** (or *Preview on Device*).
3. Open Facebook/Instagram on your test mobile device and tap the notification preview.
4. Tapping the ad will launch the Teksage app via deep link.
5. The app automatically captures the campaign name and attributes the install to Facebook.

---

## 5. How to Verify Attribution in Teksage Admin Panel

Immediately after testing an install or login:

1. Log into **Teksage Admin Panel**.
2. Navigate to **Analytics** → click on the **Acquisition** tab.
3. Verify the following sections update:

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│ [ Total Installs ]   [ Total Signups ]   [ Overall Conversion % ]   [ FB Installs ] │
└─────────────────────────────────────────────────────────────────────────────────┘
```

- **Top KPI Cards:**
  - **Facebook Installs** counter increments by `+1`.
  - **Facebook Signups** increments by `+1` once the user logs in.
  - **Facebook Conversion Rate** calculates dynamically `(Signups / Installs * 100)`.

- **Platform Distribution:**
  - Shows breakdown between **🤖 Android** and **🍎 iOS** installs & signups.

- **Campaign Performance Table:**
  - Displays a row for your campaign (e.g. `diwali_ad_2026`) with its specific install count, signup count, and conversion %.

- **Recent Installs Activity Log (Real-time Table):**
  - Displays exact timestamp, source badge (**Facebook**), platform, campaign tag, and linked user info (`✓ User Name` and phone number).

---

## 6. Testing via Command Line (QA Quick Test for Android)

QA engineers can also simulate Facebook ad clicks directly using `adb`:

```powershell
# In PowerShell:
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" shell am start -a android.intent.action.VIEW -d "https://my.teksage.app/?utm_source=facebook&utm_campaign=qa_test_campaign_2026&fbclid=test_fb_click_999" -n com.venzo.astroPrompt/.MainActivity
```

After running this command, check the **Acquisition** tab in the Admin Panel to verify `qa_test_campaign_2026` appears in the Campaign table.

---

## 7. Troubleshooting

| Issue | Root Cause | Solution |
| :--- | :--- | :--- |
| Events not showing in Meta Events Manager | App is in "Development" mode or device offline | Set Meta App to "Live" in Meta Developers Dashboard; verify internet connectivity on test device. |
| Installs showing as "Unknown" in Admin | Ad URL missing `utm_source=facebook` | Ensure ad destination URLs contain `utm_source=facebook` or `fbclid`. |
| Signups not incrementing after login | User did not complete login or network error | Complete OTP verification; check if `/api/analytics/install/attach-user` returned HTTP 200. |
| Deep link opened browser instead of app | App not installed or missing intent-filter | Reinstall the latest app build that includes the `my.teksage.app` deep linking intent-filters. |
