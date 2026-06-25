import 'dart:convert';
import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astrologer_consult_event_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/LocallySavedData/userType.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:flutter/foundation.dart';

class AstroUserEventService {
  Future<List<AstroConsultationEventModel>> fetchAstroUserEvents(int id) async {
    bool type = await getUserType();
    String userType = type ? 'customer_id' : 'astrologer_id';
    try {
      var response = await APIRequest.getRequest('${ApiEndpoint.astroEvents}?$userType=$id');
      if (kDebugMode) {
        print('EventsURL: ${ApiEndpoint.astroEvents}?$userType=$id');
      }
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> jsonList = body['data'] ?? [];
        return jsonList.map((e) => AstroConsultationEventModel.fromJson(e)).toList();
      } else {
        if (kDebugMode) {
          print("Error fetchAstroUserEvents: ${response.reasonPhrase}");
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception Astro Events: $e");
      }
      return [];
    }
  }

  Future<ConsultationEventModel?> fetchAstroSingleUserEvent(int id) async {
    try {
      var response = await APIRequest.getRequest('${ApiEndpoint.astroEvents}/$id');
      if (kDebugMode) {
        print('URL: ${ApiEndpoint.astroEvents}/$id');
      }
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        return ConsultationEventModel.fromJson(body);
      } else {
        if (kDebugMode) {
          print("Error fetchAstroUserEvents: ${response.reasonPhrase}");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception Astro Single Event: $e");
      }
      return null;
    }
  }

  Future<String?> updateAstrologerEvent(int eventId, Map<String, dynamic> body) async {
    try {
      final response = await APIRequest.putRequest('${ApiEndpoint.astroEvents}/$eventId', body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final message = data['message'];
        if (kDebugMode) {
          print('✅ Update Success: $message');
        }
        return message;
      } else {
        if (kDebugMode) {
          print('❌ Failed to update. Reason: ${response.reasonPhrase}');
        }
        return null;
      }
    } catch (e) {
      print('❌ Exception while updating: $e');
      return null;
    }
  }
}
