import 'package:astro_prompt/Components/Marathon/marathon_event_banner.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_fee.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_list_page.dart';
import 'package:astro_prompt/Services/Marathon/marathon_service.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/Helper/display_timezone.dart';
import 'package:astro_prompt/config/ask_astrologer_config.dart';
import 'package:astro_prompt/config/marathon_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

const _whatsappMark = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none">
  <path fill="#25D366" d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.435 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413z"/>
</svg>
''';

class MarathonSummaryPage extends StatefulWidget {
  const MarathonSummaryPage({super.key, required this.bookingId, this.justPaid = false});

  final int bookingId;
  final bool justPaid;

  @override
  State<MarathonSummaryPage> createState() => _MarathonSummaryPageState();
}

class _MarathonSummaryPageState extends State<MarathonSummaryPage> {
  Map<String, dynamic>? booking;
  bool loaded = false;
  String? viewerZone;

  @override
  void initState() {
    super.initState();
    loadViewerTimezone().then((zone) {
      if (mounted) setState(() => viewerZone = zone);
    });
    _load();
    if (widget.justPaid) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showSuccessSnackBar(context, 'Payment successful!');
      });
    }
  }

  Future<void> _load() async {
    final rows = await MarathonService().mine();
    Map<String, dynamic>? match;
    for (final row in rows) {
      if (row['id'] == widget.bookingId) match = row;
    }
    if (!mounted) return;
    setState(() {
      booking = match;
      loaded = true;
    });
  }

  Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final row = booking;
    final start = marathonWallParts(row?['starts_at']?.toString(), zone: viewerZone);
    final end = marathonWallParts(row?['ends_at']?.toString(), zone: viewerZone);
    final link = '${row?['meeting_link'] ?? ''}'.trim();
    final currency = '${row?['currency'] ?? 'INR'}';
    final parts = marathonFeeIncluded(double.tryParse('${row?['fee']}') ?? 0, currency);
    String money(double amount) => currency == 'USD' ? '\$${amount.toStringAsFixed(2)}' : '₹${amount.toStringAsFixed(2)}';
    final category = (row?['categories'] as List?)?.isNotEmpty == true ? '${(row?['categories'] as List).first}' : '';
    final astrologer = '${row?['astrologer_name'] ?? ''}'.trim();
    final query = '${row?['customer_query'] ?? ''}'.trim();
    final languageId = '${row?['preferred_language'] ?? ''}'.trim();
    final language = languageId.isEmpty ? '' : AskAstrologerLanguages.labelFor(languageId).tr;
    final memberName = '${row?['member_display_name'] ?? ''}'.trim();
    final memberLine = memberName.isEmpty ? '' : '$memberName (${_relatedLabel('${row?['relationship'] ?? ''}')})';
    return Scaffold(
      backgroundColor: const Color(0xffF4FBF3),
      appBar: AppBar(
        backgroundColor: const Color(0xffF4FBF3),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(appBackButton, colorFilter: const ColorFilter.mode(blackColor, BlendMode.srcIn)),
          onPressed: () => Get.off(() => const MarathonListPage()),
        ),
        title: Text(
          'Go back'.tr,
          style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize16, color: blackColor),
        ),
      ),
      body: !loaded
          ? const Center(child: CircularProgressIndicator(color: mainColor))
          : row == null
              ? Center(child: Text('No Expert Hours event is open right now.'.tr))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: blackColor.withValues(alpha: 0.08)),
                        boxShadow: [BoxShadow(color: blackColor.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 8))],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: mainColor,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: mainColor.withValues(alpha: 0.28), blurRadius: 20, offset: const Offset(0, 8))],
                            ),
                            child: const Icon(Icons.check, color: whiteColor, size: 36),
                          ),
                          const SizedBox(height: 16),
                          Text('Payment completed'.tr, style: TextStyle(fontFamily: AppFont.get(FontType.bold), fontSize: util.fontSize18, color: blackColor)),
                          const SizedBox(height: 4),
                          Text(
                            marathonDisplayName(row['event_name']?.toString()),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize16, color: mainColor),
                          ),
                          if (category.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(color: mainColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                              child: Text(category.tr, style: TextStyle(color: mainColor, fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize12)),
                            ),
                          ],
                          const SizedBox(height: 16),
                          if (link.isNotEmpty)
                            FilledButton(
                              onPressed: () => _open(link),
                              style: FilledButton.styleFrom(
                                backgroundColor: mainColor,
                                foregroundColor: whiteColor,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: const StadiumBorder(),
                              ),
                              child: Text('Join Meeting'.tr, style: TextStyle(fontFamily: AppFont.get(FontType.bold))),
                            )
                          else
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: mainColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Your astrologer will be assigned and the meeting link will be shared within 1 hour.'.tr,
                                style: TextStyle(color: blackColor, fontSize: util.fontSize13, height: 1.4),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: blackColor.withValues(alpha: 0.08)),
                        boxShadow: [BoxShadow(color: blackColor.withValues(alpha: 0.05), blurRadius: 24, offset: const Offset(0, 8))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: mainColor.withValues(alpha: 0.12),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                            child: Text('Your meeting details'.tr, style: TextStyle(fontFamily: AppFont.get(FontType.bold), fontSize: util.fontSize16)),
                          ),
                          _row('Date'.tr, _dateLabel(start), util, last: false),
                          _row('Time'.tr, start == null || end == null ? '' : marathonTimeRange(start.time, end.time), util, last: false),
                          _row('Duration'.tr, '15 minutes'.tr, util, last: false),
                          _row('Consultation fee'.tr, money(parts.base), util, last: false),
                          if (parts.taxed) _row('${'CGST'.tr} (${parts.cgstPct}%)', money(parts.cgst), util, last: false),
                          if (parts.taxed) _row('${'SGST'.tr} (${parts.sgstPct}%)', money(parts.sgst), util, last: false),
                          _row('Total'.tr, money(parts.total), util, last: language.isEmpty && query.isEmpty && astrologer.isEmpty && memberLine.isEmpty),
                          if (memberLine.isNotEmpty)
                            _row('Relationship to you'.tr, memberLine, util, last: language.isEmpty && query.isEmpty && astrologer.isEmpty),
                          if (language.isNotEmpty) _row('Preferred consultation language'.tr, language, util, last: query.isEmpty && astrologer.isEmpty),
                          if (query.isNotEmpty) _row('Your question'.tr, query, util, last: astrologer.isEmpty),
                          if (astrologer.isNotEmpty) _row('Astrologer'.tr, astrologer, util, last: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: mainColor.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: mainColor.withValues(alpha: 0.16)),
                      ),
                      child: Column(
                        children: [
                          _storeButton(
                            label: 'Login to Web App'.tr,
                            filled: true,
                            icon: SvgPicture.asset(
                              marathonWebArrow,
                              width: 18,
                              height: 16,
                              colorFilter: const ColorFilter.mode(whiteColor, BlendMode.srcIn),
                            ),
                            onTap: () => _open(MarathonConfig.websiteBookingUrl(widget.bookingId)),
                          ),
                          const SizedBox(height: 10),
                          _storeButton(
                            label: 'Get it on Android'.tr,
                            filled: false,
                            icon: SvgPicture.asset(
                              marathonPlayStore,
                              width: 16,
                              height: 18,
                              colorFilter: const ColorFilter.mode(mainColor, BlendMode.srcIn),
                            ),
                            onTap: () => _open(MarathonConfig.playStoreUrl),
                          ),
                          const SizedBox(height: 10),
                          _storeButton(
                            label: 'Contact via WhatsApp'.tr,
                            filled: false,
                            icon: SvgPicture.string(_whatsappMark, width: 20, height: 20),
                            onTap: () => _open(MarathonConfig.supportWhatsAppUrl()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  String _dateLabel(({String day, String month, String time})? start) {
    if (start == null || start.month.isEmpty) return '';
    final month = '${start.month[0]}${start.month.substring(1).toLowerCase()}';
    return '$month ${start.day}';
  }

  Widget _row(String label, String value, MyUtility util, {required bool last}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: last ? null : Border(bottom: BorderSide(color: blackColor.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: blackColor.withValues(alpha: 0.5), fontSize: util.fontSize13))),
          Flexible(
            child: Text(value, textAlign: TextAlign.right, style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize13, color: blackColor)),
          ),
        ],
      ),
    );
  }

  Widget _storeButton({required String label, required bool filled, required Widget icon, required VoidCallback onTap}) {
    final style = TextStyle(fontFamily: AppFont.get(FontType.semiBold), color: filled ? whiteColor : mainColor);
    final child = LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: (constraints.maxWidth - 36).clamp(80, constraints.maxWidth)),
              child: Text(label, textAlign: TextAlign.center, softWrap: true, style: style),
            ),
          ],
        );
      },
    );
    final padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
    if (filled) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: mainColor,
            foregroundColor: whiteColor,
            padding: padding,
            shape: const StadiumBorder(),
          ),
          child: child,
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: mainColor,
          side: BorderSide(color: mainColor.withValues(alpha: 0.35)),
          padding: padding,
          shape: const StadiumBorder(),
          backgroundColor: whiteColor.withValues(alpha: 0.8),
        ),
        child: child,
      ),
    );
  }
}

String _relatedLabel(String code) {
  const labels = {
    'spouse': 'Spouse',
    'brother': 'Brother',
    'sister': 'Sister',
    'father': 'Father',
    'mother': 'Mother',
    'son': 'Son',
    'daughter': 'Daughter',
    'friend': 'Friend',
    'other': 'Others',
  };
  final label = labels[code] ?? code;
  return label.isEmpty ? label : label.tr;
}
