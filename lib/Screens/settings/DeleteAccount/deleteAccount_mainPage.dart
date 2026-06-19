import 'package:astro_prompt/Components/Settings/deleteReasonText.dart';
import 'package:astro_prompt/Screens/settings/DeleteAccount/deleteOTPScreen.dart';
import 'package:astro_prompt/Services/SettingService/deleteAccountService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class DeleteAccountPage extends StatefulWidget {
  final String email;
  const DeleteAccountPage({super.key, required this.email});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final List<String> deleteOptions = [
    'I am having another account',
    'App not working properly',
    'I don’t like the app',
    'I am worried about my privacy',
  ];

  String deleteReason = '';

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: true,
        title: Text(
          "Delete Account".tr,
          style: TextStyle(
              fontFamily: AppFont.get(FontType.bold),
              fontSize: util.fontSize20,
              height: 1.0,
              color: blackColor),
        ),
        leading: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Future.delayed(Duration(milliseconds: 300), () {
              Get.back();
            });
          },
          icon: SvgPicture.asset(
            backButton,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: util.width20),
        width: util.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            deleteReason.isEmpty
                ? Center(
                    child: Text(
                      'We value your experience.\nWhat made you decide to leave?'
                          .tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.medium),
                          fontSize: util.fontSize16,
                          color: blackColor.withValues(alpha: 0.5)),
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: util.height50,
            ),
            deleteReason.isEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: deleteOptions.length,
                    itemBuilder: (context, index) {
                      return DeleteReasonTextComponent(
                        key: ValueKey(deleteOptions[index]),
                        title: deleteOptions[index].tr,
                        onTap: (text) {
                          setState(() {
                            deleteReason = text;
                          });
                        },
                      );
                    },
                  )
                : Center(
                    child: Column(
                      children: [
                        Text(
                          'You are about to delete\nyour account'.tr,
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.semiBold),
                              fontSize: util.fontSize20,
                              height: 1.2,
                              color: blackColor),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: util.height10,
                        ),
                        Text(
                          'All data associated with this account (including your profile, service, bookings, horoscopes, predictions) will be permanently deleted in 45 days'
                              .tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: util.fontSize14,
                              height: 1.2,
                              color: blackColor.withValues(alpha: 0.6)),
                        ),
                        SizedBox(
                          height: util.height30,
                        ),
                        GestureDetector(
                          onTap: () async {
                            CustomLoader.show(context);
                            try {
                              String message = await DeleteAccountService()
                                  .deleteAccountSendOtp();
                              CustomLoader.hide();
                              Get.to(() => DeleteOTPScreen(
                                  deleteReason: deleteReason,
                                  email: widget.email));
                              showInfoSnackBar(context, message);
                            } catch (e) {
                              CustomLoader.hide();
                              showErrorSnackBar(context, e.toString());
                            }
                          },
                          child: Container(
                            width: util.width,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(util.width20),
                                color: errorColor),
                            child: Center(
                                child: Text(
                              'Delete Account Now'.tr,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize18,
                                  height: 1.0,
                                  color: whiteColor),
                            )),
                          ),
                        ),
                        SizedBox(
                          height: util.height30,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              deleteReason = '';
                            });
                            Get.back();
                          },
                          child: Container(
                            width: util.width,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(util.width20),
                                border: Border.all(
                                    width: 1,
                                    color: blackColor.withValues(alpha: 0.12)),
                                color: whiteColor),
                            child: Center(
                                child: Text(
                              'No, I have changed my mind'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize18,
                                  height: 1.0,
                                  color: blackColor),
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
