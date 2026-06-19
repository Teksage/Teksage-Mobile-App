import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class DeleteReasonTextComponent extends StatefulWidget {
  final String title;
  final Function(String) onTap;
  const DeleteReasonTextComponent(
      {super.key, required this.title, required this.onTap});

  @override
  State<DeleteReasonTextComponent> createState() =>
      _DeleteReasonTextComponentState();
}

class _DeleteReasonTextComponentState extends State<DeleteReasonTextComponent>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -5, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return GestureDetector(
      onTap: () => widget.onTap(widget.title),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: blackColor.withValues(alpha: 0.08), width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                    fontFamily: AppFont.get(FontType.medium),
                    fontSize: util.fontSize16,
                    height: 1.0,
                    color: blackColor),
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_animation.value, 0),
                  child: Transform.rotate(
                    angle: 270 * (3.141592653589793 / 180),
                    child: SvgPicture.asset(dropDownArrow),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
