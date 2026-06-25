import 'dart:convert';

import 'package:astro_prompt/Model/whatsapp_consent_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class WhatsAppConsentService {
  Future<WhatsAppConsentState?> fetchStatus() async {
    try {
      final response =
          await APIRequest.getRequest(ApiEndpoint.whatsappConsentStatus);
      if (response.statusCode == 200) {
        return WhatsAppConsentState.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('WhatsApp consent status error: $e');
      return null;
    }
  }

  Future<WhatsAppConsentState?> requestConsent({
    bool useProfilePhone = true,
    String? countryCode,
    String? mobileNumber,
  }) async {
    try {
      final body = useProfilePhone
          ? {'use_profile_phone': true}
          : {
              'use_profile_phone': false,
              'country_code': countryCode?.replaceAll(RegExp(r'\D'), ''),
              'mobile_number': mobileNumber?.replaceAll(RegExp(r'\D'), ''),
            };
      final response =
          await APIRequest.postRequest(ApiEndpoint.whatsappConsentRequest, body);
      if (response.statusCode == 200) {
        return fetchStatus();
      }
      return null;
    } catch (e) {
      print('WhatsApp consent request error: $e');
      return null;
    }
  }

  Future<bool> revokeConsent() async {
    try {
      final response =
          await APIRequest.postRequest(ApiEndpoint.whatsappConsentRevoke, {});
      return response.statusCode == 200;
    } catch (e) {
      print('WhatsApp consent revoke error: $e');
      return false;
    }
  }
}
