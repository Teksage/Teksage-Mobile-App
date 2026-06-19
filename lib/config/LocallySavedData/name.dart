import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserName(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("userName", name);
}

Future<void> saveLastName(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("lastName", name);
}

Future<String> getUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("userName") ?? '';
}

Future<String> getLastName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("lastName") ?? '';
}

///Clear Name
Future<void> clearUserNamePrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  await prefs.remove("userName");
  await prefs.remove("lastName");
}

