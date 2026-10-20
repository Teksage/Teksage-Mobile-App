import 'package:astro_prompt/config/LocallySavedData/timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

bool _tzDataReady = false;

void _ensureTzData() {
  if (_tzDataReady) return;
  tzdata.initializeTimeZones();
  _tzDataReady = true;
}

String? normalizeDisplayTimezone(String? zone) {
  final raw = (zone ?? '').trim();
  if (raw.isEmpty) return null;
  if (raw.toUpperCase() == 'UTC') return null;
  if (raw == 'Asia/Calcutta') return 'Asia/Kolkata';
  return raw;
}

/// Consultation slot wall-clock: strip offset so `10:00+05:30` shows as 10:00.
DateTime parseWallClockIso(String dateTimeString) {
  final cleaned = dateTimeString.replaceAll(RegExp(r'([+-]\d\d:\d\d|Z)$'), '');
  return DateTime.parse(cleaned);
}

/// Same clock rules as website consultation / Expert Hours:
/// 1. Profile IANA timezone from Current Location (`getTimezone`) when usable
/// 2. Else consultation wall-clock (strip offset) — not device `toLocal()`
DateTime displayDateTimeFromIso(String iso, {String? zone}) {
  final iana = normalizeDisplayTimezone(zone);
  if (iana != null) {
    try {
      _ensureTzData();
      final location = tz.getLocation(iana);
      final utc = DateTime.parse(iso).toUtc();
      return tz.TZDateTime.from(utc, location);
    } catch (_) {
      // Fall through to consultation wall-clock.
    }
  }
  return parseWallClockIso(iso);
}

Future<String?> loadViewerTimezone() async {
  return normalizeDisplayTimezone(await getTimezone());
}
