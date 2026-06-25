import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class AlarmPermissionHelper {
  static const MethodChannel _channel = MethodChannel('com.venzo.astroPrompt/alarm');

  static Future<bool> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 31) {
        try {
          // Check if exact alarm permission is granted
          final bool hasPermission = await _channel.invokeMethod('canScheduleExactAlarms');
          if (!hasPermission) {
            // Permission not granted, open settings page
            const intent = AndroidIntent(
              action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
            );
            await intent.launch();

            // Wait for user to return and re-check permission
            await Future.delayed(const Duration(seconds: 3));

            // Re-check the permission status
            final bool afterIntentPermission = await _channel.invokeMethod('canScheduleExactAlarms');
            return afterIntentPermission;  // Return true if granted after return
          }
          return true;  // Permission already granted
        } on PlatformException catch (e) {
          print("Error checking exact alarm permission: ${e.message}");
        }
      }
    }
    return false;  // Default for unsupported or no permission needed
  }
}
