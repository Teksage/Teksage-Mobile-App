import 'dart:convert';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class TimeZoneService {
  Future<Map<String, dynamic>> updateTimezone(String timeZone) async {
    try {
      final response = await APIRequest.getRequestTimeZone(ApiEndpoint.updateTimeZone, timeZone);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print('Timezone Response: $responseBody');
        return responseBody;
      } else {
        return {
          'error': true,
          'statusCode': response.statusCode,
          'message': response.reasonPhrase ?? 'Unknown error',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': e.toString(),
      };
    }
  }
}
