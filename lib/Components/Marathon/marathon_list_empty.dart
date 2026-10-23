import 'package:astro_prompt/Components/Marathon/marathon_flow_widgets.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Empty AstroConnect Pro tab: calendar mark, title, and a short hint.
class MarathonListEmpty extends StatelessWidget {
  const MarathonListEmpty({super.key, required this.upcoming});

  final bool upcoming;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final title = upcoming
        ? 'No AstroConnect Pro event is open right now.'.tr
        : 'No past AstroConnect Pro events yet.'.tr;
    final hint = upcoming
        ? 'A new session will appear here when the next date is announced.'.tr
        : 'Sessions that have already finished will be listed here.'.tr;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: blackColor.withValues(alpha: 0.06)),
        boxShadow: const [
          BoxShadow(color: Color(0x0F101810), blurRadius: 28, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Color.alphaBlend(mainColor.withValues(alpha: 0.14), whiteColor),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.calendar_today_outlined, color: mainColor, size: 26),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: marathonText(util, FontType.bold, size: util.fontSize18, height: 1.25),
          ),
          const SizedBox(height: 8),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: marathonText(util, FontType.medium, size: util.fontSize14, color: blackColor.withValues(alpha: 0.5), height: 1.35),
          ),
        ],
      ),
    );
  }
}
