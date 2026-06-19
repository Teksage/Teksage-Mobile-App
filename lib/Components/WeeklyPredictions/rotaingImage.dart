import 'dart:math' as math;
import 'package:flutter/material.dart';

class RotatingImage extends StatefulWidget {
  final String imagePath;
  final double width;
  const RotatingImage({super.key, required this.imagePath, required this.width});

  @override
  State<RotatingImage> createState() => _RotatingImageState();
}

class _RotatingImageState extends State<RotatingImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 61,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: child,
          );
        },
        child: Image.asset(
          widget.imagePath,
          width: widget.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
