import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveWelcomeMessageStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("seenWelcomeMessage", true);
}

Future<bool> getWelcomeMessageStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('seenWelcomeMessage') ?? false;
}

Future<void> clearWelcomeMessageStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("seenWelcomeMessage");
}
