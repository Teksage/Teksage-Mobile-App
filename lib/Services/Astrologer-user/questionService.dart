import 'dart:convert';
import 'package:astro_prompt/Model/AstrologerUserConsult/astrologer_consult_event_model.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/question_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:flutter/foundation.dart';

class AstroUserQuestion {
  Future<String?> addQuestion(String question, int eventId, int index) async {
    try {
      final body = {"question": question, "index": index};
      if (kDebugMode) {
        print('URL: ${ApiEndpoint.astroEvents}/$eventId/questions');
        print('Body: $body');
      }
      var response = await APIRequest.postRequest('${ApiEndpoint.astroEvents}/$eventId/questions', body);
      if (kDebugMode) {
        print('ResponseCode: ${response.statusCode}');
      }
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) {
          print('Res: ${data['data']}');
        }

        return data['data'];
      } else {
        if (kDebugMode) {
          print("Error Add question: ${response.reasonPhrase}");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception: $e");
      }
      return null;
    }
  }

  Future<List<UserQuestion>> getQuestion(int eventId) async {
    try {
      var response = await APIRequest.getRequest('${ApiEndpoint.astroEvents}/$eventId/questions');
      if (kDebugMode) {
        print('${ApiEndpoint.astroEvents}/$eventId/questions');
      }
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        jsonList.sort((a, b) => a['id'].compareTo(b['id']));
        return jsonList.map((e) => UserQuestion.fromJson(e)).toList();
      } else {
        if (kDebugMode) {
          print("Error: ${response.reasonPhrase}");
        }
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<EventQuestions?> updateQuestionAnswer(int questionId, String answer) async {
    try {
      final body = {
        "answer": answer,
      };

      var response = await APIRequest.putRequest('${ApiEndpoint.astrologerAnswerUpdate}/$questionId', body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) {
          print('Updated Answer Response: $data');
        }
        return EventQuestions.fromJson(data);
      } else {
        if (kDebugMode) {
          print('❌ Failed to update answer. Reason: ${response.reasonPhrase}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Exception while updating answer: $e');
      }
      return null;
    }
  }
}
