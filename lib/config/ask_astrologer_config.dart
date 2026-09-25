import 'package:flutter/material.dart';

/// Consultation language options — mirrors website `consultation-languages.ts`.
class AskAstrologerLanguages {
  static const List<Map<String, String>> options = [
    {'id': 'tamil', 'label': 'Tamil', 'native': 'தமிழ்'},
    {'id': 'english', 'label': 'English', 'native': 'English'},
    {'id': 'telugu', 'label': 'Telugu', 'native': 'తెలుగు'},
    {'id': 'malayalam', 'label': 'Malayalam', 'native': 'മലയാളം'},
    {'id': 'kannada', 'label': 'Kannada', 'native': 'ಕನ್ನಡ'},
    {'id': 'hindi', 'label': 'Hindi', 'native': 'हिन्दी'},
    {'id': 'bengali', 'label': 'Bengali', 'native': 'বাংলা'},
    {'id': 'marathi', 'label': 'Marathi', 'native': 'मराठी'},
    {'id': 'urdu', 'label': 'Urdu', 'native': 'اردو'},
    {'id': 'gujarati', 'label': 'Gujarati', 'native': 'ગુજરાતી'},
    {'id': 'odia', 'label': 'Odia', 'native': 'ଓଡ଼ିଆ'},
    {'id': 'punjabi', 'label': 'Punjabi', 'native': 'ਪੰਜਾਬੀ'},
    {'id': 'assamese', 'label': 'Assamese', 'native': 'অসমীয়া'},
    {'id': 'bhojpuri', 'label': 'Bhojpuri', 'native': 'भोजपुरी'},
    {'id': 'kashmiri', 'label': 'Kashmiri', 'native': 'کٲشُر'},
    {'id': 'nepali', 'label': 'Nepali', 'native': 'नेपाली'},
    {'id': 'sindhi', 'label': 'Sindhi', 'native': 'سنڌي'},
    {'id': 'sinhala', 'label': 'Sinhala', 'native': 'සිංහල'},
    {'id': 'maithili', 'label': 'Maithili', 'native': 'मैथिली'},
    {'id': 'manipuri', 'label': 'Manipuri', 'native': 'মৈতৈলোন্'},
    {'id': 'santali', 'label': 'Santali', 'native': 'ᱥᱟᱱᱛᱟᱲᱤ'},
  ];

  static String labelFor(String id) {
    return options.firstWhere(
      (o) => o['id'] == id,
      orElse: () => {'id': id, 'label': id},
    )['label']!;
  }

  /// Normalize API values (`தமிழ்` / `Tamil` / `tamil`) to canonical id.
  static String normalizeId(String value) {
    final raw = value.trim();
    if (raw.isEmpty) return '';
    final lower = raw.toLowerCase();
    for (final opt in options) {
      final id = opt['id']!;
      if (id == lower) return id;
      if (opt['native'] == raw) return id;
      if (opt['label']!.toLowerCase() == lower) return id;
    }
    return lower;
  }

  static bool speaksLanguage(List<String> languages, String filterId) {
    final needle = normalizeId(filterId);
    if (needle.isEmpty) return true;
    return languages.any((lang) => normalizeId(lang) == needle);
  }
}

const whatsAppConsentPollMs = 5000;

/// UI copy for Ask Astrologer screens — mirrors website `ASK_ASTROLOGER_SCREEN`.
class AskAstrologerScreenCopy {
  static const publicSiteOrigin = 'https://my.teksage.app';
  static const publicSiteHost = 'my.teksage.app';
  static const answeredByPrefix = 'Answered by:';
  static const answeredBySeparator = ', ';
  static const viewProfileLink = 'View profile';
  static const languageNotes = [
    'Your answer will be delivered within 4 hours.',
    'An expert astrologer will review your question and horoscope, then reply with a personalized voice message.',
    'You can view your answer anytime under Notifications → Single-Query Consultation.',
  ];
}

class AskAstrologerNotificationStatus {
  static String labelFor(String status) {
    switch (status) {
      case 'paid':
        return 'Received';
      case 'assigned':
        return 'Assigned';
      case 'answered':
        return 'Answer ready';
      default:
        return status;
    }
  }

  static ({Color bg, Color fg}) colorsFor(String status) {
    switch (status) {
      case 'paid':
        return (bg: const Color(0xFFEFF6FF), fg: const Color(0xFF1D4ED8));
      case 'assigned':
        return (bg: const Color(0xFFF5F3FF), fg: const Color(0xFF7E22CE));
      case 'answered':
        return (bg: const Color(0xFFF0FDF4), fg: const Color(0xFF15803D));
      default:
        return (bg: const Color(0xFFF5F5F5), fg: const Color(0xFF525252));
    }
  }
}
