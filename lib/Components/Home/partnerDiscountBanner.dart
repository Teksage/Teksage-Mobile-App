import 'dart:async';
import 'dart:ui' show FontFeature;

import 'package:astro_prompt/Services/PartnerService/partnerDiscountHelpers.dart';
import 'package:astro_prompt/Services/PartnerService/partnerReferralService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Home referral discount card — mirrors website `PartnerDiscountHomeBanner`.
class PartnerDiscountBanner extends StatefulWidget {
  const PartnerDiscountBanner({super.key});

  @override
  State<PartnerDiscountBanner> createState() => _PartnerDiscountBannerState();
}

class _PartnerDiscountBannerState extends State<PartnerDiscountBanner>
    with WidgetsBindingObserver {
  static const _cardRadius = 16.0;
  static const _sectionGap = 20.0;
  static const _borderAlpha = 0.18;
  static const _rowDivider = Color(0xFFF5F5F5);

  PartnerDiscountState? _discount;
  Timer? _timer;
  PartnerCountdownParts _parts = const PartnerCountdownParts(expired: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _load();
  }

  @override
  void activate() {
    super.activate();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await PartnerReferralService.fetchMyDiscount();
      if (!mounted) return;
      setState(() => _discount = data);
      _restartTimer();
    } catch (_) {}
  }

  void _restartTimer() {
    _timer?.cancel();
    final d = _discount;
    if (d == null || !d.hasDiscount || !partnerBannerShowTimer(d)) return;
    void tick() {
      if (!mounted) return;
      setState(() => _parts = partnerCountdownParts(d.expiresAt));
      if (_parts.expired) _timer?.cancel();
    }

    tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  TextStyle get _titleStyle => TextStyle(
        fontFamily: AppFont.get(FontType.bold),
        fontSize: 14,
        height: 1.2,
        color: mainColor,
      );

  TextStyle get _timerStyle => TextStyle(
        fontFamily: 'monospace',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.0,
        color: mainColor,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  TextStyle get _rowLabelStyle => TextStyle(
        fontFamily: AppFont.get(FontType.medium),
        fontSize: 14,
        height: 1.2,
        color: blackColor,
      );

  Widget _pctChip(double pct) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '${pct.round()}% off'.tr,
        style: TextStyle(
          fontFamily: AppFont.get(FontType.bold),
          fontSize: 10,
          height: 1.0,
          color: whiteColor,
        ),
      ),
    );
  }

  Widget _statusChip(String label) {
    Color bg;
    Color fg;
    switch (label) {
      case 'Used':
        bg = const Color(0x1F2E7D32);
        fg = const Color(0xFF1B5E20);
        break;
      case 'Expired':
        bg = const Color(0x1FED6C02);
        fg = const Color(0xFFE65100);
        break;
      default:
        bg = const Color(0x24757575);
        fg = const Color(0xFF616161);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.tr,
        style: TextStyle(
          fontFamily: AppFont.get(FontType.bold),
          fontSize: 10,
          height: 1.0,
          color: fg,
        ),
      ),
    );
  }

  Widget _bannerRow(PartnerBannerRow row, {required bool isLast}) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: _rowDivider)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(row.label.tr, style: _rowLabelStyle)),
          const SizedBox(width: 12),
          if (row.isPct)
            _pctChip(row.pct!)
          else if (row.statusLabel != null)
            _statusChip(row.statusLabel!),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = _discount;
    if (d == null || !d.hasDiscount) return const SizedBox.shrink();

    final rows = partnerBannerRows(d);
    if (rows.isEmpty) return const SizedBox.shrink();

    final showTimer = partnerBannerShowTimer(d);
    final timerLabel = _parts.expired
        ? 'Expired'.tr
        : '${formatPartnerCountdown(_parts)} ${'left'.tr}';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: _sectionGap, bottom: _sectionGap),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: mainColor.withValues(alpha: _borderAlpha)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text('Referral discount'.tr, style: _titleStyle),
                ),
                if (showTimer) ...[
                  const SizedBox(width: 8),
                  Text(timerLabel, style: _timerStyle, textAlign: TextAlign.right),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++)
                  _bannerRow(rows[i], isLast: i == rows.length - 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
