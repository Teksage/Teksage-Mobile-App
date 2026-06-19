import 'package:flutter/material.dart';

class WaveformBarsPainter extends CustomPainter {
  final List<double> amplitudes;
  final Color color;

  WaveformBarsPainter(this.amplitudes, {this.color = Colors.green});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final barCount = amplitudes.length;
    final barWidth = size.width / (barCount * 2);
    final maxHeight = size.height;

    for (int i = 0; i < barCount; i++) {
      final amp = amplitudes[i];
      final barHeight = amp * maxHeight;

      final x = i * (barWidth * 2);
      final y = (maxHeight - barHeight) / 2;

      final rect = Rect.fromLTWH(x, y, barWidth, barHeight);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
