import 'dart:io';
import 'package:get/get.dart';
import 'package:astro_prompt/Model/chatAvatarModel.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class AvatarBottomSheet extends StatefulWidget {
  final Function(AvatarOption) onAvatarSelected;
  final int selectedIndex;

  const AvatarBottomSheet(
      {super.key, required this.onAvatarSelected, required this.selectedIndex});

  @override
  State<AvatarBottomSheet> createState() => _AvatarBottomSheetState();
}

class _AvatarBottomSheetState extends State<AvatarBottomSheet> {
  late int selectedAvatarIndex;

  @override
  void initState() {
    super.initState();
    selectedAvatarIndex = widget.selectedIndex;
  }

  final List<AvatarOption> avatars = [
    AvatarOption(
      imagePath: chatSeeker,
      title: 'The Seeker',
      description:
          'Ideal for those who want in-depth astrological analysis and clear reasoning',
    ),
    AvatarOption(
      imagePath: chatLuminary,
      title: 'The Luminary',
      description:
          'Ideal for those who seek joyful and engaging astrology guidance',
    ),
    AvatarOption(
      imagePath: chatGuardian,
      title: 'The Guardian',
      description:
          'Ideal for those looking for reassurance and personal connection in predictions',
    ),
    AvatarOption(
      imagePath: chatPathFinder,
      title: 'The Pathfinder',
      description:
          'Ideal for those seeking career growth, success strategies, or clear-cut solutions',
    ),
  ];

  final List<LinearGradient> gradients = [
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.center,
      colors: [
        Platform.isAndroid ? Color(0xff10B100) : Color(0xff1081DD),
        Color(0xffffffff)
      ], // Seeker
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.center,
      colors: [
        Platform.isAndroid ? Color(0xff93B100) : Color(0xff10BEDD),
        Color(0xffffffff)
      ], // Luminary
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.center,
      colors: [
        Platform.isAndroid ? Color(0xff0085B1) : Color(0xff0B4FE0),
        Color(0xffffffff)
      ], // Guardian
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.center,
      colors: [
        Platform.isAndroid ? Color(0xff00B18E) : Color(0xff1A85A9),
        Color(0xffffffff)
      ], // Pathfinder
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          widget.onAvatarSelected(avatars[selectedAvatarIndex]);
        }
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          gradient: gradients[selectedAvatarIndex],
          borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
              ),
              child: SvgPicture.asset(chatDecoration),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Indicator
                const SizedBox(height: 10),
                Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: whiteColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 70),

                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 179,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 17),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withValues(alpha: 0.25),
                            offset: const Offset(0, 4),
                            blurRadius: 20.1,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 62),
                          // Title and description
                          Text(
                            avatars[selectedAvatarIndex].title.tr,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.bold),
                                fontSize: MyUtility(context).fontSize20,
                                height: 1.0,
                                color: blackColor.withValues(alpha: 0.7)),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            avatars[selectedAvatarIndex].description.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.regular),
                                fontSize: MyUtility(context).fontSize16,
                                height: 1.3,
                                fontStyle: FontStyle.italic,
                                color: blackColor.withValues(alpha: 0.5)),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -30,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: blackColor.withValues(alpha: 0.2),
                                offset: const Offset(0, -1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: SvgPicture.asset(
                              avatars[selectedAvatarIndex].imagePath,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Avatar Choices
                Text(
                  'Choose your avatar'.tr,
                  style: TextStyle(
                      fontFamily: AppFont.get(FontType.medium),
                      fontSize: MyUtility(context).fontSize16,
                      height: 1.0,
                      color: blackColor.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  width: MyUtility(context).width,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(avatars.length, (index) {
                        final isSelected = selectedAvatarIndex == index;
                        return Container(
                          margin: EdgeInsets.only(
                              right: index == avatars.length - 1 ? 0 : 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedAvatarIndex = index;
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  // margin: EdgeInsets.only(right: index == avatars.length - 1 ? 0 : 14),
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    border: isSelected
                                        ? Border.all(
                                            color: Colors.green, width: 2)
                                        : Border.all(
                                            color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ColorFiltered(
                                    colorFilter: isSelected
                                        ? ColorFilter.mode(Colors.transparent,
                                            BlendMode.multiply)
                                        : ColorFilter.matrix(<double>[
                                            0.2126,
                                            0.7152,
                                            0.0722,
                                            0,
                                            0,
                                            0.2126,
                                            0.7152,
                                            0.0722,
                                            0,
                                            0,
                                            0.2126,
                                            0.7152,
                                            0.0722,
                                            0,
                                            0,
                                            0,
                                            0,
                                            0,
                                            1,
                                            0,
                                          ]),
                                    child: SvgPicture.asset(
                                      avatars[index].imagePath,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                width: isSelected ? 16 : 0,
                                height: 3,
                                margin: const EdgeInsets.only(top: 3),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? mainColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
