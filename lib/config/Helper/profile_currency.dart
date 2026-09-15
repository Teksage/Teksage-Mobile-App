import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/config/LocallySavedData/timezone.dart';

/// INR only for India. Any other preferred location is USD.
/// Mirrors web `consultationCurrencyForLocation`.
class ProfileCurrency {
  static const _indiaTimezones = ['Asia/Kolkata', 'Asia/Calcutta'];
  static const _indiaDial = '91';

  static String fromProfile(
    UserProfile? profile, {
    String? timezone,
  }) {
    final loc = (profile?.preferredLocation ?? '').trim();
    if (loc.isNotEmpty) {
      return _isIndiaLocation(loc) ? 'INR' : 'USD';
    }

    final tz = (timezone ?? '').trim();
    if (tz.isNotEmpty && tz.toUpperCase() != 'UTC') {
      return _indiaTimezones.contains(tz) ? 'INR' : 'USD';
    }

    final code = (profile?.countryCode ?? '').replaceAll(RegExp(r'\D'), '');
    if (code == _indiaDial) return 'INR';
    if (code.isNotEmpty) return 'USD';
    return 'INR';
  }

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
}
