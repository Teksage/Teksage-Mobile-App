import 'dart:convert';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class ProfileService {
  ///Verify Email/Mobile
  Future<Map<String, dynamic>> profileVerify(
      String keyValue, String variable) async {
    var body = {keyValue: variable};
    var response =
        await APIRequest.postRequest(ApiEndpoint.profileVerify, body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {"error": response.reasonPhrase};
    }
  }

  Future<Map<String, dynamic>> profileVerifyChange(
      String keyValue, String variable,
      {String? countryCode}) async {
    Map<String, dynamic> body = {keyValue: variable};

    if (keyValue == 'mobile_number') {
      body['country_code'] = countryCode;
    }

    var response = await APIRequest.postRequest(
        '${ApiEndpoint.profileVerify}?update=true', body);
    print('response$body');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
    }
  }

  ///Verify Email/Mobile OTP verification
  Future<String> profileVerifyOtp(
      String keyValue, String variable, String otp, bool newUser,
      {String? countryCode}) async {
    Map<String, dynamic> body = {
      keyValue: variable,
      "otp": otp,
      "login": false
    };
    if (keyValue == 'mobile_number' &&
        countryCode != null &&
        countryCode.isNotEmpty) {
      body['country_code'] = countryCode;
    }
    print('body:$body');
    var url = newUser
        ? '${ApiEndpoint.profileVerifyOtp}?update=$newUser'
        : ApiEndpoint.profileVerifyOtp;
    print('url:$url$newUser');
    var response = await APIRequest.postRequest(url, body);
    var responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      print('Stauts: $responseBody');
      if (responseBody.containsKey("status")) {
        return "success";
      } else if (responseBody.containsKey("error")) {
        return responseBody["error"];
      } else {
        return "Unexpected response: $responseBody";
      }
    } else {
      var responseBody = json.decode(response.body);
      return responseBody.containsKey("detail")
          ? responseBody["detail"]
          : "Something went wrong. Please try again.";
    }
  }

  ///Get Rashi & Nakshatra
  Future<Map<String, dynamic>> fetchRashiNakshatra({
    required String preferredLocation,
    required String dateOfBirth,
    required String timeOfBirth,
    required String birthLocation,
  }) async {
    var body = {
      "preferred_location": preferredLocation,
      "date_of_birth": dateOfBirth,
      "time_of_birth": timeOfBirth,
      "birth_location": birthLocation,
    };
    print('Body: $body');
    var response =
        await APIRequest.postRequest(ApiEndpoint.getRasiNakshatram, body);
    // print('Workingres: ${response.body}');
    if (response.statusCode == 200) {
      return {"success": true, "data": json.decode(response.body)};
    } else {
      return {"success": false, "error": "Error ${response.reasonPhrase}"};
    }
  }

  ///Update Profile
  Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> profileData) async {
    var body = profileData;
    print('Body: $body');
    var response =
        await APIRequest.postRequest(ApiEndpoint.updateProfile, body);
    print('ProfileRes: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      return {"success": true, "data": json.decode(response.body)};
    } else {
      var responseBody = json.decode(response.body);
      return {
        "success": false,
        "error": responseBody['error'] ?? 'Unknown error'
      };
    }
  }

  ///Get Profile
  Future<UserProfile?> fetchUserProfile() async {
    var response = await APIRequest.getRequest(ApiEndpoint.getProfile);
    print('res: ${response.body}');
    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      final data = json.decode(response.body);
      if (data['detail'] == 'Profile not completed') {
        throw IncompleteProfileException(data['profile_data']);
      }
      throw Exception('Error: ${data['detail']}');
    } else {
      throw Exception('Unexpected error: ${response.statusCode}');
    }
  }
}

class IncompleteProfileException implements Exception {
  final dynamic profileData;
  IncompleteProfileException(this.profileData);
}
