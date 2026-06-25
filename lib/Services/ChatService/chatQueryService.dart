import 'dart:convert';
import 'dart:typed_data';
import 'package:astro_prompt/Model/chat_message_model.dart';
import 'package:astro_prompt/Model/chat_preference_model.dart';
import 'package:astro_prompt/Model/chat_relatedQuery_model.dart';
import 'package:astro_prompt/Services/HoroscopeService/fileStorageService.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class ChatService {
  Future<RelatedQueriesModel?> getRelatedQueries(String query) async {
    try {
      final body = {
        "query": query,
      };

      var response = await APIRequest.postRequest(
        ApiEndpoint.getRelatedQueries,
        body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RelatedQueriesModel.fromJson(data['data']);
      } else {
        if (kDebugMode) {
          print("Error: ${response.reasonPhrase}");
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

  Future<String> downloadSpecificChat(List<dynamic> questions) async {
    try {
      final body = {
        "questions": questions,
      };

      final response = await APIRequest.postRequest(ApiEndpoint.chatDownload, body);
      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        final fileName = "AstroPromptChat";
        final filePath = await FileStorage.savePdfToDownloads(bytes, fileName);
        return p.basename(filePath);
      } else {
        throw Exception('Failed to download specific chat PDF');
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error downloading or saving: $e");
      }
      rethrow;
    }
  }

  Future<Uint8List?> downloadChat() async {
    try {
      final response = await APIRequest.getRequest(ApiEndpoint.chatDownload);
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        return bytes;
      } else {
        throw Exception('Failed to load horoscope data');
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error downloading or saving: $e");
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendMail(bool maintainHistory) async {
    try {
      var body = {"maintain_history": maintainHistory};
      final response = await APIRequest.postRequest(ApiEndpoint.chatMail, body);
      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);
        if (kDebugMode) {
          print('Message: $message');
        }
        return message;
      } else {
        throw Exception('Failed to send mail');
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error downloading or saving: $e");
      }
      rethrow;
    }
  }

  Future<bool> updateMaintainHistory({required bool maintainHistory}) async {
    try {
      var body = {"maintain_history": maintainHistory};
      final response = await APIRequest.putRequest(ApiEndpoint.maintainChatHistory, body);
      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);
        return message['maintain_history'] == true;
      } else {
        if (kDebugMode) {
          print('Failed to update: ${response.statusCode} ${response.reasonPhrase}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during maintain_history update: $e');
      }
      return false;
    }
  }

  Future<ChatPreference?> getMaintainHistory() async {
    try {
      final response = await APIRequest.getRequest(ApiEndpoint.maintainChatHistory);
      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);
        // return message['maintain_history'];
        return ChatPreference.fromJson(message);
      } else {
        if (kDebugMode) {
          print('Failed to update: ${response.statusCode} ${response.reasonPhrase}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during maintain_history update: $e');
      }
      return null;
    }
  }

  static Future<List<ChatMessageModel>> fetchChatHistory({required bool maintainHistory}) async {
    try {
      // var body = {"maintain_history": maintainHistory};
      final response = await APIRequest.getRequest(ApiEndpoint.chatHistory);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.map((e) => ChatMessageModel.fromJson(e)).toList();
        } else {
          if (kDebugMode) {
            print('Unexpected response format');
          }
          return [];
        }
      } else {
        if (kDebugMode) {
          print('Failed to fetch chat history: ${response.statusCode} ${response.reasonPhrase}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception in fetchChatHistory: $e');
      }
      return [];
    }
  }
}
