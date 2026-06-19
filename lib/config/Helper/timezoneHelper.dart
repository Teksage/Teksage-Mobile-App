import 'dart:async';
import 'package:astro_prompt/Services/TimeZoneService/timeZoneService.dart';
import 'package:astro_prompt/config/LocallySavedData/timezone.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class TimezoneManager {
  TimezoneManager._();
  static final TimezoneManager instance = TimezoneManager._();
  static const _neutralFallback = 'UTC';

  String? _lastSynced;
  DateTime? _lastSyncAt;

  /// Normalize aliases → canonical IANA zone
  String _normalize(String tz) {
    switch (tz) {
      case 'Asia/Calcutta':
        return 'Asia/Kolkata';
      default:
        return tz;
    }
  }

  Future<String> ensureTimezoneSynced({bool force = false}) async {
    final stored = await getTimezone();

    final fetched = await _fetchOsTimezoneWithRetry();
    final resolved = fetched ?? (stored.isNotEmpty ? stored : _neutralFallback);
    final normalized = _normalize(resolved);

    if (!force && stored == normalized) {
      if (kDebugMode) print('[TZ] unchanged: $normalized');
      return normalized;
    }

    final canHitServer = () {
      if (_lastSynced != normalized) return true;
      if (_lastSyncAt == null) return true;
      return DateTime.now().difference(_lastSyncAt!).inSeconds > 10;
    }();

    await saveTimezone(normalized);

    if (canHitServer) {
      try {
        final resp = await TimeZoneService().updateTimezone(normalized);
        _lastSynced = normalized;
        _lastSyncAt = DateTime.now();
        if (kDebugMode) print('[TZ] synced to server: $normalized | resp: $resp');
      } catch (e) {
        if (kDebugMode) print('[TZ] server sync failed: $e');
      }
    } else {
      if (kDebugMode) print('[TZ] skip server call (debounced): $normalized');
    }

    return normalized;
  }

  Future<String?> _fetchOsTimezoneWithRetry() async {
    const maxRetries = 3;
    const delay = Duration(milliseconds: 200);

    for (var i = 1; i <= maxRetries; i++) {
      try {
        final tz = await FlutterTimezone.getLocalTimezone();
        if (tz != null && tz.toString().isNotEmpty) return tz.toString();
      } catch (e) {
        if (kDebugMode) print('[TZ] attempt $i failed: $e');
      }
      await Future.delayed(delay);
    }
    return null;
  }
}
