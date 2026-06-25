import 'dart:async';

import 'package:astro_prompt/Components/Consultation-User/LanguageDropDown.dart';
import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:astro_prompt/Screens/AskAstrologer/ask_astrologer_checkout_page.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/LocallySavedData/askAstrologerFlow.dart';
import 'package:astro_prompt/config/ask_astrologer_flow_screen.dart';
import 'package:astro_prompt/config/ask_astrologer_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AskAstrologerLanguagePage extends StatefulWidget {
  final String userQuestion;
  const AskAstrologerLanguagePage({super.key, required this.userQuestion});

  @override
  State<AskAstrologerLanguagePage> createState() =>
      _AskAstrologerLanguagePageState();
}

class _AskAstrologerLanguagePageState extends State<AskAstrologerLanguagePage>
    with AskAstrologerFlowScreenMixin {
  String selectedLanguage = '';
  bool showError = false;
  final languages = AskAstrologerLanguages.options
      .map((o) => o['label']!.tr)
      .toList();

  String _languageId(String label) {
    final match = AskAstrologerLanguages.options.firstWhere(
      (o) => o['label']!.tr == label || o['label'] == label,
      orElse: () => {'id': label.toLowerCase(), 'label': label},
    );
    return match['id']!;
  }

  Future<void> _onContinue() async {
    if (selectedLanguage.isEmpty) {
      setState(() => showError = true);
      return;
    }
    final flow = await readAskAstrologerFlow();
    if (flow == null) {
      showErrorSnackBar(context, 'Session expired. Please try again.'.tr);
      Get.back();
      return;
    }
    await writeAskAstrologerFlow(AskAstrologerFlowState(
      userQuestion: flow.userQuestion,
      aiResponse: flow.aiResponse,
      preferredLanguages: [_languageId(selectedLanguage)],
    ));
    Get.to(() => AskAstrologerCheckoutPage());
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            appBackButton,
            colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Ask Astrologer'.tr,
          style: TextStyle(
            fontFamily: AppFont.get(FontType.bold),
            fontSize: util.fontSize20,
            color: blackColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(util.width20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(util.width20),
              decoration: BoxDecoration(
                color: blackColor.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your question'.tr,
                      style: TextStyle(
                          fontSize: util.fontSize12,
                          color: blackColor.withValues(alpha: 0.5))),
                  SizedBox(height: 8),
                  Text(widget.userQuestion,
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.semiBold),
                          fontSize: util.fontSize14)),
                ],
              ),
            ),
            SizedBox(height: util.height20),
            Text('Select your preferred language'.tr,
                style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    fontSize: util.fontSize18)),
            SizedBox(height: 8),
            Text(
              'We will match you with an astrologer who speaks your language.'.tr,
              style: TextStyle(
                  fontSize: util.fontSize14,
                  color: blackColor.withValues(alpha: 0.65)),
            ),
            SizedBox(height: util.height20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(util.width20),
              decoration: BoxDecoration(
                color: blackColor.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              child: UserLanguageDropDown(
                title: 'Language'.tr,
                options: languages,
                selectedValue:
                    selectedLanguage.isEmpty ? null : selectedLanguage,
                onChanged: (val) => setState(() {
                  selectedLanguage = val;
                  showError = false;
                }),
                errorFlag: showError,
                errorText: 'Please select a language',
              ),
            ),
            SizedBox(height: util.height20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: blackColor.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: blackColor.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes'.tr,
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      fontSize: util.fontSize14,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...AskAstrologerScreenCopy.languageNotes.map(
                    (note) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: TextStyle(
                              fontSize: util.fontSize14,
                              color: blackColor.withValues(alpha: 0.7),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              note.tr,
                              style: TextStyle(
                                fontSize: util.fontSize14,
                                height: 1.4,
                                color: blackColor.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(util.width20),
          child: ElevatedButton(
            onPressed: _onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: homeBanner,
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: Text('Continue to Payment'.tr,
                style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    color: whiteColor)),
          ),
        ),
      ),
    );
  }
}
