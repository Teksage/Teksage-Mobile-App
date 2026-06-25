import 'package:flutter/material.dart';

/// Consultation language options — mirrors website `consultation-languages.ts`.
class AskAstrologerLanguages {  static const List<Map<String, String>> options = [
    {'id': 'tamil', 'label': 'Tamil'},
    {'id': 'english', 'label': 'English'},
    {'id': 'telugu', 'label': 'Telugu'},
    {'id': 'malayalam', 'label': 'Malayalam'},
    {'id': 'kannada', 'label': 'Kannada'},
    {'id': 'hindi', 'label': 'Hindi'},
    {'id': 'bengali', 'label': 'Bengali'},
    {'id': 'marathi', 'label': 'Marathi'},
    {'id': 'urdu', 'label': 'Urdu'},
    {'id': 'gujarati', 'label': 'Gujarati'},
    {'id': 'odia', 'label': 'Odia'},
    {'id': 'punjabi', 'label': 'Punjabi'},
    {'id': 'assamese', 'label': 'Assamese'},
    {'id': 'bhojpuri', 'label': 'Bhojpuri'},
    {'id': 'kashmiri', 'label': 'Kashmiri'},
    {'id': 'nepali', 'label': 'Nepali'},
    {'id': 'sindhi', 'label': 'Sindhi'},
    {'id': 'sinhala', 'label': 'Sinhala'},
    {'id': 'maithili', 'label': 'Maithili'},
    {'id': 'manipuri', 'label': 'Manipuri'},
    {'id': 'santali', 'label': 'Santali'},
  ];

  static String labelFor(String id) {
    return options.firstWhere(
      (o) => o['id'] == id,
      orElse: () => {'id': id, 'label': id},
    )['label']!;
  }
}

const whatsAppConsentPollMs = 5000;

/// UI copy for Ask Astrologer screens — mirrors website `ASK_ASTROLOGER_SCREEN`.
class AskAstrologerScreenCopy {
  static const publicSiteOrigin = 'https://www.teksage.app';
  static const publicSiteHost = 'www.teksage.app';
  static const answeredByPrefix = 'Answered by:';
  static const answeredBySeparator = ', ';
  static const viewProfileLink = 'View profile';
  static const languageNotes = [
    'Your answer will be delivered within 4 hours.',
    'An expert astrologer will review your question and horoscope, then reply with a personalized voice message.',
    'You can view your answer anytime under Notifications → Consultation.',
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
