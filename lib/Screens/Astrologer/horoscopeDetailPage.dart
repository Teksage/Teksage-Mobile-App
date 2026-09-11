import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Components/Horoscope/horoscopeChart.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astrologer_consult_event_model.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';


class HoroscopeDetailsPage extends StatefulWidget {
  final UserHoroscope horoscope;
  final String fullName;
  final int? eventId;
  const HoroscopeDetailsPage(
      {super.key,
      required this.horoscope,
      required this.fullName,
      this.eventId});

  @override
  State<HoroscopeDetailsPage> createState() => _HoroscopeDetailsPageState();
}

class _HoroscopeDetailsPageState extends State<HoroscopeDetailsPage> {
  DateTime? parsedDob;
  String? formatedDob;

  DateTime? parsedTob;
  String? formatedTob;

  @override
  void initState() {
    super.initState();
    parsedDob = DateTime.parse(widget.horoscope.dateOfBirth);
    formatedDob = DateFormat("MMM dd, yyyy").format(parsedDob!);

    parsedTob = DateFormat("HH:mm:ss").parse(widget.horoscope.timeOfBirth);
    formatedTob = DateFormat("hh:mm:ss a").format(parsedTob!);
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Horoscope Details".tr,
            style: TextStyle(
                color: blackColor,
                fontSize: util.fontSize20,
                fontFamily: AppFont.get(FontType.bold),
                height: 1.0)),
        leading: SizedBox(
          width: util.responsiveWidth(0.08),
          height: util.responsiveHeight(0.037),
          child: IconButton(
            icon: SvgPicture.asset(
              backButton,
              width: util.width20,
              height: util.height20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Divider(
                thickness: 1,
                color: blackColor.withValues(alpha: 0.3),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: EdgeInsets.all(util.width20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: mainColor.withValues(alpha: 0.3), width: 3)),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: util.width10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: util.width / 3,
                            child: Text(
                              'Name'.tr,
                              style: TextStyle(
                                  fontFamily: 'FontSemiBold',
                                  fontSize: util.fontSize14,
                                  height: 1.0,
                                  color: Color(0xff719600)),
                            ),
                          ),
                          Expanded(
                              child: Text(widget.fullName,
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.2,
                                      color: blackColor)))
                        ],
                      ),
                    ),
                    DashedLine(
                      dashWidth: 3,
                      color: blackColor.withValues(alpha: 0.3),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: util.width10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: util.width / 3,
                            child: Text(
                              'Date of Birth'.tr,
                              style: TextStyle(
                                  fontFamily: 'FontSemiBold',
                                  fontSize: util.fontSize14,
                                  height: 1.0,
                                  color: Color(0xff719600)),
                            ),
                          ),
                          Expanded(
                            child: Text(formatedDob!,
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: util.fontSize14,
                                    height: 1.2,
                                    color: blackColor)),
                          )
                        ],
                      ),
                    ),
                    DashedLine(
                      dashWidth: 3,
                      color: blackColor.withValues(alpha: 0.3),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: util.width10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: util.width / 3,
                            child: Text(
                              'Time of Birth'.tr,
                              style: TextStyle(
                                  fontFamily: 'FontSemiBold',
                                  fontSize: util.fontSize14,
                                  height: 1.0,
                                  color: Color(0xff719600)),
                            ),
                          ),
                          Expanded(
                            child: Text(formatedTob!,
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: util.fontSize14,
                                    height: 1.2,
                                    color: blackColor)),
                          )
                        ],
                      ),
                    ),
                    DashedLine(
                      dashWidth: 3,
                      color: blackColor.withValues(alpha: 0.3),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: util.width10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: util.width / 3,
                            child: Text(
                              'Place'.tr,
                              style: TextStyle(
                                  fontFamily: 'FontSemiBold',
                                  fontSize: util.fontSize14,
                                  height: 1.0,
                                  color: Color(0xff719600)),
                            ),
                          ),
                          Expanded(
                            child: Text(widget.horoscope.placeOfBirth,
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: util.fontSize14,
                                    height: 1.2,
                                    color: blackColor)),
                          )
                        ],
                      ),
                    ),
                    DashedLine(
                      dashWidth: 3,
                      color: blackColor.withValues(alpha: 0.3),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: util.width10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: util.width / 3,
                            child: Text(
                              'Rasi'.tr,
                              style: TextStyle(
                                  fontFamily: 'FontSemiBold',
                                  fontSize: util.fontSize14,
                                  height: 1.0,
                                  color: Color(0xff719600)),
                            ),
                          ),
                          Expanded(
                            child: Text(widget.horoscope.rashi,
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: util.fontSize14,
                                    height: 1.2,
                                    color: blackColor)),
                          )
                        ],
                      ),
                    ),
                    DashedLine(
                      dashWidth: 3,
                      color: blackColor.withValues(alpha: 0.3),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: util.width10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: util.width / 3,
                            child: Text(
                              'Nakshatram'.tr,
                              style: TextStyle(
                                  fontFamily: 'FontSemiBold',
                                  fontSize: util.fontSize14,
                                  height: 1.0,
                                  color: Color(0xff719600)),
                            ),
                          ),
                          Expanded(
                            child: Text(widget.horoscope.nakshatra,
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: util.fontSize14,
                                    height: 1.2,
                                    color: blackColor)),
                          )
                        ],
                      ),
                    ),
                    DashedLine(
                      dashWidth: 3,
                      color: blackColor.withValues(alpha: 0.3),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: util.width10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: util.width / 3,
                            child: Text(
                              'Lagna'.tr,
                              style: TextStyle(
                                  fontFamily: 'FontSemiBold',
                                  fontSize: util.fontSize14,
                                  height: 1.0,
                                  color: Color(0xff719600)),
                            ),
                          ),
                          Expanded(
                            child: Text(widget.horoscope.lagna,
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: util.fontSize14,
                                    height: 1.2,
                                    color: blackColor)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  ChartWidget(htmlChart: widget.horoscope.rasiChart),
                  SizedBox(
                    height: 10,
                  ),
                  ChartWidget(htmlChart: widget.horoscope.navamsaChart),
                ],
              ),
              if (widget.eventId != null) ...[
                SizedBox(height: util.height20),
                _FullHoroscopeWebEntry(eventId: widget.eventId!),
              ],
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Opens website Full Horoscope for this consultation (astrologer must be logged in on web).
class _FullHoroscopeWebEntry extends StatelessWidget {
  final int eventId;
  const _FullHoroscopeWebEntry({required this.eventId});

  static const _origin = 'https://www.teksage.app';

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse('$_origin/astrologer/meetings/$eventId/horoscope');
    final ok = await canLaunchUrl(uri) &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      showInfoSnackBar(context, 'Could not open Full Horoscope');
    }
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
          vertical: util.responsiveHeight(0.016),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [eventPlannerBannerTop, eventPlannerBannerBottom],
          ),
          border: Border.all(color: eventPlannerBannerBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: whiteColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.grid_view_rounded, size: 20, color: mainColor),
            ),
            SizedBox(width: util.width12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Full Horoscope'.tr,
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      fontSize: util.fontSize14,
                      color: blackColor,
                    ),
                  ),
                  Text(
                    'Dasa, Shadbala, Ashtavarga & more'.tr,
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.medium),
                      fontSize: util.fontSize12,
                      color: panchangHeading,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Open'.tr,
              style: TextStyle(
                fontFamily: AppFont.get(FontType.semiBold),
                fontSize: util.fontSize12,
                color: mainColor,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward, size: 16, color: mainColor),
          ],
        ),
      ),
    );
  }
}
