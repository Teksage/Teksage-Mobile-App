import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserId(int userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("UserId", userId);
}

Future<int?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('UserId');
}

///Clear UserId
Future<void> clearUserIdPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("UserId");
}
