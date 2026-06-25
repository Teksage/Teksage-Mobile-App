import 'package:astro_prompt/Components/Common/customCountryDropDown.dart';
import 'package:astro_prompt/Model/country_model.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/auth/password.dart';
import 'package:astro_prompt/Screens/settings/profile_page.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class ChangeEmailMobile extends StatefulWidget {
  final bool verifyScreen;
  final String title;
  final List<Country> countries;
  const ChangeEmailMobile(
      {super.key,
      required this.verifyScreen,
      required this.title,
      required this.countries});

  @override
  State<ChangeEmailMobile> createState() => _ChangeEmailMobileState();
}

class _ChangeEmailMobileState extends State<ChangeEmailMobile> {
  String? errorMessage;
  bool isButtonEnabled = false;
  bool isLoading = false;
  bool containerColor = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  String title = '';
  ProfileService profileService = ProfileService();
  String keyValue = '';
  Map<String, String> selectedCountry = {
    'countryFlag': '',
    'dialCode': '',
  };
  int? mobileLengthLimit;

  bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
  }

  void validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        errorMessage = "Enter a valid email address";
        isButtonEnabled = false;
      } else if (!isValidEmail(value)) {
        errorMessage = "Enter a valid email address";
        isButtonEnabled = false;
      } else {
        errorMessage = null;
        isButtonEnabled = true;
      }
    });
  }

  // bool isValidMobile(String mobile) {
  //   return RegExp(r'^[1-9]\d{9}$').hasMatch(mobile);
  // }
  bool isValidMobile(String mobile) {
    if (mobileLengthLimit == null) return false;
    return RegExp('^[1-9]\\d{${mobileLengthLimit! - 1}}\$').hasMatch(mobile);
  }

  void validateMobile(String value) {
    setState(() {
      if (value.isEmpty || !isValidMobile(value)) {
        errorMessage = "Enter a valid mobile number";
        isButtonEnabled = false;
        containerColor = false;
      } else {
        errorMessage = null;
        isButtonEnabled = true;
        containerColor = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      title = widget.title.replaceAll('Existing ', '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
// print('Width: ${util.responsiveWidth(0.0495)}');
//     print('Height: ${util.responsiveHeight(0.056)}');
    // print('FontSize: ${util.responsiveFontSize(0.0406)}');

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Stack(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: SizedBox(
                width: util.responsiveWidth(0.08),
                height: util.responsiveHeight(0.037),
                child: IconButton(
                  icon: SvgPicture.asset(
                      widget.verifyScreen ? otpDown : appBackButton,
                      width: widget.verifyScreen ? util.width30 : util.width20,
                      height: widget.verifyScreen ? util.width30 : util.width20,
                      colorFilter:
                          ColorFilter.mode(Colors.black, BlendMode.srcIn)),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              title: widget.verifyScreen
                  ? Text(
                      widget.title == 'Verify Existing Email'
                          ? 'Verify Email'.tr
                          : 'Verify Phone Number'.tr,
                          textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.bold),
                          fontSize: util.fontSize20,
                          // height: 1.0,
                          color: blackColor),
                          maxLines: 3,
                    )
                  : null,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: util.responsiveHeight(0.0248)),
              height: util.height,
              width: util.width,
              child: Column(
                children: [
                  SizedBox(
                    height: util.responsiveHeight(0.21),
                  ),
                  Text(
                    widget.title == 'Verify Existing Email'
                        ? 'Enter your new email and verify it using OTP'.tr
                        : 'Enter your new phone number and verify it using OTP'
                            .tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: AppFont.get(FontType.semiBold),
                        fontSize: util.fontSize18,
                        height: util.lineHeight28 / util.fontSize18,
                        color: blackColor.withValues(alpha: 0.6)),
                  ),
                  SizedBox(
                    height: util.responsiveHeight(0.067),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      children: [
                        Text(
                          widget.title == 'Verify Existing Email'
                              ? 'Verify Email'.tr
                              : 'Verify Phone Number'.tr,
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: util.fontSize10,
                              height: 1.0,
                              color: blackColor),
                        ),
                        Text('*',
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.medium),
                                fontSize: util.fontSize10,
                                height: 1.0,
                                color: errorColor)),
                      ],
                    ),
                  ),
                  title.toLowerCase().contains('email')
                      ? SizedBox(
                          height: util.responsiveHeight(0.056),
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: validateEmail,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.medium),
                                fontSize: util.fontSize14,
                                height: 1.0),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              LengthLimitingTextInputFormatter(50),
                            ],
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(util.width8),
                                borderSide: BorderSide(
                                    color: blackColor.withValues(alpha: 0.2)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(util.width8),
                                borderSide: BorderSide(
                                    color: errorMessage != null
                                        ? errorColor
                                        : mainColor,
                                    width: 2),
                              ),
                              hintText: 'Enter Email'.tr,
                              hintStyle: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize14,
                                  height: 1.0,
                                  color: blackColor.withValues(alpha: 0.6)),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: util.responsiveWidth(0.032),
                                  horizontal: util.responsiveHeight(0.0248)),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final result =
                                    await showDialog<Map<String, String>>(
                                  context: context,
                                  builder: (_) => CountryDropdownDialog(
                                    countries: widget.countries,
                                  ),
                                );
                                if (result != null) {
                                  setState(() {
                                    selectedCountry = result;
                                    mobileLengthLimit = int.tryParse(
                                        result['mobileNumberLength'] ?? '');
                                  });
                                  print(
                                      'country: $selectedCountry, lenght:$mobileLengthLimit');
                                }
                              },
                              child: Container(
                                padding: selectedCountry['countryFlag']!.isEmpty
                                    ? EdgeInsets.zero
                                    : EdgeInsets.symmetric(
                                        horizontal: util.responsiveWidth(0.03)),
                                width: util.responsiveWidth(0.2055),
                                height: util.responsiveHeight(0.056),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(util.width12),
                                  border: Border.all(
                                      color: blackColor.withValues(alpha: 0.2)),
                                ),
                                child: selectedCountry['countryFlag']!.isEmpty
                                    ? Center(
                                        child: Text(
                                          'Select Country'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily:
                                                  AppFont.get(FontType.medium),
                                              fontSize: util.fontSize16,
                                              color: blackColor.withValues(
                                                  alpha: 0.6),
                                              height: util.responsiveHeight(
                                                      0.0248) /
                                                  util.responsiveFontSize(
                                                      0.0304)),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.network(
                                            selectedCountry['countryFlag'] ??
                                                '',
                                            width: 22.5,
                                            height: 15,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.flag),
                                          ),
                                          Text(
                                            selectedCountry['dialCode'] ?? '',
                                            style: TextStyle(
                                              fontFamily:
                                                  AppFont.get(FontType.bold),
                                              fontSize: util.fontSize18,
                                              height: util.responsiveHeight(
                                                      0.0248) /
                                                  util.responsiveFontSize(
                                                      0.0304),
                                            ),
                                          )
                                        ],
                                      ),
                              ),
                            ),
                            SizedBox(
                              width: util.responsiveWidth(0.667),
                              height: util.responsiveHeight(0.0567),
                              child: TextField(
                                controller: mobileController,
                                keyboardType: TextInputType.number,
                                onChanged: validateMobile,
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.bold),
                                    fontSize: util.fontSize18,
                                    height:
                                        util.lineHeight21_6 / util.fontSize18),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                enabled: mobileLengthLimit != null,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(util.width12),
                                    borderSide: BorderSide(
                                        color:
                                            blackColor.withValues(alpha: 0.2)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(util.width12),
                                    borderSide: BorderSide(
                                        color: errorMessage != null
                                            ? errorColor
                                            : mainColor,
                                        width: 2),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(util.width12),
                                    borderSide: BorderSide(
                                        color:
                                            blackColor.withValues(alpha: 0.2)),
                                  ),
                                  hintText: 'Enter Mobile Number'.tr,
                                  hintStyle: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize18,
                                      color: blackColor.withValues(alpha: 0.6),
                                      height: util.responsiveHeight(0.0248) /
                                          util.responsiveFontSize(0.0304)
                                          ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: util.responsiveWidth(0.032),
                                      horizontal:
                                          util.responsiveHeight(0.0248)
                                          ),
                                ),
                              ),
                            )
                          ],
                        ),

                  //ErrorMessage
                  if (errorMessage != null) ...[
                    SizedBox(
                      height: util.responsiveHeight(0.0092),
                    ),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: errorColor,
                        fontFamily: AppFont.get(FontType.semiBold),
                        fontSize: util.fontSize14,
                      ),
                    ),
                  ],
                  SizedBox(
                    height: errorMessage != null
                        ? util.responsiveHeight(0.0413)
                        : util.responsiveHeight(0.076),
                  ),
