import 'package:astro_prompt/Services/Astrologer-user/questionService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class ConsultationDialog extends StatefulWidget {
  final int eventId;
  final VoidCallback onSubmit;
  const ConsultationDialog(
      {super.key, required this.eventId, required this.onSubmit});

  @override
  State<ConsultationDialog> createState() => _ConsultationDialogState();
}

class _ConsultationDialogState extends State<ConsultationDialog> {
  final List<TextEditingController> controllers =
      List.generate(5, (_) => TextEditingController());
  final List<bool> isSubmitted = List.generate(5, (_) => false);
  final List<String?> submittedQuestions = List.generate(5, (_) => null);

  String? errorText;
  bool isLoading = false;
  int currentIndex = 0;

  void _handleNext() async {
    final question = controllers[currentIndex].text.trim();

    if (question.isEmpty) {
      setState(() {
        errorText = "Question cannot be empty".tr;
      });
      return;
    }

    setState(() {
      errorText = null;
    });

    // Only save if it's new or different
    if (submittedQuestions[currentIndex] != question) {
      setState(() {
        isLoading = true;
      });

      final result = await AstroUserQuestion()
          .addQuestion(question, widget.eventId, currentIndex);

      setState(() {
        isLoading = false;
      });

      if (result != null) {
        submittedQuestions[currentIndex] = question;
      } else {
        showErrorSnackBar(context, 'Failed to save Questions');
        return;
      }
    }

    if (currentIndex < 4) {
      setState(() {
        currentIndex++;
      });
    } else {
      widget.onSubmit();
      Get.back();
    }
  }

  void _handlePrevious() {
    if (currentIndex > 0) {
      setState(() {
        errorText = null;
        currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Write your consultation query here".tr,
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.bold),
                        fontSize: util.fontSize20,
                        height: 1.0,
                        color: blackColor.withValues(alpha: 0.8),
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: questionButtonColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        maxLength: 250,
                        controller: controllers[currentIndex],
                        style: TextStyle(
                          fontFamily: AppFont.get(FontType.medium),
                          fontSize: util.fontSize16,
                          height: 1.2,
                          color: blackColor,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 5,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[\x00-\x7F]'),
                          ),
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter your question here...".tr,
                          hintStyle: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize16,
                            height: 1.0,
                            color: blackColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          errorText!,
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize14,
                            color: errorColor,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        '${currentIndex + 1}/5',
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize16,
                            height: 1.0,
                            color: blackColor),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        if (currentIndex > 0)
                          Expanded(
                            child: GestureDetector(
                              onTap: _handlePrevious,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: questionButtonColor,
                                ),
                                child: Text(
                                  'Previous'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'FontSemiBold',
                                      fontSize: util.fontSize16,
                                      height: 1.0,
                                      color: whiteColor),
                                ),
                              ),
                            ),
                          ),
                        if (currentIndex > 0) const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: isLoading ? null : _handleNext,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: questionButtonColor,
                              ),
                              child: isLoading
                                  ? LoadingAnimationWidget.halfTriangleDot(
                                      color: whiteColor,
                                      size: util.height20,
                                    )
                                  : Text(
                                      currentIndex == 4 ? 'Submit'.tr : 'Next'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'FontSemiBold',
                                          fontSize: util.fontSize16,
                                          height: 1.0,
                                          color: whiteColor),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '* All questions are required to help us serve you better.'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'FontSemiBold',
                          fontSize: util.fontSize12,
                          height: 1.0,
                          color: errorColor),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 67,
              height: 67,
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: const Color(0xffDDE8A9),
                border: Border.all(color: whiteColor, width: 3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withValues(alpha: 0.25),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SvgPicture.asset(questions),
            ),
          ),
        ],
      ),
    );
  }
}
