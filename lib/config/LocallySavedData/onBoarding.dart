import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveOnboardingStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("seenOnboarding", true);
}

Future<bool> getOnboardingStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('seenOnboarding') ?? false;
}

