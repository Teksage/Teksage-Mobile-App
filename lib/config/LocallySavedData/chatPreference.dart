import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveChatPreference(String style, String avatar, String lang) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("chat_style", style);
  await prefs.setString("chat_avatar", avatar);
  await prefs.setString("chat_lang", lang);
}

Future<Map<String, String>> getChatPreference() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    "style": prefs.getString("chat_style") ?? '',
    "avatar": prefs.getString("chat_avatar") ?? '',
    "lang": prefs.getString("chat_lang") ?? '',
  };
}

Future<bool> clearChatPreference() async {
  final prefs = await SharedPreferences.getInstance();
  final styleRemoved = await prefs.remove("chat_style");
  final avatarRemoved = await prefs.remove("chat_avatar");
  final langRemoved = await prefs.remove("chat_lang");
  return styleRemoved && avatarRemoved && langRemoved;
}
