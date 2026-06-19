import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class UserLanguageDropDown extends StatefulWidget {
  final String title;
  final bool isMandatory;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final bool errorFlag;
  final String? errorText;
  final String? selectedValue;
  final bool enabled;

  const UserLanguageDropDown(
      {super.key,
      required this.title,
      required this.onChanged,
      this.isMandatory = false,
      this.errorFlag = false,
      this.errorText,
      required this.options,
      this.selectedValue,
      this.enabled = true});

  @override
  State<UserLanguageDropDown> createState() => _UserLanguageDropDownState();
}

class _UserLanguageDropDownState extends State<UserLanguageDropDown> {
  String? selectedValue;
  TextEditingController controller = TextEditingController();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
    controller = TextEditingController(text: widget.selectedValue ?? '');
  }

  @override
  void didUpdateWidget(covariant UserLanguageDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      selectedValue = widget.selectedValue;
      controller.text = widget.selectedValue ?? '';
    }
  }

  void showDropdownModal(BuildContext context) {
    final util = MyUtility(context);
    if (!widget.enabled) {
      showErrorSnackBar(context, 'Please select the first language first');
      return;
    }
    showGeneralDialog(
      barrierLabel: widget.title.tr,
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
                    widget.title,
                    style: TextStyle(
                      fontSize: util.fontSize16,
                      fontFamily: AppFont.get(FontType.medium),
                      height: util.lineHeight16_8 / util.fontSize14,
                      color: blackColor,
                    ),
                  ),
                  SizedBox(height: util.responsiveHeight(0.0124)),
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
                              widget.options[index].tr,
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
        Text(
          widget.title,
          style: TextStyle(
            color: blackColor.withValues(alpha: 0.6),
            fontSize: util.fontSize16,
            height: 1.0,
            fontFamily: AppFont.get(FontType.medium),
          ),
        ),
        SizedBox(
          height: util.responsiveHeight(0.005),
        ),
        FocusScope(
          child: Focus(
            onFocusChange: (focus) {
              setState(() {
                isFocused = focus;
              });
            },
            child: GestureDetector(
              onTap: () => showDropdownModal(context),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: util.width20, vertical: 11.5),
                decoration: BoxDecoration(
                  border: Border.all(color: blackColor.withValues(alpha: 0.12)),
                  borderRadius: BorderRadius.circular(100),
                  color: controller.text.isEmpty ? Colors.white : homeBanner,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset(categoryLanguage),
                          ),
                        ),
                        Text(
                          controller.text.isEmpty
                              ? "Select language".tr
                              : controller.text.tr,
                          style: TextStyle(
                            fontSize: util.fontSize18,
                            fontFamily: AppFont.get(FontType.semiBold),
                            height: 1.0,
                            color: controller.text.isEmpty
                                ? blackColor.withValues(alpha: 0.6)
                                : whiteColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SvgPicture.asset(dropDownArrow, fit: BoxFit.scaleDown),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Visibility(
          visible: widget.errorFlag,
          child: Text(
            '${'${widget.errorText}'.tr} *',
            style: TextStyle(
                fontFamily: AppFont.get(FontType.medium),
                fontSize: util.fontSize11,
                color: errorColor),
          ),
        ),
      ],
    );
  }
}
