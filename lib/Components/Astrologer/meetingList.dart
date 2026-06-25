import 'package:astro_prompt/Model/AstrologerUserConsult/meetings.dart';
import 'package:astro_prompt/Screens/Astrologer/meetingDetailsPage.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class MeetingList extends StatelessWidget {
  final List<Meeting> meetings;
  final bool isUpcoming;

  const MeetingList(
      {super.key, required this.meetings, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    if (meetings.isEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              isUpcoming
                  ? "You have no upcoming meetings at the moment.".tr
                  : "You have no completed meetings at the moment.".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: blackColor.withAlpha(150),
                fontFamily: AppFont.get(FontType.medium),
                fontSize: MyUtility(context).fontSize14,
                height: 1.0,
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: meetings.length,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          decoration: BoxDecoration(
              color: Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: blackColor.withValues(alpha: 0.04), width: 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: lightGrey,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: astroUserConsultBG.withValues(alpha: 0.3),
                            width: 2.6)),
                    child: Center(
                        child: Text(meeting.initials,
                            style: TextStyle(
                                color: mainColor,
                                fontFamily: 'FontSemiBold',
                                fontSize: MyUtility(context).fontSize14,
                                height: 1.0))),
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${meeting.name} ${'booked a slot on'.tr}",
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: MyUtility(context).fontSize12,
                            color: blackColor.withValues(alpha: 0.8)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        meeting.date,
                        style: TextStyle(
                            fontFamily: 'FontSemiBold',
                            fontSize: MyUtility(context).fontSize14,
                            color: blackColor),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => MeetingDetailsPage(
                      meetingId: meeting.meetingId,
                      initials: meeting.initials,
                      name: meeting.fullName,
                      meetingStatus: !isUpcoming,
                      meetingLink: meeting.meetingLink));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: astroUserConsultBG,
                  ),
                  child: Text(
                    'View\nDetails'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'FontSemiBold',
                        fontSize: MyUtility(context).fontSize12,
                        color: whiteColor,
                        height: 1.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
