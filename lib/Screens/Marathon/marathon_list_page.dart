import 'package:astro_prompt/Components/Marathon/marathon_event_banner.dart';
import 'package:astro_prompt/Components/Marathon/marathon_list_hero.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_detail_page.dart';
import 'package:astro_prompt/Services/Marathon/marathon_service.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

class MarathonListPage extends StatefulWidget {
  const MarathonListPage({super.key});

  @override
  State<MarathonListPage> createState() => _MarathonListPageState();
}

class _MarathonListPageState extends State<MarathonListPage> {
  final MarathonService _service = MarathonService();
  List<Map<String, dynamic>> events = [];
  List<Map<String, dynamic>> mine = [];
  bool loading = true;
  String error = '';
  bool showUpcoming = true;

  @override
  void initState() {
    super.initState();
    final locale = Get.locale?.toString() ?? 'en_US';
    initializeDateFormatting(locale);
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await _service.publicList();
      rows.sort((left, right) => '${right['starts_at']}'.compareTo('${left['starts_at']}'));
      final token = await getAccessToken();
      final past = token.isEmpty ? <Map<String, dynamic>>[] : await _service.mine();
      if (!mounted) return;
      setState(() {
        events = rows;
        mine = past;
        loading = false;
      });
    } catch (err) {
      if (!mounted) return;
      setState(() {
        error = err.toString().replaceFirst('Exception: ', '');
        loading = false;
      });
    }
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
            colorFilter: const ColorFilter.mode(blackColor, BlendMode.srcIn),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Teksage Expert Hours'.tr,
          style: TextStyle(
            fontFamily: AppFont.get(FontType.bold),
            fontSize: util.fontSize16,
            color: blackColor,
          ),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: mainColor))
          : Builder(
              builder: (context) {
                final now = DateTime.now();
                bool upcoming(Map<String, dynamic> event) {
                  final end = DateTime.tryParse('${event['ends_at'] ?? ''}');
                  final ended = event['admin_ended'] == true;
                  return !ended && (end == null || !end.isBefore(now));
                }

                final visible = events.where((event) => showUpcoming ? upcoming(event) : !upcoming(event)).toList();
                final pastCount = events.where((event) => !upcoming(event)).length;
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const MarathonListHero(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => showUpcoming = true),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: showUpcoming ? mainColor : whiteColor,
                              foregroundColor: showUpcoming ? whiteColor : mainColor,
                              side: const BorderSide(color: mainColor),
                            ),
                            child: Text('Upcoming'.tr),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => showUpcoming = false),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: !showUpcoming ? mainColor : whiteColor,
                              foregroundColor: !showUpcoming ? whiteColor : mainColor,
                              side: const BorderSide(color: mainColor),
                            ),
                            child: Text('${'Past'.tr} ($pastCount)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (error.isNotEmpty) Text(error, style: const TextStyle(color: Colors.red)),
                    if (visible.isEmpty) Text('No Expert Hours event is open right now.'.tr),
                    ...visible.map((event) {
                      final ended = event['admin_ended'] == true;
                      final bookedRows = mine.where((row) => row['marathon_id'] == event['id']).toList();
                      return MarathonEventBanner(
                        event: event,
                        bookings: bookedRows,
                        onTap: () {
                          if (ended && bookedRows.isEmpty) return;
                          Get.to(() => MarathonDetailPage(id: event['id'] as int));
                        },
                      );
                    }),
                  ],
                );
              },
            ),
    );
  }
}
