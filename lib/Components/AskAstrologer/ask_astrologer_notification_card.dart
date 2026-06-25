import 'package:astro_prompt/Components/AskAstrologer/ask_astrologer_answer_dialog.dart';
import 'package:astro_prompt/Components/Notification/notification_card_shell.dart';
import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:astro_prompt/Services/AskAstrologerService/askAstrologerService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/ask_astrologer_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AskAstrologerNotificationCard extends StatelessWidget {
  final AskAstrologerRequest request;
  const AskAstrologerNotificationCard({super.key, required this.request});

  String get _statusLabel {
    return AskAstrologerNotificationStatus.labelFor(request.status);
  }

  ({Color bg, Color fg}) get _statusColors {
    return AskAstrologerNotificationStatus.colorsFor(request.status);
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final statusColors = _statusColors;
    final isAnswered = request.status == 'answered';

    return NotificationCardShell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const NotificationCircleAvatar(),
          SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: NotificationSectionLabel(
                        label: 'Ask Astrologer'.tr,
                      ),
                    ),
                    SizedBox(width: util.width8),
                    _StatusBadge(
                      label: _statusLabel.tr,
                      bg: statusColors.bg,
                      fg: statusColors.fg,
                    ),
                  ],
                ),
                SizedBox(height: isAnswered ? util.height10 : 4),
                Text(
                  request.userQuestion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    fontSize: util.fontSize14,
                    height: 1.2,
                    color: blackColor,
                  ),
                ),
                if (!isAnswered) ...[
                  SizedBox(height: 4),
                  Text(
                    'Expected within 4 hours'.tr,
                    style: TextStyle(
                      fontSize: util.fontSize12,
                      color: blackColor.withValues(alpha: 0.45),
                      height: 1.0,
                    ),
                  ),
                ] else if (request.answerVoiceUrl != null) ...[
                  SizedBox(height: 4),
                  Text(
                    'Includes voice answer'.tr,
                    style: TextStyle(
                      fontSize: util.fontSize12,
                      color: blackColor.withValues(alpha: 0.45),
                      height: 1.0,
                    ),
                  ),
                ],
                if (request.paidAt != null) ...[
                  SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMM, yyyy').format(
                      DateTime.parse(request.paidAt!).toLocal(),
                    ),
                    style: TextStyle(
                      fontSize: util.fontSize11,
                      color: blackColor.withValues(alpha: 0.4),
                      height: 1.0,
                    ),
                  ),
                ],
                if (isAnswered) ...[
                  SizedBox(height: util.height10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: NotificationActionPill(
                      label: 'View Answer'.tr,
                      onTap: () async {
                        await AskAstrologerService()
                            .acknowledgeAnswerReady(request.id);
                        if (context.mounted) {
                          showAskAstrologerAnswerDialog(
                              context, request.id);
                        }
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const _StatusBadge({
    required this.label,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: util.fontSize11,
          color: fg,
          fontFamily: AppFont.get(FontType.semiBold),
        ),
      ),
    );
  }
}
