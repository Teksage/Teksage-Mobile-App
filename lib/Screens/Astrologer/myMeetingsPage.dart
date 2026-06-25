import 'package:astro_prompt/Components/Astrologer/meetingList.dart';
import 'package:astro_prompt/Components/Astrologer/meetingsTab.dart';
import 'package:astro_prompt/Components/Consultation-User/timeConversion.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/meetings.dart';
import 'package:astro_prompt/Services/Astrologer-user/eventsService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MyMeetingsPage extends StatefulWidget {
  final List<AstroConsultationEventModel> eventData;
  const MyMeetingsPage({super.key, required this.eventData});

  @override
  State<MyMeetingsPage> createState() => _MyMeetingsPageState();
}

class _MyMeetingsPageState extends State<MyMeetingsPage> {
  bool isUpcoming = true;
  bool isLoading = true;
  List<AstroConsultationEventModel> allEvents = [];

  @override
  void initState() {
    super.initState();
    allEvents = List<AstroConsultationEventModel>.from(widget.eventData);
    _loadMeetings();
  }

  Future<void> _loadMeetings() async {
    try {
      final userId = await getUserId();
      if (userId == null) return;
      final fetched =
          await AstroUserEventService().fetchAstroUserEvents(userId);
      fetched.sort((a, b) {
        final aTime = DateTime.parse(a.startTime);
        final bTime = DateTime.parse(b.startTime);
        return aTime.compareTo(bTime);
      });
      if (!mounted) return;
      setState(() {
        allEvents = fetched;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading astrologer meetings: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  List<AstroConsultationEventModel> get upcomingMeetings => allEvents
      .where((e) => e.status == 'new' || e.status == 'confirmed')
      .toList();

  List<AstroConsultationEventModel> get completedMeetings =>
      allEvents.where((e) => e.status == 'completed').toList();

  void onTabChanged(bool isUpcomingSelected) {
    setState(() {
      isUpcoming = isUpcomingSelected;
    });
  }

  List<Meeting> _mapEvents(List<AstroConsultationEventModel> events) {
    return events.map((event) {
      final fullName =
          "${event.customerFirstName ?? 'Unknown'} ${event.customerLastName ?? ''}"
              .trim();
      final name = event.customerFirstName?.trim().isNotEmpty == true
          ? event.customerFirstName!.trim()
          : fullName;
      final date = DateFormat("dd MMM, yyyy - h:mm a")
          .format(parseWithoutOffset(event.startTime));
      final initials = fullName.isNotEmpty
          ? fullName
              .split(' ')
              .map((e) => e.isNotEmpty ? e[0] : '')
              .take(2)
              .join()
          : "--";
      return Meeting(
        name: name,
        date: date,
        initials: initials,
        meetingId: event.id,
        fullName: fullName,
        meetingLink: event.eventLink,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Meetings".tr,
            style: TextStyle(
                color: blackColor,
                fontSize: util.fontSize20,
                fontFamily: AppFont.get(FontType.bold),
                height: 1.0)),
        leading: SizedBox(
          width: util.responsiveWidth(0.08),
          height: util.responsiveHeight(0.037),
          child: IconButton(
            icon: SvgPicture.asset(backButton,
                width: util.width20, height: util.height20),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: blackColor.withValues(alpha: 0.3), width: 1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MeetingTabButton(
                  label: "Upcoming",
                  selected: isUpcoming,
                  onTap: () => onTabChanged(true),
                  userPage: false,
                ),
                const SizedBox(width: 8),
                MeetingTabButton(
                  label: "Completed",
                  selected: !isUpcoming,
                  onTap: () => onTabChanged(false),
                  userPage: false,
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: LoadingAnimationWidget.halfTriangleDot(
                      color: astroUserConsultBG,
                      size: util.height30,
                    ),
                  )
                : MeetingList(
                    meetings: _mapEvents(
                        isUpcoming ? upcomingMeetings : completedMeetings),
                    isUpcoming: isUpcoming,
                  ),
          ),
        ],
      ),
    );
  }
}
