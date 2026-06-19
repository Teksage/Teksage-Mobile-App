import 'dart:async';

import 'package:astro_prompt/Components/Consultation-User/LanguageDropDown.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userHome.dart';
import 'package:astro_prompt/Services/Astrologer-user/userAstrologer.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/currencyHelper.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class UserSelectLanguage extends StatefulWidget {
  final List<String> selectedCategory;
  const UserSelectLanguage({super.key, required this.selectedCategory});

  @override
  State<UserSelectLanguage> createState() => _UserSelectLanguageState();
}

class _UserSelectLanguageState extends State<UserSelectLanguage> {
  String selectedFirstLanguage = '';
  String selectedSecondLanguage = '';
  bool firstErrorFlag = false;
  bool secondErrorFlag = false;
  String secondLangError = '';
  AstrologerConsultationService userConsultService =
      AstrologerConsultationService();
  bool showError = false;
  List<String> selectedLanguage = [];

  List<String> languages = [
    'Tamil'.tr,
    'English'.tr,
    'Telugu'.tr,
    'Malayalam'.tr,
    'Kannada'.tr,
    'Hindi'.tr,
    'Bengali'.tr,
    'Marathi'.tr,
    'Urdu'.tr,
    'Gujarati'.tr,
    'Odia'.tr,
    'Punjabi'.tr,
    'Assamese'.tr,
    'Bhojpuri'.tr,
    'Kashmiri'.tr,
    'Nepali'.tr,
    'Sindhi'.tr,
    'Sinhala'.tr,
    'Maithili'.tr,
    'Manipuri'.tr,
    'Santali'.tr,
  ];


  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.0268)}');
    // print('Height: ${util.responsiveHeight(0.1232)}');
    // print('FontSize: ${util.responsiveFontSize(0.0153)}');

    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          /// Background Images
          SvgPicture.asset(categoryTopDeco, fit: BoxFit.cover),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child:
                  SvgPicture.asset(categoryBottomDeco, fit: BoxFit.fitWidth)),

          ///AppBar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(PlatformTextConfig.astrologerUserHomeTitle.tr,
                    style: TextStyle(
                        color: blackColor,
                        fontSize: util.fontSize20,
                        fontFamily: AppFont.get(FontType.bold),
                        height: 1.0)),
                leading: IconButton(
                  icon: SvgPicture.asset(
                    appBackButton,
                    colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                centerTitle: true,
              ),

              ///content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: util.width20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: util.responsiveHeight(0.1232),
                      ),
                      Text(
                        'Choose your\npreferred language'.tr,
                        style: TextStyle(
                            fontFamily: 'FontSemiBold',
                            fontSize: util.fontSize29,
                            height: 1.2,
                            color: blackColor),
                      ),
                      SizedBox(
                        height: util.width12,
                      ),
                      Text(
                        PlatformTextConfig.astrologerUserLangSelect.tr,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize16,
                            height: 1.2,
                            color: blackColor.withValues(alpha: 0.6)),
                      ),
                      SizedBox(
                        height: util.height50,
                      ),
                      UserLanguageDropDown(
                        title: 'First Preference'.tr,
                        errorFlag: firstErrorFlag,
                        errorText: 'Kindly select your preferred language',
                        selectedValue: selectedFirstLanguage,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              selectedFirstLanguage = value;
                              firstErrorFlag = false;
                              secondErrorFlag = false;
                              secondLangError = '';
                              showError = false;
                            });
                          }
                        },
                        options: languages,
                        enabled: true,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      UserLanguageDropDown(
                        title: 'Second Preference'.tr,
                        errorFlag: secondErrorFlag,
                        errorText: secondLangError,
                        selectedValue: selectedSecondLanguage,
                        enabled: selectedFirstLanguage.isNotEmpty,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            print('Value:$value $selectedFirstLanguage');
                            if (value == selectedFirstLanguage) {
                              setState(() {
                                selectedSecondLanguage = '';
                                secondErrorFlag = true;
                                secondLangError =
                                    'Second language must be different from first';
                              });
                            } else {
                              setState(() {
                                selectedSecondLanguage = value;
                                firstErrorFlag = false;
                                secondErrorFlag = false;
                                secondLangError = '';
                                showError = false;
                              });
                            }
                          } else {
                            setState(() {
                              secondErrorFlag = true;
                              secondLangError =
                                  'Kindly select your preferred language';
                            });
                          }
                        },
                        options: languages,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: util.width20),
                child: Visibility(
                    visible: showError,
                    child: Text('Choose a preferred language to continue'.tr,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize11,
                            color: errorColor))),
              ),
              SizedBox(
                height: util.height10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: util.width20),
                child: GestureDetector(
                  onTap: () async {
                    selectedLanguage.clear();
                    final first = selectedFirstLanguage.toLowerCase();
                    final second = selectedSecondLanguage.toLowerCase();

                    if (first.isEmpty && second.isEmpty) {
                      setState(() {
                        showError = true;
                        firstErrorFlag = true;
                        secondErrorFlag = true;
                        secondLangError =
                            'Kindly select your preferred language';
                      });
                      return;
                    }

                    if (first.isNotEmpty &&
                        second.isNotEmpty &&
                        first == second) {
                      setState(() {
                        showError = true;
                        secondErrorFlag = true;
                        secondLangError =
                            'Second language must be different from first';
                      });
                      return;
                    }

                    if (first.isNotEmpty) selectedLanguage.add(first);
                    if (second.isNotEmpty && first != second)
                      selectedLanguage.add(second);

                    setState(() {
                      showError = false;
                      firstErrorFlag = false;
                      secondErrorFlag = false;
                    });
                    final completer = Completer<String>();
                    await CurrencyHelper.fetchCurrencyIfNeeded(
                      loaderColor: homeBanner,
                      context: context,
                      currentCurrency: '',
                      onCurrencyFetched: completer.complete,
                    );
                    final currency = await completer.future;
                    if (currency.isEmpty) {
                      showErrorSnackBar(context,
                          'Location access is required to determine your currency. Please enable it');
                      return;
                    }
                    
                    Get.to(() => UserAstrologerHomePage(
                          selectedCategories: widget.selectedCategory,
                          selectedLanguages: selectedLanguage,
                          currency: currency,
                        ));
                    print('selectedLanguage: ${selectedLanguage}}');
                  },
                 
                  child: Container(
                    width: util.width,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(util.width30),
                      color: selectedFirstLanguage.isNotEmpty ||
                              selectedSecondLanguage.isNotEmpty
                          ? homeBanner
                          : homeBanner.withValues(alpha: 0.5),
                    ),
                    child: Center(
                        child: Text(
                      "Submit".tr,
                      style: TextStyle(
                          fontFamily: 'FontSemiBold',
                          fontSize: util.fontSize18,
                          height: 1.0,
                          color: whiteColor),
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: util.height50,
              )
            ],
          ),
        ],
      ),
    );
  }
}
