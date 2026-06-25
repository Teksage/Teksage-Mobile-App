import 'package:astro_prompt/Components/MatchMaking/customMatchDropDown.dart';
import 'package:astro_prompt/Components/MatchMaking/customMatchTextfield.dart';
import 'package:astro_prompt/Model/match_making_model.dart';
import 'package:astro_prompt/Model/nakshatram_model.dart';
import 'package:astro_prompt/Model/rasi_model.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/MatchMaking/matchMakingDetails.dart';
import 'package:astro_prompt/Services/MatchService/matchService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/matchMaking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/LocallySavedData/appLanguage.dart';

class MatchMakingPage extends StatefulWidget {
  final List<RasiModel> rasiList;
  const MatchMakingPage({super.key, required this.rasiList});

  @override
  State<MatchMakingPage> createState() => _MatchMakingPageState();
}

class _MatchMakingPageState extends State<MatchMakingPage> {
  TextEditingController boyName = TextEditingController();
  TextEditingController girlName = TextEditingController();

  String? selectedMaleRasi;
  String? selectedFemaleRasi;
  String? selectedMaleNakshatra;
  String? selectedFemaleNakshatra;

  int? selectedMaleRasiId;

  bool errorBoyName = false;
  bool errorGirlName = false;
  bool errorMaleRasi = false;
  bool errorFemaleRasi = false;
  bool errorMaleNakshatra = false;
  bool errorFemaleNakshatra = false;

  List<NakshatraModel> nakshatraBoyList = [];
  List<NakshatraModel> nakshatraGirlList = [];
  bool isNakshatraMaleLoading = false;
  String errorMessageMale = '';
  String errorMessageFemale = '';

  bool isLoading = false;

  Future<void> fetchNakshatraBoyList(int rasiId) async {
    setState(() {
      isNakshatraMaleLoading = true;
    });
    try {
      List<NakshatraModel> fetchedNakshatra =
          await MatchMakingService().getNakshatraList(rasiId);
      setState(() {
        nakshatraBoyList = fetchedNakshatra;
        isNakshatraMaleLoading = false;
      });
    } catch (e) {
      print("Error fetching Nakshatra list: $e");
      setState(() {
        isNakshatraMaleLoading = false;
      });
    }
  }

  Future<void> fetchNakshatraGirlList(int rasiId) async {
    setState(() {
      isNakshatraMaleLoading = true;
    });
    try {
      List<NakshatraModel> fetchedNakshatra =
          await MatchMakingService().getNakshatraList(rasiId);
      setState(() {
        nakshatraGirlList = fetchedNakshatra;
        isNakshatraMaleLoading = false;
      });
    } catch (e) {
      print("Error fetching Nakshatra list: $e");
      setState(() {
        isNakshatraMaleLoading = false;
      });
    }
  }

  void validateInput(BuildContext context) async {
    await clearMakingMaking();
    setState(() {
      errorBoyName = boyName.text.isEmpty;
      errorGirlName = girlName.text.isEmpty;
      errorMaleRasi = selectedMaleRasi == null;
      errorFemaleRasi = selectedFemaleRasi == null;
      errorMaleNakshatra = selectedMaleNakshatra == null;
      errorFemaleNakshatra = selectedFemaleNakshatra == null;
      isLoading = true;
    });

    if (errorMaleNakshatra == true) {
      setState(() {
        errorMessageMale = "Please select Boy's Nakshatram";
      });
    }

    if (errorFemaleNakshatra == true) {
      setState(() {
        errorMessageFemale = "Please select Girl's Nakshatram";
      });
    }

    if (!errorBoyName &&
        !errorGirlName &&
        !errorMaleRasi &&
        !errorFemaleRasi &&
        !errorMaleNakshatra &&
        !errorFemaleNakshatra) {
      try {
        CustomLoader.show(context, loaderColor: matchTopGradient);

        GetNewMatchMakingModel? result =
            await MatchMakingService().postMatchMaking(
          boyName: boyName.text,
          girlName: girlName.text,
          boyRashi: selectedMaleRasi!,
          boyNakshatra: selectedMaleNakshatra!,
          girlRashi: selectedFemaleRasi!,
          girlNakshatra: selectedFemaleNakshatra!,
        );
        print('MatchData: $result');
        await saveMakingMaking(
            boyName.text,
            girlName.text,
            selectedMaleRasi!,
            selectedFemaleRasi!,
            selectedMaleNakshatra!,
            selectedFemaleNakshatra!);

        CustomLoader.hide();
        if (result != null) {
          // Clear the regeneration flag since user has generated new match making
          await setMatchMakingNeedsRegeneration(false);
          // Sync previousAppLanguage to current so home page doesn't re-trigger language change
          String currentLang = await getAppLanguage();
          if (currentLang.isNotEmpty) {
            await savePreviousAppLanguage(currentLang);
          }
          Get.to(() => MatchMakingDetailsPage(
                matchMakingData: result,
                fromHomePage: false,
              ));
          print('Result: $result');
        } else {
          showErrorSnackBar(context, "Failed to fetch data. Please try again.");
        }
      } catch (e) {
        showErrorSnackBar(context, "Error: $e");
      }
    }
    if (mounted) {
      setState(() {
        isLoading = false; // Hide loader
      });
    }
  }

