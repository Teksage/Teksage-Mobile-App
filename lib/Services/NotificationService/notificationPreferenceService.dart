import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class NotificationPreferenceService {
  Future<String> updateNotificationPreference(
    bool dailyPredictions,
    bool weeklyPredictions,
    bool yearlyPredictions,
    bool promotionOffers,
    bool warnings,
  ) async {
    try {
      var body = {
        'daily_predictions': dailyPredictions,
        'weekly_predictions': weeklyPredictions,
        'yearly_predictions': yearlyPredictions,
        'promotion_offers': promotionOffers,
        'warnings': warnings,
      };
      final response = await APIRequest.postRequest(ApiEndpoint.updateNotificationPreference, body);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to store the preference');
      }
    } catch (e) {
      print("❌ Error downloading or saving: $e");
      rethrow;
    }
  }
}
