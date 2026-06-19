import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userCategory.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userConsultationHomePage.dart';
import 'package:astro_prompt/Services/Astrologer-user/eventsService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class ChatBanner extends StatefulWidget {
  final bool fromChat;
  const ChatBanner({super.key, required this.fromChat});

  @override
  State<ChatBanner> createState() => _ChatBannerState();
}

class _ChatBannerState extends State<ChatBanner> {
  int userId = 0;
  List<AstroConsultationEventModel> eventGetData = [];

  Future<void> fetchUserId() async {
    int? id = await getUserId();
    setState(() {
      userId = id!;
    });
    fetchAstroUserEventService();
  }

  Future<void> fetchAstroUserEventService() async {
    try {
      var fetchEventData =
          await AstroUserEventService().fetchAstroUserEvents(userId);
      var data = fetchEventData
          .where((e) => e.status == 'confirmed' || e.status == 'completed')
          .toList()
        ..sort((a, b) => a.bookingDate.compareTo(b.bookingDate));
      setState(() {
        eventGetData = data;
      });
    } catch (e) {
      print("Error fetching Astro User Event list: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Container(
      width: util.width,
      padding: EdgeInsets.symmetric(horizontal: util.width10),
      // height: util.responsiveHeight(0.0806),
      decoration: BoxDecoration(
        borderRadius: !widget.fromChat ? BorderRadius.circular(12) : null,
        border: Border.all(
            width: util.responsiveWidth(0.0055), color: homeBannerBorder),
        color: homeBanner,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            children: [
              SvgPicture.asset(chatBanner),
              Padding(
                padding: EdgeInsets.only(
                    top: util.responsiveWidth(0.004), left: util.width12),
                child: Image.asset(
                  'assets/images/test.png',
                  width: util.responsiveWidth(0.125),
                ),
              ),
            ],
          ),
          Text(
            PlatformTextConfig.chatBanner.tr,
            maxLines: 2,
            style: TextStyle(
                fontFamily: AppFont.get(FontType.bold),
                fontSize: util.fontSize14,
                height: util.lineHeight16_8 / util.fontSize14,
                color: Color(0xff3a3b00)),
          ),
          GestureDetector(
            onTap: () {
              if (eventGetData.isNotEmpty) {
                Get.to(() => UserConsultationDetailsHome(
                      backButton: true,
                      eventData: eventGetData,
                    ));
              } else {
                Get.to(() => UserCategoryPage(
                      toHome: false,
                    ));
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: util.responsiveWidth(0.0294),
                  vertical: util.responsiveWidth(0.0107)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(util.width30),
                  color: whiteColor),
              child: Text(
                'Book Now'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    fontSize: util.fontSize11,
                    height: util.lineHeight13_2 / util.fontSize11,
                    color: Color(0xff0E0D0C)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
