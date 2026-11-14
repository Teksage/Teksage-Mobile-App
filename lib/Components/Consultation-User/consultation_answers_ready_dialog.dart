import 'package:astro_prompt/Screens/ConsultationUser/userBookingComplete.dart';
import 'package:astro_prompt/Services/Astrologer-user/eventsService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Suppress answers-ready popup while viewing this booking details event.
int? viewingConsultationAnswersEventId;

Future<void> showConsultationAnswersReadyDialog(
  BuildContext context,
  Map<String, dynamic> event,
) async {
  final util = MyUtility(context);
  final eventId = event['id'] as int? ?? 0;
  final astrologerName =
      (event['astrologer_name'] as String?)?.trim().isNotEmpty == true
          ? (event['astrologer_name'] as String).trim()
          : 'Astrologer'.tr;

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
              'Your answers are ready'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFont.get(FontType.semiBold),
                fontSize: util.fontSize18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your astrologer has submitted answers to your consultation questions.'
                  .tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: util.fontSize14,
                color: blackColor.withValues(alpha: 0.65),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Open Booking Details to read them — you can also leave a review there.'
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
                astrologerName,
                textAlign: TextAlign.center,
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
                    onPressed: () => _dismissAndAck(dialogContext, eventId),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: blackColor.withValues(alpha: 0.6),
                      side: BorderSide(
                          color: blackColor.withValues(alpha: 0.12)),
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
                      await _dismissAndAck(dialogContext, eventId);
                      _openBookingDetails(event);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      minimumSize: Size(0, 44),
                    ),
                    child: Text(
                      'View answers'.tr,
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

Future<void> _dismissAndAck(BuildContext dialogContext, int eventId) async {
  await AstroUserEventService().acknowledgeAnswersReady(eventId);
  if (dialogContext.mounted) Navigator.pop(dialogContext);
}

void _openBookingDetails(Map<String, dynamic> event) {
  final start = event['start_datetime']?.toString() ?? '';
  final end = event['end_datetime']?.toString() ?? '';
  String bookingDate = '';
  String bookingTime = '';
  try {
    if (start.isNotEmpty) {
      final s = DateTime.parse(start).toLocal();
      bookingDate = DateFormat('dd MMM yyyy').format(s);
      if (end.isNotEmpty) {
        final e = DateTime.parse(end).toLocal();
        bookingTime =
            '${DateFormat('hh:mm a').format(s)} - ${DateFormat('hh:mm a').format(e)}';
      }
    }
  } catch (_) {}

  final name = (event['astrologer_name'] as String?)?.trim() ?? '';
  final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  final first = parts.isNotEmpty ? parts.first : '';
  final last = parts.length > 1 ? parts.sublist(1).join(' ') : '';
  final fee = event['consultation_fee'];
  final currency = event['currency']?.toString() ?? 'INR';
  final categories = (event['category'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
      <String>[];
  final languages = (event['languages'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
      <String>[];

  Get.to(() => UserConsultationBookingComplete(
        eventId: event['id'] as int? ?? 0,
        categories: categories,
        languages: languages,
        bookingDate: bookingDate,
        bookingTime: bookingTime,
        consultingFee: fee?.toString() ?? '0',
        profileImage: event['astrologer_picture']?.toString() ?? '',
        firstName: first,
        lastName: last,
        currency: currency,
        rating: (event['rating'] as num?)?.toInt() ?? 0,
      ));
}
