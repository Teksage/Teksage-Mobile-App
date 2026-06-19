import 'dart:ui';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class UpdateRequiredDialog extends StatelessWidget {
  const UpdateRequiredDialog({super.key});

  Future<void> _redirectToStore() async {
    const url =
        "https://play.google.com/store/apps/details?id=com.venzo.astroPrompt";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Stack(
      children: [
        // Background blur
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
        ),
        // Dialog box
        Center(
          child: SizedBox(
            width: util.responsiveWidth(0.8),
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(util.width12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(util.width12),
                  color: whiteColor,
                ),
                padding: EdgeInsets.all(util.width10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      "Update Required",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: util.fontSize18,
                        fontFamily: AppFont.get(FontType.semiBold),
                        height: 1.2,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: util.responsiveWidth(0.04)),

                    // Body text
                    Text(
                      "Your planetary journey just got smoother 🪐.\nUpdate now for an enhanced Teksage experience.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: util.fontSize16,
                        fontFamily: AppFont.get(FontType.regular),
                        height: 1.3,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: util.responsiveWidth(0.06)),

                    // Action button
                    GestureDetector(
                      onTap: _redirectToStore,
                      child: Container(
                        width: util.width / 1.8,
                        padding: EdgeInsets.symmetric(
                          horizontal: util.responsiveWidth(0.0375),
                          vertical: util.responsiveWidth(0.0188),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(util.width30),
                          color: mainColor,
                        ),
                        child: Text(
                          'Unlock Celestial Insights',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.semiBold),
                            fontSize: util.fontSize16,
                            height: 1.0,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: util.responsiveWidth(0.02)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
