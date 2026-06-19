import 'dart:io';
import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Services/AuthService/authService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/appLanguage.dart';
import 'package:astro_prompt/config/LocallySavedData/matchMaking.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class AppLanguagePage extends StatefulWidget {
  const AppLanguagePage({super.key});

  @override
  State<AppLanguagePage> createState() => _AppLanguagePageState();
}

class _AppLanguagePageState extends State<AppLanguagePage> {
  String selectedLanguage = 'en_US'; // Default value

  final List<Map<String, String>> languages = [
    {'code': 'en_US', 'name': 'English', 'nativeName': 'English'},
    {'code': 'ta', 'name': 'Tamil', 'nativeName': 'தமிழ்'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिंदी'},
    {'code': 'te_IN', 'name': 'Telugu', 'nativeName': 'తెలుగు'},
    {'code': 'kn_IN', 'name': 'Kannada', 'nativeName': 'ಕನ್ನಡ'},
    {'code': 'ml_IN', 'name': 'Malayalam', 'nativeName': 'മലയാളം'},
    {'code': 'mr_IN', 'name': 'Marathi', 'nativeName': 'मराठी'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    String lang = await getAppLanguage();
    if (mounted) {
      setState(() {
        // lang is now a language name like "tamil", "hindi", "english"
        // Convert it to code for UI comparison
        selectedLanguage = lang.isEmpty ? 'en_US' : _getCodeFromName(lang);
      });
    }
  }

  // Helper to convert language name to code
  String _getCodeFromName(String languageName) {
    final nameToCode = {
      'english': 'en_US',
      'tamil': 'ta',
      'hindi': 'hi',
      'telugu': 'te_IN',
      'kannada': 'kn_IN',
      'malayalam': 'ml_IN',
      'marathi': 'mr_IN',
    };
    return nameToCode[languageName.toLowerCase()] ?? 'en_US';
  }

  // Map language codes to names (matching backend format)
  final Map<String, String> languageCodeToName = {
    'en_US': 'english',
    'ta': 'tamil',
    'hi': 'hindi',
    'te_IN': 'telugu',
    'kn_IN': 'kannada',
    'ml_IN': 'malayalam',
    'mr_IN': 'marathi',
  };

  Future<void> _changeLanguage(String languageCode) async {
    // Get the language name from code
    String languageName = languageCodeToName[languageCode] ?? 'english';

    // Save current language as previous before changing
    String currentLang = await getAppLanguage();

    // Mark match making as needing regeneration due to language change
    if (currentLang.isNotEmpty &&
        currentLang.toLowerCase() != languageName.toLowerCase()) {
      await setMatchMakingNeedsRegeneration(true);
      if (kDebugMode) {
        print(
            '🔔 Language changed from "$currentLang" to "$languageName" - Match making flag set to TRUE');
      }
    } else {
      if (kDebugMode) {
        print(
            '✅ Same language selected ("$currentLang" == "$languageName") - Match making flag unchanged');
      }
    }

    // Save new language as previous so home page Case 2 doesn't re-trigger
    await savePreviousAppLanguage(languageName);

    // Update UI state immediately
    setState(() {
      selectedLanguage = languageCode;
    });

    // Save new language NAME to SharedPreferences (matching backend format)
    await saveAppLanguage(languageName);
    print('new language: "$languageName"');
    // Update to backend API (will convert name to proper case)
    final authService = AuthService();
    await authService.updateAppLanguage(languageCode);

    // Update app locale
    Locale newLocale;
    switch (languageCode) {
      case 'ta':
        newLocale = Locale('ta');
        break;
      case 'hi':
        newLocale = Locale('hi');
        break;
      case 'te_IN':
        newLocale = Locale('te', 'IN');
        break;
      case 'kn_IN':
        newLocale = Locale('kn', 'IN');
        break;
      case 'ml_IN':
        newLocale = Locale('ml', 'IN');
        break;
      case 'mr_IN':
        newLocale = Locale('mr', 'IN');
        break;
      default:
        newLocale = Locale('en', 'US');
    }

    Get.updateLocale(newLocale);

    // Check if opened from dialog (no route below in stack)
    if (Get.previousRoute.isEmpty || Get.previousRoute == '/') {
      // Opened from language selection dialog, just pop back
      Get.back(result: languageCode);
      return;
    }

    // Reset bottom navigation to home tab
    final controller = Get.find<BottomNavController>();
    controller.changeIndex(0);

    // Redirect to home page immediately
    // The home page will automatically detect language change and reset match making
    Get.offAllNamed(
      '/home',
    );

    // Show confirmation after navigation
    Future.delayed(Duration(milliseconds: 300), () {
      Get.snackbar(
        'Language Updated',
        'App language has been changed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: mainColor.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Platform.isAndroid ? Color(0x80FFFFFF) : Colors.transparent,
        centerTitle: true,
        title: Text(
          'Language',
          style: TextStyle(
            fontFamily: AppFont.get(FontType.bold),
            fontSize: util.fontSize20,
            height: util.lineHeight24 / util.fontSize20,
            color: blackColor,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(backButton),
        ),
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Container(
        height: util.height,
        width: util.width,
        decoration: BoxDecoration(
          gradient: Platform.isIOS
              ? null
              : LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    mainColor.withValues(alpha: 0.1),
                    Color(0x80FFFFFF),
                  ],
                  stops: [0.0, 0.9],
                ),
          image: Platform.isIOS
              ? DecorationImage(
                  image: AssetImage(iosSettingBg),
                  alignment: Alignment.topLeft,
                )
              : null,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select your preferred language',
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.medium),
                    fontSize: util.fontSize14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 20),
                ...languages.map((language) {
                  return _buildLanguageOption(
                    languageCode: language['code']!,
                    languageName: language['name']!,
                    nativeName: language['nativeName']!,
                    util: util,
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String languageCode,
    required String languageName,
    required String nativeName,
    required MyUtility util,
  }) {
    bool isSelected = selectedLanguage == languageCode;

    return Column(
      children: [
        GestureDetector(
          onTap: () => _changeLanguage(languageCode),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: util.width12,
              vertical: util.height10,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? (Platform.isAndroid ? mainColor : iosMainColor)
                      .withOpacity(0.1)
                  : blackColor.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(util.width8),
              border: Border.all(
                color: isSelected
                    ? (Platform.isAndroid ? mainColor : iosMainColor)
                    : Colors.transparent,
                width: isSelected ? 2 : 0,
              ),
            ),
            child: Row(
              children: [
                Radio<String>(
                  value: languageCode,
                  groupValue: selectedLanguage,
                  onChanged: (value) {
                    if (value != null) {
                      _changeLanguage(value);
                    }
                  },
                  activeColor: Platform.isAndroid ? mainColor : iosMainColor,
                  fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Platform.isAndroid ? mainColor : iosMainColor;
                    }
                    return Colors.grey;
                  }),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                SizedBox(width: util.width10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nativeName,
                        style: TextStyle(
                          fontSize: util.fontSize16,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontFamily: isSelected ? 'FontBold' : 'FontMedium',
                          color: isSelected
                              ? (Platform.isAndroid ? mainColor : iosMainColor)
                              : blackColor,
                        ),
                      ),
                      if (languageName != nativeName)
                        Text(
                          languageName,
                          style: TextStyle(
                            fontSize: util.fontSize12,
                            fontFamily: AppFont.get(FontType.regular),
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
