import 'package:shared_preferences/shared_preferences.dart';

///Access Token
Future<void> saveAccessToken(String accessToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("access_token", accessToken);
}

Future<String> getAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("access_token") ?? '';
}

///Refresh Token
Future<void> saveRefreshToken(String refreshToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("refresh_token", refreshToken);
}

Future<String> getRefreshToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("refresh_token") ?? '';
}

///Clear Token
Future<void> clearPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  await prefs.remove("access_token");
}
