import 'dart:convert';
import 'dart:io';
import 'package:astro_prompt/config/Helper/timezoneHelper.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/appLanguage.dart';
import 'package:astro_prompt/config/LocallySavedData/chatLanguage.dart';
import 'package:astro_prompt/config/LocallySavedData/chatPreference.dart';
import 'package:astro_prompt/config/LocallySavedData/matchMaking.dart';
import 'package:astro_prompt/config/LocallySavedData/name.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:astro_prompt/config/LocallySavedData/timezone.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart';
import 'package:astro_prompt/config/LocallySavedData/userType.dart';
import 'package:astro_prompt/config/LocallySavedData/welcomeMessage.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<String> _readOrEnsureTimezone() async {
    final saved = await getTimezone();
    if (saved.isNotEmpty) return saved;
    final tz = await TimezoneManager.instance.ensureTimezoneSynced();
    return tz;
  }

  ///Login with Email/Password
  Future<Map<String, dynamic>> login(String keyValue, String variable,
      {String? countryCode}) async {
    // String tz = await _readOrEnsureTimezone();
    var headers = {
      'Content-Type': 'application/json',
      // 'X-Timezone': tz,
    };
    Map<String, dynamic> body = {keyValue: variable};

    if (keyValue == 'mobile_number') {
      body['country_code'] = countryCode;
    }
    // if (Platform.isIOS) {
    //   body['device'] = 'ios';
    // }

    if (kDebugMode) {
      print('Login body: $body');
    }
    try {
      var response = await http.post(
        Uri.parse(ApiEndpoint.login),
        headers: headers,
        body: json.encode(body),
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        return {'error': responseBody['detail'] ?? 'Unknown error occurred'};
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return {'error': e.toString()};
    }
  }

  ///Login with Email/Password OTP Verification
  Future<Map<String, dynamic>> loginOTP(
    String keyValue,
    String variable,
    String otp, [
    String? countryCode,
  ]) async {
    // String tz = await _readOrEnsureTimezone();

    var headers = {
      'Content-Type': 'application/json',
      // 'X-Timezone': tz,
    };
    Map<String, dynamic> body = {
      keyValue: variable,
      "otp": otp,
    };
    if (keyValue == 'mobile_number' && countryCode != null) {
      body['country_code'] = countryCode;
    }

    try {
      var response = await http.post(Uri.parse(ApiEndpoint.verifyOTP),
          headers: headers, body: json.encode(body));
      if (kDebugMode) {
        print('BodyLogin: $body ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        String accessToken = responseBody["access_token"];
        String refreshToken = responseBody["refresh_token"];
        String? name = responseBody["first_name"];
        String? lastName = responseBody["last_name"];
        String? email = responseBody["email"];
        String? mobile = responseBody["mobile_number"];
        bool? isEmailVerified = responseBody["is_email_verified"];
        bool? isMobileVerified = responseBody["is_mobile_verified"];
        bool profileUpdated = responseBody["profile_updated"] ?? false;
        String userType = responseBody["user_type"];
        int? userId = responseBody["user_id"];
        int? userPlanId = responseBody['user_plan_id'];
        bool premiumUser = responseBody['premium_member'];
        String? fcmToken = responseBody["fcm_token"];
        String? countryCode = responseBody["country_code"];
        String? timeZone = responseBody["timezone"];
        String? format = responseBody["format"];
        String? avatar = responseBody["avatar"];
        String? chat_languages = responseBody["chat_languages"];
        String? app_language = responseBody["app_language"];
        if (kDebugMode) {
          print(
              'responseBody; $responseBody, $format, $avatar, $chat_languages, $app_language');
        }

        await saveAccessToken(accessToken);
        await saveRefreshToken(refreshToken);

        // Save app language if available
        // Backend returns language NAMES (lowercase): "tamil", "hindi", "malayalam", "english", etc.
        // We save the full language NAME to SharedPreferences
        // Only use API response language if user hasn't already selected a language from the dialog
        String existingLang = await getAppLanguage();
        if (existingLang.isEmpty) {
          // No language selected by user from dialog - use API response language
          if (app_language != null && app_language.isNotEmpty) {
            await saveAppLanguage(app_language.toLowerCase());
            // Set flag for first login to ensure match making matches selected language
            await setMatchMakingNeedsRegeneration(true);
            if (kDebugMode) {
              print(
                  '✅ Saved API response language: ${app_language.toLowerCase()} - Flag set to regenerate match making');
            }
          } else {
            if (kDebugMode) {
              print('❌ Not saving app_language (it is empty or null)');
            }
          }
        } else {
          // User already has a language preference (from dialog or previous session)
          // Check if it differs from backend language - if so, set flag to regenerate
          if (app_language != null && app_language.isNotEmpty) {
            String backendLang = app_language.toLowerCase();
            if (existingLang.toLowerCase() != backendLang) {
              // Language mismatch - set flag to force regeneration
              await setMatchMakingNeedsRegeneration(true);
              if (kDebugMode) {
                print(
                    '🔔 Language mismatch - User: "$existingLang", Backend: "$backendLang" - Flag set to regenerate match making');
              }
            }
          }
          if (kDebugMode) {
            print(
                '✅ Keeping user-selected language from dialog: $existingLang (Backend language: $app_language)');
          }
        }

        return {
          "status": "success",
          "name": name,
          "lastName": lastName,
          "email": email,
          "mobile": mobile,
          "isEmailVerified": isEmailVerified,
          "isMobileVerified": isMobileVerified,
          "profile_updated": profileUpdated,
          "user_type": userType,
          "userId": userId,
          "userPlanId": userPlanId,
          "premiumUser": premiumUser,
          "fcmToken": fcmToken,
          "countryCode": countryCode,
          "timeZone": timeZone,
          "format": format,
          "avatar": avatar,
          "chat_languages": chat_languages,
          "app_language": app_language,
        };
      } else {
        var responseBody = json.decode(response.body);
        return responseBody;
      }
    } catch (e) {
      return {"status": "An error occurred. Please try again."};
    }
  }

  Future<void> resetLocaleAfterLogout() async {
    // Try to read language again (will be empty after clear)
    final String savedLang = await getAppLanguage();

    Locale locale;

    if (savedLang.isNotEmpty) {
      switch (savedLang.toLowerCase()) {
        case 'tamil':
          locale = const Locale('ta');
          break;
        case 'hindi':
          locale = const Locale('hi');
          break;
        case 'telugu':
          locale = const Locale('te', 'IN');
          break;
        case 'kannada':
          locale = const Locale('kn', 'IN');
          break;
        case 'malayalam':
          locale = const Locale('ml', 'IN');
          break;
        case 'marathi':
          locale = const Locale('mr', 'IN');
          break;
        default:
          locale = const Locale('en', 'US');
      }
    } else {
      // 🔥 No app language → system locale
      locale = Get.deviceLocale ?? const Locale('en', 'US');
    }

    Get.updateLocale(locale);
  }

  ///Logout
  Future<String?> logout() async {
    final prefs = await SharedPreferences.getInstance();
    String chatKey = 'savedChatMessages';
    String savedAtKey = 'savedAt';
    String expireInKey = 'expireIn';
    String refreshToken = await getRefreshToken();
    String accessToken = await getAccessToken();
    final chatPrefs = await getChatPreference();
    final langPref = await getChatLanguage();
    if (refreshToken.isEmpty) {
      if (kDebugMode) {
        print("No refresh token available.");
      }
      return null;
    }

    final String timezone = await getTimezone();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      // 'X-Timezone': timezone,
    };

    var body = json.encode({
      "refresh_token": refreshToken,
      "format": chatPrefs["style"],
      "avatar": chatPrefs["avatar"],
      "chat_languages": chatPrefs["lang"]
    });
    print('logout payload:$body');
    print('logout payload:${chatPrefs["avatar"]}');
    print('logout payload:${chatPrefs["style"]}');

    try {
      var response = await http.post(Uri.parse(ApiEndpoint.logout),
          headers: headers, body: body);
      print('LogoutResponse: ${response.statusCode} ${response.body}');

      // Save app language before clearing prefs so it persists across logout
      final String savedAppLang = await getAppLanguage();

      await clearPrefs();
      await clearUserNamePrefs();
      await clearUserTypePrefs();
      await clearUserIdPrefs();
      await clearUserPremiumPrefs();
      await clearChatPreference();
      await prefs.remove(chatKey);
      await prefs.remove(savedAtKey);
      await prefs.remove(expireInKey);
      await clearTimezone();
      await clearChatLanguage();
      await clearAppLanguage();

      // Restore app language after clearing prefs
      if (savedAppLang.isNotEmpty) {
        await saveAppLanguage(savedAppLang);
      }

      // Reset locale after logout
      resetLocaleAfterLogout();
      await clearWelcomeMessageStatus();
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonData["message"];
      } else if (response.statusCode == 401) {
        return jsonData["detail"];
      } else {
        return null;
      }
    } catch (e) {
      // Save app language before clearing prefs so it persists across logout
      final String savedAppLang = await getAppLanguage();

      await clearPrefs();
      await clearUserNamePrefs();
      await clearUserTypePrefs();
      await clearUserIdPrefs();
      await clearUserPremiumPrefs();
      await clearChatPreference();
      await prefs.remove('savedChatMessages');
      await prefs.remove('savedAt');
      await prefs.remove('expireIn');
      await clearTimezone();
      await clearChatLanguage();
      await clearAppLanguage();

      // Restore app language after clearing prefs
      if (savedAppLang.isNotEmpty) {
        await saveAppLanguage(savedAppLang);
      }

      // Reset locale after logout
      resetLocaleAfterLogout();
      await clearWelcomeMessageStatus();
      return null;
    }
  }

  Map<String, String> languageCodeToName = {
    'en_US': 'English',
    'ta': 'Tamil',
    'hi': 'Hindi',
    'te_IN': 'Telugu',
    'kn_IN': 'Kannada',
    'ml_IN': 'Malayalam',
    'mr_IN': 'Marathi',
  };

  /// Update Chat Format, Avatar, and Chat Language to Backend
  Future<bool> updateChatFormat({
    required String format,
    required String avatar,
    required String chatLanguage,
  }) async {
    try {
      String accessToken = await getAccessToken();
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      var body = json.encode({
        'format': format,
        'avatar': avatar,
        'chat_languages': chatLanguage,
      });
      var response = await http.put(
        Uri.parse(ApiEndpoint.chatFormat),
        headers: headers,
        body: body,
      );
      if (kDebugMode) {
        print('updateChatFormat: ${response.statusCode} ${response.body}');
      }
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating chat format: $e');
      }
      return false;
    }
  }

  /// Update App Language to Backend
  Future<bool> updateAppLanguage(String languageCode) async {
    try {
      String accessToken = await getAccessToken();

      final languageName = languageCodeToName[languageCode] ?? 'English';
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      var body = json.encode({
        'app_language': languageName, // ✅ send name
      });
      var response = await http.post(
        Uri.parse(ApiEndpoint.getAppLanguage),
        headers: headers,
        body: body,
      );
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating app language: $e');
      }
      return false;
    }
  }
}
