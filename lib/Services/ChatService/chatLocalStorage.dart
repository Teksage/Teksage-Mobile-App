import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatStorageService {
  static const _messagesKey = 'savedChatMessages';
  static const _savedAtKey = 'savedAt';
  static const _expireInKey = 'expireIn'; // '1h' or '1d'

  static Future<void> saveMessages(List<Map<String, dynamic>> messages, String expireIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_messagesKey, jsonEncode(messages));
    await prefs.setString(_savedAtKey, DateTime.now().toIso8601String());
    await prefs.setString(_expireInKey, expireIn);
  }

  static Future<List<Map<String, dynamic>>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesStr = prefs.getString(_messagesKey);
    if (messagesStr != null) {
      final List<dynamic> decoded = jsonDecode(messagesStr);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  static Future<bool> isChatValid() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAtStr = prefs.getString(_savedAtKey);
    final expireIn = prefs.getString(_expireInKey);

    if (savedAtStr == null || expireIn == null) return false;

    final savedAt = DateTime.parse(savedAtStr);
    final now = DateTime.now();
    final expiry = expireIn == '1d' ? Duration(days: 1) : Duration(hours: 1);

    return now.difference(savedAt) < expiry;
  }

  static Future<void> clearChat() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_messagesKey);
    await prefs.remove(_savedAtKey);
    await prefs.remove(_expireInKey);
  }
}
