import 'dart:ui';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class DownloadSuccessDialog extends StatelessWidget {
  final String title;
  final String? file;
  const DownloadSuccessDialog({super.key, required this.title, this.file});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.5735)}');
    // print('Height: ${util.responsiveHeight(0.234)}');
    // print('FontSize: ${util.responsiveFontSize(0.022)}');

    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withValues(alpha: 0.5),
            // color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
        Dialog(
          child: Container(
            padding: EdgeInsets.all(util.width10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(util.width12),
              color: whiteColor,
            ),
            width: util.responsiveWidth(0.5735),
            height: util.responsiveHeight(0.234),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (file != null) {
                      Get.back();
                      await OpenFile.open(file);
                      Get.back();
                    } else {
                      Get.back();
                    }
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset(closeButton),
                  ),
                ),
                SvgPicture.asset(successDownload),
                SizedBox(height: util.responsiveHeight(0.0235)),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "FontBold",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
