import 'dart:convert';
import 'dart:io';

import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:astro_prompt/Services/AuthService/authService.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/appLanguage.dart';
import 'package:astro_prompt/config/LocallySavedData/timezone.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AstrologerAskService {
  Future<List<AskAstrologerRequest>> fetchAssignedRequests() async {
    try {
      final response =
          await APIRequest.getRequest(ApiEndpoint.astrologerAskRequests);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final list = data['requests'] as List<dynamic>? ?? [];
        return list
            .map((e) =>
                AskAstrologerRequest.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Astrologer ask requests error: $e');
      return [];
    }
  }

  Future<bool> submitAnswer({
    required int requestId,
    String? answerText,
    File? voiceFile,
    int? voiceDurationSec,
  }) async {
    final url = '${ApiEndpoint.astrologerAskRequests}/$requestId/answer';
    return _multipartPut(
      url: url,
      fields: {
        if (answerText?.trim().isNotEmpty == true)
          'answer_text': answerText!.trim(),
        if (voiceDurationSec != null && voiceDurationSec > 0)
          'voice_duration_sec': voiceDurationSec.toString(),
      },
      voiceFile: voiceFile,
    );
  }

  Future<bool> _multipartPut({
    required String url,
    required Map<String, String> fields,
    File? voiceFile,
  }) async {
    String accessToken = await getAccessToken();
    final timezone = await getTimezone();
    final responseLanguage = await _responseLanguage();

    Future<http.StreamedResponse> send(String token) async {
      final request = http.MultipartRequest('PUT', Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'X-Timezone': timezone,
        'response_language': responseLanguage,
      });
      request.fields.addAll(fields);
      if (voiceFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'voice',
            voiceFile.path,
            contentType: MediaType('audio', 'mpeg'),
          ),
        );
      }
      return request.send();
    }

    try {
      var response = await send(accessToken);
      if (response.statusCode == 401) {
        final refreshed = await APIRequest().refreshAccessToken();
        if (refreshed == null) {
          await AuthService().logout();
          if (Platform.isAndroid) {
            Get.offAllNamed('/home');
          } else {
            Get.offAllNamed('/login');
          }
          return false;
        }
        response = await send(refreshed);
      }
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Astrologer submit answer error: $e');
      return false;
    }
  }

  Future<String> _responseLanguage() async {
    final lang = await getAppLanguage();
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
      default:
        return 'english';
    }
  }
}
