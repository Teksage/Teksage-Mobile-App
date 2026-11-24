import 'dart:convert';

import 'package:astro_prompt/Model/yearly_2027_promo_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class Yearly2027PromoService {
  Future<Yearly2027PromoStatus?> fetchStatus({bool ensure = true}) async {
    try {
      final url =
          '${ApiEndpoint.yearly2027PromoStatus}?ensure=${ensure ? 'true' : 'false'}';
      final response = await APIRequest.getRequest(url);
      if (response.statusCode == 200) {
        return Yearly2027PromoStatus.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Yearly2027PromoStatus?> dismiss() async {
    try {
      final response = await APIRequest.postRequest(
        ApiEndpoint.yearly2027PromoDismiss,
        {},
      );
      if (response.statusCode == 200) {
        return Yearly2027PromoStatus.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
