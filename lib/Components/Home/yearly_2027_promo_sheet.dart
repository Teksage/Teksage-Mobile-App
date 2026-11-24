import 'package:astro_prompt/Model/yearly_2027_promo_model.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Compact static 2027 promo sheet — matches website list layout.
class Yearly2027PromoSheet extends StatelessWidget {
  final Yearly2027Scores? scores;
  final bool isPremium;
  final bool generating;
  final VoidCallback onClose;
  final VoidCallback onOpenYearly;
  final VoidCallback onUpgrade;

  const Yearly2027PromoSheet({
    super.key,
    required this.scores,
    required this.isPremium,
    required this.generating,
    required this.onClose,
    required this.onOpenYearly,
    required this.onUpgrade,
  });

  static const _starGold = Color(0xFFF0A818);
  static const _ink = Color(0xFF1B5E24);
  static const _cream = Color(0xFFF7FCF4);

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final primary = isPremium ? onOpenYearly : onUpgrade;
    final primaryLabel = isPremium
        ? 'View full 2027 prediction'.tr
        : 'Unlock your full Yearly Prediction'.tr;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: util.height * 0.52),
      child: ColoredBox(
        color: _cream,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Hero(onClose: onClose, util: util),
            Transform.translate(
              offset: const Offset(0, -6),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  util.width20,
                  0,
                  util.width20,
                  6 + bottomInset,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your 2027 Yearly Journey Awaits'.tr,
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.bold),
                        fontSize: util.fontSize14,
                        color: _ink,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      generating && scores == null
                          ? 'Preparing your 2027 scores…'.tr
                          : 'A quick look at your year ahead:'.tr,
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.medium),
                        fontSize: util.fontSize12,
                        color: blackColor.withValues(alpha: 0.55),
                      ),
                    ),
                    if (scores != null) ...[
                      const SizedBox(height: 6),
                      _ScoreList(scores: scores!, util: util),
                    ],
                    const SizedBox(height: 8),
                    _PrimaryCta(label: primaryLabel, onTap: primary, util: util),
                    Center(
                      child: TextButton(
                        onPressed: onClose,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Not now'.tr,
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize12,
                            color: blackColor.withValues(alpha: 0.55),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final VoidCallback onClose;
  final MyUtility util;

  const _Hero({required this.onClose, required this.util});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 92,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            yearly2027ZodiacHd,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.28),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0x8C0A7A08),
                  Color(0x3310B100),
                  Color(0x00000000),
                ],
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x33000000),
                  Color(0x00000000),
                  Color(0x40F7FCF4),
                ],
              ),
            ),
          ),
          Positioned(
            top: 6,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 32,
                height: 3,
                decoration: BoxDecoration(
                  color: whiteColor.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: util.width20,
            right: util.width20,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: util.width10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: blackColor.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Yearly2027PromoSheet._starGold),
                  ),
                  child: Text(
                    '✦ NEW • 2027'.tr,
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.bold),
                      fontSize: util.fontSize12,
                      color: Yearly2027PromoSheet._starGold,
                    ),
                  ),
                ),
                const Spacer(),
                Material(
                  color: blackColor.withValues(alpha: 0.35),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onClose,
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.close, size: 13, color: whiteColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 28,
            child: CustomPaint(painter: _HeroWavePainter()),
          ),
        ],
      ),
    );
  }
}

/// Cream wave + gold edge — mirrors website `yearly-2027-sheet-wave`.
class _HeroWavePainter extends CustomPainter {
  const _HeroWavePainter();

  Path _wavePath(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(0, h * 0.42)
      ..cubicTo(w * 0.15, h * 0.08, w * 0.3, h * 0.78, w * 0.5, h * 0.42)
      ..cubicTo(w * 0.7, h * 0.08, w * 0.85, h * 0.64, w, h * 0.36);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final wave = _wavePath(size);
    final fill = Path.from(wave)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      fill,
      Paint()
        ..color = Yearly2027PromoSheet._cream
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      wave,
      Paint()
        ..color = Yearly2027PromoSheet._starGold.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.25
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PrimaryCta extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final MyUtility util;

  const _PrimaryCta({
    required this.label,
    required this.onTap,
    required this.util,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Yearly2027PromoSheet._starGold),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [mainColor, Color(0xFF0D8F00)],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Yearly2027PromoSheet._starGold),
                  SizedBox(width: util.width8),
                  Container(width: 1, height: 12, color: whiteColor.withValues(alpha: 0.35)),
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.semiBold),
                        fontSize: util.fontSize12,
                        color: whiteColor,
                      ),
                    ),
                  ),
                  const Text('→', style: TextStyle(color: whiteColor, fontSize: 14)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreList extends StatelessWidget {
  final Yearly2027Scores scores;
  final MyUtility util;

  const _ScoreList({required this.scores, required this.util});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Career'.tr, scores.career),
      ('Relationship'.tr, scores.relationship),
      ('Finance'.tr, scores.finance),
      ('Health'.tr, scores.health),
    ];

    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    items[i].$1,
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      fontSize: util.fontSize14,
                      color: Yearly2027PromoSheet._ink,
                    ),
                  ),
                ),
                Text(
                  '${'★' * items[i].$2}${'☆' * (5 - items[i].$2)}',
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    fontSize: util.fontSize16,
                    height: 1,
                    color: Yearly2027PromoSheet._starGold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          if (i < items.length - 1)
            Divider(
              height: 1,
              thickness: 1,
              color: blackColor.withValues(alpha: 0.08),
            ),
        ],
      ],
    );
  }
}
