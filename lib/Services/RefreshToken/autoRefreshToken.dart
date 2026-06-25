import 'dart:convert';
import 'dart:io';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/auth/login_with_email.dart';
import 'package:astro_prompt/Services/AuthService/authService.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/appLanguage.dart';
import 'package:astro_prompt/config/LocallySavedData/timezone.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class APIRequest {
  /// Helper function to get the API language format
  static Future<String> _getResponseLanguage() async {
    String lang = await getAppLanguage();
    // Map app language codes to API language format
    switch (lang) {
      case 'tamil':
        return 'tamil';
      case 'hindi':
        return 'hindi';
      case 'telugu':
        return 'telugu';
      case 'kannada':
        return 'kannada';
      case 'malayalam':
        return 'malayalam';
      case 'marathi':
        return 'marathi';
      case 'en_US':
      case 'en':
        return 'english';
      default:
        return 'english'; // Default to english if not set
    }
  }

  ///Refresh Token
  Future<String?> refreshAccessToken() async {
    String refreshToken = await getRefreshToken();
    AuthService authService = AuthService();

    if (refreshToken.isEmpty) {
      print("No refresh token available.");
      return null;
    }

    final String timezone = await getTimezone();
    final String responseLanguage = await _getResponseLanguage();
    var headers = {
      'Content-Type': 'application/json',
      'X-Timezone': timezone,
      'response_language': responseLanguage
    };
    var body = json.encode({"refresh_token": refreshToken});

    try {
      if (kDebugMode) {
        print("Refreshing token with URL: ${ApiEndpoint.refreshToken}");
      }
      var response = await http.post(Uri.parse(ApiEndpoint.refreshToken),
          headers: headers, body: body);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        String newAccessToken = jsonData['access_token'];
        await saveAccessToken(newAccessToken);
        if (kDebugMode) {
          print("✅ New Access Token Saved");
        }
        return newAccessToken;
      } else {
        if (response.statusCode == 401) {
          if (kDebugMode) {
            print(
                "❌ Refresh Token Failed: ${response.reasonPhrase} ${response.statusCode} ${response.body}");
          }
          await authService.logout();
          print('Testing: ${Platform.isAndroid}');
          if (Platform.isAndroid) {
            print('Came here');
            await authService.logout();
            Get.offAllNamed('/home');
          } else {
            Get.offAllNamed('/login');
          }
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error refreshing token: $e");
      }
      return null;
    }
  }

  /// Common method to handle all GET requests with auto-refresh
  static Future<http.Response> getRequest(String url) async {
    String accessToken = await getAccessToken();
    String timezone = await getTimezone();
    String responseLanguage = await _getResponseLanguage();
    AuthService authService = AuthService();
    var headers = {
      'Authorization': 'Bearer $accessToken',
      'X-Timezone': timezone,
      'response_language': responseLanguage
    };
    var response = await http.get(Uri.parse(url), headers: headers);
    if (kDebugMode) {
      print('Token: $accessToken');
    }
    if (response.statusCode == 401) {
// If token is expired, refresh it
      if (kDebugMode) {
        print('⚠️ Access token expired. Refreshing token...');
      }
      String? newAccessToken = await APIRequest().refreshAccessToken();

      if (newAccessToken != null) {
// Retry the request with the new token
        headers['Authorization'] = 'Bearer $newAccessToken';
        return await http.get(Uri.parse(url), headers: headers);
      } else {
        await authService.logout();
        if (Platform.isAndroid) {
          Get.offAllNamed('/home');
        } else {
          Get.offAllNamed('/login');
        }
        throw Exception('❌ Token refresh failed. Please log in again.');
      }
    }
    return response;
  }

  static Future<http.Response> getRequestTimeZone(
      String url, String timezone) async {
    String accessToken = await getAccessToken();
    String responseLanguage = await _getResponseLanguage();
    AuthService authService = AuthService();
    var headers = {
      'Authorization': 'Bearer $accessToken',
      'X-Timezone': timezone,
      'response_language': responseLanguage
    };
    var response = await http.get(Uri.parse(url), headers: headers);
    if (kDebugMode) {
      print('Token: $accessToken');
    }
    if (response.statusCode == 401) {
// If token is expired, refresh it
      if (kDebugMode) {
        print('⚠️ Access token expired. Refreshing token...');
      }
      String? newAccessToken = await APIRequest().refreshAccessToken();

      if (newAccessToken != null) {
// Retry the request with the new token
        headers['Authorization'] = 'Bearer $newAccessToken';
        return await http.get(Uri.parse(url), headers: headers);
      } else {
        await authService.logout();
        if (Platform.isAndroid) {
          Get.offAllNamed('/home');
        } else {
          Get.offAllNamed('/login');
        }
        throw Exception('❌ Token refresh failed. Please log in again.');
      }
    }
    return response;
  }

  /// Common method to handle all POST requests with auto-refresh
  static Future<http.Response> postRequest(
      String url, Map<String, dynamic> body) async {
    String? accessToken = await getAccessToken();
    final String timezone = await getTimezone();
    String responseLanguage = await _getResponseLanguage();
    AuthService authService = AuthService();
    var headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'X-Timezone': timezone,
      'response_language': responseLanguage
    };
    if (kDebugMode) {
      print('Token: $accessToken');
      print('Timezone: $timezone');
      print('Auto Refresh URL: $url');
    }
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body), // Encode inside the function
      );

      if (response.statusCode == 401) {
        if (kDebugMode) {
          print('Access token expired. Refreshing token...');
        }
        String? newAccessToken = await APIRequest().refreshAccessToken();

        if (newAccessToken != null) {
          return postRequest(url, body); // Retry request
        } else {
          await authService.logout();
          if (Platform.isAndroid) {
            Get.offAllNamed('/home');
          } else {
            Get.offAllNamed('/login');
          }
          throw Exception('Token refresh failed. Please log in again.');
        }
      }

      return response;
    } catch (e) {
      throw Exception("Request failed: $e");
    }
  }

  /// Common method to handle all PUT requests with auto-refresh
  static Future<http.Response> putRequest(
      String url, Map<String, dynamic> body) async {
    final String timezone = await getTimezone();
    String? accessToken = await getAccessToken();
    String responseLanguage = await _getResponseLanguage();
    AuthService authService = AuthService();
    var headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'X-Timezone': timezone,
      'response_language': responseLanguage,
    };

    try {
      var response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 401) {
        if (kDebugMode) {
          print('Access token expired. Refreshing token...');
        }
        String? newAccessToken = await APIRequest().refreshAccessToken();

        if (newAccessToken != null) {
          return await http.put(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $newAccessToken',
              'Content-Type': 'application/json',
              'X-Timezone': timezone,
              'response_language': responseLanguage,
            },
            body: json.encode(body),
          );
        } else {
          await authService.logout();
          if (Platform.isAndroid) {
            Get.offAllNamed('/home');
          } else {
            Get.offAllNamed('/login');
          }
          throw Exception('Token refresh failed. Please log in again.');
        }
      }

      return response;
    } catch (e) {
      throw Exception("PUT request failed: $e");
    }
  }

  /// Common method to handle all MultiPOST requests with auto-refresh
  static Future<String?> multipartPostRequest(String url, File file,
      {String fieldName = 'file', Map<String, String>? fields}) async {
    String? accessToken = await getAccessToken();
    final String timezone = await getTimezone();
    String responseLanguage = await _getResponseLanguage();
    AuthService authService = AuthService();

    var headers = {
      'Authorization': 'Bearer $accessToken',
      'X-Timezone': timezone,
      'response_language': responseLanguage
    };

    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.headers.addAll(headers);

      // Attach any additional form fields (for example: language)
      if (fields != null && fields.isNotEmpty) {
        request.fields.addAll(fields);
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          fieldName,
          file.path,
          contentType: MediaType('audio', 'wav'),
        ),
      );

      var response = await request.send();

      if (response.statusCode == 401) {
        // Refresh token
        String? newAccessToken = await APIRequest().refreshAccessToken();
        if (newAccessToken != null) {
          return multipartPostRequest(url, file,
              fieldName: fieldName, fields: fields); // Retry
        } else {
          await authService.logout();
          if (Platform.isAndroid) {
            Get.offAllNamed('/home');
          } else {
            Get.offAllNamed('/login');
          }
          throw Exception('Token refresh failed. Please log in again.');
        }
      }

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        debugPrint("API Response: $respStr");
        return respStr;
      } else {
        debugPrint("API Error: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      throw Exception("Multipart request failed: $e");
    }
  }
}
