import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class CustomMatchDropDown extends StatefulWidget {
  final String title;
  final bool isMandatory;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final bool errorFlag;
  final String? errorText;
  final String? selectedValue;
  final bool isLoading;

  const CustomMatchDropDown({
    super.key,
    required this.title,
    required this.onChanged,
    this.isMandatory = false,
    this.errorFlag = false,
    this.errorText,
    required this.options,
    this.selectedValue,
    required this.isLoading,
  });

  @override
  State<CustomMatchDropDown> createState() => _CustomMatchDropDownState();
}

class _CustomMatchDropDownState extends State<CustomMatchDropDown> {
  String? selectedValue;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.selectedValue ?? '');
  }

  @override
  void didUpdateWidget(covariant CustomMatchDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      controller.text = widget.selectedValue ?? '';
    }
  }

  void showDropdownModal(BuildContext context) {
    final util = MyUtility(context);

    showGeneralDialog(
      barrierLabel: widget.title,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 350),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: util.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.5,
              margin: const EdgeInsets.only(top: 60, left: 12, right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(height: util.height20),
                  Text(
                    widget.title.tr,
                    style: TextStyle(
                      fontSize: util.fontSize16,
                      fontFamily: AppFont.get(FontType.medium),
                      height: util.lineHeight16_8 / util.fontSize14,
                      color: blackColor,
                    ),
                  ),
                  SizedBox(height: util.responsiveHeight(0.0124)),
                  if (widget.isLoading)
                    Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: matchTopGradient,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 0),
                        itemCount: widget.options.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: util.height50,
                            child: ListTile(
                              title: Text(
                                widget.options[index],
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: util.fontSize14,
                                  height: util.lineHeight12 / util.fontSize14,
                                  fontFamily: AppFont.get(FontType.medium),
                                ),
                              ),
                              onTap: () {
                                String newValue = widget.options[index];
                                Future.delayed(Duration(milliseconds: 100), () {
                                  Get.back();
                                });
                                Future.delayed(Duration(milliseconds: 300), () {
                                  setState(() {
                                    selectedValue = newValue;
                                    controller.text = selectedValue!;
                                  });

                                  widget.onChanged(newValue);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
              .animate(anim),
          child: child,
        );
      },
    );
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
            if (widget.isMandatory)
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
          controller: controller,
          readOnly: true,
          onTap: () {
            if (widget.title == "Nakshatram" && widget.options.isEmpty) {
              // Show error if Rasi is not selected
              widget.onChanged(""); // Trigger validation in MatchMakingPage
            } else {
              // Open dropdown if valid
              showDropdownModal(context);
            }
          },
          decoration: InputDecoration(
            hintText: widget.title.tr,
            hintStyle: TextStyle(
                fontFamily: AppFont.get(FontType.medium),
                fontSize: util.fontSize16,
                height: 1.0,
                color: blackColor.withValues(alpha: 0.4)),
            filled: true,
            fillColor: whiteColor,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: matchTopGradient),
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
        SizedBox(height: 5),
        Visibility(
          visible: widget.errorFlag,
          child: Text(
          '${widget.errorText?.tr ?? ''}*',
            style: TextStyle(
                fontFamily: AppFont.get(FontType.medium),
                fontSize: 11,
                color: Colors.red),
          ),
        ),
      ],
    );
  }
}
