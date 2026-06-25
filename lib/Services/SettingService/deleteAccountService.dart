import 'dart:convert';
import 'dart:io';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:flutter/foundation.dart';

class DeleteAccountService {
  Future<String> deleteAccountSendOtp() async {
    try {
      // var deleteRequest = Platform.isIOS ? '${ApiEndpoint.deleteAccountSendOtp}?device=ios' : ApiEndpoint.deleteAccountSendOtp;
      var deleteRequest = ApiEndpoint.deleteAccountSendOtp;
      var response = await APIRequest.getRequest(deleteRequest);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return result['message'];
      } else {
        var errorBody = jsonDecode(response.body);
        String errorMessage = errorBody['detail'] ?? response.reasonPhrase ?? 'Unknown error';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('Error: $e');
    }
  }

  Future<String> deleteAccountVerifyOtp(String otpValue, String deleteReason) async {
    try {
      var body = {"otp": otpValue, "deletion_reason": deleteReason};
      var response = await APIRequest.postRequest(ApiEndpoint.deleteAccountVerifyOtp, body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return result['message'];
      } else {
        var errorBody = jsonDecode(response.body);
        String errorMessage = errorBody['detail'] ?? response.reasonPhrase ?? 'Unknown error';
        if (kDebugMode) {
          print('Error: $errorMessage');
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
