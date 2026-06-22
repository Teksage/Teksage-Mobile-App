import 'dart:convert';

import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class AskAstrologerService {
  Future<AskAstrologerPricing?> fetchPricing() async {
    try {
      final response =
          await APIRequest.getRequest(ApiEndpoint.askAstrologerPricing);
      if (response.statusCode == 200) {
        return AskAstrologerPricing.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Ask pricing error: $e');
      return null;
    }
  }

  Future<AskAstrologerOrderResponse?> createRequest({
    required String userQuestion,
    required String aiResponse,
    required List<String> preferredLanguages,
    required String currency,
  }) async {
    try {
      final body = {
        'user_question': userQuestion,
        'ai_response': aiResponse,
        'preferred_languages': preferredLanguages,
        'currency': currency,
      };
      final response =
          await APIRequest.postRequest(ApiEndpoint.askAstrologerCreate, body);
      if (response.statusCode == 200) {
        return AskAstrologerOrderResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Ask create error: $e');
      return null;
    }
  }

  Future<bool> verifyPayment({
    required int requestId,
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final body = {
        'request_id': requestId,
        'razorpay_order_id': orderId,
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
      };
      final response =
          await APIRequest.postRequest(ApiEndpoint.askAstrologerVerify, body);
      return response.statusCode == 200;
    } catch (e) {
      print('Ask verify error: $e');
      return false;
    }
  }

  Future<List<AskAstrologerRequest>> fetchMyRequests() async {
    try {
      final response =
          await APIRequest.getRequest(ApiEndpoint.askAstrologerRequests);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final list = data['requests'] as List<dynamic>? ?? [];
        return list
            .map((e) =>
                AskAstrologerRequest.fromJson(e as Map<String, dynamic>))
            .where((r) => r.status != 'pending_payment' && r.status != 'cancelled')
            .toList();
      }
      return [];
    } catch (e) {
      print('Ask requests error: $e');
      return [];
    }
  }

  Future<AskAstrologerRequest?> fetchRequest(int requestId) async {
    try {
      final response = await APIRequest.getRequest(
          '${ApiEndpoint.askAstrologerBase}/$requestId');
      if (response.statusCode == 200) {
        return AskAstrologerRequest.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Ask request detail error: $e');
      return null;
    }
  }

  Future<AskAstrologerRequest?> fetchPendingAnswerPopup() async {
    try {
      final response = await APIRequest.getRequest(
          ApiEndpoint.askAstrologerPendingAnswerPopup);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final req = data['request'];
        if (req == null) return null;
        return AskAstrologerRequest.fromJson(req as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Ask pending popup error: $e');
      return null;
    }
  }

  Future<bool> acknowledgeAnswerReady(int requestId) async {
    try {
      final response = await APIRequest.postRequest(
        '${ApiEndpoint.askAstrologerBase}/$requestId/acknowledge-answer-ready',
        {},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Ask acknowledge error: $e');
      return false;
    }
  }
}
