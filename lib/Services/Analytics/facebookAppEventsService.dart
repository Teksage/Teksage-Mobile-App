import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';

/// Meta / Facebook App Events wrapper.
/// Replace the Client Token in native config before release.
class FacebookAppEventsService {
  FacebookAppEventsService._();
  static final FacebookAppEventsService instance = FacebookAppEventsService._();

  final FacebookAppEvents _fb = FacebookAppEvents();
  bool _activated = false;

  Future<void> activate() async {
    if (_activated) return;
    try {
      // 0.20.x has no activateApp(); native SDK auto-logs ActivateApp when configured.
      await _fb.setAutoLogAppEventsEnabled(true);
      await _fb.getApplicationId();
      _activated = true;
    } catch (e) {
      if (kDebugMode) {
        print('Facebook activate failed (check Client Token): $e');
      }
    }
  }

  Future<void> setUserId(String userId) async {
    try {
      await _fb.setUserID(userId);
    } catch (e) {
      if (kDebugMode) print('Facebook setUserID failed: $e');
    }
  }

  Future<void> clearUserId() async {
    try {
      await _fb.clearUserID();
    } catch (e) {
      if (kDebugMode) print('Facebook clearUserID failed: $e');
    }
  }

  Future<void> logCompletedRegistration({String method = 'otp'}) async {
    try {
      await _fb.logCompletedRegistration(registrationMethod: method);
    } catch (e) {
      if (kDebugMode) print('Facebook CompleteRegistration failed: $e');
    }
  }

  Future<void> logViewContent({
    required String contentId,
    required String contentType,
  }) async {
    try {
      await _fb.logViewContent(
        id: contentId,
        type: contentType,
      );
    } catch (e) {
      if (kDebugMode) print('Facebook ViewContent failed: $e');
    }
  }

  Future<void> logInitiatedCheckout({
    required String contentId,
    required String contentType,
    required double totalPrice,
    required String currency,
  }) async {
    try {
      await _fb.logInitiatedCheckout(
        totalPrice: totalPrice,
        currency: currency,
        contentId: contentId,
        contentType: contentType,
        numItems: 1,
        paymentInfoAvailable: true,
      );
    } catch (e) {
      if (kDebugMode) print('Facebook InitiateCheckout failed: $e');
    }
  }

  Future<void> logPurchase({
    required double amount,
    required String currency,
    String? contentId,
    String? contentType,
  }) async {
    try {
      await _fb.logPurchase(
        amount: amount,
        currency: currency,
        parameters: {
          if (contentId != null) 'fb_content_id': contentId,
          if (contentType != null) 'fb_content_type': contentType,
        },
      );
    } catch (e) {
      if (kDebugMode) print('Facebook Purchase failed: $e');
    }
  }

  Future<void> logSubscribe({
    String? orderId,
    String currency = 'INR',
    double price = 0,
  }) async {
    try {
      await _fb.logSubscribe(
        orderId: orderId ?? 'subscription',
        currency: currency,
        price: price,
      );
    } catch (e) {
      if (kDebugMode) print('Facebook Subscribe failed: $e');
    }
  }

  Future<void> logSchedule() async {
    try {
      await _fb.logEvent(name: 'Schedule');
    } catch (e) {
      if (kDebugMode) print('Facebook Schedule failed: $e');
    }
  }

  Future<void> logRate({
    required double value,
    double maxRatingValue = 5,
    String contentType = 'consultation',
  }) async {
    try {
      await _fb.logRated(valueToSum: value);
    } catch (e) {
      if (kDebugMode) print('Facebook Rate failed: $e');
    }
  }
}
