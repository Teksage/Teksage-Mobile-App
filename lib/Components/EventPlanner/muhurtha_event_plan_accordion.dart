import 'package:astro_prompt/Components/EventPlanner/event_planner_day_row.dart';
import 'package:astro_prompt/Model/muhurtha_model.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MuhurthaEventPlanAccordion extends StatefulWidget {
  final MuhurthaResult result;

  const MuhurthaEventPlanAccordion({super.key, required this.result});

  @override
  State<MuhurthaEventPlanAccordion> createState() =>
      _MuhurthaEventPlanAccordionState();
}

class _MuhurthaEventPlanAccordionState extends State<MuhurthaEventPlanAccordion> {
  bool _open = false;

  String _formatRange(String start, String end) {
    try {
      final s = DateTime.parse(start);
      final e = DateTime.parse(end);
      final fmt = DateFormat('d MMM yyyy');
      return '${fmt.format(s)} – ${fmt.format(e)}';
    } catch (_) {
      return '$start – $end';
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = widget.result.displayDays;
    return Container(
      decoration: BoxDecoration(
        color: blackColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: blackColor.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your event plan'.tr,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: AppFont.get(FontType.semiBold),
                            color: blackColor.withValues(alpha: 0.45),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.result.event.tr,
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.semiBold),
                            fontSize: 14,
                          ),
                        ),
                        if (widget.result.startDate.isNotEmpty &&
                            widget.result.endDate.isNotEmpty)
                          Text(
                            _formatRange(
                                widget.result.startDate, widget.result.endDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: blackColor.withValues(alpha: 0.5),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    _open
                        ? 'Hide event plan'.tr
                        : 'View event plan'.tr,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: AppFont.get(FontType.semiBold),
                      color: mainColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_open) ...[
            Divider(height: 1, color: blackColor.withValues(alpha: 0.08)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text('Date'.tr,
                        style: TextStyle(
                            fontSize: 11,
                            fontFamily: AppFont.get(FontType.semiBold),
                            color: blackColor.withValues(alpha: 0.5))),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text('Status'.tr,
                        style: TextStyle(
                            fontSize: 11,
                            fontFamily: AppFont.get(FontType.semiBold),
                            color: blackColor.withValues(alpha: 0.5))),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text('Details'.tr,
                        style: TextStyle(
                            fontSize: 11,
                            fontFamily: AppFont.get(FontType.semiBold),
                            color: blackColor.withValues(alpha: 0.5))),
                  ),
                ],
              ),
            ),
            ...rows.map((d) => EventPlannerDayRow(day: d)),
            if (widget.result.location.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.result.location,
                    style: TextStyle(
                      fontSize: 11,
                      color: blackColor.withValues(alpha: 0.45),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
