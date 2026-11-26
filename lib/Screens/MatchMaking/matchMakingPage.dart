import 'package:astro_prompt/Components/Common/customDropDown.dart';
import 'package:astro_prompt/Components/MatchMaking/customMatchBirthField.dart';
import 'package:astro_prompt/Components/MatchMaking/customMatchTextfield.dart';
import 'package:astro_prompt/Components/Profile/customDatePicker.dart';
import 'package:astro_prompt/Model/location_selection_model.dart';
import 'package:astro_prompt/Model/match_making_model.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/MatchMaking/matchMakingDetails.dart';
import 'package:astro_prompt/Services/MatchService/matchService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/LocallySavedData/appLanguage.dart';
import 'package:astro_prompt/config/LocallySavedData/matchMaking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MatchMakingPage extends StatefulWidget {
  const MatchMakingPage({super.key});

  @override
  State<MatchMakingPage> createState() => _MatchMakingPageState();
}

class _MatchMakingPageState extends State<MatchMakingPage> {
  final TextEditingController boyName = TextEditingController();
  final TextEditingController girlName = TextEditingController();
  final TextEditingController boyDob = TextEditingController();
  final TextEditingController girlDob = TextEditingController();
  final TextEditingController boyTob = TextEditingController();
  final TextEditingController girlTob = TextEditingController();
  final TextEditingController boyPob = TextEditingController();
  final TextEditingController girlPob = TextEditingController();

  DateTime? boyDobDate;
  DateTime? girlDobDate;
  TimeOfDay? boyTobTime;
  TimeOfDay? girlTobTime;
  String boyPobFull = '';
  String girlPobFull = '';

  bool errorBoyName = false;
  bool errorGirlName = false;
  bool errorBoyDob = false;
  bool errorGirlDob = false;
  bool errorBoyTob = false;
  bool errorGirlTob = false;
  bool errorBoyPob = false;
  bool errorGirlPob = false;
  bool isLoading = false;

  Future<void> _pickDob({required bool isBoy}) async {
    final picked = await CustomDatePicker.show(
      context: context,
      currentDateText: isBoy ? boyDob.text : girlDob.text,
      initialDate: isBoy ? boyDobDate : girlDobDate,
    );
    if (picked == null) return;
    setState(() {
      if (isBoy) {
        boyDobDate = picked;
        boyDob.text = CustomDatePicker.formatDate(picked);
        errorBoyDob = false;
      } else {
        girlDobDate = picked;
        girlDob.text = CustomDatePicker.formatDate(picked);
        errorGirlDob = false;
      }
    });
  }

  Future<void> _pickTob({required bool isBoy}) async {
    final initial = isBoy
        ? (boyTobTime ?? const TimeOfDay(hour: 12, minute: 0))
        : (girlTobTime ?? const TimeOfDay(hour: 12, minute: 0));
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    final formatted = DateFormat('hh:mm a').format(
      DateTime(2000, 1, 1, picked.hour, picked.minute),
    );
    setState(() {
      if (isBoy) {
        boyTobTime = picked;
        boyTob.text = formatted;
        errorBoyTob = false;
      } else {
        girlTobTime = picked;
        girlTob.text = formatted;
        errorGirlTob = false;
      }
    });
  }

  String _apiDate(String display) {
    final parsed = DateFormat('dd/MM/yyyy').parse(display);
    return DateFormat('yyyy-MM-dd').format(parsed);
  }

  String _apiTime(String display) {
    final parsed = DateFormat('hh:mm a').parse(display);
    return DateFormat('HH:mm:ss').format(parsed);
  }

  Future<void> validateInput(BuildContext context) async {
    await clearMakingMaking();
    setState(() {
      errorBoyName = boyName.text.trim().isEmpty;
      errorGirlName = girlName.text.trim().isEmpty;
      errorBoyDob = boyDob.text.trim().isEmpty;
      errorGirlDob = girlDob.text.trim().isEmpty;
      errorBoyTob = boyTob.text.trim().isEmpty;
      errorGirlTob = girlTob.text.trim().isEmpty;
      errorBoyPob = boyPob.text.trim().isEmpty;
      errorGirlPob = girlPob.text.trim().isEmpty;
      isLoading = true;
    });

    final valid = !errorBoyName &&
        !errorGirlName &&
        !errorBoyDob &&
        !errorGirlDob &&
        !errorBoyTob &&
        !errorGirlTob &&
        !errorBoyPob &&
        !errorGirlPob;

    if (!valid) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    try {
      CustomLoader.show(context, loaderColor: matchTopGradient);
      final boyLoc =
          boyPobFull.trim().isNotEmpty ? boyPobFull.trim() : boyPob.text.trim();
      final girlLoc = girlPobFull.trim().isNotEmpty
          ? girlPobFull.trim()
          : girlPob.text.trim();

      final result = await MatchMakingService().postMatchMaking(
        boyName: boyName.text.trim(),
        girlName: girlName.text.trim(),
        boyDateOfBirth: _apiDate(boyDob.text),
        boyTimeOfBirth: _apiTime(boyTob.text),
        boyBirthLocation: boyLoc,
        girlDateOfBirth: _apiDate(girlDob.text),
        girlTimeOfBirth: _apiTime(girlTob.text),
        girlBirthLocation: girlLoc,
      );

      CustomLoader.hide();
      if (result != null) {
        await saveMakingMaking(
          boyName.text.trim(),
          girlName.text.trim(),
          boyDob.text,
          girlDob.text,
          boyTob.text,
          girlTob.text,
        );
        await setMatchMakingNeedsRegeneration(false);
        final currentLang = await getAppLanguage();
        if (currentLang.isNotEmpty) {
          await savePreviousAppLanguage(currentLang);
        }
        Get.to(() => MatchMakingDetailsPage(
              matchMakingData: result,
              fromHomePage: false,
            ));
      } else {
        showErrorSnackBar(context, "Failed to fetch data. Please try again.");
      }
    } catch (e) {
      CustomLoader.hide();
      showErrorSnackBar(context, "Error: $e");
    }

    if (mounted) setState(() => isLoading = false);
  }

