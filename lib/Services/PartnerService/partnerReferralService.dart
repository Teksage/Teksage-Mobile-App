import 'dart:convert';
import 'package:astro_prompt/Services/PartnerService/partnerDiscountHelpers.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class PartnerReferralService {
  static Future<Map<String, dynamic>> redeem(String code) async {
    final response = await APIRequest.postRequest(
      ApiEndpoint.partnerCodeRedeem,
      {'code': code.trim().toUpperCase()},
    );
    final body = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Map<String, dynamic>.from(body as Map);
    }
    throw Exception(
      body is Map
          ? (body['detail'] ?? body['error'] ?? 'Invalid referral code')
          : 'Invalid referral code',
    );
  }

  static Future<PartnerDiscountState> fetchMyDiscount() async {
    final response = await APIRequest.getRequest(ApiEndpoint.partnerMyDiscount);
    final body = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PartnerDiscountState.fromJson(
        Map<String, dynamic>.from(body as Map),
      );
    }
    return const PartnerDiscountState(hasDiscount: false);
  }
}
