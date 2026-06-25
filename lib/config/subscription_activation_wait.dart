import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';

/// Poll profile until subscription + plan details exist (mirrors web `waitForPremiumActivation`).
Future<UserProfile?> waitForPremiumProfile({
  int maxAttempts = 3,
  Duration delay = const Duration(milliseconds: 800),
}) async {
  final service = ProfileService();
  UserProfile? latest;
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    latest = await service.fetchUserProfile();
    if (latest?.subscription != null && latest?.planDetails != null) {
      return latest;
    }
    if (attempt < maxAttempts - 1) {
      await Future.delayed(delay);
    }
  }
  return latest;
}
