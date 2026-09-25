import 'package:astro_prompt/Services/Analytics/facebookAppEventsService.dart';
import 'package:astro_prompt/Services/Astrologer-user/eventsService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customSnackBar.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:get/get.dart';

class RatingDialog extends StatefulWidget {
  final int meetingId;
  final void Function(int rating, String? feedback)? onSubmit;

  const RatingDialog({super.key, required this.meetingId, this.onSubmit});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int selectedRating = 1;
  bool _submitting = false;
  final _feedbackCtrl = TextEditingController();
  final astroService = AstroUserEventService();
  final List<String> emojiList = [rating1, rating2, rating3, rating4, rating5];

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (selectedRating < 1 || _submitting) return;
    setState(() => _submitting = true);

    final feedback = _feedbackCtrl.text.trim();
    final body = <String, dynamic>{
      'rating': selectedRating,
      if (feedback.isNotEmpty) 'feedback': feedback,
    };

    try {
      final result = await astroService.updateAstrologerEvent(
        widget.meetingId,
        body,
      );
      if (result == 'Event updated successfully') {
        widget.onSubmit?.call(
          selectedRating,
          feedback.isEmpty ? null : feedback,
        );
        await FacebookAppEventsService.instance.logRate(
          value: selectedRating.toDouble(),
          contentType: 'consultation',
        );

        if (!mounted) return;
        customSnackBar(
          context: context,
          message: 'Review submitted for approval.'.tr,
          backgroundColor: const Color(0xffECF4D3),
          indicatorColor: mainColor,
          iconType: 'success',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final utility = MyUtility(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(false),
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    selectedRating > 0
                        ? emojiList[selectedRating - 1]
                        : rating5,
                    height: 45,
                    width: 45,
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Rate your experience with this astrologer appointment'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: utility.fontSize18,
                      fontFamily: AppFont.get(FontType.semiBold),
                      color: blackColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                        icon: SvgPicture.asset(
                          index < selectedRating
                              ? customerRatingSelect
                              : customerRatingUnSelect,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _feedbackCtrl,
                    maxLines: 3,
                    maxLength: 1000,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Write a short review (optional)'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: selectedRating == 0 || _submitting ? null : _submit,
                    child: Container(
                      width: utility.width,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xff85ad0a),
                      ),
                      child: Text(
                        _submitting
                            ? 'Submitting…'.tr
                            : 'Save & Submit'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFont.get(FontType.semiBold),
                          fontSize: utility.fontSize16,
                          height: 1.0,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
