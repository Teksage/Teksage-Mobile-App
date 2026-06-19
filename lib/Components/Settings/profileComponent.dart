import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class RasiNakshatraComponent extends StatefulWidget {
  final String title;
  final TextEditingController controller;

  const RasiNakshatraComponent({
    super.key,
    required this.title,
    required this.controller,
  });

  @override
  State<RasiNakshatraComponent> createState() => _RasiNakshatraComponentState();
}

class _RasiNakshatraComponentState extends State<RasiNakshatraComponent> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: blackColor,
                fontSize: util.fontSize10,
                height: util.lineHeight12 / util.fontSize10,
                fontFamily: AppFont.get(FontType.medium),
              ),
            ),
            Text(
              '*',
              style: TextStyle(
                  fontFamily: AppFont.get(FontType.medium),
                  fontSize: util.fontSize10,
                  color: errorColor),
            )
          ],
        ),
        SizedBox(
          height: util.responsiveHeight(0.005),
        ),
        TextField(
          style: TextStyle(
            fontSize: util.fontSize14,
            fontFamily: AppFont.get(FontType.medium),
            height: util.lineHeight16_8 / util.fontSize14,
            color: blackColor,
          ),
          controller: widget.controller,
          readOnly: true,
          // onTap: () => showDropdownModal(context),
          decoration: InputDecoration(
            filled: true,
            fillColor: notEditable,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: mainColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: blackColor.withValues(alpha: 0.2)),
            ),
            suffixIcon: SvgPicture.asset(
              dropDownArrow,
              fit: BoxFit.scaleDown,
            ),
          ),
          cursorColor: Colors.black,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
