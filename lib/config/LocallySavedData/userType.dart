import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserType(bool userType) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("UserType", userType);
}

Future<bool> getUserType() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Missing role matches the website: a normal account is a customer, not an astrologer.
  return prefs.getBool('UserType') ?? true;
}

///Clear UserType
Future<void> clearUserTypePrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  await prefs.remove("UserType");
}
