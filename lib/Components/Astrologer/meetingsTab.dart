import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class MeetingTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool userPage;
  final int? count;

  const MeetingTabButton(
      {super.key,
      required this.label,
      required this.selected,
      required this.onTap,
      required this.userPage,
      this.count});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? questionButtonColor : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Row(
          children: [
            Text(
              label.tr,
              style: TextStyle(
                color:
                    selected ? whiteColor : blackColor.withValues(alpha: 0.5),
                fontFamily: AppFont.get(FontType.semiBold),
                fontSize: util.fontSize16,
                height: 1.0,
              ),
            ),
            if (userPage) ...[
              SizedBox(
                width: 10,
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: selected ? whiteColor : questionButtonColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  count.toString(),
                  style: TextStyle(
                      fontFamily: 'FontSemiBold',
                      fontSize: util.fontSize14,
                      height: 1.0,
                      color: selected ? questionButtonColor : whiteColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
