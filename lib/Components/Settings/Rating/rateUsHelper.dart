import 'package:astro_prompt/Components/Settings/Rating/ratingPromptDialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class RateUsHelper {
  static const String packageName = "com.venzo.astroPrompt";

  static Future<void> showRatingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => RatingPromptDialog(
        onRateNow: () {
          Get.back();
          openStore();
        },
      ),
    );
  }

  static Future<void> openStore() async {
    final Uri playStoreUri = Uri.parse("market://details?id=$packageName");
    final Uri webStoreUri = Uri.parse("https://play.google.com/store/apps/details?id=$packageName");

    try {
      if (!await launchUrl(playStoreUri, mode: LaunchMode.externalApplication)) {
        await launchUrl(webStoreUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      await launchUrl(webStoreUri, mode: LaunchMode.externalApplication);
    }
  }
}
