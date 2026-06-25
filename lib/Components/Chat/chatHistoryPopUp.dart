import 'dart:ui';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class ChatHistoryDialog extends StatelessWidget {
  const ChatHistoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withValues(alpha: 0.1)),
          ),
        ),
        Center(
          child: SizedBox(
            width: util.responsiveWidth(0.9),
            child: Dialog(
              backgroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(util.width12),
              ),
              child: Padding(
                padding: EdgeInsets.all(util.width20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(chatHistory),
                    SizedBox(height: util.height20),
                    Text(
                      "Chat history\nwill be cleared every 1 hour",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: util.fontSize16,
                        fontFamily: AppFont.get(FontType.semiBold),
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: util.responsiveWidth(0.048)),
                    _buildActionButton(
                      context: context,
                      text: 'Keep My Chats for 1 Day',
                      color: mainColor,
                      textColor: whiteColor,
                      util: util,
                      returnValue: '1d',
                    ),
                    SizedBox(height: 12),
                    _buildActionButton(
                      context: context,
                      text: 'I don\'t need it',
                      color: const Color(0xffebebeb),
                      textColor: blackColor.withValues(alpha: 0.7),
                      util: util,
                      returnValue: '1h',
                    ),
                    SizedBox(height: util.height10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String text,
    required Color color,
    required Color textColor,
    required MyUtility util,
    required String returnValue,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, returnValue),
      child: Container(
        width: util.width,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(util.width30),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFont.get(FontType.semiBold),
            fontSize: util.fontSize16,
            height: 1.0,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
