import 'dart:convert';
import 'package:astro_prompt/Model/AstrologerUserConsult/subscription_model.dart';
import 'package:astro_prompt/Model/subscription_payment_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';

class SubscriptionService {
  Future<SubscriptionPaymentData?> subscriptionPaymentInitiate(
      {required int planId,
      required double paymentAmount,
      required String currency,
      required String couponId}) async {
    final body = {
      'plan_id': planId,
      'payment_amount': paymentAmount,
      'currency': currency,
      'coupon_id': couponId.isEmpty ? null : couponId,
    };
    var response =
        await APIRequest.postRequest(ApiEndpoint.subscriptionPayment, body);
    print('SubscriptionPaymentData: ${response.body} ${response.statusCode}');
    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SubscriptionPaymentData.fromJson(data['data']);
      } else {
        final errorJson = response.body;
        final errorMessage = jsonDecode(errorJson)['detail']
            .toString()
            .split('Razorpay error: ')
            .last;
        if (errorMessage.isNotEmpty) {}
        print(
            'Error Subscription: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception Subscription Payment: $e');
      return null;
    }
  }

  Future<AutoSubscriptionPaymentData?> autoSubscriptionPaymentInitiate(
      {required int planId,
      required double paymentAmount,
      required String currency,
      required String couponId}) async {
    final body = {
      'plan_id': planId,
      'payment_amount': paymentAmount,
      'currency': currency,
      'coupon_id': couponId.isEmpty ? null : couponId,
    };
    var response =
        await APIRequest.postRequest(ApiEndpoint.autoSubscriptionPayment, body);
    print(
        'AutoSubscriptionPaymentData: ${response.body} ${response.statusCode}');
    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AutoSubscriptionPaymentData.fromJson(data);
      } else {
        final errorJson = response.body;
        final errorMessage = jsonDecode(errorJson)['detail']
            .toString()
            .split('Razorpay error: ')
            .last;
        if (errorMessage.isNotEmpty) {}
        print(
            'Error Auto Subscription: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception Auto Subscription Payment: $e');
      return null;
    }
  }

  Future<SubscriptionPlanModel?> fetchSubscriptionPlan(int planId) async {
    try {
      var response = await APIRequest.getRequest(
          '${ApiEndpoint.getSubscriptionPlans}$planId');
      print('${ApiEndpoint.getSubscriptionPlans}$planId');
      print('Res: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SubscriptionPlanModel.fromJson(data);
      } else {
        print('Error Subscription Plan: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
