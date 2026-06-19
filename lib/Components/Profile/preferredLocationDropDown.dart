import 'package:astro_prompt/Services/PlacesService/googlePlacesApiService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class PreferredLocationDropDown extends StatefulWidget {
  final String title;
  final bool isMandatory;
  final ValueChanged<String> onChanged;
  final bool errorFlag;
  final String? errorText;
  final String? selectedValue;
  final bool enableEdit;

  const PreferredLocationDropDown({
    super.key,
    required this.title,
    required this.onChanged,
    this.isMandatory = false,
    this.errorFlag = false,
    this.errorText,
    this.selectedValue,
    required this.enableEdit,
  });

  @override
  State<PreferredLocationDropDown> createState() =>
      _PreferredLocationDropDownState();
}

class _PreferredLocationDropDownState extends State<PreferredLocationDropDown> {
  TextEditingController controller = TextEditingController();
  bool isFocused = false;
  List<Map<String, String>> locations = [];
  final GooglePlacesService placesService = GooglePlacesService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.selectedValue ?? '');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(covariant CustomDropDown oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // if (widget.selectedValue != oldWidget.selectedValue) {
  //   controller.text = widget.selectedValue ?? '';
  //   // }
  // }
  @override
  void didUpdateWidget(covariant PreferredLocationDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue) {
      controller.text = widget.selectedValue ?? '';
      print('${widget.title} Controller updated: ${controller.text}');
    } else {
      print('${widget.title} No update needed');
    }
    print(
        'Preferred Old: ${oldWidget.selectedValue}, Preferred New: ${widget.selectedValue}');
  }
  // @override
  // void didUpdateWidget(covariant CustomDropDown oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.selectedValue != oldWidget.selectedValue && widget.selectedValue != controller.text) {
  //     controller.text = widget.selectedValue ?? '';
  //   }
  // }

  void fetchPlaces(String query, Function setStateModal) async {
    if (query.isEmpty) {
      setStateModal(() => locations = []);
      return;
    }
    try {
      final results = await placesService.fetchPlaceSuggestions(query);
      setStateModal(() => locations = results);
    } catch (e) {
      print('Error fetching places: $e');
    }
  }

  void showDropdownModal(BuildContext context) {
    if (!widget.enableEdit) return;

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
                      widget.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: controller,
                        // onChanged: fetchPlaces,
                        onChanged: (query) {
                          setStateModal(() {});
                          fetchPlaces(query, setStateModal);
                        },
                        decoration: InputDecoration(
                          hintText: "Search places...",
                          filled: true,
                          fillColor:
                              widget.enableEdit ? whiteColor : notEditable,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: controller.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      controller.clear();
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
                          return ListTile(
                            title: Text(locations[index]['displayText'] ?? ''),
                            onTap: () {
                              String selectedText =
                                  locations[index]['selectedText'] ?? '';
                              setState(() {
                                isLoading = true;
                              });

                              Future.delayed(Duration(milliseconds: 1000), () {
                                setState(() {
                                  controller.text = selectedText;
                                  locations = [];
                                  isLoading = false;
                                });
                                widget.onChanged(selectedText);
                              });
                              Get.back();
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
                style: TextStyle(fontSize: 12, color: Colors.red),
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
                          ? mainColor
                          : blackColor.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(8),
                  color: widget.enableEdit ? Colors.white : notEditable,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: isLoading
                          ? LoadingAnimationWidget.halfTriangleDot(
                              color: mainColor,
                              size: MyUtility(context).height20,
                            )
                          : Text(
                              controller.text.isEmpty
                                  ? "Select a place".tr
                                  : controller.text,
                              // (widget.selectedValue ?? '').isEmpty ? "Select a place" : widget.selectedValue!,
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
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
        Visibility(
          visible: widget.errorFlag,
          child: Text(
            widget.errorText ?? '',
            style: TextStyle(fontSize: 11, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