  @override
  void dispose() {
    boyName.dispose();
    girlName.dispose();
    boyDob.dispose();
    girlDob.dispose();
    boyTob.dispose();
    girlTob.dispose();
    boyPob.dispose();
    girlPob.dispose();
    super.dispose();
  }

  Widget _partnerCard({
    required bool isBoy,
    required TextEditingController nameCtrl,
    required TextEditingController dobCtrl,
    required TextEditingController tobCtrl,
    required TextEditingController pobCtrl,
    required bool nameErr,
    required bool dobErr,
    required bool tobErr,
    required bool pobErr,
  }) {
    final util = MyUtility(context);
    return Column(
      children: [
        Container(
          height: 48,
          width: util.width,
          decoration: BoxDecoration(
            color: matchHeadColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(isBoy ? boy : girl),
              SizedBox(width: util.width10),
              Text(
                (isBoy ? 'Boy Details' : 'Girl Details').tr,
                style: TextStyle(
                  fontFamily: AppFont.get(FontType.semiBold),
                  fontSize: util.fontSize16,
                  height: 1.0,
                  color: blackColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: util.width,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          child: Column(
            children: [
              CustomMatchTextField(
                hintText: isBoy ? "Enter boy's name" : "Enter girl's name",
                controller: nameCtrl,
                errorFlag: nameErr,
                errorText: isBoy
                    ? "Please enter Boy's name"
                    : "Please enter Girl's name",
              ),
              const SizedBox(height: 9),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomMatchBirthField(
                      title: 'Date of Birth',
                      hintText: 'Select date of birth',
                      controller: dobCtrl,
                      errorFlag: dobErr,
                      errorText: 'Please select Date of Birth',
                      onTap: () => _pickDob(isBoy: isBoy),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: CustomMatchBirthField(
                      title: 'Time of Birth',
                      hintText: 'Select time of birth',
                      controller: tobCtrl,
                      errorFlag: tobErr,
                      errorText: 'Please select Time of Birth',
                      onTap: () => _pickTob(isBoy: isBoy),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              CustomDropDown(
                title: 'Place of Birth'.tr,
                textController: pobCtrl,
                isMandatory: true,
                enableEdit: true,
                errorFlag: pobErr,
                onLocationChanged: (LocationSelection location) {
                  setState(() {
                    pobCtrl.text = location.selectedText;
                    if (isBoy) {
                      boyPobFull = location.displayText;
                      errorBoyPob = false;
                    } else {
                      girlPobFull = location.displayText;
                      errorGirlPob = false;
                    }
                  });
                },
              ),
              if (pobErr)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Please enter the Place of birth'.tr,
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.medium),
                        fontSize: util.fontSize11,
                        color: errorColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Future.microtask(() => Get.back());
        }
      },
      child: Scaffold(
        body: Hero(
          tag: 'matchMakingHero',
          child: Material(
            child: Container(
              width: util.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [matchTopGradient, matchBottomGradient],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: util.responsiveHeight(0.1232),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: AppBar(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              title: Text(
                                "Marriage Match Making".tr,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: util.fontSize20,
                                  fontFamily: AppFont.get(FontType.bold),
                                  height: 1.0,
                                ),
                              ),
                              leading: SizedBox(
                                width: util.responsiveWidth(0.08),
                                height: util.responsiveHeight(0.037),
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                    appBackButton,
                                    width: util.width20,
                                    height: util.height20,
                                  ),
                                  onPressed: () {
                                    Get.to(() => BottomNavigationScreen());
                                  },
                                ),
                              ),
                              centerTitle: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              color: whiteColor,
                            ),
                          ),
                          SizedBox(height: util.responsiveHeight(0.0321)),
                          _partnerCard(
                            isBoy: true,
                            nameCtrl: boyName,
                            dobCtrl: boyDob,
                            tobCtrl: boyTob,
                            pobCtrl: boyPob,
                            nameErr: errorBoyName,
                            dobErr: errorBoyDob,
                            tobErr: errorBoyTob,
                            pobErr: errorBoyPob,
                          ),
                          const SizedBox(height: 15),
                          _partnerCard(
                            isBoy: false,
                            nameCtrl: girlName,
                            dobCtrl: girlDob,
                            tobCtrl: girlTob,
                            pobCtrl: girlPob,
                            nameErr: errorGirlName,
                            dobErr: errorGirlDob,
                            tobErr: errorGirlTob,
                            pobErr: errorGirlPob,
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              if (!isLoading) validateInput(context);
                            },
                            child: Container(
                              width: util.width,
                              padding: EdgeInsets.symmetric(
                                  vertical: util.height10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: whiteColor,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Calculate Match'.tr,
                                    style: TextStyle(
                                      fontFamily: AppFont.get(FontType.semiBold),
                                      fontSize: util.fontSize18,
                                      height: 1.0,
                                      color: matchButtonText,
                                    ),
                                  ),
                                  SizedBox(width: util.width10),
                                  SvgPicture.asset(ring),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: util.height50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
