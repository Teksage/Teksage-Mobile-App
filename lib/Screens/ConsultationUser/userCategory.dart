import 'package:astro_prompt/Components/Consultation-User/multiSelectCategory.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userSelectLanguage.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class UserCategoryPage extends StatefulWidget {
  final bool toHome;
  const UserCategoryPage({super.key, required this.toHome});

  @override
  State<UserCategoryPage> createState() => _UserCategoryPageState();
}

class _UserCategoryPageState extends State<UserCategoryPage> {
  List<String> selectedCategories = [];
  bool showError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.0268)}');
    // print('Height: ${util.responsiveHeight(0.1232)}');
    // print('FontSize: ${util.responsiveFontSize(0.0153)}');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Future.microtask(() {
            widget.toHome
                ? Get.offAll(() => BottomNavigationScreen())
                : Navigator.pop(context);
          });
        }
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SizedBox(
          width: util.width,
          child: Stack(
            children: [
              /// Background Images
              SvgPicture.asset(categoryTopDeco, fit: BoxFit.cover),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(categoryBottomDeco,
                      fit: BoxFit.fitWidth)),

              ///AppBar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    title: Text(PlatformTextConfig.astrologerUserHomeTitle.tr,
                        style: TextStyle(
                            color: blackColor,
                            fontSize: util.fontSize20,
                            fontFamily: AppFont.get(FontType.bold),
                            height: 1.0)),
                    leading: IconButton(
                      icon: SvgPicture.asset(
                        appBackButton,
                        colorFilter:
                            ColorFilter.mode(blackColor, BlendMode.srcIn),
                      ),
                      onPressed: () {
                        widget.toHome
                            ? Get.to(() => BottomNavigationScreen())
                            : Navigator.pop(context);
                      },
                    ),
                    centerTitle: true,
                  ),

                  ///content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: util.width20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: util.responsiveHeight(0.1232),
                          ),
                          Text(
                            'What do you\nneed guidance on?'.tr,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold),
                                fontSize: util.fontSize29,
                                height: 1.2,
                                color: blackColor),
                          ),
                          SizedBox(
                            height: util.width12,
                          ),
                          Text(
                            'Select the categories and continue'.tr,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.medium),
                                fontSize: util.fontSize16,
                                height: 1.2,
                                color: blackColor.withValues(alpha: 0.6)),
                          ),
                          SizedBox(
                            height: util.height50,
                          ),
                          MultiSelectCategory(
                            onSelectionChanged: (selected) {
                              setState(() {
                                selectedCategories = selected;
                                showError = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: util.width20),
                    child: Visibility(
                        visible: showError,
                        child: Text('Kindly select one or more categories'.tr,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.medium),
                                fontSize: util.fontSize11,
                                color: errorColor))),
                  ),
                  SizedBox(
                    height: util.height10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: util.width20),
                    child: GestureDetector(
                      onTap: () {
                        if (selectedCategories.isEmpty) {
                          setState(() {
                            showError = true;
                          });
                        } else {
                          selectedCategories = selectedCategories
                              .map((e) => e.toLowerCase())
                              .toList();
                          Get.to(() => UserSelectLanguage(
                                selectedCategory: selectedCategories,
                              ));
                        }
                      },
                      child: Container(
                        width: util.width,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(util.width30),
                          color: selectedCategories.isNotEmpty
                              ? homeBanner
                              : homeBanner.withValues(alpha: 0.5),
                        ),
                        child: Center(
                            child: Text(
                          '${'Continue'.tr} (${selectedCategories.length})',
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.semiBold),
                              fontSize: util.fontSize18,
                              height: 1.0,
                              color: whiteColor),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: util.height50,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
