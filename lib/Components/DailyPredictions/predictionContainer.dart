import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class PredictionContainer extends StatefulWidget {
  final String title;
  final List<String> data;
  const PredictionContainer(
      {super.key, required this.title, required this.data});

  @override
  State<PredictionContainer> createState() => _PredictionContainerState();
}

class _PredictionContainerState extends State<PredictionContainer> {
  static const Map<String, dynamic> design = {
    'career': {
      'icon': career,
      'color': Color(0xFFE2EAFB),
      'headColor': Color(0xFF30569F)
    },
    'relationship': {
      'icon': relationship,
      'color': Color(0xFFFFEAF8),
      'headColor': Color(0xFFFFFFFF)
    },
    'wealth': {
      'icon': wealth,
      'color': Color(0xFFFBEEE2),
      'headColor': Color(0xFFFF9C00)
    },
    'health': {
      'icon': health,
      'color': Color(0xFFE6E2FB),
      'headColor': Color(0xFF7E6DED)
    },
  };

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final designData = design[widget.title.toLowerCase()];
    // print('Height: ${util.responsiveHeight(0.0237)}');
    // print('FontSize: ${util.responsiveFontSize(0.027)}');

    return Column(
      children: [
        Container(
          width: util.width,
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border(
              left: BorderSide(
                  color: blackColor.withValues(alpha: 0.05), width: 1),
              right: BorderSide(
                  color: blackColor.withValues(alpha: 0.05), width: 1),
              bottom: BorderSide(
                  color: blackColor.withValues(alpha: 0.05), width: 1),
            ),
            borderRadius: BorderRadius.circular(util.width20),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min, // Prevents unnecessary empty space
                children: [
                  // Title Bar
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: util.width20, vertical: util.width12),
                    width: util.width,
                    decoration: BoxDecoration(
                      color: designData['color'],
                      border: Border(
                        top: BorderSide(
                            color: blackColor.withValues(alpha: 0.05),
                            width: 1),
                        left: BorderSide(
                            color: blackColor.withValues(alpha: 0.05),
                            width: 1),
                        right: BorderSide(
                            color: blackColor.withValues(alpha: 0.05),
                            width: 1),
                        bottom: BorderSide.none,
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Text(
                      widget.title.tr,
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.semiBold),
                        fontSize: util.fontSize20,
                        height: util.lineHeight24 / util.fontSize20,
                        color: blackColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(util.width20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.data
                          .map((item) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: util.responsiveHeight(0.01)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("• ",
                                        style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize16,
                                            color: blackColor.withValues(
                                                alpha: 0.7),
                                            height: util.lineHeight24 /
                                                util.fontSize16)),
                                    Expanded(
                                        child: Text(item,
                                            style: TextStyle(
                                                fontFamily: AppFont.get(
                                                    FontType.medium),
                                                fontSize: util.fontSize16,
                                                color: blackColor.withValues(
                                                    alpha: 0.7),
                                                height: util.lineHeight24 /
                                                    util.fontSize16))),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),

              // Icon
              Positioned(
                top: util.responsiveHeight(0.0346),
                right: util.width20,
                child: SvgPicture.asset(designData['icon']),
              ),
            ],
          ),
        ),
        SizedBox(height: util.width20),
      ],
    );
  }
}
