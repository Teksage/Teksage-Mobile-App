import 'dart:ui';
import 'package:astro_prompt/Model/AstrologerUserConsult/astrologer_consult_event_model.dart';
import 'package:astro_prompt/Services/Astrologer-user/questionService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:get/get.dart';


Future<bool?> answerDialog(BuildContext context, List<EventQuestions> questions,
    int startIndex) async {
  TextEditingController controller = TextEditingController();
  int currentIndex = startIndex;
  final questionService = AstroUserQuestion();

  return await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          // ✅ Do NOT set controller.text here repeatedly.
          return Dialog(
            backgroundColor: Colors.transparent,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Text
                    Text(
                      questions[currentIndex].question,
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.semiBold),
                        fontSize: MyUtility(context).fontSize16,
                        color: blackColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Answer Field
                    TextField(
                      controller: controller,
                      maxLines: 4,
                      // onChanged: (value) {
                      //   questions[currentIndex] = questions[currentIndex].copyWith(answer: value);
                      // },
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.medium),
                        fontSize: MyUtility(context).fontSize16,
                        height: 1.2,
                        color: blackColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your answer here...'.tr,
                        hintStyle: TextStyle(
                          fontFamily: AppFont.get(FontType.medium),
                          fontSize: MyUtility(context).fontSize16,
                          height: 1.2,
                          color: blackColor.withValues(alpha: 0.6),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Color(0xff85AD0A), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Color(0xff85AD0A), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Color(0xff85AD0A), width: 1),
                        ),
                      ),
                      maxLength: 500,
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: Text(
                        '${currentIndex + 1}/${questions.length}',
                        style: TextStyle(
                          fontFamily: AppFont.get(FontType.medium),
                          fontSize: MyUtility(context).fontSize16,
                          height: 1.2,
                          color: blackColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Navigation Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Previous Button
                        Expanded(
                          child: GestureDetector(
                            onTap: currentIndex > 0
                                ? () {
                                    final original =
                                        questions[currentIndex].answer ?? "";
                                    final updated = controller.text;

                                    print(original != updated
                                        ? 'Answer has been changed.'
                                        : 'Answer remains the same.');

                                    questions[currentIndex] =
                                        questions[currentIndex]
                                            .copyWith(answer: updated);

                                    setState(() {
                                      currentIndex--;
                                      controller.text =
                                          questions[currentIndex].answer ?? "";
                                      controller.selection =
                                          TextSelection.fromPosition(
                                        TextPosition(
                                            offset: controller.text.length),
                                      );
                                    });
                                  }
                                : null,
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
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: MyUtility(context).fontSize16,
                                  color: whiteColor,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),

                        // Next / Done Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final original =
                                  questions[currentIndex].answer ?? "";
                              final updated = controller.text;

                              print(original != updated
                                  ? 'Answer has been changed.'
                                  : 'Answer remains the same.');

                              if (original != updated) {
                                print("Answer has been changed.");

                                final updatedQuestion =
                                    await questionService.updateQuestionAnswer(
                                        questions[currentIndex].id, updated);

                                if (updatedQuestion != null) {
                                  questions[currentIndex] = updatedQuestion;
                                } else {
                                  print(
                                      "⚠️ Failed to update on server. Keeping local change.");
                                  questions[currentIndex] =
                                      questions[currentIndex]
                                          .copyWith(answer: updated);
                                }
                              } else {
                                print("Answer remains the same.");
                              }

                              questions[currentIndex] = questions[currentIndex]
                                  .copyWith(answer: updated);

                              if (currentIndex < questions.length - 1) {
                                setState(() {
                                  currentIndex++;
                                  controller.text =
                                      questions[currentIndex].answer ?? "";
                                  controller.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: controller.text.length),
                                  );
                                });
                              } else {
                                Navigator.pop(context, true);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: questionButtonColor,
                              ),
                              child: Text(
                                currentIndex == questions.length - 1
                                    ? 'Done'.tr
                                    : 'Next'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: MyUtility(context).fontSize16,
                                  color: whiteColor,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
