import 'dart:math' as math;

import 'package:astro_prompt/Model/AstrologerUserConsult/coupon_model.dart';

const int kPartnerYearlyPlanId = 3;
const String kPartnerCheckoutCode = 'REFERRAL';
const double kInrCgstPct = 9;
const double kInrSgstPct = 9;

class PartnerDiscountState {
  final bool hasDiscount;
  final bool codeActive;
  final bool showConsultationRow;
  final bool showSubscriptionRow;
  final double consultPct;
  final double yearlyPct;
  final String consultStatus;
  final String yearlyStatus;
  final int daysLeft;
  final String? expiresAt;
  final String? message;

  const PartnerDiscountState({
    required this.hasDiscount,
    this.codeActive = true,
    this.showConsultationRow = false,
    this.showSubscriptionRow = false,
    this.consultPct = 0,
    this.yearlyPct = 0,
    this.consultStatus = 'na',
    this.yearlyStatus = 'na',
    this.daysLeft = 0,
    this.expiresAt,
    this.message,
  });

  factory PartnerDiscountState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PartnerDiscountState(hasDiscount: false);
    }
    return PartnerDiscountState(
      hasDiscount: json['has_discount'] == true,
      codeActive: json['code_active'] != false,
      showConsultationRow: json['show_consultation_row'] == true,
      showSubscriptionRow: json['show_subscription_row'] == true,
      consultPct: (json['consult_pct'] as num?)?.toDouble() ?? 0,
      yearlyPct: (json['yearly_pct'] as num?)?.toDouble() ?? 0,
      consultStatus: (json['consult_status'] ?? 'na').toString(),
      yearlyStatus: (json['yearly_status'] ?? 'na').toString(),
      daysLeft: (json['days_left'] as num?)?.toInt() ?? 0,
      expiresAt: json['expires_at']?.toString(),
      message: json['message']?.toString(),
    );
  }

  double consultPctForCheckout() {
    if (!hasDiscount || !codeActive || !showConsultationRow) return 0;
    return math.max(0, consultPct);
  }

  double yearlyPctForCheckout(int? planId) {
    if (planId != kPartnerYearlyPlanId) return 0;
    if (!hasDiscount || !codeActive || !showSubscriptionRow) return 0;
    return math.max(0, yearlyPct);
  }
}

class PartnerBannerRow {
  final String label;
  final double? pct;
  final String? statusLabel;

  const PartnerBannerRow({required this.label, this.pct, this.statusLabel});

  bool get isPct => pct != null && pct! > 0;
}

bool _rowEligible(String status, double pct) => status != 'na' || pct > 0;

String _resolveStatus(String status, bool codeActive) {
  if (!codeActive && status == 'active') return 'revoked';
  return status;
}

List<PartnerBannerRow> partnerBannerRows(PartnerDiscountState discount) {
  final rows = <PartnerBannerRow>[];
  final codeActive = discount.codeActive;

  void push(String label, String status, double pct) {
    if (!_rowEligible(status, pct)) return;
    final resolved = _resolveStatus(status, codeActive);
    if (resolved == 'active' && pct > 0 && discount.daysLeft > 0) {
      rows.add(PartnerBannerRow(label: label, pct: pct));
      return;
    }
    if (resolved == 'consumed') {
      rows.add(PartnerBannerRow(label: label, statusLabel: 'Used'));
      return;
    }
    if (resolved == 'expired') {
      rows.add(PartnerBannerRow(label: label, statusLabel: 'Expired'));
      return;
    }
    if (resolved == 'revoked') {
      rows.add(PartnerBannerRow(label: label, statusLabel: 'Referral is inactive'));
    }
  }

  push('Yearly plan', discount.yearlyStatus, discount.yearlyPct);
  push('Consultation', discount.consultStatus, discount.consultPct);
  return rows;
}

bool partnerBannerShowTimer(PartnerDiscountState discount) {
  if (!discount.codeActive) return false;
  if (discount.daysLeft <= 0) return false;
  return discount.consultStatus == 'active' ||
      discount.yearlyStatus == 'active';
}

double _round2(double n) => (n * 100).roundToDouble() / 100;

/// Client-side partner % pricing (mirrors website consultation-pricing).
CouponModel partnerPricingFromFee({
  required double fee,
  required String currency,
  required double partnerPct,
}) {
  final pct = math.max(0, partnerPct);
  final discount = pct > 0 ? _round2(fee * (pct / 100)) : 0.0;
  final discounted = _round2(math.max(0, fee - discount));
  if (currency.toUpperCase() == 'INR') {
    final cgst = _round2(discounted * kInrCgstPct / 100);
    final sgst = _round2(discounted * kInrSgstPct / 100);
    return CouponModel(
      planPrice: fee,
      discount: discount,
      discountedPrice: discounted,
      cgstPercentage: kInrCgstPct,
      cgstAmount: cgst,
      sgstPercentage: kInrSgstPct,
      sgstAmount: sgst,
      finalPrice: _round2(discounted + cgst + sgst),
      couponId: 0,
    );
  }
  return CouponModel(
    planPrice: fee,
    discount: discount,
    discountedPrice: discounted,
    cgstPercentage: 0,
    cgstAmount: 0,
    sgstPercentage: 0,
    sgstAmount: 0,
    finalPrice: discounted,
    couponId: 0,
  );
}

DateTime? partnerExpiresAt(String? expiresAt) {
  if (expiresAt == null || expiresAt.trim().isEmpty) return null;
  final raw = expiresAt.trim();
  final hasZone = RegExp(r'(Z|[+-]\d{2}:?\d{2})$', caseSensitive: false)
      .hasMatch(raw);
  try {
    return DateTime.parse(hasZone ? raw : '${raw}Z').toUtc();
  } catch (_) {
    return null;
  }
}

class PartnerCountdownParts {
  final bool expired;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  const PartnerCountdownParts({
    required this.expired,
    this.days = 0,
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
  });
}

PartnerCountdownParts partnerCountdownParts(String? expiresAt, {DateTime? now}) {
  final end = partnerExpiresAt(expiresAt);
  if (end == null) {
    return const PartnerCountdownParts(expired: true);
  }
  final current = (now ?? DateTime.now()).toUtc();
  var totalMs = end.difference(current).inMilliseconds;
  if (totalMs <= 0) {
    return const PartnerCountdownParts(expired: true);
  }
  final totalSec = totalMs ~/ 1000;
  return PartnerCountdownParts(
    expired: false,
    days: totalSec ~/ 86400,
    hours: (totalSec % 86400) ~/ 3600,
    minutes: (totalSec % 3600) ~/ 60,
    seconds: totalSec % 60,
  );
}

String formatPartnerCountdown(PartnerCountdownParts parts) {
  if (parts.expired) return '00:00:00';
  String pad(int n) => n.toString().padLeft(2, '0');
  final hms =
      '${pad(parts.hours)}:${pad(parts.minutes)}:${pad(parts.seconds)}';
  if (parts.days > 0) return '${parts.days}d $hms';
  return hms;
}
