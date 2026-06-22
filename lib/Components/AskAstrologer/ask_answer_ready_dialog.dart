import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:astro_prompt/Screens/Notification/notificationPage.dart';
import 'package:astro_prompt/Services/AskAstrologerService/askAstrologerService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showAskAnswerReadyDialog(
  BuildContext context,
  AskAstrologerRequest request,
) async {
  final util = MyUtility(context);
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => Dialog(
      insetPadding: EdgeInsets.all(util.width20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(util.width20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: mainColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '✓',
                style: TextStyle(
                  fontSize: util.fontSize22,
                  color: mainColor,
                  fontFamily: AppFont.get(FontType.bold),
                ),
              ),
            ),
            SizedBox(height: util.height20),
            Text(
              'Your answer is ready'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFont.get(FontType.semiBold),
                fontSize: util.fontSize18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'An astrologer has replied to your question.'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: util.fontSize14,
                color: blackColor.withValues(alpha: 0.65),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Read or listen to the answer now — or find it later in Notifications.'
                  .tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: util.fontSize12,
                color: blackColor.withValues(alpha: 0.45),
              ),
            ),
            SizedBox(height: util.height20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: blackColor.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(color: mainColor, width: 4),
                ),
              ),
              child: Text(
                request.userQuestion,
                style: TextStyle(
                  fontFamily: AppFont.get(FontType.medium),
                  fontSize: util.fontSize14,
                ),
              ),
            ),
            SizedBox(height: util.height20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _dismissAndAcknowledge(
                      dialogContext,
                      request.id,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: blackColor.withValues(alpha: 0.6),
                      side: BorderSide(color: blackColor.withValues(alpha: 0.12)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      minimumSize: Size(0, 44),
                    ),
                    child: Text('Not now'.tr),
                  ),
                ),
                SizedBox(width: util.width8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _dismissAndAcknowledge(
                        dialogContext,
                        request.id,
                      );
                      Get.to(() => NotificationPage(
                            selectedTab: 1,
                            openAskRequestId: request.id,
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      minimumSize: Size(0, 44),
                    ),
                    child: Text(
                      'Open answer'.tr,
                      style: TextStyle(
                        color: whiteColor,
                        fontFamily: AppFont.get(FontType.semiBold),
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
}

Future<void> _dismissAndAcknowledge(
  BuildContext dialogContext,
  int requestId,
) async {
  await AskAstrologerService().acknowledgeAnswerReady(requestId);
  if (dialogContext.mounted) Navigator.pop(dialogContext);
}
