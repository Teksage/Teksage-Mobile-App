import 'package:astro_prompt/Utility/customMarquee.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class ComingSoonContainer extends StatelessWidget {
  const ComingSoonContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: MyUtility(context).height30),
          child: Text(
            'NORTH\nINDIAN\nCHART',
            style: TextStyle(
                fontFamily: AppFont.get(FontType.extraBold),
                fontSize: 75,
                height: 0.75,
                color: Color(0xff97D492).withValues(alpha: 0.5)),
          ),
        ),
        CustomMarquee()
      ],
    );
  }
}
