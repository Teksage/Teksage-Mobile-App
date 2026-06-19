import 'dart:convert';
import 'dart:io';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:flutter/foundation.dart';

class AudioTranscriptionService {
  static Future<String?> transcribeAudio(String filePath, String language) async {
    final file = File(filePath);

    try {
      final respStr = await APIRequest.multipartPostRequest(
        ApiEndpoint.recordAudio,
        file,
        fields: {
          'language': language,
        },
      );

      if (respStr == null) {
        debugPrint("No response from API");
        return null;
      }

      try {
        final Map<String, dynamic> data = jsonDecode(respStr);
        final transcript = data['transcript'] as String?;
        return transcript;
      } catch (e) {
        debugPrint('Failed to parse transcription response: $e — resp: $respStr');
        return null;
      }
    } catch (e) {
      debugPrint("Audio transcription failed: $e");
      return null;
    } finally {
      try {
        if (await file.exists()) await file.delete();
      } catch (e) {
        debugPrint("Failed to delete temp file: $e");
      }
    }
  }
}
