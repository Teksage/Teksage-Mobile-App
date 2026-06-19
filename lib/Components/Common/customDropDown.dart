import 'dart:io';

import 'package:flutter/services.dart';
import 'package:astro_prompt/Model/location_selection_model.dart';
import 'package:astro_prompt/Services/PlacesService/googlePlacesApiService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/capitalizeFirstLetter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class CustomDropDown extends StatefulWidget {
  final String title;
  final bool isMandatory;
  final ValueChanged<LocationSelection>? onLocationChanged;
  final bool errorFlag;
  final bool enableEdit;
  final TextEditingController textController;
  final VoidCallback? onTapRestricted;
  final ValueChanged<String>? onLanguageChanged;
  final ValueChanged<String>? onReferredByChanged;

  const CustomDropDown({
    super.key,
    required this.title,
    this.onLocationChanged,
    this.isMandatory = false,
    this.errorFlag = false,
    required this.enableEdit,
    required this.textController,
    this.onTapRestricted,
    this.onLanguageChanged,
    this.onReferredByChanged,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  bool isFocused = false;
  List<Map<String, String>> locations = [];
  final GooglePlacesService placesService = GooglePlacesService();
  final List<String> languageList = [
    "English",
    "Tamil",
    "Kannada",
    "Malayalam",
    "Telugu",
    "Hindi",
    "Marathi"
  ];
  final List<String> referredByList = [
    "Google Play Store / App Store",
    "Google Search",
    "Quora",
    "Facebook / Instagram",
    "YouTube",
    "WhatsApp / Telegram (friends or groups)",
    "Word of mouth (friends/family)",
    "Product Hunt",
    "Other",
  ];

  void fetchPlaces(String query, Function setStateModal) async {
    if (query.isEmpty) {
      setStateModal(() => locations = []);
      return;
    }
    try {
      final results = await placesService.fetchPlaceSuggestions(query);
      if (kDebugMode) {
        print('fetchPlacesResult: $results');
      }
      setStateModal(() => locations = results);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching places: $e');
      }
    }
  }

  void showDropdownModal(BuildContext context) {
    if (!widget.enableEdit) {
      if (widget.onTapRestricted != null) {
        widget.onTapRestricted!();
      }
      return;
    }

    // Check if this is AI Chat Language dropdown by checking if onLanguageChanged callback exists
    if (widget.onLanguageChanged != null) {
      showGeneralDialog(
        barrierLabel: widget.title,
        barrierDismissible: true,
        barrierColor: blackColor.withValues(alpha: 0.5),
        transitionDuration: const Duration(milliseconds: 250),
        context: context,
        pageBuilder: (context, _, __) {
          return Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                margin: const EdgeInsets.only(top: 60, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Text(
                      widget.title.tr,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        itemCount: languageList.length,
                        // separatorBuilder: (_, __) => Divider(height: 1),
                        itemBuilder: (context, index) {
                          final language = languageList[index];
                          return ListTile(
                            title: Text(language.tr),
                            onTap: () {
                              Get.back();
                              Future.delayed(const Duration(milliseconds: 200),
                                  () {
                                widget.textController.text = language.tr;
                                if (widget.onLanguageChanged != null) {
                                  widget.onLanguageChanged!(language.tr);
                                }
                              });
                            },
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
      return;
    }

    // Check if this is "How did you first hear about" dropdown by checking if onReferredByChanged callback exists
    if (widget.onReferredByChanged != null) {
      showGeneralDialog(
        barrierLabel: widget.title,
        barrierDismissible: true,
        barrierColor: blackColor.withValues(alpha: 0.5),
        transitionDuration: const Duration(milliseconds: 250),
        context: context,
        pageBuilder: (context, _, __) {
          return Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: widget.title
                        .trim()
                        .toLowerCase()
                        .contains('how did you first hear about')
                    ? MediaQuery.of(context).size.height * 0.52
                    : MediaQuery.of(context).size.height * 0.45,
                margin: const EdgeInsets.only(top: 60, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        widget.title.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 5,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: referredByList.length,
                          itemBuilder: (context, index) {
                            final referredBy = referredByList[index];
                            return ListTile(
                              // dense: true,
                              visualDensity: const VisualDensity(vertical: -4),
                              title: Text(referredBy.tr),
                              onTap: () {
                                Get.back();
                                Future.delayed(
                                    const Duration(milliseconds: 200), () {
                                  widget.textController.text = referredBy.tr;
                                  if (widget.onReferredByChanged != null) {
                                    widget.onReferredByChanged!(referredBy.tr);
                                  }
                                });
                              },
                            );
                          },
                        ),
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
      return;
    }

    final TextEditingController searchController =
        TextEditingController(text: widget.textController.text);

    showGeneralDialog(
      barrierLabel: widget.title,
      barrierDismissible: true,
      barrierColor: blackColor.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 350),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: StatefulBuilder(builder: (context, setStateModal) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.5,
                margin: const EdgeInsets.only(top: 60, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Text(
                      widget.title.tr,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: searchController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-Z0-9\s,.'/-]")),
                        ],
                        // onChanged: fetchPlaces,
                        onChanged: (query) {
                          setStateModal(() {});
                          fetchPlaces(query, setStateModal);
                        },
                        decoration: InputDecoration(
                          hintText: widget.title == 'Place of Birth'.tr
                              ? "Enter place of birth".tr
                              : "Enter Current location".tr,
                          filled: true,
                          fillColor:
                              widget.enableEdit ? whiteColor : notEditable,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Platform.isAndroid
                                    ? mainColor
                                    : iosMainColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Platform.isAndroid
                                    ? mainColor
                                    : iosMainColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: widget.textController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      searchController.clear();
                                      locations = [];
                                    });
                                    fetchPlaces('', setStateModal);
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: locations.length,
                        itemBuilder: (context, index) {
                          if (kDebugMode) {
                            print('locations[index]: ${locations[index]}');
                          }
                          return ListTile(
                            title: Text(locations[index]['displayText'] ?? ''),
                            onTap: () {
                              String selectedText =
                                  locations[index]['selectedText'] ?? '';
                              String displayText =
                                  locations[index]['displayText'] ?? '';

                              Get.back();
                              Future.delayed(Duration(milliseconds: 300), () {
                                widget.textController.text = selectedText;
                                widget.onLocationChanged!(LocationSelection(
                                    selectedText, displayText));
                                setStateModal(() {
                                  locations = [];
                                });
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
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
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.title
                            .trim()
                            .toLowerCase()
                            .contains('how did you first hear about')
                        ? 'How did you first hear about Teksage'.tr
                        : widget.title.tr,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: util.fontSize10,
                      height: util.lineHeight12 / util.fontSize10,
                      fontFamily: AppFont.get(FontType.medium),
                    ),
                  ),
                  if (widget.isMandatory)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: util.fontSize10,
                        fontFamily: AppFont.get(FontType.medium),
                      ),
                    ),
                ],
              ),
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
            child: GestureDetector(
              onTap: () => showDropdownModal(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isFocused
                          ? (Platform.isAndroid ? mainColor : iosMainColor)
                          : blackColor.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(8),
                  color: widget.enableEdit ? Colors.white : notEditable,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: widget.textController,
                        builder: (context, value, _) {
                          final placeholder = widget.title
                                      .trim()
                                      .toLowerCase() ==
                                  'ai chat language'
                              ? "Select a language".tr
                              : widget.title.trim() ==
                                      "How did you first hear about Teksage?"
                                  ? "Select any one Option".tr
                                  : "Select a place".tr;

                          return Text(
                            TextHelper.capitalizeFirstLetter(
                              value.text.isEmpty
                                  ? placeholder.trim().toLowerCase()
                                  : value.text.trim().toLowerCase(),
                            ),
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ),
                    SvgPicture.asset(dropDownArrow, fit: BoxFit.scaleDown),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
