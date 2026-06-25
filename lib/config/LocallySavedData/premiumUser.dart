import 'package:shared_preferences/shared_preferences.dart';

Future<void> savePremiumUser(bool premiumUser) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isPremium", premiumUser);
}

Future<bool> getUserPremium() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isPremium') ?? false;
}

Future<void> clearUserPremiumPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("isPremium");
}

Future<void> savePremiumUserId(int planId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("planId", planId);
}

Future<int> getUserPremiumId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('planId') ?? 0;
}

Future<void> clearUserPremiumPrefsId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("planId");
}
