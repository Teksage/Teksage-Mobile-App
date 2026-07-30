import 'dart:convert';

import 'package:astro_prompt/Model/muhurtha_model.dart';
import 'package:astro_prompt/config/LocallySavedData/appLanguage.dart';
import 'package:astro_prompt/config/event_planner_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

String eventPlannerCacheKey({
  required String userId,
  required String event,
  required String startDate,
  required String location,
  required String language,
}) {
  final parts = [
    userId.trim().isEmpty ? 'guest' : userId.trim(),
    event.trim(),
    startDate.trim(),
    location.trim().toLowerCase(),
    language.trim().toLowerCase(),
  ];
  return '${EventPlannerConfig.storagePrefix}:${parts.join('|')}';
}

Future<String> currentEventPlannerLanguage() async {
  final lang = await getAppLanguage();
  if (lang.isEmpty) return 'english';
  return lang.toLowerCase();
}

MuhurthaPayload? readEventPlannerCache(String cacheKey) {
  return null;
}

Future<MuhurthaPayload?> readEventPlannerCacheAsync(String cacheKey) async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(cacheKey);
  if (raw == null || raw.isEmpty) return null;
  try {
    final entry = json.decode(raw) as Map<String, dynamic>;
    final expiresAt = entry['expiresAt'] as String?;
    if (expiresAt != null) {
      final expiresMs = DateTime.tryParse(expiresAt)?.millisecondsSinceEpoch;
      if (expiresMs != null && expiresMs <= DateTime.now().millisecondsSinceEpoch) {
        await prefs.remove(cacheKey);
        return null;
      }
    }
    final resultJson = entry['result'] as Map<String, dynamic>?;
    if (resultJson == null) return null;
    final muhurthaId = entry['muhurthaId'] as int? ?? 0;
    return MuhurthaPayload(
      muhurthaId: muhurthaId,
      result: MuhurthaResult.fromJson(resultJson),
    );
  } catch (_) {
    await prefs.remove(cacheKey);
    return null;
  }
}

Future<void> writeEventPlannerCache(
  String cacheKey,
  MuhurthaPayload payload,
) async {
  final prefs = await SharedPreferences.getInstance();
  final expires = DateTime.now().add(
    Duration(days: EventPlannerConfig.ttlDays),
  );
  final entry = {
    'muhurthaId': payload.muhurthaId,
    'result': payload.result.toJson(),
    'cachedAt': DateTime.now().toIso8601String(),
    'expiresAt': expires.toIso8601String(),
  };
  await prefs.setString(cacheKey, json.encode(entry));
}

Future<void> clearAllEventPlannerCache() async {
  final prefs = await SharedPreferences.getInstance();
  final prefix = '${EventPlannerConfig.storagePrefix}:';
  final keys = prefs.getKeys().where((k) => k.startsWith(prefix)).toList();
  for (final key in keys) {
    await prefs.remove(key);
  }
}
