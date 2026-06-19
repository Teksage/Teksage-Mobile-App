import 'dart:convert';
import 'package:astro_prompt/Model/notification_model.dart';
import 'package:astro_prompt/Model/weekly_prediction_model.dart';
import 'package:astro_prompt/Screens/Notification/notificationPage.dart';
import 'package:astro_prompt/Screens/prediction/dailyPrediction.dart';
import 'package:astro_prompt/Screens/prediction/weeklyPrediction.dart';
import 'package:astro_prompt/Services/NotificationService/firebaseService.dart';
import 'package:astro_prompt/Services/PredictionService/predictionService.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static bool shouldRefreshGeneralNotifications = false;

  static VoidCallback? onGeneralNotificationReceived;

  /// Call this during app initialization
  static Future<void> init() async {
    FirebaseMessaging.instance.setAutoInitEnabled(true);
    debugPrint('[NotificationService] Auto-init enabled');

    await _requestPermissions();
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('[NotificationService] Foreground presentation options set for iOS');

    await _initializeLocalNotifications();
    _listenToMessages();
    await _checkInitialMessage();
  }

  static Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('FCM Permission status: ${settings.authorizationStatus}');
  }

  static Future<void> generateFcmToken() async {
    try {
      final fcmToken = await _firebaseMessaging.getToken();

      if (fcmToken != null && fcmToken.isNotEmpty) {
        final result = await NotificationFirebaseService().saveFcmToken(fcmToken);
        debugPrint('[NotificationService] FCM Token saved to backend: ${result['status']}');
      } else {
        debugPrint('[NotificationService] FCM token is null or empty');
      }
    } catch (e) {
      debugPrint('[NotificationService] Error generating FCM token: $e');
    }
  }

  static void _listenToMessages() {
    bool premiumUser = false;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // ✅ Extract 'type' from 'data'
      final type = message.data['type'];
      debugPrint('[NotificationService] Extracted type: $type');

      if (notification != null && android != null) {
        debugPrint('[NotificationService] 🔔 Foreground message received');
        // 🔍 Log everything for debugging
        debugPrint('[NotificationService] Raw message: ${message.toMap()}');
        debugPrint('[NotificationService] Data: ${message.data}');
        debugPrint('[NotificationService] Notification: ${notification.title}');

        _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel',
              'Default',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(),
          ),
          payload: notification.title,
        );
        debugPrint('[NotificationService] Local notification shown in foreground');
        final title = notification.title;
        debugPrint('TitleNotify: $title');
        if (title == 'Daily Wisdom') {
          premiumUser = await getUserPremium();
          Map<String, dynamic> predictions = await PredictionService.getDailyPrediction();
          Get.to(() => DailyPrediction(predictionsData: predictions, premiumUser: premiumUser));
        } else if (title == 'Weekly Insights') {
          Future<({int predictionId, List<WeeklyPredictionModel> predictions})>? weeklyPredictions;
          final data = await weeklyPredictions!;
          Get.to(() => WeeklyPrediction(weeklyPrediction: data));
        } else {
          Get.to(() => NotificationPage(
                selectedTab: 1,
              ));
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint('[NotificationService] 🔁 App opened via notification');
      debugPrint('[NotificationService] message.data: ${message.data}');

      final type = message.data['type']; // Use data here too
      debugPrint('[NotificationService] Opened notification type: $type');
      debugPrint('Title: ${message.notification?.title}');

      if (message.notification?.title == 'Daily Wisdom') {
        premiumUser = await getUserPremium();
        Map<String, dynamic> predictions = await PredictionService.getDailyPrediction();
        Get.to(() => DailyPrediction(predictionsData: predictions, premiumUser: premiumUser));
      } else if (message.notification?.title == 'Weekly Insights') {
        Future<({int predictionId, List<WeeklyPredictionModel> predictions})>? weeklyPredictions;
        final data = await weeklyPredictions!;
        Get.to(() => WeeklyPrediction(weeklyPrediction: data));
      } else {
        Get.to(() => NotificationPage(
              selectedTab: 1,
            ));
      }
    });
  }

  static Future<void> _initializeLocalNotifications() async {
    bool premiumUser = false;
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        debugPrint(
            "[NotificationService] Notification tapped : ${response.data} <=> ${response.notificationResponseType} <=> payload: ${response.payload}");
        if (response.payload == 'Daily Wisdom') {
          premiumUser = await getUserPremium();
          Map<String, dynamic> predictions = await PredictionService.getDailyPrediction();
          Get.to(() => DailyPrediction(predictionsData: predictions, premiumUser: premiumUser));
        } else if (response.payload == 'Weekly Insights') {
          Future<({int predictionId, List<WeeklyPredictionModel> predictions})>? weeklyPredictions;
          final data = await weeklyPredictions!;
          Get.to(() => WeeklyPrediction(weeklyPrediction: data));
        } else {
          // NotificationService.shouldRefreshGeneralNotifications = true;
          Get.to(() => NotificationPage(
                selectedTab: 1,
              ));
        }
      },

      // onDidReceiveNotificationResponse: (payload) {
      //   debugPrint("User tapped on notification: $payload");
      // },
    );

    const androidChannel = AndroidNotificationChannel(
      'default_channel',
      'Default',
      description: 'Default notification channel',
      importance: Importance.high,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    debugPrint('[NotificationService] Local notifications initialized and channel created');
  }

  static Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("[NotificationService] 📦 App opened from terminated state via notification");
      debugPrint("[NotificationService] Data: ${initialMessage.data}");
    } else {
      debugPrint("[NotificationService] No initial notification found");
    }
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    var response = await APIRequest.getRequest(ApiEndpoint.getNotification);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['notifications'] != null) {
        return (decoded['notifications'] as List).map((item) => NotificationModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load notifications: ${response.reasonPhrase}');
    }
  }

  Future<String> updateNotificationStatus(List<int> readIds) async {
    try {
      final body = {
        'read_ids': readIds,
      };
      var response = await APIRequest.postRequest(ApiEndpoint.updateNotification, body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['message'];
      } else {
        throw Exception('Failed to update status: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error updating notification status: $e');
    }
  }

  Future<String> clearAllNotification() async {
    try {
      final body = {
        'clear_notifications': true,
      };
      var response = await APIRequest.postRequest(ApiEndpoint.updateNotification, body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['message'];
      } else {
        throw Exception('Failed to update status: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error updating notification status: $e');
    }
  }
}
