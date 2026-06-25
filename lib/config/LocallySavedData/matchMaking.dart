import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveMakingMaking(String boyName, String girlName, String boyRasi,
    String girlRasi, String boyNakshatram, String girlNakshatram) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> names = {
    "boyName": boyName,
    "girlName": girlName,
    "boyRasi": boyRasi,
    "girlRasi": girlRasi,
    "boyNakshatram": boyNakshatram,
    "girlNakshatram": girlNakshatram,
  };
  await prefs.setString("MatchMaking", jsonEncode(names));
}

Future<Map<String, String>> getMakingMaking() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString("MatchMaking");
  if (jsonString == null)
    return {
      "boyName": "",
      "girlName": "",
      "boyRasi": "",
      "girlRasi": "",
      "boyNakshatram": "",
      "girlNakshatram": ""
    };

  Map<String, dynamic> decoded = jsonDecode(jsonString);
  return {
    "boyName": decoded["boyName"] ?? "",
    "girlName": decoded["girlName"] ?? "",
    "boyRasi": decoded["boyRasi"] ?? "",
    "girlRasi": decoded["girlRasi"] ?? "",
    "boyNakshatram": decoded["boyNakshatram"] ?? "",
    "girlNakshatram": decoded["girlNakshatram"] ?? "",
  };
}

Future<void> clearMakingMaking() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("MakingMaking");
}

/// Flag to indicate match making needs regeneration (e.g., after language change)
Future<void> setMatchMakingNeedsRegeneration(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("matchMakingNeedsRegeneration", value);
}

Future<bool> getMatchMakingNeedsRegeneration() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("matchMakingNeedsRegeneration") ?? false;
}
