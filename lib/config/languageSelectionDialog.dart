import 'package:astro_prompt/Services/AuthService/authService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/config/LocallySavedData/appLanguage.dart';
import 'package:astro_prompt/config/LocallySavedData/matchMaking.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class LanguageSelectionDialog extends StatefulWidget {
  final bool isInitialSelection;

  const LanguageSelectionDialog({
    super.key,
    this.isInitialSelection = false,
  });

  @override
  State<LanguageSelectionDialog> createState() =>
      _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<LanguageSelectionDialog> {
  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    String lang = await getAppLanguage();
    setState(() {
      // lang is now a language name like "tamil", "hindi", "english"
      selectedLanguage = lang.isEmpty ? null : lang;
    });
  }

  // Map language names to codes for locale updates
  final Map<String, String> languageNameToCode = {
    'english': 'en_US',
    'tamil': 'ta',
    'hindi': 'hi',
    'telugu': 'te_IN',
    'kannada': 'kn_IN',
    'malayalam': 'ml_IN',
    'marathi': 'mr_IN',
  };

  // Map language codes to names for backend API
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

    if (kDebugMode) {
      print(
          'LanguageDialog - User selected: $languageName (code: $languageCode)');
    }

    // Save current language as previous before changing
    String currentLang = await getAppLanguage();

    // Mark match making as needing regeneration
    // Case 1: currentLang is empty (fresh login/first selection) - always set flag to regenerate
    // Case 2: currentLang exists and differs from new language - set flag to regenerate
    if (currentLang.isEmpty) {
      // Fresh login - force regeneration to ensure match making matches selected language
      await setMatchMakingNeedsRegeneration(true);
      if (kDebugMode) {
        print(
            '🆕 First language selection: "$languageName" - Match making flag set to TRUE');
      }
    } else if (currentLang.toLowerCase() != languageName.toLowerCase()) {
      // Language changed - force regeneration
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

    // Save new language as previous so home page doesn't re-trigger
    await savePreviousAppLanguage(languageName);

    // Save new language NAME to SharedPreferences (matching backend format)
    await saveAppLanguage(languageName);
    // print('Saved new language to SharedPreferences: "$languageName"');

    // Update to backend API (will convert name to proper case)
    final authService = AuthService();
    bool success = await authService.updateAppLanguage(languageCode);

    if (kDebugMode) {
      print('Backend API update success: $success');
    }

    // Verify what was saved
    String savedLang = await getAppLanguage();
    // print('Verification - SharedPreferences contains: "$savedLang"');

    // Update locale based on language NAME (not code)
    Locale newLocale;
    switch (languageName.toLowerCase()) {
      case 'tamil':
        newLocale = Locale('ta');
        break;
      case 'hindi':
        newLocale = Locale('hi');
        break;
      case 'telugu':
        newLocale = Locale('te', 'IN');
        break;
      case 'kannada':
        newLocale = Locale('kn', 'IN');
        break;
      case 'malayalam':
        newLocale = Locale('ml', 'IN');
        break;
      case 'marathi':
        newLocale = Locale('mr', 'IN');
        break;
      default:
        newLocale = Locale('en', 'US');
    }

    Get.updateLocale(newLocale);
    setState(() {
      selectedLanguage = languageName; // Store language name, not code
    });

    // Close dialog after selection
    Get.back();

    // Show confirmation only if not initial selection
    if (!widget.isInitialSelection) {
      Get.snackbar(
        'Language Updated',
        'App language has been changed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: mainColor.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget
          .isInitialSelection, // Prevent back button if initial selection
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isInitialSelection
                    ? 'Select Your Preferred Language'
                    : 'Select Language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFont.get(FontType.bold),
                ),
              ),
              if (widget.isInitialSelection) ...[
                SizedBox(height: 8),
                Text(
                  'Choose your language to get started',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: AppFont.get(FontType.regular),
                  ),
                ),
              ],
              SizedBox(height: 20),
              _buildLanguageOption(
                languageCode: 'en_US',
                languageName: 'English',
              ),
              SizedBox(height: 12),
              _buildLanguageOption(
                languageCode: 'ta',
                languageName: 'தமிழ் (Tamil)',
              ),
              SizedBox(height: 12),
              _buildLanguageOption(
                languageCode: 'hi',
                languageName: 'हिंदी (Hindi)',
              ),
              SizedBox(height: 12),
              _buildLanguageOption(
                languageCode: 'te_IN',
                languageName: 'తెలుగు (Telugu)',
              ),
              SizedBox(height: 12),
              _buildLanguageOption(
                languageCode: 'kn_IN',
                languageName: 'ಕನ್ನಡ (Kannada)',
              ),
              SizedBox(height: 12),
              _buildLanguageOption(
                languageCode: 'ml_IN',
                languageName: 'മലയാളം (Malayalam)',
              ),
              SizedBox(height: 12),
              _buildLanguageOption(
                languageCode: 'mr_IN',
                languageName: 'मराठी (Marathi)',
              ),
              SizedBox(height: 20),
              // if (!widget.isInitialSelection)
              //   Align(
              //     alignment: Alignment.centerRight,
              //     child: TextButton(
              //       onPressed: () => Get.back(),
              //       child: Text(
              //         'Cancel',
              //         style: TextStyle(
              //           color: Colors.grey[600],
              //           fontFamily: AppFont.get(FontType.semiBold),
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String languageCode,
    required String languageName,
  }) {
    // Compare with language name from SharedPreferences
    String languageNameInPrefs = languageCodeToName[languageCode] ?? 'english';
    bool isSelected = selectedLanguage == languageNameInPrefs;

    return GestureDetector(
      onTap: () => _changeLanguage(languageCode),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? mainColor.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? mainColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                languageName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontFamily: isSelected ? 'FontBold' : 'FontRegular',
                  color: isSelected ? mainColor : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: mainColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show the language selection dialog
void showLanguageSelectionDialog({bool isInitialSelection = false}) {
  Get.dialog(
    LanguageSelectionDialog(isInitialSelection: isInitialSelection),
    barrierDismissible:
        !isInitialSelection, // Can't dismiss if initial selection
    barrierColor: Colors.black.withOpacity(0.5),
  );
}
