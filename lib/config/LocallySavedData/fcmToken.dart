import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveFCMToken(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("FCMToken", name);
}

Future<String> getFCMToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("FCMToken") ?? '';
}

///Clear FCMToken
Future<void> clearFCMTokenPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("FCMToken");
}
