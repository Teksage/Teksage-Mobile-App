import 'dart:convert';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:flutter/foundation.dart';

class NotificationFirebaseService {
  Future<Map<String, dynamic>> saveFcmToken(String fcmToken) async {
    try {
      var body = {"fcm_token": fcmToken};
      if (kDebugMode) {
        print('Body: $body');
      }
      var response = await APIRequest.postRequest(ApiEndpoint.registerFcmToken, body);
      if (kDebugMode) {
        print('Status Code: ${response.statusCode}');
        print('Status URL: ${ApiEndpoint.registerFcmToken}');
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (kDebugMode) {
          print('Data: $data');
        }
        return {
          'status': data['status'],
          'message': data['message'],
        };
      } else {
        return {
          'status': 'error',
          'message': response.reasonPhrase ?? 'Unknown error',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Exception: $e',
      };
    }
  }
}
