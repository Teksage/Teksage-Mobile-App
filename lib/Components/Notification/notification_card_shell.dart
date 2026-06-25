import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';

/// Shared notification list card — matches consultation appointment row styling.
class NotificationCardShell extends StatelessWidget {
  final Widget child;
  final bool emphasized;

  const NotificationCardShell({
    super.key,
    required this.child,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Container(
      margin: EdgeInsets.only(bottom: util.height10),
      padding: EdgeInsets.symmetric(
        horizontal: util.width10,
        vertical: util.width20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: emphasized ? whiteColor : notEditable,
        border: Border.all(
          color: emphasized
              ? mainColor.withValues(alpha: 0.25)
              : blackColor.withValues(alpha: 0.04),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

class NotificationCircleAvatar extends StatelessWidget {
  final String? imageUrl;

  const NotificationCircleAvatar({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 41,
      height: 41,
      decoration: BoxDecoration(
        color: lightGrey,
        shape: BoxShape.circle,
        border: Border.all(
          color: astroUserConsultBG.withValues(alpha: 0.3),
          width: 2.6,
        ),
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(imageUrl!, fit: BoxFit.cover)
            : Center(
                child: Image.asset(dummyImage, width: 25, height: 25),
              ),
      ),
    );
  }
}

class NotificationActionPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const NotificationActionPill({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(util.width20),
          color: astroUserConsultBG,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 9,
            horizontal: util.width12,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.semiBold),
              fontSize: util.fontSize12,
              height: 1.0,
              color: whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationSectionLabel extends StatelessWidget {
  final String label;

  const NotificationSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: util.fontSize12,
        color: blackColor.withValues(alpha: 0.45),
        fontFamily: AppFont.get(FontType.semiBold),
      ),
    );
  }
}
