import 'package:astro_prompt/Screens/Marathon/marathon_summary_page.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonMeetingSection extends StatelessWidget {
  const MarathonMeetingSection({super.key, required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your meeting details'.tr,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.bold),
              color: blackColor,
            ),
          ),
          ...rows.map((row) {
            final rawId = row['id'];
            final bookingId = rawId is int ? rawId : int.tryParse('$rawId') ?? 0;
            final link = '${row['meeting_link'] ?? ''}'.trim();
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${row['starts_at'] ?? ''}'),
              subtitle: Text(
                link.isNotEmpty
                    ? 'Meeting Link'.tr
                    : 'Your astrologer will be assigned and the meeting link will be shared within 8 hours.'.tr,
              ),
              onTap: bookingId > 0
                  ? () => Get.to(() => MarathonSummaryPage(bookingId: bookingId))
                  : null,
            );
          }),
        ],
      ),
    );
  }
}
