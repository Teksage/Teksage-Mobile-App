import 'package:astro_prompt/Components/Dashboard/LoginDialog.dart';
import 'package:astro_prompt/Screens/EventPlanner/event_planner_form_page.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventPlannerHomeBanner extends StatelessWidget {
  const EventPlannerHomeBanner({super.key});

  Future<void> _open(BuildContext context) async {
    final token = await getAccessToken();
    if (token.isEmpty) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        builder: (_) => const LoginPromptDialog(reDirectHome: false),
      );
      return;
    }
    Get.to(() => const EventPlannerFormPage());
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: util.width20,
          vertical: util.responsiveHeight(0.018),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(util.width20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              eventPlannerBannerTop,
              eventPlannerBannerBottom,
            ],
          ),
          border: Border.all(color: eventPlannerBannerBorder),
          boxShadow: [
            BoxShadow(
              color: blackColor.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Planner'.tr,
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.bold),
                      fontSize: util.fontSize14,
                      color: blackColor.withValues(alpha: 0.5),
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Plan Now'.tr,
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      fontSize: util.fontSize12,
                      color: blackColor.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.event_available_rounded, color: mainColor, size: 32),
          ],
        ),
      ),
    );
  }
}
