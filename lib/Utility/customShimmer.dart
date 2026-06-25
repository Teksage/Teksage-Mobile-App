import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:flutter/material.dart';

class CustomShimmer extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const CustomShimmer({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Stack(
        children: [
          // Base grey background with border
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: mainColor, width: 1),
              borderRadius: widget.borderRadius,
            ),
          ),

          // Shimmer overlay
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(widget.width * (2 * _controller.value - 1), 0),
                  child: Container(
                    width: widget.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.grey.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: 0.4),
                          Colors.grey.withValues(alpha: 0.0),
                        ],
                        stops: const [0.25, 0.5, 0.75],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
