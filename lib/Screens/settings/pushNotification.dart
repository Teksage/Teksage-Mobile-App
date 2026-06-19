import 'package:astro_prompt/Components/Dashboard/subscribeDialog.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Services/NotificationService/notificationPreferenceService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customSnackBar.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class PushNotificationPage extends StatefulWidget {
  final UserNotify userNotifyData;
  const PushNotificationPage({super.key, required this.userNotifyData});

  @override
  State<PushNotificationPage> createState() => _PushNotificationPageState();
}

class _PushNotificationPageState extends State<PushNotificationPage> {
  late UserNotify originalNotify;
  Map<String, bool> notificationSettings = {};
  bool premiumUser = false;

  @override
  void initState() {
    super.initState();
    originalNotify = widget.userNotifyData;

    notificationSettings = {
      PlatformTextConfig.dailyTitle: widget.userNotifyData.dailyPredictions,
      PlatformTextConfig.weeklyTitle: widget.userNotifyData.weeklyPredictions,
      PlatformTextConfig.yearlyTitle: widget.userNotifyData.yearlyPredictions,
      "Promotions & Offers": widget.userNotifyData.promotionOffers,
      "Warnings": widget.userNotifyData.warnings,
    };
    getPremiumUser();
  }

  void getPremiumUser() async {
    final result = await getUserPremium();
    setState(() {
      premiumUser = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.2668)}');
    // print('Height: ${util.responsiveHeight(0.1232)}');
    // print('FontSize: ${util.responsiveFontSize(0.0186)}');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Future.microtask(() async {
            Get.back(result: true);
          });
        }
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          title: Text(
            'Push Notification'.tr,
            style: TextStyle(
                fontFamily: AppFont.get(FontType.bold),
                fontSize: util.fontSize20,
                height: 1.0,
                color: blackColor),
          ),
          centerTitle: true,
          leading: SizedBox(
            width: util.responsiveWidth(0.08),
            height: util.responsiveHeight(0.037),
            child: IconButton(
              icon: SvgPicture.asset(appBackButton,
                  width: util.width20,
                  height: util.height20,
                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn)),
              onPressed: () {
                Get.back(result: true);
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: notificationSettings.keys.map((String key) {
              bool isSelected = notificationSettings[key]!;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        key.tr,
                        style: TextStyle(
                          fontSize: util.fontSize16,
                          fontFamily: AppFont.get(FontType.medium),
                          color: isSelected
                              ? blackColor
                              : blackColor.withValues(alpha: 0.6),
                        ),
                      ),
                      Switch(
                        value: isSelected,
                        onChanged: (bool value) async {
                          if (premiumUser) {
                            setState(() {
                              notificationSettings[key] = value;
                            });
                            final updatedSettings = {
                              PlatformTextConfig.dailyTitle:
                                  notificationSettings[
                                      PlatformTextConfig.dailyTitle]!,
                              PlatformTextConfig.weeklyTitle:
                                  notificationSettings[
                                      PlatformTextConfig.weeklyTitle]!,
                              PlatformTextConfig.yearlyTitle:
                                  notificationSettings[
                                      PlatformTextConfig.yearlyTitle]!,
                              "Promotions & Offers":
                                  notificationSettings["Promotions & Offers"]!,
                              "Warnings": notificationSettings["Warnings"]!,
                            };

                            try {
                              final service = NotificationPreferenceService();
                              final response =
                                  await service.updateNotificationPreference(
                                updatedSettings[PlatformTextConfig.dailyTitle]!,
                                updatedSettings[
                                    PlatformTextConfig.weeklyTitle]!,
                                updatedSettings[
                                    PlatformTextConfig.yearlyTitle]!,
                                updatedSettings["Promotions & Offers"]!,
                                updatedSettings["Warnings"]!,
                              );

                              setState(() {
                                originalNotify = originalNotify.copyWith(
                                  dailyPredictions: updatedSettings[
                                      PlatformTextConfig.dailyTitle]!,
                                  weeklyPredictions: updatedSettings[
                                      PlatformTextConfig.weeklyTitle]!,
                                  yearlyPredictions: updatedSettings[
                                      PlatformTextConfig.yearlyTitle]!,
                                  promotionOffers:
                                      updatedSettings["Promotions & Offers"]!,
                                  warnings: updatedSettings["Warnings"]!,
                                );
                              });

                              // customSnackBar(
                              //   context: context,
                              //   message: "Notification Setting preference is updated!",
                              //   backgroundColor: horoscopeLightBg,
                              //   indicatorColor: mainColor,
                              //   duration: const Duration(seconds: 2),
                              //   iconType: 'success',
                              // );
                            } catch (e) {
                              print('Error preferences: $e');
                              customSnackBar(
                                context: context,
                                message:
                                    "Failed to update preferences. Try again.",
                                backgroundColor: matchDetailTopGradient,
                                indicatorColor: matchButtonText,
                                duration: const Duration(seconds: 2),
                                iconType: 'error',
                              );
                            }
                          } else {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierColor: Colors.black.withValues(alpha: 0.5),
                              builder: (context) => const SubscribePromptDialog(
                                reDirectHome: false,
                              ),
                            );
                          }
                        },
                        activeThumbColor: mainColor,
                        activeTrackColor: whiteColor,
                        inactiveThumbColor: pushUnselect,
                        inactiveTrackColor: whiteColor,
                        thumbIcon:
                            WidgetStateProperty.resolveWith<Icon?>((states) {
                          return Icon(Icons.circle,
                              size: 20,
                              color: states.contains(WidgetState.selected)
                                  ? mainColor
                                  : pushUnselect);
                        }),
                        trackOutlineWidth: WidgetStateProperty.all(1.0),
                        trackOutlineColor:
                            WidgetStateProperty.resolveWith<Color?>((states) {
                          if (states.contains(WidgetState.selected)) {
                            return mainColor;
                          }
                          return pushUnselect;
                        }),
                      ),
                    ],
                  ),
                  Divider(
                      height: 20, thickness: 1, color: Colors.grey.shade300),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
