import 'package:get/get.dart';

enum FontType {
  regular,
  medium,
  semiBold,
  bold,
  extraBold,
}

class AppFont {
  static String get(FontType type) {
    final lang = Get.locale?.languageCode ?? 'en';

    switch (lang) {
      // ---------------- TAMIL ----------------
      case 'ta':
        return _tamil(type);

      // ---------------- TELUGU ----------------
      case 'te':
        return _telugu(type);

      // ---------------- MALAYALAM ----------------
      case 'ml':
        return _malayalam(type);

      // ---------------- KANNADA ----------------
      case 'kn':
        return _kannada(type);

      // ---------------- ENGLISH ----------------
      default:
        return _english(type);
    }
  }

  static String _english(FontType t) {
    switch (t) {
      case FontType.regular:
        return 'FontRegular';
      case FontType.medium:
        return 'FontMedium';
      case FontType.semiBold:
        return 'FontSemiBold';
      case FontType.bold:
        return 'FontBold';
      case FontType.extraBold:
        return 'FontExtraBold';
    }
  }

  static String _tamil(FontType t) {
    switch (t) {
      case FontType.regular:
        return 'TamilRegular';
      case FontType.medium:
        return 'TamilMedium';
      case FontType.semiBold:
        return 'TamilSemiBold';
      case FontType.bold:
        return 'TamilBold';
      case FontType.extraBold:
        return 'TamilExtraBold';
    }
  }

  static String _telugu(FontType t) {
    switch (t) {
      case FontType.regular:
        return 'TeluguRegular';
      case FontType.medium:
        return 'TeluguMedium';
      case FontType.semiBold:
        return 'TeluguSemiBold';
      case FontType.bold:
        return 'TeluguBold';
      case FontType.extraBold:
        return 'TeluguExtraBold';
    }
  }

  static String _malayalam(FontType t) {
    switch (t) {
      case FontType.regular:
        return 'MalayalamRegular';
      case FontType.medium:
        return 'MalayalamMedium';
      case FontType.semiBold:
        return 'MalayalamSemiBold';
      case FontType.bold:
        return 'MalayalamBold';
      case FontType.extraBold:
        return 'MalayalamExtraBold';
    }
  }

  static String _kannada(FontType t) {
    switch (t) {
      case FontType.regular:
        return 'KannadaRegular';
      case FontType.medium:
        return 'KannadaMedium';
      case FontType.semiBold:
        return 'KannadaSemiBold';
      case FontType.bold:
        return 'KannadaBold';
      case FontType.extraBold:
        return 'KannadaExtraBold';
    }
  }
}
