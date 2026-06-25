import 'dart:io';
import 'package:get/get.dart';
import 'package:astro_prompt/Components/Common/changeButton.dart';
import 'package:astro_prompt/Components/Common/customCountryDropDown.dart';
import 'package:astro_prompt/Model/country_model.dart';
import 'package:astro_prompt/Services/countryService/countryCodeService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:collection/collection.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class CustomTextField extends StatefulWidget {
  final String title;
  final bool isMandatory;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool? isEmail;
  final bool? isMobileNumber;
  final bool? isVerified;
  final VoidCallback? onChangeTap;
  final bool? isExist;
  final bool isFirst;
  final Function(bool)? onVerifiedChange;
  final bool enableEdit;
  final TextCapitalization textStyle;
  final bool showCursor;
  final String? selectedCountryCode;
  final Function(String)? onCountryCodeChanged;
  final Function(bool)? onPhoneNumberValidationChanged;
  final bool? mobileVerifiedDB;
  final VoidCallback? onEditRequested;

  const CustomTextField({
    super.key,
    required this.title,
    required this.isMandatory,
    required this.controller,
    this.inputFormatters,
    this.keyboardType = TextInputType.text,
    required this.readOnly,
    this.onTap,
    this.isEmail,
    this.isMobileNumber,
    this.isVerified,
    this.onChangeTap,
    this.isExist,
    required this.isFirst,
    this.onVerifiedChange,
    required this.enableEdit,
    required this.textStyle,
    required this.showCursor,
    this.selectedCountryCode,
    this.onCountryCodeChanged,
    this.onPhoneNumberValidationChanged,
    this.mobileVerifiedDB,
    this.onEditRequested,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isFocused = false;
  bool isEditable = true;
  bool hasError = false;
  String errorMessage = '';
  bool showVerified = false;
  bool showChangeButton = false;
  bool mobileVerifiedDB = false;
  bool locallyVerified = false;
  List<Country> countryList = [];
  Map<String, String> selectedCountry = {
    'countryFlag': '',
    'dialCode': '',
  };
  int? mobileLengthLimit;
  bool isCountryLoading = true;

  bool validateInput(String value) {
    if (widget.isMandatory && value.trim().isEmpty) {
      setState(() {
        hasError = true;
        errorMessage = '${widget.title} ${'cannot be empty'.tr}';
      });
      return true;
    }

    if (widget.isEmail == true && !isValidEmail(value)) {
      setState(() {
        hasError = true;
        errorMessage = 'Enter a valid Email'.tr;
      });
      return true;
    }

    if (widget.isMobileNumber == true) {
      if (selectedCountry['dialCode'] == null ||
          selectedCountry['dialCode']!.isEmpty) {
        setState(() {
          hasError = true;
          errorMessage = 'Select country code'.tr;
        });
        widget.onPhoneNumberValidationChanged?.call(false);
        return true;
      }

      if (mobileLengthLimit != null &&
          value.trim().length != mobileLengthLimit) {
        setState(() {
          hasError = true;
          errorMessage = 'Enter valid (mobileLengthLimit)-digit number'
              .tr
              .replaceAll('(mobileLengthLimit)', mobileLengthLimit.toString());
        });
        widget.onPhoneNumberValidationChanged?.call(false);
        return true;
      }
    }

    setState(() {
      hasError = false;
    });
    widget.onPhoneNumberValidationChanged?.call(true);
    return false;
  }

  bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    // Initialize selected country if provided, but don't fetch the full list yet
    if (widget.selectedCountryCode != null &&
        widget.selectedCountryCode!.isNotEmpty) {
      final normalizedCode = widget.selectedCountryCode!.replaceAll('+', '');
      selectedCountry = {
        'countryFlag': '',
        'dialCode': '+$normalizedCode',
      };
      isCountryLoading = false;
    } else {
      isCountryLoading = false;
    }
    showVerified = (widget.mobileVerifiedDB ?? false) &&
        widget.isMobileNumber == true;
    if (widget.isEmail == true) {
      showChangeButton = widget.isExist == true;
    } else {
      showChangeButton = (widget.isExist == true || !(widget.mobileVerifiedDB ?? false)) &&
          widget.isMobileNumber == true;
    }
  }

  Future<void> loadCountry() async {
    // Only load if not already loaded
    if (countryList.isNotEmpty) return;

    setState(() {
      isCountryLoading = true;
    });

    try {
      countryList = await CountryCodeService().fetchCountries();

      if (widget.selectedCountryCode != null &&
          widget.selectedCountryCode!.isNotEmpty) {
        final normalizedCode = widget.selectedCountryCode!.replaceAll('+', '');
        Country? matched = countryList.firstWhereOrNull(
          (c) => c.dialCode.replaceAll('+', '') == normalizedCode,
        );

        if (matched != null) {
          selectedCountry = {
            'countryFlag': matched.countryFlag,
            'dialCode': matched.dialCode,
            'mobileNumberLength': matched.mobileNumberLength.toString(),
          };
          mobileLengthLimit = matched.mobileNumberLength;

          if (widget.title == 'Phone Number' &&
              widget.enableEdit &&
              widget.controller.text.trim().isEmpty) {
            widget.controller.clear();
          }

          widget.onCountryCodeChanged
              ?.call(matched.dialCode.replaceAll('+', ''));
        }
      }
    } catch (e) {
      // Error will be shown when dialog opens
    } finally {
      if (mounted) {
        setState(() {
          isCountryLoading = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mobileVerifiedDB != widget.mobileVerifiedDB) {
      setState(() {
        mobileVerifiedDB = widget.mobileVerifiedDB ?? false;
      });
    }

    if (oldWidget.isExist != widget.isExist ||
        oldWidget.mobileVerifiedDB != widget.mobileVerifiedDB) {
      setState(() {
        showVerified = (widget.mobileVerifiedDB ?? false) &&
            widget.isMobileNumber == true;
        if (widget.isEmail == true) {
          showChangeButton = widget.isExist == true;
        } else {
          showChangeButton = (widget.isExist == true || !(widget.mobileVerifiedDB ?? false)) &&
              widget.isMobileNumber == true;
        }
      });
    }
    if (oldWidget.selectedCountryCode != widget.selectedCountryCode) {
      loadCountry();
    }
  }

  void updateVerificationStatus(bool status) {
    setState(() {
      showVerified = status;
      showChangeButton = !status;
      mobileVerifiedDB = status;
      if (widget.isMobileNumber == true && status) {
        locallyVerified = true;
      }
    });
    if (widget.onVerifiedChange != null) {
      widget.onVerifiedChange!(status);
    }
  }

  String get fullMobileNumber {
    if (widget.title == 'Phone Number' &&
        selectedCountry['dialCode']!.isNotEmpty &&
        widget.controller.text.trim().isNotEmpty) {
      return '${selectedCountry['dialCode']}${widget.controller.text.trim()}';
    }
    return '';
  }

  Widget verifiedWidget() {
    bool showVerifyOption = false;

    if (widget.isFirst) {
      // If user just verified phone in this session, always show the tick
      if (widget.isMobileNumber == true && locallyVerified) {
        showVerified = true;
        showChangeButton = false;
        showVerifyOption = false;
      } else if (widget.isMobileNumber == true && (widget.mobileVerifiedDB ?? false)) {
        if (widget.enableEdit) {
          // Phone verified in DB but user is editing — show Change button
          showVerified = false;
          showChangeButton = true;
          showVerifyOption = false;
        } else {
          // Phone verified in DB and not editing — show verified tick only
          showVerified = true;
          showChangeButton = false;
          showVerifyOption = false;
        }
      } else {
        showVerified = false;
        showVerifyOption = true;

        if (widget.isEmail == true || widget.isMobileNumber == true) {
          showChangeButton = true;
          showVerifyOption = false;
        }
      }
    }

    if (showVerified) {
      return Container(
        height: MyUtility(context).responsiveHeight(0.0555),
        padding: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
            color: widget.enableEdit ? whiteColor : notEditable,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: SvgPicture.asset(verified),
      );
    } else if (showChangeButton) {
      if (widget.enableEdit == true) {
        setState(() {
          showVerifyOption = true;
        });
      } else if (widget.mobileVerifiedDB == false) {
        setState(() {
          showVerifyOption = true;
        });
      } else {
        setState(() {
          showVerifyOption = false;
        });
      }
      return showVerifyOption == true
          ? ChangeButton(
              onTap: () {
                if (widget.controller.text.trim().isEmpty &&
                    widget.title != 'Email' &&
                    widget.title != 'Phone Number') {
                  setState(() {
                    hasError = true;
                    errorMessage = '${widget.title} ${'cannot be empty'.tr}';
                  });
                  return;
                }

                if (widget.title == 'Email') {
                  bool isInvalid = validateInput(widget.controller.text);
                  if (isInvalid) return;
                }

                widget.onChangeTap?.call();
              },
              isExist: widget.isExist!,
              userData: widget.controller,
              title: widget.title,
              enableEdit: widget.enableEdit,
              onResult: (bool? result) {
                if (result == true) {
                  setState(() {
                    updateVerificationStatus(true);
                  });
                }
              },
              selectedCountry: selectedCountry,
              mobileLengthLimit: mobileLengthLimit,
              showVerifyButton: widget.mobileVerifiedDB ?? false,
            )
          : SizedBox.shrink();
    }
    return SizedBox();
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
              widget.title.tr,
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
        SizedBox(height: util.responsiveHeight(0.005)),
        FocusScope(
          child: Focus(
            onFocusChange: (focus) {
              setState(() {
                isFocused = focus;
              });
            },
            child: Container(
              height: util.responsiveHeight(0.0555),
              decoration: BoxDecoration(
                border: Border.all(
                    color: isFocused
                        ? (Platform.isAndroid ? mainColor : iosMainColor)
                        : blackColor.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  if (widget.title == 'Phone Number')
                    GestureDetector(
                      onTap: () async {
                        if (showVerified) return;
                        if (widget.title != 'Phone Number') {
                          if (widget.readOnly) return;
                          if (!widget.enableEdit) return;
                        }

                        CustomLoader.show(context);
                        try {
                          // Load countries only when user taps (lazy loading)
                          await loadCountry();
                          CustomLoader.hide();

                          final result = await showDialog<Map<String, String>>(
                            context: context,
                            builder: (_) =>
                                CountryDropdownDialog(countries: countryList),
                          );

                          if (result != null) {
                            setState(() {
                              selectedCountry = result;
                              mobileLengthLimit = int.tryParse(
                                  result['mobileNumberLength'] ?? '');
                              errorMessage = '';
                              if ((widget.isMobileNumber == true ||
                                      widget.title == 'Phone Number') &&
                                  !(widget.mobileVerifiedDB ?? false)) {
                                widget.controller.clear();
                                widget.onPhoneNumberValidationChanged
                                    ?.call(false);
                                widget.onEditRequested?.call();
                              }
                            });
                            if (result['dialCode'] != null) {
                              widget.onCountryCodeChanged?.call(
                                  result['dialCode']!.replaceAll('+', ''));
                            }
                          }
                        } catch (e) {
                          CustomLoader.hide();
                          showErrorSnackBar(
                              context, 'Error in Fetching Country code');
                        }
                      },
                      child: Container(
                        height: util.responsiveHeight(0.0555),
                        padding: selectedCountry['countryFlag']!.isEmpty
                            ? EdgeInsets.symmetric(horizontal: util.width10)
                            : EdgeInsets.symmetric(horizontal: util.width10),
                        decoration: BoxDecoration(
                          color: widget.enableEdit ? whiteColor : notEditable,
                          border: Border(
                            right: BorderSide(
                                color: blackColor.withValues(alpha: 0.2)),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            isCountryLoading
                                ? LoadingAnimationWidget.halfTriangleDot(
                                    color: (Platform.isAndroid
                                        ? mainColor
                                        : iosMainColor),
                                    size: util.height20)
                                : Text(
                                    selectedCountry['dialCode']?.isNotEmpty ==
                                            true
                                        ? selectedCountry['dialCode']!
                                        : 'Select\nCountry',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      color: blackColor,
                                      height: 1.0,
                                      fontSize: selectedCountry['dialCode']
                                                  ?.isNotEmpty ==
                                              true
                                          ? util.fontSize14
                                          : util.fontSize12,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (widget.title == 'Phone Number' &&
                            selectedCountry['dialCode']!.isEmpty) {
                          FocusScope.of(context).unfocus(); // Prevent keyboard
                          showErrorSnackBar(
                              context, 'Please select a country code first');
                          return;
                        }
                        if (widget.onTap != null) widget.onTap!();
                      },
                      child: AbsorbPointer(
                        absorbing: widget.title == 'Phone Number' &&
                            selectedCountry['dialCode']!.isEmpty,
                        child: TextField(
                          enableInteractiveSelection: (widget.title ==
                                          'Phone Number' &&
                                      selectedCountry['dialCode']!.isEmpty) ||
                                  showVerified
                              ? false
                              : widget.showCursor,
                          showCursor: (widget.title == 'Phone Number' &&
                                      selectedCountry['dialCode']!.isEmpty) ||
                                  showVerified
                              ? false
                              : widget.showCursor,
                          style: TextStyle(
                            fontSize: util.fontSize14,
                            fontFamily: AppFont.get(FontType.medium),
                            height: 1.0,
                            color: blackColor,
                          ),
                          controller: widget.controller,
                          inputFormatters: widget.title == 'Phone Number' &&
                                  mobileLengthLimit != null
                              ? [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(
                                      mobileLengthLimit),
                                ]
                              : widget.inputFormatters,
                          keyboardType: widget.keyboardType,
                          // readOnly: widget.title == 'Phone Number' ? selectedCountry['dialCode']!.isEmpty || !widget.enableEdit : widget.readOnly,
                          readOnly: widget.title != 'Phone Number'
                              ? showVerified || widget.readOnly
                              : widget.mobileVerifiedDB!,
                          textCapitalization: widget.textStyle,
                          onTap: widget.onTap,
                          // onChanged: validateInput,
                          onChanged: (value) {
                            final _ = validateInput(value);
                            if ((widget.isMobileNumber == true ||
                                    widget.title == 'Phone Number') &&
                                !(widget.mobileVerifiedDB ?? false)) {
                              widget.onEditRequested?.call();
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                widget.enableEdit ? whiteColor : notEditable,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          cursorColor: blackColor,
                        ),
                      ),
                    ),
                  ),
                  verifiedWidget(),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Visibility(
          visible: hasError,
          child: Text(
            errorMessage.tr,
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
