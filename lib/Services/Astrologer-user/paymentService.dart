import 'dart:convert';
import 'package:astro_prompt/Model/AstrologerUserConsult/coupon_model.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/user_booking_consultation_model.dart';
import 'package:astro_prompt/Model/subscription_payment_model.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:flutter/foundation.dart';

class PaymentService {
  Future<UserBookingConsultation?> consultationVerifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final body = {
        "razorpay_order_id": orderId,
        "razorpay_payment_id": paymentId,
        "razorpay_signature": signature,
      };
      if (kDebugMode) {
        print('Payment Body: $body');
      }
      var response =
          await APIRequest.postRequest(ApiEndpoint.verifyPayment, body);
      if (kDebugMode) {
        print(
            'Payment Response Code: ${response.body}  ${response.statusCode}');
      }
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) {
          print('Payment Data: $data');
        }
        return UserBookingConsultation.fromJson(data);
      } else {
        if (kDebugMode) {
          print("Error-statusCode: ${response.reasonPhrase}");
        }
        return null;
      }
    } catch (e) {
      print('Error Payment: $e');
      return null;
    }
  }

  Future<SubscriptionPaymentVerification?> subscriptionVerifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final body = {
        "razorpay_order_id": orderId,
        "razorpay_payment_id": paymentId,
        "razorpay_signature": signature,
      };

      var response =
          await APIRequest.postRequest(ApiEndpoint.verifyPayment, body);
      print(
          'Subscription Payment Response: ${response.body}  ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SubscriptionPaymentVerification.fromJson(data);
      } else {
        print("Error-statusCode: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print('Error Payment: $e');
      return null;
    }
  }

  Future<SubscriptionPaymentVerification?> subscriptionAutoVerifyPayment({
    required String subscriptionId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final body = {
        "razorpay_subscription_id": subscriptionId,
        "razorpay_payment_id": paymentId,
        "razorpay_signature": signature,
      };

      var response =
          await APIRequest.postRequest(ApiEndpoint.verifyAutoPayment, body);
      print(
          'Auto Subscription Verify Response: ${response.body}  ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SubscriptionPaymentVerification.fromJson(data);
      } else {
        print("Error-statusCode: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print('Error Payment: $e');
      return null;
    }
  }

  Future<CouponModel?> applyCoupon(
      {required String couponName,
      int? planId,
      required String currency,
      required String couponType,
      double? consultationAmount}) async {
    try {
      final body;
      if (planId != null) {
        body = {
          'coupon_name': couponName,
          'plan_id': planId,
          "currency": currency,
          "type": couponType,
          "amount": consultationAmount
        };
      } else {
        body = {
          'coupon_name': couponName,
          "currency": currency,
          "type": couponType,
          "amount": consultationAmount
        };
      }

      var response =
          await APIRequest.postRequest(ApiEndpoint.applyCoupon, body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CouponModel.fromJson(data);
      } else {
        print('Failed to apply coupon: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error applying coupon: $e');
      return null;
    }
  }
}
