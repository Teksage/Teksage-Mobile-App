import 'dart:convert';

import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:http/http.dart' as http;

class AstroConnectLeadService {
  Future<Map<String, dynamic>> submitLead({
    required String name,
    required String countryCode,
    required String mobileNumber,
    required List<String> categories,
    required int sourceMarathonId,
    String platform = 'android',
  }) async {
    final response = await http.post(
      Uri.parse(ApiEndpoint.marathonLeads),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'country_code': countryCode,
        'mobile_number': mobileNumber,
        'categories': categories,
        'source_marathon_id': sourceMarathonId,
        'platform': platform,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(_detail(response));
    }
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> lookupLead({
    required String countryCode,
    required String mobileNumber,
    required int sourceMarathonId,
  }) async {
    final uri = Uri.parse(ApiEndpoint.marathonLeadsLookup).replace(
      queryParameters: {
        'country_code': countryCode,
        'mobile_number': mobileNumber,
        'source_marathon_id': '$sourceMarathonId',
      },
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) return null;
    if (response.body.isEmpty || response.body == 'null') return null;
    final decoded = json.decode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    return null;
  }

  String _detail(http.Response response) {
    try {
      final body = json.decode(response.body);
      if (body is Map && body['detail'] != null) return body['detail'].toString();
    } catch (_) {}
    return 'Could not save your details. Please try again.';
  }
}
