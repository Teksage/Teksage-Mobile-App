import 'dart:convert';

import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:http/http.dart' as http;

class MarathonService {
  Future<List<Map<String, dynamic>>> publicList() async {
    final response = await http.get(Uri.parse(ApiEndpoint.marathonPublic));
    if (response.statusCode != 200) {
      throw Exception(_detail(response));
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    return List<Map<String, dynamic>>.from(body['data'] ?? []);
  }

  Future<Map<String, dynamic>> publicDetail(int id) async {
    final response =
        await http.get(Uri.parse('${ApiEndpoint.marathonPublic}/$id'));
    if (response.statusCode != 200) {
      throw Exception(_detail(response));
    }
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> checkout(int slotId, {String currency = 'INR'}) async {
    final response = await APIRequest.postRequest(
      '${ApiEndpoint.marathon}/slots/$slotId/checkout?currency=$currency',
      {},
    );
    if (response.statusCode != 200) {
      throw Exception(_detail(response));
    }
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> verify({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    final response = await APIRequest.postRequest(
      ApiEndpoint.verifyPayment,
      {
        'razorpay_order_id': orderId,
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
      },
    );
    if (response.statusCode != 200) {
      throw Exception(_detail(response));
    }
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> mine() async {
    final response = await APIRequest.getRequest('${ApiEndpoint.marathon}/mine');
    if (response.statusCode != 200) return [];
    final body = json.decode(response.body) as Map<String, dynamic>;
    return List<Map<String, dynamic>>.from(body['data'] ?? []);
  }

  Future<List<Map<String, dynamic>>> astrologerDrafts() async {
    final response =
        await APIRequest.getRequest('${ApiEndpoint.marathon}/astrologer/drafts');
    if (response.statusCode != 200) {
      throw Exception(_detail(response));
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    return List<Map<String, dynamic>>.from(body['data'] ?? []);
  }

  Future<void> confirmParticipation(int marathonId) async {
    final response = await APIRequest.postRequest(
      '${ApiEndpoint.marathon}/$marathonId/confirm',
      {},
    );
    if (response.statusCode != 200) {
      throw Exception(_detail(response));
    }
  }

  Future<Map<String, dynamic>> astrologerSeats() async {
    final response =
        await APIRequest.getRequest('${ApiEndpoint.marathon}/astrologer/seats');
    if (response.statusCode != 200) {
      throw Exception(_detail(response));
    }
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<void> complete(int bookingId) async {
    final response = await APIRequest.postRequest(
      '${ApiEndpoint.marathon}/bookings/$bookingId/complete',
      {},
    );
    if (response.statusCode != 200) {
      throw Exception(_detail(response));
    }
  }

  Future<Map<String, dynamic>> accept(int bookingId) async {
    final response = await APIRequest.postRequest(
      '${ApiEndpoint.marathon}/bookings/$bookingId/accept',
      {},
    );
    if (response.statusCode != 200) {
      throw Exception(_detail(response));
    }
    return json.decode(response.body) as Map<String, dynamic>;
  }

  String _detail(http.Response response) {
    try {
      final body = json.decode(response.body);
      final detail = body['detail'];
      if (detail is String && detail.isNotEmpty) return detail;
    } catch (_) {}
    return 'Something went wrong. Try again.';
  }
}
