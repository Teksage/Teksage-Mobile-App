import 'package:shared_preferences/shared_preferences.dart';

/// Save the selected app language
Future<void> saveAppLanguage(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("appLanguage", languageCode);
}

/// Get the saved app language
/// Returns empty string if not set
Future<String> getAppLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("appLanguage") ?? '';
}

/// Save the previous app language before changing
Future<void> savePreviousAppLanguage(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("previousAppLanguage", languageCode);
}

/// Get the previous app language
/// Returns empty string if not set
Future<String> getPreviousAppLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("previousAppLanguage") ?? '';
}

/// Clear the saved language
Future<void> clearAppLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("appLanguage");
  await prefs.remove("previousAppLanguage");
}
