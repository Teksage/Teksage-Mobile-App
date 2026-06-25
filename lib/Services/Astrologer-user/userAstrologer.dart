import 'dart:convert';
import 'dart:io';
import 'package:astro_prompt/Model/AstrologerUserConsult/all_astrologer_model.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astrologer_detail_model.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/subscription_model.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/top_5_astrologer_model.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/user_booking_razorpay.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class AstrologerConsultationService {
  Future<List<Top5AstrologerConsultUserData>?> fetchTop5AstroConsult({
    required List<String> languages,
    required List<String> categories,
  }) async {
    try {
      final body = {
        'languages': languages,
        'category': categories,
      };
       print("body: $body");
      var response = await APIRequest.postRequest(ApiEndpoint.userConsultationFilter, body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> dataList = data['data'];
        return dataList.map((json) => Top5AstrologerConsultUserData.fromJson(json)).toList();
      } else {
        print("Error: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  Future<List<AllAstrologerConsultUserData>> fetchAllAstroConsult(List<int> astroIds) async {
    final String astroIdsParam = astroIds.join(',');

    var response = await APIRequest.getRequest('${ApiEndpoint.userConsultationFilter}?astro_ids=$astroIdsParam');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List<dynamic> dataList = data['astrologers'];
      return dataList.map((json) => AllAstrologerConsultUserData.fromJson(json)).toList();
    } else {
      print("Error: ${response.reasonPhrase}");
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchAstrologerDetail(int astrologerId) async {
    var response = await APIRequest.getRequest('${ApiEndpoint.getAstrologerDetail}/$astrologerId?completed=true');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      AstrologerDetails astrologer = AstrologerDetails.fromJson(jsonData['astrologer']);
      List<Event> events = (jsonData['events'] as List).map((e) => Event.fromJson(e)).toList();
      return {
        'astrologer': astrologer,
        'events': events,
      };
    } else {
      print("Error fetchAstrologerDetail: ${response.reasonPhrase}");
      throw Exception('Failed to load astrologer details');
    }
  }

  Future<UserBookingRazorPay?> astroConsultBooking(
      {required String startTime,
      required String endTime,
      required bool shareHoroscope,
      required List<String> languages,
      required List<String> category,
      required int astrologerId,
      required int amount,
      required String currency,
      required String couponId}) async {
    try {
      final body = {
        "start_datetime": startTime,
        "end_datetime": endTime,
        "share_horoscope": shareHoroscope,
        "languages": languages,
        "category": category,
        "astrologer_id": astrologerId,
        "payment_amount": amount,
        "currency": currency,
        "coupon_id":couponId.isEmpty ? null : couponId,
      };

      print('Body: $body');
      var response = await APIRequest.postRequest(ApiEndpoint.createAstrologerBooking, body);
      print('Astro Status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Data: ${data['event']}');
        return UserBookingRazorPay.fromJson(data['event']);
      } else {
        print("Error: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("ExceptionHere: $e");
      return null;
    }
  }

  // Future<UserBookingConsultation?> verifyPayment({
  //   required String orderId,
  //   required String paymentId,
  //   required String signature,
  // }) async {
  //   try {
  //     final body = {
  //       "razorpay_order_id": orderId,
  //       "razorpay_payment_id": paymentId,
  //       "razorpay_signature": signature,
  //     };
  //     var response = await APIRequest.postRequest(ApiEndpoint.verifyPayment, body);
  //     print('Payment Response Code: ${response.body}  ${response.statusCode}');
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       return UserBookingConsultation.fromJson(data);
  //     } else {
  //       print("Error-statusCode: ${response.reasonPhrase}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error Payment: $e');
  //     return null;
  //   }
  // }

  Future<List<SubscriptionPlanModel>> fetchPremiumPlans() async {
    var response = await APIRequest.getRequest(ApiEndpoint.getSubscriptionPlans);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<SubscriptionPlanModel> plans = data.map((item) => SubscriptionPlanModel.fromJson(item)).where((plan) => plan.serviceType == 'premium').toList();

      if (Platform.isAndroid) {
        return plans.where((plan) => plan.os == 'android').toList();
      } else if (Platform.isIOS) {
        return plans.where((plan) => plan.os == 'ios').toList();
      }

      return plans;
    } else {
      throw Exception('Failed to load service plans: ${response.reasonPhrase}');
    }
  }
}
