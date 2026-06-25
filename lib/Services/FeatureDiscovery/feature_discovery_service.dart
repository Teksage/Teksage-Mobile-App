import 'dart:convert';

import 'package:astro_prompt/Model/feature_discovery_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class FeatureDiscoveryService {
  Future<FeatureDiscoveryStatus?> fetchStatus() async {
    try {
      final response =
          await APIRequest.getRequest(ApiEndpoint.featureDiscoveryStatus);
      if (response.statusCode == 200) {
        return FeatureDiscoveryStatus.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<FeatureDiscoveryStatus?> dismiss() async {
    try {
      final response = await APIRequest.postRequest(
        ApiEndpoint.featureDiscoveryDismiss,
        {},
      );
      if (response.statusCode == 200) {
        return FeatureDiscoveryStatus.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