  @override
  void initState() {
    super.initState();
    boyName.text = '';
    girlName.text = '';
  }

  @override
  void dispose() {
    boyName.dispose();
    girlName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.989)}');
    // print('Height12: ${util.responsiveHeight(0.0321)}');
    // print('FontSize: ${util.responsiveFontSize(0.0186)}');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Future.microtask(() {
            Get.back();
          });
        }
      },
      child: Scaffold(
        body: Hero(
            tag: 'matchMakingHero',
            child: Material(
              child: Container(
                width: util.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [matchTopGradient, matchBottomGradient],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ///AppBar
                      SizedBox(
                        height: util.responsiveHeight(0.1232),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 300),
                                opacity: 1.0,
                                child: AppBar(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  title: Text("Marriage Match Making".tr,
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: util.fontSize20,
                                          fontFamily:
                                              AppFont.get(FontType.bold),
                                          height: 1.0)),
                                  leading: SizedBox(
                                    width: util.responsiveWidth(0.08),
                                    height: util.responsiveHeight(0.037),
                                    child: IconButton(
                                      icon: SvgPicture.asset(appBackButton,
                                          width: util.width20,
                                          height: util.height20),
                                      onPressed: () {
                                        // Navigator.pop(context);
                                        Get.to(() => BottomNavigationScreen());
                                      },
                                    ),
                                  ),
                                  centerTitle: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Text(
                              'Check astrological compatibility for a perfect match'
                                  .tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize14,
                                  height: 1.0,
                                  color: whiteColor),
                            ),
                            SizedBox(
                              height: util.responsiveHeight(0.0321),
                            ),

                            ///Boy Data
                            Column(
                              children: [
                                Container(
                                  height: 48,
                                  width: util.width,
                                  decoration: BoxDecoration(
                                      color: matchHeadColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(boy),
                                      SizedBox(
                                        width: util.width10,
                                      ),
                                      Text(
                                        'Boy Details'.tr,
                                        style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.semiBold),
                                            fontSize: util.fontSize16,
                                            height: 1.0,
                                            color: blackColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: util.width,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(12),
                                          bottomLeft: Radius.circular(12))),
                                  child: Column(
                                    children: [
                                      CustomMatchTextField(
                                        hintText: 'Enter boy\'s name',
                                        controller: boyName,
                                        errorFlag: errorBoyName,
                                        errorText: "Please enter Boy's name",
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      CustomMatchDropDown(
                                        title: 'Rasi'.tr,
                                        isMandatory: true,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedMaleRasi = value;
                                            errorMaleRasi = false;
                                            selectedMaleNakshatra = null;
                                            nakshatraBoyList = [];
                                            errorMaleNakshatra = false;
                                            fetchNakshatraBoyList(widget
                                                .rasiList
                                                .firstWhere(
                                                    (r) => r.name == value)
                                                .id);
                                          });
                                        },
                                        errorFlag: errorMaleRasi,
                                        errorText: "Please select Boy's Rasi",
                                        options: widget.rasiList
                                            .map((rasi) => rasi.name)
                                            .toList(),
                                        isLoading: widget.rasiList.isEmpty,
                                        selectedValue: selectedMaleRasi,
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      CustomMatchDropDown(
                                        title: 'Nakshatram'.tr,
                                        isMandatory: true,
                                        onChanged: (value) {
                                          if (selectedMaleRasi == null) {
                                            setState(() {
                                              errorMaleNakshatra = true;
                                              errorMessageMale =
                                                  'Please Select Rasi';
                                            });
                                            return;
                                          } else {
                                            setState(() {
                                              selectedMaleNakshatra = value;
                                              errorMaleNakshatra = false;
                                            });
                                          }
                                        },
                                        errorFlag: errorMaleNakshatra,
                                        errorText: errorMessageMale,
                                        options: nakshatraBoyList
                                            .map((nakshatra) => nakshatra.name)
                                            .toList(),
                                        isLoading: isNakshatraMaleLoading,
                                        selectedValue: selectedMaleNakshatra,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            ///Girl Data
                            Column(
                              children: [
                                Container(
                                  height: 48,
                                  width: util.width,
                                  decoration: BoxDecoration(
                                      color: matchHeadColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(girl),
                                      SizedBox(
                                        width: util.width10,
                                      ),
                                      Text(
                                        'Girl Details'.tr,
                                        style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.semiBold),
                                            fontSize: util.fontSize16,
                                            height: 1.0,
                                            color: blackColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: util.width,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(12),
                                          bottomLeft: Radius.circular(12))),
                                  child: Column(
                                    children: [
                                      CustomMatchTextField(
                                        hintText: 'Enter girl\'s name',
                                        controller: girlName,
                                        errorFlag: errorGirlName,
                                        errorText: "Please enter Girl's name",
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      CustomMatchDropDown(
                                        title: 'Rasi'.tr,
                                        isMandatory: true,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedFemaleRasi = value;
                                            errorFemaleRasi = false;
                                            selectedFemaleNakshatra = null;
                                            nakshatraGirlList = [];
                                            errorFemaleNakshatra = false;
                                            fetchNakshatraGirlList(widget
                                                .rasiList
                                                .firstWhere(
                                                    (r) => r.name == value)
                                                .id);
                                          });
                                        },
                                        errorFlag: errorFemaleRasi,
                                        errorText: "Please select Girl's Rasi",
                                        options: widget.rasiList
                                            .map((rasi) => rasi.name)
                                            .toList(),
                                        isLoading: widget.rasiList.isEmpty,
                                        selectedValue: selectedFemaleRasi,
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      CustomMatchDropDown(
                                        title: 'Nakshatram'.tr,
                                        isMandatory: true,
                                        onChanged: (value) {
                                          if (selectedFemaleRasi == null) {
                                            setState(() {
                                              errorFemaleNakshatra = true;
                                              errorMessageFemale =
                                                  'Please Select Rasi';
                                            });
                                            return;
                                          } else {
                                            setState(() {
                                              selectedFemaleNakshatra = value;
                                              errorFemaleNakshatra = false;
                                            });
                                          }
                                        },
                                        errorFlag: errorFemaleNakshatra,
                                        errorText: errorMessageFemale,
                                        options: nakshatraGirlList
                                            .map((nakshatra) => nakshatra.name)
                                            .toList(),
                                        isLoading: isNakshatraMaleLoading,
                                        selectedValue: selectedFemaleNakshatra,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            ///Calculate Button
                            GestureDetector(
                              onTap: () {
                                if (!isLoading) {
                                  validateInput(context);
                                }
                              },
                              child: Container(
                                width: util.width,
                                padding: EdgeInsets.symmetric(
                                    vertical: util.height10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: whiteColor),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Calculate Match'.tr,
                                      style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.semiBold),
                                          fontSize: util.fontSize18,
                                          height: 1.0,
                                          color: matchButtonText),
                                    ),
                                    SizedBox(
                                      width: util.width10,
                                    ),
                                    SvgPicture.asset(ring)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: util.height50,
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
