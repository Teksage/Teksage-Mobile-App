import 'dart:ui';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:flutter/material.dart';

class IosChatTopBackground extends StatelessWidget {
  const IosChatTopBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            iosChatBgTop,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              SizedBox(
                height: 220,
              ),
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20,
                    sigmaY: 20,
                  ),
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: 0.7),
                          Colors.white.withValues(alpha: 1.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class IosChatBottomBackground extends StatelessWidget {
  const IosChatBottomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Image.asset(
        iosChatBgBottom,
        fit: BoxFit.cover,
      ),
    );
  }
}
