import 'package:astro_prompt/Services/PartnerService/partnerReferralService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PartnerDiscountBanner extends StatefulWidget {
  const PartnerDiscountBanner({super.key});

  @override
  State<PartnerDiscountBanner> createState() => _PartnerDiscountBannerState();
}

class _PartnerDiscountBannerState extends State<PartnerDiscountBanner>
    with WidgetsBindingObserver {
  Map<String, dynamic>? _discount;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _load();
    }
  }

  @override
  void activate() {
    super.activate();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await PartnerReferralService.fetchMyDiscount();
      if (mounted) setState(() => _discount = data);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final d = _discount;
    if (d == null || d['has_discount'] != true) {
      return const SizedBox.shrink();
    }

    final codeActive = d['code_active'] != false;
    if (!codeActive) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Referral code inactive'.tr,
              style: TextStyle(
                fontFamily: AppFont.get(FontType.semibold),
                color: Colors.grey.shade800,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              (d['message'] ??
                      'This referral code is no longer active. Discount cannot be used on new purchases.')
                  .toString()
                  .tr,
              style: TextStyle(
                fontFamily: AppFont.get(FontType.medium),
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      );
    }

    final showSub = d['show_subscription_row'] == true;
    final showConsult = d['show_consultation_row'] == true;
    if (!showSub && !showConsult) return const SizedBox.shrink();
    final days = '${d['days_left'] ?? 0}';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: homeBannerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Referral discount'.tr,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.semibold),
              color: mainColor,
              fontSize: 14,
            ),
          ),
          if (showSub)
            Text(
              'Subscription discount — @days days left'.trParams({'days': days}),
              style: TextStyle(fontFamily: AppFont.get(FontType.medium), fontSize: 13),
            ),
          if (showConsult)
            Text(
              'Consultation discount — @days days left'.trParams({'days': days}),
              style: TextStyle(fontFamily: AppFont.get(FontType.medium), fontSize: 13),
            ),
        ],
      ),
    );
  }
}
