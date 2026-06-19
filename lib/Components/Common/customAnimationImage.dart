import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAnimationAstrologerIcon extends StatefulWidget {
  final String imagePath;
  final double floatRange;
  final Duration duration;

  const CustomAnimationAstrologerIcon({
    required this.imagePath,
    this.floatRange = 10,
    this.duration = const Duration(seconds: 2),
    super.key,
  });

  @override
  State<CustomAnimationAstrologerIcon> createState() => _CustomAnimationAstrologerIconState();
}

class _CustomAnimationAstrologerIconState extends State<CustomAnimationAstrologerIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: widget.floatRange).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value),
          child: child,
        );
      },
      child: SvgPicture.asset(widget.imagePath),
    );
  }
}
