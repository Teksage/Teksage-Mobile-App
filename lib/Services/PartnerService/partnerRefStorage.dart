import 'package:shared_preferences/shared_preferences.dart';

const _kPartnerRefKey = 'teksage_partner_ref_code';

class PartnerRefStorage {
  static Future<void> save(String code) async {
    final trimmed = code.trim().toUpperCase();
    if (trimmed.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPartnerRefKey, trimmed);
  }

  static Future<String?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_kPartnerRefKey)?.trim().toUpperCase();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPartnerRefKey);
  }

  /// Capture `?ref=` from a deep-link / web URL.
  static Future<String?> captureFromUri(Uri? uri) async {
    if (uri == null) return null;
    final ref = uri.queryParameters['ref']?.trim();
    if (ref != null && ref.isNotEmpty) {
      await save(ref);
      return ref.toUpperCase();
    }
    final redirect = uri.queryParameters['redirect'];
    if (redirect != null && redirect.isNotEmpty) {
      try {
        final nested = Uri.parse(
          redirect.startsWith('http')
              ? redirect
              : 'https://local.invalid$redirect',
        );
        final nestedRef = nested.queryParameters['ref']?.trim();
        if (nestedRef != null && nestedRef.isNotEmpty) {
          await save(nestedRef);
          return nestedRef.toUpperCase();
        }
      } catch (_) {}
    }
    return null;
  }
}
