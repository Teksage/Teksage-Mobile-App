import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class CustomMatchTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isMandatory;
  final bool errorFlag;
  final String? errorText;

  const CustomMatchTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isMandatory = false,
    required this.errorFlag,
    this.errorText,
  });

  @override
  State<CustomMatchTextField> createState() => _CustomMatchTextFieldState();
}

class _CustomMatchTextFieldState extends State<CustomMatchTextField> {
  bool isFocused = false;
  bool hasError = false;
  String errorMessage = '';

  void validateInput(String value) {
    setState(() {
      hasError = value.isEmpty;
      errorMessage = hasError ? "${widget.hintText} cannot be empty".tr : '';
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
              'Name'.tr,
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
                  fontSize: 10,
                  color: Colors.red),
            )
          ],
        ),
        SizedBox(height: 5),
        FocusScope(
          child: Focus(
            onFocusChange: (focus) {
              setState(() {
                isFocused = focus;
              });
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(
                    color: isFocused
                        ? matchTopGradient
                        : blackColor.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: util.fontSize14,
                  fontFamily: AppFont.get(FontType.medium),
                  height: 1.0,
                  color: blackColor,
                ),
                controller: widget.controller,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                ],
                onChanged: validateInput,
                decoration: InputDecoration(
                  hintText: widget.hintText.tr,
                  hintStyle: TextStyle(
                      fontFamily: AppFont.get(FontType.medium),
                      fontSize: util.fontSize16,
                      height: 1.0,
                      color: blackColor.withValues(alpha: 0.4)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                cursorColor: Colors.black,
              ),
            ),
          ),
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
