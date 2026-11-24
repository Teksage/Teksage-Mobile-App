import 'package:shared_preferences/shared_preferences.dart';

const _dismissedOnKey = 'yearly_2027_promo_dismissed_on';
const _legacyHiddenOnKey = 'yearly_2027_promo_hidden_on';

String yearly2027LocalTodayIso() {
  final d = DateTime.now();
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$m-$day';
}

Future<String?> getYearly2027PromoDismissedOn() async {
  final prefs = await SharedPreferences.getInstance();
  final current = prefs.getString(_dismissedOnKey);
  if (current != null) return current;
  final legacy = prefs.getString(_legacyHiddenOnKey);
  if (legacy != null) {
    await prefs.setString(_dismissedOnKey, legacy);
    await prefs.remove(_legacyHiddenOnKey);
  }
  return legacy;
}

Future<void> setYearly2027PromoDismissedOn(String isoDate) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_dismissedOnKey, isoDate);
  await prefs.remove(_legacyHiddenOnKey);
}

Future<void> clearYearly2027PromoDismissedLocal() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_dismissedOnKey);
  await prefs.remove(_legacyHiddenOnKey);
}

Future<bool> isYearly2027PromoHiddenLocallyToday() async {
  final saved = await getYearly2027PromoDismissedOn();
  return saved == yearly2027LocalTodayIso();
}

Future<void> markYearly2027PromoHiddenLocallyToday() async {
  await setYearly2027PromoDismissedOn(yearly2027LocalTodayIso());
}
