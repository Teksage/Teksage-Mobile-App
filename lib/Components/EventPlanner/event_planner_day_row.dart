import 'package:astro_prompt/Model/muhurtha_model.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventPlannerDayRow extends StatelessWidget {
  final MuhurthaDayResult day;

  const EventPlannerDayRow({super.key, required this.day});

  String _periodLabel(String period) {
    if (period == 'Morning') return 'Morning'.tr.toUpperCase();
    if (period == 'Evening') return 'Evening'.tr.toUpperCase();
    if (period == 'Full day') return 'Full day'.tr.toUpperCase();
    return period.toUpperCase();
  }

  List<String> _reasons(MuhurthaDayResult d) {
    final codes = <String>[
      ...d.reasonCodes,
      if (d.reasonCode != null && !d.reasonCodes.contains(d.reasonCode!))
        d.reasonCode!,
    ];
    return codes.map((c) => c.tr).toList();
  }

  List<String> _segmentReasons(MuhurthaDaySegment s) {
    final codes = <String>[
      ...s.reasonCodes,
      if (s.reasonCode != null && !s.reasonCodes.contains(s.reasonCode!))
        s.reasonCode!,
    ];
    return codes.map((c) => c.tr).toList();
  }

  List<String> _windows(MuhurthaDayResult d) {
    if (d.windows.isNotEmpty) return d.windows;
    if (d.window != null && d.window!.isNotEmpty) return [d.window!];
    return [];
  }

  /// Morning/Evening only when the day is not a full weekday exclusion.
  List<MuhurthaDaySegment> _displaySegments(MuhurthaDayResult d) {
    if (d.segments.length <= 1) return const [];
    final weekday = (d.weekday ?? '').toLowerCase();
    if (weekday == 'tuesday' || weekday == 'saturday') return const [];
    final allWeekdayExcluded = d.segments.every((s) {
      final codes = <String>[
        ...s.reasonCodes,
        if (s.reasonCode != null) s.reasonCode!,
      ];
      return codes.contains('weekday_excluded');
    });
    if (allWeekdayExcluded) return const [];
    return d.segments;
  }

  String _statusLabel(bool suitable, {String? rating}) {
    if (!suitable) return '🔴 Not Suitable';
    final r = (rating ?? '').toLowerCase();
    if (r.contains('average')) return '🟠 Average';
    if (r.contains('good') && !r.contains('very')) return '🟡 Good';
    return '🟢 Very Good';
  }

  Widget _statusChip(bool suitable, {String? rating}) {
    return Text(
      _statusLabel(suitable, rating: rating),
      style: TextStyle(
        fontSize: 11,
        fontFamily: AppFont.get(FontType.semiBold),
        color: blackColor,
        height: 1.25,
      ),
    );
  }

  void _showReasonsPopup(BuildContext context, List<String> reasons) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: reasons
              .map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('•  ',
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold))),
                        Expanded(
                          child: Text(
                            r,
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: AppFont.get(FontType.medium),
                              height: 1.4,
                              color: blackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'.tr,
                style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    color: mainColor)),
          ),
        ],
      ),
    );
  }

  Widget _reasonPreview(BuildContext context, List<String> reasons) {
    if (reasons.isEmpty) return const SizedBox.shrink();
    final primary = reasons.first;
    final extra = reasons.length - 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          primary,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 10,
            fontFamily: AppFont.get(FontType.semiBold),
            color: blackColor,
            height: 1.3,
          ),
        ),
        if (extra > 0)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showReasonsPopup(context, reasons),
            child: Padding(
              padding: const EdgeInsets.only(top: 2, left: 8, bottom: 4),
              child: Text(
                '+$extra more',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: AppFont.get(FontType.semiBold),
                  color: blackColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _windowsBlock(List<String> wins) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: wins
            .map((w) => Text(
                  w,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: AppFont.get(FontType.medium),
                    color: blackColor.withValues(alpha: 0.8),
                  ),
                ))
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    // Tue/Sat (or any day where every segment is weekday-excluded): show as one row.
    final split = _displaySegments(day);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: blackColor.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day.date,
                    style: TextStyle(
                        fontFamily: AppFont.get(FontType.semiBold),
                        fontSize: 12)),
                if (day.weekday != null)
                  Text(day.weekday!,
                      style: TextStyle(
                          fontSize: 10,
                          color: blackColor.withValues(alpha: 0.5))),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: split.isEmpty
                ? _statusChip(day.isSuitable, rating: day.rating)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: split.map((s) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_periodLabel(s.period),
                                style: TextStyle(
                                    fontSize: 9,
                                    fontFamily: AppFont.get(FontType.semiBold),
                                    color:
                                        blackColor.withValues(alpha: 0.45))),
                            const SizedBox(height: 3),
                            _statusChip(s.isSuitable, rating: s.rating),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
          Expanded(
            flex: 4,
            child: split.isEmpty
                ? (day.isSuitable && _windows(day).isNotEmpty
                    ? _windowsBlock(_windows(day))
                    : _reasonPreview(context, _reasons(day)))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: split.map((s) {
                      final wins = s.windows.isNotEmpty
                          ? s.windows
                          : (s.window != null ? [s.window!] : <String>[]);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(_periodLabel(s.period),
                                style: TextStyle(
                                    fontSize: 9,
                                    fontFamily: AppFont.get(FontType.semiBold),
                                    color:
                                        blackColor.withValues(alpha: 0.45))),
                            if (s.isSuitable && wins.isNotEmpty)
                              _windowsBlock(wins)
                            else
                              _reasonPreview(context, _segmentReasons(s)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
