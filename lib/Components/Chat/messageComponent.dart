import 'dart:async';
import 'dart:io';
import 'package:astro_prompt/Components/Chat/chatAudioPlayer.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class MessageComponent extends StatefulWidget {
  final String text;
  final String sender;
  final String? profilePic;
  final dynamic audio;
  final String? messageMode;

  const MessageComponent({
    super.key,
    required this.text,
    required this.sender,
    this.profilePic,
    this.audio,
    this.messageMode,
  });

  @override
  State<MessageComponent> createState() => _MessageComponentState();
}

class _MessageComponentState extends State<MessageComponent> {
  bool showLoader = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if ((widget.messageMode == 'audio' || widget.messageMode == 'hybrid') &&
        widget.audio == null) {
      showLoader = true;
      _timer = Timer(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            showLoader = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final bool isUser = widget.sender == "user";
    final String initials = widget.profilePic ?? "AP";

    final bool hasAudio =
        widget.audio is String && widget.audio.toString().isNotEmpty;

    return Container(
      // color: Colors.amber,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Row(
              children: [
                Platform.isAndroid
                    ? SvgPicture.asset(botLogo)
                    : Image.asset(iosBotIcon),
                SizedBox(width: util.width8),
              ],
            ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: util.width12, vertical: util.width10),
              constraints: BoxConstraints(
                maxWidth: util.responsiveWidth(0.65),
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? (Platform.isAndroid ? lightGrey : whiteColor)
                    : (Platform.isAndroid ? mainColor : iosMainColor),
                borderRadius:
                    BorderRadius.circular(util.responsiveWidth(0.0369)),
                border: isUser
                    ? Border.all(
                        width: 1,
                        color: blackColor.withValues(alpha: 0.1),
                      )
                    : null,
              ),
              child: Column(
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: isUser ? blackColor : whiteColor,
                      fontFamily: AppFont.get(FontType.medium),
                      fontSize: util.fontSize16,
                      height: util.lineHeight21_6 / util.fontSize16,
                    ),
                  ),
                  if (!isUser) ...[
                    if (showLoader)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Center(
                            child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: whiteColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1,
                              color: whiteColor.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Text(
                            'Converting this \ninto speech for you…',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'FontSemiBold',
                                fontSize: util.fontSize13,
                                color: whiteColor),
                          ),
                        )),
                      )
                    else if (hasAudio)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: ChatAudioPlayer(audioBase64: widget.audio!),
                      ),
                  ]
                ],
              ),
            ),
          ),
          if (isUser)
            Row(
              children: [
                SizedBox(width: util.width8),
                Container(
                  width: util.responsiveWidth(0.0855),
                  height: util.responsiveHeight(0.0395),
                  decoration: BoxDecoration(
                    color: Platform.isAndroid ? lightGrey : whiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: util.responsiveWidth(0.007),
                      color: Platform.isAndroid
                          ? mainColor.withValues(alpha: 0.3)
                          : iosMainColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: TextStyle(
                          color: Platform.isAndroid ? mainColor : iosMainColor,
                          fontSize: util.fontSize14,
                          fontFamily: 'FontSemiBold'),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
