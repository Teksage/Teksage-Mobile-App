import 'package:astro_prompt/Components/Dashboard/LoginDialog.dart';
import 'package:astro_prompt/Screens/EventPlanner/event_planner_form_page.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PanchangEventPlannerCta extends StatelessWidget {
  const PanchangEventPlannerCta({super.key});

  Future<void> _open(BuildContext context) async {
    final token = await getAccessToken();
    if (token.isEmpty) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        builder: (_) => const LoginPromptDialog(reDirectHome: true),
      );
      return;
    }
    Get.to(() => const EventPlannerFormPage());
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(util.width20),
          decoration: BoxDecoration(
            color: mainColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: mainColor.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find Event Planner for your event'.tr,
                style: TextStyle(
                  fontFamily: AppFont.get(FontType.semiBold),
                  fontSize: util.fontSize14,
                  color: blackColor,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Personalized 7-day scan for life events'.tr,
                style: TextStyle(
                  fontSize: util.fontSize12,
                  color: blackColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
