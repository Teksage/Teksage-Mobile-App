import 'dart:convert';

import 'package:astro_prompt/Model/astroconnect_popup_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class AstroConnectPopupService {
  Future<AstroConnectPopupStatus?> fetchStatus() async {
    try {
      final response = await APIRequest.getRequest(ApiEndpoint.marathonPopup);
      if (response.statusCode != 200) return null;
      return AstroConnectPopupStatus.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> dismiss(int eventId) async {
    try {
      await APIRequest.postRequest(
        ApiEndpoint.marathonPopupDismiss,
        {'event_id': eventId},
      );
    } catch (_) {}
  }
}
