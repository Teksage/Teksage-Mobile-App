import 'dart:async';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class CustomToolTip extends StatefulWidget {
  final String message;

  const CustomToolTip({super.key, required this.message});

  @override
  State<CustomToolTip> createState() => _CustomToolTipState();
}

class _CustomToolTipState extends State<CustomToolTip>
    with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? overlayEntry;
  bool tooltipVisible = false;
  bool _isDisposed = false;
  Timer? _hideTimer;

  late AnimationController controller;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_isDisposed && mounted) {
        _showOverlay();
        _hideTimer = Timer(const Duration(seconds: 2), removeOverlay);
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _hideTimer?.cancel();
    overlayEntry?.remove();
    overlayEntry = null;
    controller.dispose();
    super.dispose();
  }

  void _showOverlay() {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height + 8,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              Transform.translate(
                offset: Offset(0, 0),
                child: CustomPaint(
                  size: const Size(12, 6),
                  painter: _TrianglePainter(color: Color(0xffFEDF30)),
                ),
              ),
              SlideTransition(
                position: offsetAnimation,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xffFEDF30),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x66000000),
                        offset: Offset(0, 4),
                        blurRadius: 16,
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Text(
                    widget.message.tr,
                    style: TextStyle(
                        fontFamily: AppFont.get(FontType.medium),
                        fontSize: MyUtility(context).fontSize16,
                        height: 1.0,
                        color: Color(0xff1e1e1e)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
    controller.forward();

    if (!_isDisposed && mounted) {
      setState(() {
        tooltipVisible = true;
      });
    }
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), removeOverlay);
  }

  void removeOverlay() {
    if (_isDisposed) return;

    _hideTimer?.cancel();

    if (overlayEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed) {
          controller.reset();
        }
      });
      overlayEntry?.remove();
      overlayEntry = null;
    }
    if (mounted && !_isDisposed) {
      setState(() {
        tooltipVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: () {
        if (!tooltipVisible) {
          _showOverlay();
        } else {
          removeOverlay();
        }
      },
      child: SvgPicture.asset(
        toolTip,
        colorFilter: ColorFilter.mode(
          !tooltipVisible ? Colors.white : const Color(0xffFEDF30),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
