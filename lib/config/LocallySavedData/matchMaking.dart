import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveMakingMaking(
  String boyName,
  String girlName,
  String boyDob,
  String girlDob,
  String boyTob,
  String girlTob,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> names = {
    "boyName": boyName,
    "girlName": girlName,
    "boyDob": boyDob,
    "girlDob": girlDob,
    "boyTob": boyTob,
    "girlTob": girlTob,
  };
  await prefs.setString("MatchMaking", jsonEncode(names));
}

Future<Map<String, String>> getMakingMaking() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString("MatchMaking");
  if (jsonString == null) {
    return {
      "boyName": "",
      "girlName": "",
      "boyDob": "",
      "girlDob": "",
      "boyTob": "",
      "girlTob": "",
    };
  }

  Map<String, dynamic> decoded = jsonDecode(jsonString);
  return {
    "boyName": decoded["boyName"] ?? "",
    "girlName": decoded["girlName"] ?? "",
    "boyDob": decoded["boyDob"] ?? decoded["boyRasi"] ?? "",
    "girlDob": decoded["girlDob"] ?? decoded["girlRasi"] ?? "",
    "boyTob": decoded["boyTob"] ?? decoded["boyNakshatram"] ?? "",
    "girlTob": decoded["girlTob"] ?? decoded["girlNakshatram"] ?? "",
  };
}

Future<void> clearMakingMaking() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("MatchMaking");
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
