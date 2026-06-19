import 'dart:convert';
import 'package:astro_prompt/Model/AstrologerUserConsult/slot_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class SlotService {
  Future<List<SlotModel>> fetchAvailableSlots({
    required String astrologerId,
    required String date,
  }) async {
    final body = {
      'astrologer_id': astrologerId,
      'date': date,
    };
    print('body from slot service $body');
    var response =
        await APIRequest.postRequest(ApiEndpoint.getAstrologerSlots, body);
    print('response from slot service ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> slots = data['available_slots'];
      return slots.map((json) => SlotModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load slots: ${response.reasonPhrase}');
    }
  }

  Future<String> createSlots(List<Map<String, dynamic>> slots) async {
    final body = {"slots": slots};

    try {
      var response =
          await APIRequest.postRequest(ApiEndpoint.createAstrologerSlots, body);

      if (response.statusCode == 200) {
        return "success";
      } else {
        return "Error: ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
}
