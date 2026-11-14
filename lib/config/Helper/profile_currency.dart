import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/config/LocallySavedData/timezone.dart';

/// Same order as the website `consultationCurrencyForLocation`.
/// India text, +91, or an India timezone is INR. A named foreign place is USD.
/// Any other saved place stays INR.
class ProfileCurrency {
  static const _indiaTimezones = ['Asia/Kolkata', 'Asia/Calcutta', 'IST'];
  static const _indiaDial = '91';
  static const _foreignHints = [
    'usa',
    'united states',
    'uk',
    'united kingdom',
    'canada',
    'australia',
    'uae',
    'dubai',
    'abu dhabi',
    'singapore',
    'malaysia',
    'germany',
    'france',
    'europe',
    'qatar',
    'saudi',
    'kuwait',
    'oman',
    'bahrain',
    'new zealand',
    'japan',
    'london',
    'new york',
    'california',
    'texas',
    'toronto',
    'sydney',
    'melbourne',
  ];

  static String fromProfile(
    UserProfile? profile, {
    String? timezone,
  }) {
    final loc = (profile?.preferredLocation ?? '').trim().toLowerCase();
    if (loc.isNotEmpty) {
      if (_containsAny(loc, _foreignHints)) return 'USD';
      if (_isIndiaLocation(loc)) return 'INR';
    }

    final code = (profile?.countryCode ?? '').replaceAll(RegExp(r'\D'), '');
    if (code == _indiaDial) return 'INR';
    if (code.isNotEmpty) return 'USD';

    final tz = (timezone ?? '').trim();
    if (_indiaTimezones.contains(tz)) return 'INR';
    if (loc.isNotEmpty) return 'INR';
    if (tz.isNotEmpty && tz.toUpperCase() != 'UTC') return 'USD';
    return 'INR';
  }

  static Future<String> resolve() async {
    final profile = await ProfileService().fetchUserProfile();
    final timezone = await getTimezone();
    return fromProfile(profile, timezone: timezone);
  }

  static bool _isIndiaLocation(String location) {
    if (location == 'india' || location == 'in' || location == 'ind') return true;
    return location.contains('india') ||
        location.contains('bharat') ||
        location.contains('hindustan');
  }

  static bool _containsAny(String value, List<String> hints) {
    for (final hint in hints) {
      if (value.contains(hint)) return true;
    }
    return false;
  }
}