//Continue button

                  title.toLowerCase().contains('email')
                      ? GestureDetector(
                          onTap: (isValidEmail(emailController.text) &&
                                  errorMessage == null)
                              ? () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  setState(() {
                                    keyValue =
                                        title.toLowerCase().contains('email')
                                            ? 'email'
                                            : 'mobile_number';
                                  });
                                  // var response = await authService.login('email', emailController.text);
                                  var response =
                                      await profileService.profileVerifyChange(
                                          keyValue, emailController.text);
                                  // print('Response: ${response['error']['detail']}');
                                  if (response['message'] ==
                                      'OTP sent successfully') {
                                    setState(() {
                                      isLoading = false;
                                    });

                                    showLoginSuccessSnackBar(context,
                                       'otp_response'.tr.replaceAll('(title)',title),
                                        );
                                    // print('title: $title');
                                    var result = await Get.to(() => OTPScreen(
                                          title: title,
                                          userInfo: emailController.text,
                                          keyValue: keyValue,
                                          isMobileScreen: false,
                                          verifyScreen: true,
                                          isChange: false,
                                          newVerify: true,
                                        ));
                                    if (result == 'success') {
                                      Get.to(() => ProfilePage(
                                            title: 'Profile Details',
                                            isProfileUpdated: true,
                                          ));
                                    }
                                  } else {
                                    showErrorSnackBar(
                                        context, response['detail']);
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              : null,
                          child: Container(
                            width: util.width,
                            height: util.responsiveHeight(0.0518),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    util.responsiveWidth(0.0535)),
                                color: (isValidEmail(emailController.text) &&
                                        errorMessage == null)
                                    ? mainColor
                                    : mainColor.withValues(alpha: 0.2)),
                            child: Center(
                                child: isLoading
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          width: MyUtility(context)
                                              .responsiveWidth(0.2668),
                                          height: MyUtility(context)
                                              .responsiveHeight(0.1232),
                                          child: Center(
                                            child: LoadingAnimationWidget
                                                .halfTriangleDot(
                                              color: whiteColor,
                                              size: MyUtility(context).height30,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'Continue'.tr,
                                        style: TextStyle(
                                            color: (isValidEmail(
                                                        emailController.text) &&
                                                    errorMessage == null)
                                                ? whiteColor
                                                : mainColor,
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize18,
                                            height: util.lineHeight21_6 /
                                                util.fontSize18),
                                      )),
                          ),
                        )
                      : GestureDetector(
                          onTap: (isValidMobile(mobileController.text) &&
                                  errorMessage == null)
                              ? () async {
                                  print('Came here');

                                  // setState(() {
                                  //   keyValue = title == 'Email' ? 'email' : 'mobile_number';
                                  // });
                                  Map<String, dynamic> profileData;
                                  profileData = {
                                    "country_code": selectedCountry['dialCode'],
                                    "mobile_number": mobileController.text,
                                  };
                                  Get.to(() => ProfilePage(
                                        title: 'Profile Details',
                                        isProfileUpdated: true,
                                        phoneNumberChangeData: profileData,
                                      ));
                                  // print('ProfileDate: $profileData');
                                  // CustomLoader.show(context);
                                  // Future.delayed(Duration(milliseconds: 200), () async {
                                  //   var result = await ProfileService().updateProfile(profileData);
                                  //   CustomLoader.hide();
                                  //   if (result['success']) {
                                  //     Get.snackbar('Hi!', result['data']['data'], snackPosition: SnackPosition.TOP, duration: Duration(seconds: 1));
                                  //     CustomLoader.show(context);
                                  //     Get.offAllNamed('/home');
                                  //     CustomLoader.hide();
                                  //   } else {
                                  //     showErrorSnackBar(context, result['error']);
                                  //     // Get.snackbar('Hi ${firstNameController.text}!', result['error'], snackPosition: SnackPosition.BOTTOM);
                                  //   }
                                  // });

                                  // var response = await profileService.profileVerifyChange(keyValue, mobileController.text,
                                  //     countryCode: selectedCountry['dialCode']!.replaceAll('+', ''));
                                  // if (response['message'] == 'OTP sent successfully') {
                                  //   setState(() {
                                  //     isLoading = false;
                                  //   });
                                  //   showLoginSuccessSnackBar(context, '$title Verification\n${response['message']}');
                                  //   var result = await Get.to(() => OTPScreen(
                                  //         title: title,
                                  //         userInfo: mobileController.text,
                                  //         keyValue: keyValue,
                                  //         isMobileScreen: true,
                                  //         verifyScreen: true,
                                  //         isChange: false,
                                  //         newVerify: true,
                                  //     countryCode: selectedCountry['dialCode'],
                                  //       ));
                                  //   if (result == 'success') {
                                  //     Get.to(() => ProfilePage(
                                  //           title: 'Profile Details',
                                  //           isProfileUpdated: true,
                                  //         ));
                                  //   }
                                  // } else {
                                  //   showErrorSnackBar(context, response['detail']);
                                  //   setState(() {
                                  //     isLoading = false;
                                  //   });
                                  // }
                                }
                              : null,
                          child: Container(
                            width: util.width,
                            height: util.responsiveHeight(0.0518),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    util.responsiveWidth(0.0535)),
                                color: (isValidMobile(mobileController.text) &&
                                        errorMessage == null)
                                    ? mainColor
                                    : mainColor.withValues(alpha: 0.2)),
                            child: Center(
                                child: isLoading
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          width: MyUtility(context)
                                              .responsiveWidth(0.2668),
                                          height: MyUtility(context)
                                              .responsiveHeight(0.1232),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: LoadingAnimationWidget
                                                  .halfTriangleDot(
                                                color: mainColor,
                                                size:
                                                    MyUtility(context).height30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'Continue'.tr,
                                        style: TextStyle(
                                            color: (isValidMobile(
                                                        mobileController
                                                            .text) &&
                                                    errorMessage == null)
                                                ? whiteColor
                                                : mainColor,
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize18,
                                            height: util.lineHeight21_6 /
                                                util.fontSize18),
                                      )),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
