import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveChatLanguage(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("ChatLanguage", name);
}

Future<String> getChatLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("ChatLanguage") ?? '';
}

///Clear Chat Language
Future<void> clearChatLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("ChatLanguage");
}
