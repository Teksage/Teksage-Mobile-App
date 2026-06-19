import 'dart:convert';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class SupportMailService {
  Future<String> submitSupportMail(String query) async {
    try {
      final body = {"query": query};
      var response = await APIRequest.postRequest(ApiEndpoint.supportMail, body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return 'Error: ${response.reasonPhrase}';
      }
    } catch (e) {
      throw Exception('Error in SupportMail: $e');
    }
  }
}
