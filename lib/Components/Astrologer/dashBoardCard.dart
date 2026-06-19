import 'package:astro_prompt/Components/Common/customAnimationImage.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Screens/Astrologer/myAvailabilityPage.dart';
import 'package:astro_prompt/Screens/Astrologer/myMeetingsPage.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/LocallySavedData/appLanguage.dart';

class DashboardCards extends StatefulWidget {
  final List<AstroConsultationEventModel> eventData;
  const DashboardCards({super.key, required this.eventData});

  @override
  State<DashboardCards> createState() => _DashboardCardsState();
}

class _DashboardCardsState extends State<DashboardCards> {
  String currentLanguage = 'english';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    String lang = await getAppLanguage();
    if (mounted) {
      setState(() {
        currentLanguage = lang.isEmpty ? 'english' : lang;
      });
    }
  }

  double _getCardHeight(BuildContext context) {
    final util = MyUtility(context);

    switch (currentLanguage) {
      case 'tamil':
        return util.responsiveHeight(0.280);
      case 'kannada':
         return util.responsiveHeight(0.245);
      case 'malayalam':
        return util.responsiveHeight(0.260);
      case 'telugu':
        return util.responsiveHeight(0.230);
      case 'hindi':
      case 'marathi':
        return util.responsiveHeight(0.220);
      case 'english':
      default:
        return util.responsiveHeight(0.230);
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Height: ${util.responsiveHeight(0.205)}');

    return SizedBox(
      width: util.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildCard(
                title: 'Meetings',
                subtitle: 'View your scheduled appointments & completed ones',
                imagePath: astroMeeting,
                context: context,
                onTap: () {
                  Get.to(() => MyMeetingsPage(
                        eventData: widget.eventData,
                      ));
                }),
          ),
          SizedBox(
            width: MyUtility(context).width20,
          ),
          Expanded(
            child: _buildCard(
                title: 'My Availability',
                subtitle: 'Set your available time slots.',
                imagePath: astroCalender,
                context: context,
                onTap: () {
                  Get.to(() => MyAvailabilityPage());
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // width: MyUtility(context).responsiveWidth(0.3842),
        // Dynamic height based on selected language
        height: _getCardHeight(context),
        decoration: BoxDecoration(
            color: Color(0xffFAFFDE),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: blackColor.withValues(alpha: 0.06), width: 1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  Text(
                    title.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: AppFont.get(FontType.bold),
                        fontSize: MyUtility(context).fontSize16,
                        height: 1.0,
                        color: blackColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: AppFont.get(FontType.semiBold),
                        fontSize: MyUtility(context).fontSize13,
                        height: 1.3,
                        color: blackColor.withValues(alpha: 0.4)),
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 40,
                  child: ClipPath(
                    clipper: TopCurveClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffa2be35),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                // The icon/image
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(bottom: 5),
                  child: CustomAnimationAstrologerIcon(
                    imagePath: imagePath,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 20);
    path.quadraticBezierTo(size.width / 2, -20, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
