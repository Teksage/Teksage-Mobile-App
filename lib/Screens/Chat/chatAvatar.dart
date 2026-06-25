import 'dart:io';

import 'package:astro_prompt/Model/chatAvatarModel.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class ChatAvatar extends StatefulWidget {
  const ChatAvatar({super.key});

  @override
  State<ChatAvatar> createState() => _ChatAvatarState();
}

class _ChatAvatarState extends State<ChatAvatar> {
  int selectedAvatarIndex = 0;

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

  Future<void> _saveAvatar(String avatar) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("chat_avatar", avatar);
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.1867)}');
    // print('Height: ${util.responsiveHeight(0.0863)}');

    final int count = avatars.length;
    final double sidePadding = util.width20 * 2;
    final double spacing = util.width12 * (count - 1);
    final double availableWidth = util.width - sidePadding - spacing;
    double itemSize = availableWidth / (count > 0 ? count : 1);
    const double maxItemSize = 96.0;
    if (itemSize > maxItemSize) itemSize = maxItemSize;
    const double minItemSize = 40.0;
    if (itemSize < minItemSize)
      itemSize = availableWidth / (count > 0 ? count : 1);

    return Scaffold(
      backgroundColor: whiteColor,
      // appBar: AppBar(
      //   backgroundColor: whiteColor,
      //   title: Text(
      //     'AI Chat',
      //     style: TextStyle( fontFamily: AppFont.get(FontType.bold), fontSize: util.fontSize20),
      //   ),
      //   leading: IconButton(
      //     onPressed: () {
      //       Get.back();
      //     },
      //     icon: SvgPicture.asset(
      //       backButton,
      //     ),
      //   ),
      // ),
      body: Container(
        width: util.width,
        padding: EdgeInsets.symmetric(horizontal: util.width20),
        decoration: BoxDecoration(
          image: Platform.isIOS
              ? DecorationImage(
                  image: AssetImage(iosSettingBg), alignment: Alignment.topLeft)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                'AI Chat',
                style: TextStyle(
                    fontFamily: AppFont.get(FontType.bold),
                    fontSize: util.fontSize20),
              ),
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: SvgPicture.asset(
                  backButton,
                ),
              ),
            ),
            Column(
              children: [
                // SizedBox(
                //   height: util.height50,
                // ),
                // SizedBox(
                //   height: util.height50,
                // ),
                Text(
                  'Choose an avatar for AI'.tr,
                  style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      fontSize: util.fontSize24),
                ),
                SizedBox(
                  height: util.height50,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 210,
                          padding:
                              EdgeInsets.symmetric(horizontal: util.width30),
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: blackColor.withValues(alpha: 0.2),
                                  width: 1)),
                          child: Column(
                            children: [
                              const SizedBox(height: 75),
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
                          top: -40,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: blackColor.withValues(alpha: 0.2),
                                    offset: const Offset(
                                      0,
                                      3,
                                    ),
                                    blurRadius: 5,
                                    spreadRadius: -5,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: SvgPicture.asset(
                                  avatars[selectedAvatarIndex].imagePath,
                                  width: 95,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Avatar Choices
                    const SizedBox(height: 12),
                    SizedBox(
                      height: itemSize + util.height10 + 12,
                      width: util.width,
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
                                      width: util.responsiveWidth(0.1867),
                                      height: util.responsiveHeight(0.0863),
                                      // margin: EdgeInsets.only(right: index == avatars.length - 1 ? 0 : 14),
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        border: isSelected
                                            ? Border.all(
                                                color: Platform.isAndroid
                                                    ? mainColor
                                                    : iosMainColor,
                                                width: 2)
                                            : Border.all(
                                                color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: ColorFiltered(
                                        colorFilter: isSelected
                                            ? ColorFilter.mode(
                                                Colors.transparent,
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
                                    width: isSelected ? 30 : 0,
                                    height: 3,
                                    margin: const EdgeInsets.only(top: 3),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? (Platform.isAndroid
                                              ? mainColor
                                              : iosMainColor)
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
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final avatar =
                        avatars[selectedAvatarIndex].title.toLowerCase();
                    await _saveAvatar(avatar);
                    Get.back(result: avatar);
                  },
                  child: Container(
                    width: util.width,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Platform.isAndroid ? mainColor : iosMainColor,
                    ),
                    child: Text(
                      'Continue'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.semiBold),
                          fontSize: util.fontSize18,
                          color: whiteColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: util.height50,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
