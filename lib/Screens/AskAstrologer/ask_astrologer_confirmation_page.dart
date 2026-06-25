import 'package:astro_prompt/Screens/Chat/chat.dart';
import 'package:astro_prompt/Screens/Notification/notificationPage.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/LocallySavedData/askAstrologerFlow.dart';
import 'package:astro_prompt/config/ask_astrologer_flow_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AskAstrologerConfirmationPage extends StatefulWidget {
  const AskAstrologerConfirmationPage({super.key});

  @override
  State<AskAstrologerConfirmationPage> createState() =>
      _AskAstrologerConfirmationPageState();
}

class _AskAstrologerConfirmationPageState
    extends State<AskAstrologerConfirmationPage> with AskAstrologerFlowScreenMixin {
  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(util.width20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: homeBanner, size: 64),
              SizedBox(height: 24),
              Text('You are all set!'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: AppFont.get(FontType.bold),
                      fontSize: util.fontSize22)),
              SizedBox(height: 12),
              Text(
                'Your question is with our team. An expert astrologer will answer within 4 hours.'
                    .tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: util.fontSize14,
                    color: blackColor.withValues(alpha: 0.7)),
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: blackColor.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Status'.tr,
                        style: TextStyle(color: blackColor.withValues(alpha: 0.5))),
                    Text('Received'.tr,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.semiBold),
                            color: homeBanner)),
                  ],
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  await clearAskAstrologerFlow();
                  Get.off(() => const NotificationPage(selectedTab: 1));
                },
                child: Text(
                  'Track in Notifications → Consultation'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: util.fontSize13,
                    color: homeBanner,
                    fontFamily: AppFont.get(FontType.semiBold),
                    decoration: TextDecoration.underline,
                    decorationColor: homeBanner,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(util.width20),
          child: ElevatedButton(
            onPressed: () async {
              await clearAskAstrologerFlow();
              Get.offAll(() => AIChatScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: homeBanner,
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: Text('Back to Chat'.tr,
                style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    color: whiteColor)),
          ),
        ),
      ),
    );
  }
}
