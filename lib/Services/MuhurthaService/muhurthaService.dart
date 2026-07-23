import 'dart:convert';

import 'package:astro_prompt/Model/muhurtha_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class MuhurthaService {
  Future<MuhurthaPayload> fetchEventPlanner({
    required String event,
    required String startDate,
    required String location,
  }) async {
    final encodedEvent = Uri.encodeQueryComponent(event);
    final encodedLocation = Uri.encodeQueryComponent(location);
    final url =
        '${ApiEndpoint.eventPlanner}?event=$encodedEvent&start_date=$startDate&location=$encodedLocation';

    final response = await APIRequest.getRequest(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to load Event Planner');
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return MuhurthaPayload.fromJson(decoded);
  }
}
