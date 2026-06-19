import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter {
  final double animationValue;
  ArcPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Color(0xFFF8F9FE).withValues(alpha: 0.08);

    double centerX = size.width / 2;
    double baseY = size.height;

    for (int i = 0; i < 4; i++) {
      double scaleFactor = (animationValue + i * 0.3) % 1;
      double rx = (scaleFactor * 300) + 30;
      double ry = (scaleFactor * 200) + 30;

      paint.color = Color(0xFFF8F9FE).withValues(alpha: 0.08 * (1 - i * 0.2));

      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(centerX, baseY),
          width: rx * 2,
          height: ry * 2,
        ),
        3.14,
        3.14,
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
