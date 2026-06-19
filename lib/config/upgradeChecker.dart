import 'package:flutter/services.dart';

class UpdateChecker {
  static const platform = MethodChannel("com.venzo.astroPrompt/update");

  static Future<bool> isUpdateAvailable() async {
    try {
      final result = await platform.invokeMethod("checkForUpdate");
      print("🔎 Native update check result: $result");
      return result == true;
    } on PlatformException catch (e) {
      print("❌ Failed to check update: ${e.message}");
      return false;
    }
  }
}

