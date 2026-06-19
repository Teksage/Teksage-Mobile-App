import 'dart:ui';
import 'package:astro_prompt/Model/AstrologerUserConsult/coupon_model.dart';
import 'package:astro_prompt/Services/Astrologer-user/paymentService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:get/get.dart';


class PromoCodeContainer extends StatefulWidget {
  final int? planId;
  final String currency;
  final Color applyBorderColor;
  final Color backgroundColor;
  final Color fontColor;
  final Color containerBorderColor;
  final String couponType;
  final double? amount;
  final Color applyFontColor;
  final void Function(CouponModel? newAmount)? onCouponApplied;
  const PromoCodeContainer(
      {super.key,
      this.planId,
      this.onCouponApplied,
      required this.currency,
      required this.applyBorderColor,
      required this.backgroundColor,
      required this.fontColor,
      required this.containerBorderColor,
      required this.couponType,
      this.amount,
      required this.applyFontColor});

  @override
  State<PromoCodeContainer> createState() => _PromoCodeContainerState();
}

class _PromoCodeContainerState extends State<PromoCodeContainer> {
  final TextEditingController _controller = TextEditingController();
  bool _isApplied = false;
  bool _isLoading = false;
  bool _isValid = false;
  String errorText = '';
  String _appliedCode = '';
  double discountAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final currentText = _controller.text.trim();
      if ((_isApplied || _isValid || errorText.isNotEmpty) &&
          currentText != _appliedCode) {
        setState(() {
          _isApplied = false;
          _isValid = false;
          errorText = '';
          widget.onCouponApplied?.call(null);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _applyCoupon() async {
    FocusScope.of(context).unfocus();

    final couponName = _controller.text.trim();
    if (couponName.isEmpty) return;

    setState(() => _isLoading = true);
    final service = PaymentService();
    final result = await service.applyCoupon(
        couponName: couponName,
        planId: widget.planId,
        currency: widget.currency,
        couponType: widget.couponType,
        consultationAmount: widget.amount);
    setState(() {
      _isLoading = false;
      if (result != null) {
        _isApplied = true;
        _isValid = true;
        _appliedCode = couponName;
        discountAmount = result.discount;
        print('Result: ${result.discount}');
        widget.onCouponApplied?.call(result);
      } else {
        _isApplied = false;
        _isValid = false;
        errorText = 'Invalid or expired promo code.';
        _appliedCode = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: whiteColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
            border: _isValid
                ? Border.all(color: widget.applyBorderColor, width: 1)
                : null,
          ),
          child: CustomPaint(
            painter: _isValid
                ? null
                : DashedBorderPainter(borderColor: widget.containerBorderColor),
            child: Container(
              padding: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(6),
                // border: Border.all(color: whiteColor.withValues(alpha: 0.32), width: 1)
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      // enabled: !_isApplied,
                      style: TextStyle(
                          color: widget.fontColor,
                          fontFamily: AppFont.get(FontType.medium),
                          fontSize: MyUtility(context).fontSize16,
                          height: 1.0),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Promo Code'.tr,
                        hintStyle: TextStyle(
                            color: widget.fontColor,
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: MyUtility(context).fontSize14,
                            height: 1.0),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _isApplied || _isLoading ? null : _applyCoupon,
                    child: Text(
                      _isApplied ? 'Applied'.tr : 'Apply'.tr,
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.medium),
                          fontSize: MyUtility(context).fontSize14,
                          height: 1.0,
                          color: widget.applyFontColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        (_isApplied && widget.couponType == 'consultation')
            ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Coupon applied & you saved',
                      style: TextStyle(
                          color: astroUserConsultBG,
                          fontSize: MyUtility(context).fontSize14,
                          fontFamily: AppFont.get(FontType.medium),
                          height: 1.0),
                    ),
                    Text(
                      '${widget.currency == 'INR' ? '₹' : '\$'} ${discountAmount.toStringAsFixed(2)}/-',
                      style: TextStyle(
                          color: astroUserConsultBG,
                          fontSize: MyUtility(context).fontSize14,
                          fontFamily: AppFont.get(FontType.medium),
                          height: 1.0),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
        (!_isApplied && errorText.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  errorText,
                  style: TextStyle(color: errorColor),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color borderColor;

  DashedBorderPainter({required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor.withValues(alpha: 0.32)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final dashWidth = 3;
    final dashSpace = 3;
    final radius = 6.0;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(radius),
      ));

    final dashedPath = Path();
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final len = dashWidth.toDouble();
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + len),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
