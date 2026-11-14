import 'package:astro_prompt/Components/Marathon/marathon_event_banner.dart';
import 'package:astro_prompt/Components/Marathon/marathon_flow_widgets.dart';
import 'package:astro_prompt/Model/astroconnect_popup_model.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/Helper/display_timezone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AstroConnectPopupDialog extends StatefulWidget {
  final AstroConnectPopupEvent event;

  const AstroConnectPopupDialog({super.key, required this.event});

  @override
  State<AstroConnectPopupDialog> createState() => _AstroConnectPopupDialogState();
}

class _AstroConnectPopupDialogState extends State<AstroConnectPopupDialog> {
  String? _zone;

  @override
  void initState() {
    super.initState();
    loadViewerTimezone().then((zone) {
      if (mounted) setState(() => _zone = zone);
    });
  }

  String _categoryLine(List<String> categories) {
    const phrases = {'Marriage & Relationships': 'marriage and relationship'};
    final names = categories.where((name) => name.isNotEmpty && name != 'All').toList();
    final chosen = names.isEmpty ? ['Career'] : names;
    return chosen.map((name) => (phrases[name] ?? name).tr).join(' and ');
  }

  String _dateLabel(String iso) {
    try {
      final date = displayDateTimeFromIso(iso, zone: _zone);
      final locale = Get.locale?.toString() ?? 'en_US';
      return DateFormat('EEE, d MMM y', locale).format(date);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final event = widget.event;
    final category = _categoryLine(event.categories);
    final start = marathonWallParts(event.startsAt, zone: _zone);
    final end = marathonWallParts(event.endsAt, zone: _zone);
    final time = start == null || end == null ? '' : marathonTimeRange(start.time, end.time);
    final wide = MediaQuery.sizeOf(context).width >= 700;
    final storyHeight = wide ? 420.0 : 280.0;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: wide ? 20 : 12, vertical: 12),
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: wide ? 720 : 420),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: wide
                  ? IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(width: 320, child: _story(util, category, storyHeight)),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 28, 16, 16),
                              child: _details(util, marathonDisplayName(event.name), _dateLabel(event.startsAt), time),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _story(util, category, storyHeight),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: _details(util, marathonDisplayName(event.name), _dateLabel(event.startsAt), time),
                        ),
                      ],
                    ),
            ),
            Positioned(
              top: 6,
              right: 4,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(false),
                icon: Icon(Icons.close, size: 26, color: blackColor.withValues(alpha: 0.75)),
                tooltip: 'Close'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _story(MyUtility util, String category, double imageHeight) {
    return SizedBox(
      height: imageHeight,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              astroConnectPopupBanner,
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
          ),
          const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xF2FFFFFF), Color(0xB3FFFFFF), Color(0x00FFFFFF)],
          )))),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 150,
            child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00000000), Color(0xE6000000)],
            ))),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: _copy(util, category),
            ),
          ),
        ],
      ),
    );
  }

  Widget _markedLine(MyUtility util, String template, String token, String value) {
    var text = template.tr;
    text = text.replaceFirst(' your ', '\nyour ');
    text = text.replaceFirst(" what's ", "\nwhat's ");
    final parts = text.split(token);
    final style = marathonText(util, FontType.bold, size: util.fontSize24, height: 1.12);
    if (parts.length < 2) {
      return Text(template.tr, style: style);
    }
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: value,
            style: style.copyWith(color: mainColor, fontStyle: FontStyle.italic),
          ),
          TextSpan(text: parts[1]),
        ],
      ),
    );
  }

  Widget _copy(MyUtility util, String category) {
    final footer = "We're bringing together expert astrologers specialising in @category guidance – all in one place, just for you."
        .trParams({'category': category.toLowerCase()});
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: blackColor.withValues(alpha: 0.12)),
          ),
          child: Text('AstroConnect Pro'.tr, style: marathonText(util, FontType.semiBold, size: util.fontSize12)),
        ),
        const SizedBox(height: 14),
        _markedLine(util, 'Stuck in your @category?', '@category', category),
        _markedLine(util, "Not sure what's @word?", '@word', 'Next'.tr),
        const Spacer(),
        Text(
          footer,
          style: marathonText(util, FontType.medium, size: util.fontSize15, color: whiteColor, height: 1.35),
        ),
      ],
    );
  }

  Widget _details(MyUtility util, String name, String date, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('WHAT YOU GET'.tr, style: marathonText(util, FontType.semiBold, color: mainColor)),
        const SizedBox(height: 6),
        Text(name, style: marathonText(util, FontType.bold, size: util.fontSize16)),
        const SizedBox(height: 12),
        _perk(util, Icons.schedule_rounded, 'Exclusive 15-min one-on-one'.tr),
        _perk(util, Icons.public_rounded, 'Online — join from anywhere'.tr),
        _perk(util, Icons.event_available_rounded, 'Limited slots available'.tr),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _when(util, 'DATE'.tr, date)),
            const SizedBox(width: 10),
            Expanded(child: _when(util, 'TIME'.tr, time)),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              foregroundColor: whiteColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Book your session'.tr, style: marathonText(util, FontType.semiBold, color: whiteColor)),
          ),
        ),
      ],
    );
  }

  Widget _perk(MyUtility util, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: mainColor),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: marathonText(util, FontType.medium))),
        ],
      ),
    );
  }

  Widget _when(MyUtility util, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: blackColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.45))),
          const SizedBox(height: 4),
          Text(value, style: marathonText(util, FontType.semiBold)),
        ],
      ),
    );
  }
}
