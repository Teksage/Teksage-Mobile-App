import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveTimezone(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("Timezone", name);
}

Future<String> getTimezone() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("Timezone") ?? '';
}

///Clear Timezone
Future<void> clearTimezone() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("Timezone");
}
