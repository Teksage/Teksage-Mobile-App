import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/config/LocallySavedData/timezone.dart';

/// INR vs USD from profile — mirrors web `consultationCurrencyForLocation`.
/// Preferred location wins, then phone country code, then stored timezone.
class ProfileCurrency {
  static const _foreignLocationHints = [
    'united states',
    'usa',
    'u.s.a',
    'united kingdom',
    'uk',
    'canada',
    'australia',
    'singapore',
    'uae',
    'dubai',
    'europe',
    'ontario',
    'quebec',
    'british columbia',
  ];

  static const _foreignCountryCodes = ['1'];
  static const _indiaTimezones = ['Asia/Kolkata', 'Asia/Calcutta'];
  static const _indiaDial = '91';

  static String fromProfile(
    UserProfile? profile, {
    String? timezone,
  }) {
    final loc = (profile?.preferredLocation ?? '').trim();
    if (loc.isNotEmpty) {
      if (_isIndiaLocation(loc)) return 'INR';
      if (_isForeignLocation(loc)) return 'USD';
    }

    final code = (profile?.countryCode ?? '').replaceAll(RegExp(r'\D'), '');
    if (code == _indiaDial) return 'INR';
    if (code.isNotEmpty && _foreignCountryCodes.contains(code)) return 'USD';

    final tz = (timezone ?? '').trim();
    if (tz.isNotEmpty) {
      if (_indiaTimezones.contains(tz)) return 'INR';
      return 'USD';
    }

    if (code.isNotEmpty && code != _indiaDial) return 'USD';
    return 'INR';
  }

  /// Loads profile (+ saved timezone) and resolves INR/USD.
  static Future<String> resolve() async {
    final profile = await ProfileService().fetchUserProfile();
    final timezone = await getTimezone();
    return fromProfile(profile, timezone: timezone);
  }

  static bool _isIndiaLocation(String location) {
    final loc = location.toLowerCase();
    if (loc == 'india' || loc == 'in') return true;
    return loc.contains('india');
  }

  static bool _isForeignLocation(String location) {
    final loc = location.toLowerCase();
    if (_foreignLocationHints.any(loc.contains)) return true;
    final parts = loc.split(',').map((p) => p.trim()).where((p) => p.isNotEmpty);
    if (parts.length < 2) return false;
    final countryPart = parts.last;
    if (countryPart == 'ca' || countryPart == 'us' || countryPart == 'usa') {
      return true;
    }
    return _foreignLocationHints.any(countryPart.contains);
  }
}
