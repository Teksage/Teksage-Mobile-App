import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/config/LocallySavedData/appLanguage.dart';
import 'package:astro_prompt/config/languageSelectionDialog.dart';
import 'package:flutter/material.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


/// A widget that displays current language and allows changing it
class LanguageSelectorButton extends StatefulWidget {
  final bool showLabel;
  final double? fontSize;

  const LanguageSelectorButton({
    super.key,
    this.showLabel = true,
    this.fontSize,
  });

  @override
  State<LanguageSelectorButton> createState() => _LanguageSelectorButtonState();
}

class _LanguageSelectorButtonState extends State<LanguageSelectorButton> {
  String currentLanguage = 'en_US';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    String lang = await getAppLanguage();
    setState(() {
      currentLanguage = lang.isEmpty ? 'en_US' : lang;
    });
  }

  String get languageDisplayName {
    switch (currentLanguage) {
      case 'ta':
        return 'தமிழ்';
      case 'hi':
        return 'हिंदी';
      case 'te_IN':
        return 'తెలుగు';
      case 'kn_IN':
        return 'ಕನ್ನಡ';
      case 'ml_IN':
        return 'മലയാളം';
      case 'mr_IN':
        return 'मराठी';
      case 'en_US':
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showLanguageSelectionDialog();
        // Reload current language after dialog closes
        Future.delayed(Duration(milliseconds: 500), () {
          _loadLanguage();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: mainColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showLabel) ...[
              Text(
                languageDisplayName,
                style: TextStyle(
                  fontSize: widget.fontSize ?? 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFont.get(FontType.semiBold),
                  color: mainColor,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                color: mainColor,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
