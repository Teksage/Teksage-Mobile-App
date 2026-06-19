import 'dart:io';
import 'package:astro_prompt/Components/Common/customDropDown.dart';
import 'package:astro_prompt/Components/Common/customTextField.dart';
import 'package:astro_prompt/Components/Dashboard/subscribeDialog.dart';
import 'package:astro_prompt/Components/Dashboard/subscribeIosDialog.dart';
import 'package:astro_prompt/Components/Profile/unsavedDialog.dart';
import 'package:astro_prompt/Components/Profile/customDatePicker.dart';
import 'package:astro_prompt/Components/Profile/customTimePicker.dart';
import 'package:astro_prompt/Components/Settings/profileComponent.dart';
import 'package:astro_prompt/Model/country_model.dart';
import 'package:astro_prompt/Model/location_selection_model.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Screens/Chat/chat.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/settings/settings_page.dart';
import 'package:astro_prompt/Services/NotificationService/notificationService.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Services/TimeZoneService/timeZoneService.dart';
import 'package:astro_prompt/Services/countryService/countryCodeService.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/fieldFormatter.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/currencyHelper.dart';
import 'package:astro_prompt/config/LocallySavedData/chatLanguage.dart';
import 'package:astro_prompt/config/LocallySavedData/name.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:astro_prompt/config/LocallySavedData/timezone.dart';
import 'package:astro_prompt/config/locationNameCorrection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class ProfilePage extends StatefulWidget {
  final String title;
  final bool isProfileUpdated;
  final bool? fromChangePage;
  final String? userInfo;
  final String? keyValue;
  final String? countryCode;
  final bool? userType;
  final Map<String, dynamic>? userData;
  final Map<String, dynamic>? phoneNumberChangeData;
  const ProfilePage({
    super.key,
    required this.title,
    required this.isProfileUpdated,
    this.userInfo,
    this.keyValue,
    this.fromChangePage,
    this.countryCode,
    this.userType,
    this.userData,
    this.phoneNumberChangeData,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Subscription? subscriptionData;

  bool _isPlanExpired() {
    try {
      final status = subscriptionData?.planStatus ?? '';
      return status.toString().toLowerCase().trim() == 'expired';
    } catch (e) {
      return false;
    }
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  ProfileService profileService = ProfileService();
  DateTime? dateOfBirth;
  TimeOfDay? timeOfBirth;
  TextEditingController dobController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController selectedRasi = TextEditingController();
  TextEditingController selectedNakshatra = TextEditingController();
  TextEditingController placeOfBirth = TextEditingController();
  TextEditingController chatLanguage = TextEditingController();
  TextEditingController howYouKnow = TextEditingController();
  TextEditingController preferredLocation = TextEditingController();
  String birthPlaceFullLocation = '';
  String preferredPlaceFullLocation = '';
  List<Country> countries = [];
  bool enableEdit = false;
  bool premiumUser = false;
  bool showEmailVerify = false;
  bool showMobileVerify = false;
  bool emailVerified = false;
  bool mobileVerified = false;
  bool firstNameError = false;
  bool secondNameError = false;
  bool emailError = false;
  bool mobileError = false;
  bool chatLanguageError = false;
  bool howYouKnowError = false;
  bool dobError = false;
  bool tobError = false;
  bool pobError = false;
  bool prefLocError = false;
  bool requiredField = false;
  String emailErrMessage = '';
  String mobileErrMessage = '';
  String currency = '';
  bool isPhoneNumberValid = false;
  bool isPhoneVerifiedDB = false;
  bool isNewUser = false;

  void updateEmailVerification(bool isVerified) {
    setState(() {
      emailVerified = isVerified;
      emailError = false;
    });
  }

  void updateMobileVerification(bool isVerified) {
    setState(() {
      mobileVerified = isVerified;
      mobileError = false;
    });
  }

  bool validateInputs() {
    bool isEmpty(TextEditingController c) => c.text.trim().isEmpty;

    setState(() {
      firstNameError = isEmpty(firstNameController);
      secondNameError = isEmpty(secondNameController);
      emailError = isEmpty(emailController);
      // mobileError = isEmpty(mobileController);
      mobileError = false;
      chatLanguageError = isEmpty(chatLanguage);
      howYouKnowError = isEmpty(howYouKnow);
      dobError = isEmpty(dobController);
      tobError = isEmpty(timeController);
      pobError = isEmpty(placeOfBirth);
      // prefLocError = isEmpty(preferredLocation);
      prefLocError = false;
      emailErrMessage = emailError ? 'Please enter a valid Email' : '';
      // mobileErrMessage = mobileError ? 'Please enter a valid Mobile number' : '';
      mobileErrMessage = '';
    });

    bool hasCommonError = firstNameError ||
            secondNameError ||
            emailError ||
            // mobileError ||
            chatLanguageError ||
            dobError ||
            tobError ||
            pobError
        // || prefLocError
        ;

    return !widget.isProfileUpdated
        ? !(hasCommonError || howYouKnowError)
        : !hasCommonError;
  }

  Future<void> datePicker() async {
    DateTime? pickedDate = await CustomDatePicker.show(
      context: context,
      currentDateText: dobController.text,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dateOfBirth = pickedDate;
        dobController.text = CustomDatePicker.formatDate(pickedDate);
      });
      FocusScope.of(context).requestFocus(FocusNode());
    }
    if (enableEdit) {
      updateRashiNakshatra();
    }
  }

  Future<void> timePicker() async {
    TimeOfDay? pickedTime = await CustomTimePicker.show(
      context: context,
      initialTime: timeOfBirth ?? TimeOfDay.now(),
      dateOfBirth: dateOfBirth,
      onError: (errorMessage) {
        showErrorSnackBar(context, errorMessage);
      },
    );

    if (pickedTime != null) {
      if (mounted) {
        setState(() {
          timeOfBirth = pickedTime;
          timeController.text = CustomTimePicker.formatTime(pickedTime);
        });
      }
      FocusScope.of(context).requestFocus(FocusNode());
      if (enableEdit) {
        updateRashiNakshatra();
      }
    }
  }

  Future subscribeDialog() async {
    if (Platform.isAndroid) {
      if (currency.isNotEmpty) {
        if (_isPlanExpired()) {
          showDialog(
            context: context,
            barrierDismissible: true,
            barrierColor: Colors.black.withAlpha(128),
            builder: (context) => const SubscribePromptDialog(
              planStatus: 'expired',
              currency: 'INR',
              reDirectHome: false,
            ),
          );
        } else {
          showDialog(
            context: context,
            barrierDismissible: true,
            barrierColor: Colors.black.withValues(alpha: 0.5),
            builder: (context) => SubscribePromptDialog(
              reDirectHome: false,
              currency: currency,
            ),
          );
        }
      } else {
        await CurrencyHelper.fetchCurrencyIfNeeded(
          context: context,
          currentCurrency: currency,
          loaderColor: Platform.isAndroid ? mainColor : iosMainColor,
          onCurrencyFetched: (fetchedCurrency) {
            setState(() {
              currency = fetchedCurrency;
            });
            if (_isPlanExpired()) {
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Colors.black.withAlpha(128),
                builder: (context) => const SubscribePromptDialog(
                  planStatus: 'expired',
                  currency: 'INR',
                  reDirectHome: false,
                ),
              );
            } else {
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Colors.black.withAlpha(128),
                builder: (context) => SubscribePromptDialog(
                  currency: fetchedCurrency,
                  reDirectHome: false,
                ),
              );
            }
          },
        );
      }
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        builder: (context) => SubscriptionIosPromptDialog(),
      );
      // Get.to(() => SubscriptionDetailsPageIos());
    }
  }

  void updateRashiNakshatra() async {
    final dob = dobController.text;
    final time = timeController.text;

    if (dob.isNotEmpty && time.isNotEmpty && placeOfBirth.text.isNotEmpty
        // && preferredLocation.text.isNotEmpty
        ) {
      CustomLoader.show(context);

      DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(dob);
      String formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      DateTime parsedTime = DateFormat("hh:mm a").parse(time);
      String formattedTime = DateFormat("HH:mm").format(parsedTime);

      if (kDebugMode) {
        print('DOB: $dob, Time: $time');
        print('Place: $placeOfBirth, Preferred: $preferredLocation');
      }

      var response = await profileService.fetchRashiNakshatra(
        preferredLocation: preferredLocation.text,
        dateOfBirth: formattedDate,
        timeOfBirth: formattedTime,
        birthLocation: placeOfBirth.text,
      );
      CustomLoader.hide();

      if (response['success']) {
        setState(() {
          selectedRasi.text = response['data']['rashi'];
          selectedNakshatra.text = response['data']['nakshatra'];
          requiredField = false;
        });
      }
    } else {
      if (kDebugMode) print('Validation failed. Some fields are empty.');
    }
  }

  @override
  void initState() {
    super.initState();
    // fetchProfileData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProfileData();
    });

    checkLoginInfo();
    firstNameController.addListener(() {
      if (firstNameController.text.trim().isNotEmpty && firstNameError) {
        setState(() {
          firstNameError = false;
        });
      }
    });

    secondNameController.addListener(() {
      if (secondNameController.text.trim().isNotEmpty && secondNameError) {
        setState(() {
          secondNameError = false;
        });
      }
    });

    emailController.addListener(() {
      if (emailController.text.trim().isNotEmpty && emailError) {
        setState(() {
          emailError = false;
          emailErrMessage = '';
        });
      }
    });

    mobileController.addListener(() {
      if (mobileController.text.trim().length >= 10 && mobileError) {
        setState(() {
          mobileError = false;
          mobileErrMessage = '';
        });
      }
    });

    chatLanguage.addListener(() {
      if (chatLanguage.text.trim().isNotEmpty && chatLanguageError) {
        setState(() {
          chatLanguageError = false;
        });
      }
    });

    dobController.addListener(() {
      if (dobController.text.trim().isNotEmpty && dobError) {
        setState(() {
          dobError = false;
        });
      }
    });

    timeController.addListener(() {
      if (timeController.text.trim().isNotEmpty && tobError) {
        setState(() {
          tobError = false;
        });
      }
    });

    placeOfBirth.addListener(() {
      if (placeOfBirth.text.trim().isNotEmpty && pobError) {
        setState(() {
          pobError = false;
        });
      }
    });

    preferredLocation.addListener(() {
      if (preferredLocation.text.trim().isNotEmpty && prefLocError) {
        setState(() {
          prefLocError = false;
        });
      }
    });

    howYouKnow.addListener(() {
      if (howYouKnow.text.trim().isNotEmpty && howYouKnowError) {
        setState(() {
          howYouKnowError = false;
        });
      }
    });
  }

  UserProfile? originalProfileData;
  String? selectedCountryCode;

  String convertDateFormat(String date) {
    List<String> parts = date.split('-');
    if (parts.length == 3) {
      return "${parts[2]}/${parts[1]}/${parts[0]}";
    }
    return date;
  }

  String convertTimeFormat(String time) {
    List<String> parts = time.split(':');
    if (parts.length >= 2) {
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      String period = hour >= 12 ? "PM" : "AM";
      hour = hour % 12 == 0 ? 12 : hour % 12;
      String formattedHour = hour.toString().padLeft(2, '0');
      String formattedMinute = minute.toString().padLeft(2, '0');
      return "$formattedHour:$formattedMinute $period";
    }
    return time;
  }

  bool hasProfileChanged() {
    if (kDebugMode) {
      print(
          'Name: ${firstNameController.text} ${originalProfileData!.firstName}, ${secondNameController.text} ${originalProfileData!.lastName}');
      print(
          'ChatLang: ${chatLanguage.text} ${originalProfileData!.chatLanguage}');
      print(
          'DOB: ${dobController.text} ${convertDateFormat(originalProfileData!.dateOfBirth)}');
      print(
          'TOB: ${timeController.text} ${convertTimeFormat(originalProfileData!.timeOfBirth)}');
      print(
          'POB: ${placeOfBirth.text} ${extractCityName(originalProfileData!.birthLocation)}');
      print(
          'PrefLoc: ${preferredLocation.text} ${extractCityName(originalProfileData!.preferredLocation)}');
    }

    if (originalProfileData == null) return false;

    return firstNameController.text != originalProfileData!.firstName ||
        secondNameController.text != originalProfileData!.lastName ||
        chatLanguage.text != originalProfileData!.chatLanguage ||
        dobController.text !=
            convertDateFormat(originalProfileData!.dateOfBirth) ||
        timeController.text !=
            convertTimeFormat(originalProfileData!.timeOfBirth) ||
        placeOfBirth.text !=
            extractCityName(originalProfileData!.birthLocation) ||
        preferredLocation.text !=
            extractCityName(originalProfileData!.preferredLocation);
  }

  void fetchProfileData() async {
    premiumUser = await getUserPremium();

    final bool isFromChangePage = widget.fromChangePage ?? false;
    final bool isProfileUpdated = widget.isProfileUpdated;
    if (kDebugMode) {
      print('widget.isProfileUpdated: $isProfileUpdated}');
    }
    setState(() {
      isNewUser = isProfileUpdated;
    });
    try {
      CustomLoader.show(context);

      UserProfile? profileData = await profileService.fetchUserProfile();
      if (profileData != null) {
        subscriptionData = profileData.subscription;
        // print('Fetched profile data: ${profileData.subscription?.planStatus}');
        final String status = (subscriptionData?.planStatus ?? '')
            .toString()
            .toLowerCase()
            .trim();
        if (status == 'active') {
          await savePremiumUser(true);
          setState(() {
            premiumUser = true;
          });
        }
        if (!isFromChangePage && isProfileUpdated) {
          originalProfileData = profileData;
          updateProfileFields(profileData);
        } else {
          originalProfileData = profileData;
          updateProfileFields(profileData, skipIfFilled: true);
        }
      } else {
        if (kDebugMode) {
          print("Profile data is null. Unable to update UI.");
        }
      }
    } on IncompleteProfileException catch (e) {
      if (kDebugMode) {
        print("Incomplete profile data: ${e.profileData}");
      }
      final UserProfile profile = UserProfile.fromJson(e.profileData);
      updateProfileFields(profile, skipIfFilled: true);
      // Optionally handle or prefill partial data
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching profile: $e");
      }
    } finally {
      CustomLoader.hide();
    }
  }

  void updateProfileFields(UserProfile profileData,
      {bool skipIfFilled = false}) async {
    String dob = convertDateFormat(profileData.dateOfBirth);
    String tob = convertTimeFormat(profileData.timeOfBirth);

    print(
        'mobileVerified from API: ${profileData.mobileVerified},${widget.phoneNumberChangeData}');
    setState(() {
      emailVerified = (profileData.email.isNotEmpty);
      isPhoneVerifiedDB = widget.phoneNumberChangeData != null
          ? false
          : profileData.mobileVerified;
      print('isPhoneVerifiedDB : $isPhoneVerifiedDB');
      showEmailVerify = !emailVerified;
      showMobileVerify = isPhoneVerifiedDB;
      if (!skipIfFilled || firstNameController.text.isEmpty) {
        firstNameController.text = profileData.firstName;
      }
      if (!skipIfFilled || secondNameController.text.isEmpty) {
        secondNameController.text = profileData.lastName;
      }
      if (!skipIfFilled || emailController.text.isEmpty) {
        emailController.text = profileData.email;
      }
      if (!skipIfFilled || mobileController.text.isEmpty) {
        if (widget.phoneNumberChangeData != null) {
          mobileController.text =
              widget.phoneNumberChangeData!['mobile_number'];
          selectedCountryCode = widget.phoneNumberChangeData!['country_code'];
          isPhoneNumberValid = true;
          enableEdit = true;
        } else {
          mobileController.text = profileData.mobileNumber;
          isPhoneNumberValid = true;
          if (profileData.mobileNumber.isNotEmpty) {
            selectedCountryCode = profileData.countryCode;
          }
        }
      }
      if (!skipIfFilled || chatLanguage.text.isEmpty) {
        chatLanguage.text = profileData.chatLanguage;
        saveChatLanguage(chatLanguage.text);
      }
      // if (!skipIfFilled || howYouKnow.text.isEmpty) {
      //   howYouKnow.text = profileData.howYouKnow!;
      // }
      if (!skipIfFilled || dobController.text.isEmpty) {
        dobController.text = dob;
        if (dob.isNotEmpty) {
          dateOfBirth = DateFormat('dd/MM/yyyy').parse(dob);
        }
      }
      if (!skipIfFilled || timeController.text.isEmpty) {
        timeController.text = tob;
      }
      if (!skipIfFilled || placeOfBirth.text.isEmpty) {
        placeOfBirth.text = extractCityName(profileData.birthLocation);
        birthPlaceFullLocation = profileData.birthLocation;
      }
      if (!skipIfFilled || preferredLocation.text.isEmpty) {
        preferredLocation.text = extractCityName(profileData.preferredLocation);
        preferredPlaceFullLocation = profileData.preferredLocation;
      }
      selectedRasi.text = profileData.rashi;
      selectedNakshatra.text = profileData.nakshatra;
    });
  }

  checkLoginInfo() async {
    print('country code:${widget.countryCode}');
    if (widget.isProfileUpdated == false) {
      // countries = await CountryCodeService().fetchCountries();
      if (widget.userType != null && widget.userType == true) {
        setState(() {
          enableEdit = true;
        });
        if (widget.keyValue == 'email') {
          setState(() {
            emailController.text = widget.userInfo!;
            showEmailVerify = false;
            showMobileVerify = true;
            emailVerified = true;
          });
        } else if (widget.keyValue == 'mobile_number') {
          // String formattedNumber = formatPhoneNumber(widget.userInfo!);
          setState(() {
            mobileController.text = widget.userInfo!;
            selectedCountryCode = widget.countryCode;
            showEmailVerify = true;
            showMobileVerify = false;
            mobileVerified = true;
          });
        }
      } else {
        setState(() {
          enableEdit = true;
          if (widget.userData != null) {
            firstNameController.text = widget.userData!['name'];
            secondNameController.text = widget.userData!['lastName'];
            emailController.text = widget.userData!['email'];
            mobileController.text = widget.userData!['mobile'];
            emailVerified = widget.userData!['isEmailVerified'];
            mobileVerified = widget.userData!['isMobileVerified'];
          }
        });
      }
    } else {
      setState(() {
        enableEdit = false;
      });
    }
  }

  void navigateAfterDelay(String name, String result) async {
    print('result: $result');
    await Future.delayed(Duration(milliseconds: 1000));
    Get.snackbar('Hi (name)!'.tr.replaceAll('(name)', name), result,
        snackPosition: SnackPosition.TOP, duration: Duration(seconds: 1));
    CustomLoader.show(context);
    if (Platform.isAndroid) {
      Get.offAllNamed('/home');
    } else {
      Get.offAll(() => AIChatScreen());
    }
    CustomLoader.hide();
  }

  void generateRasiNakshatra() async {}

  Future<bool> showUnsavedChangesDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black.withValues(alpha: 0.5),
          builder: (context) => const UnsavedChangesDialog(),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.989)}');
    // print('Height12: ${util.responsiveHeight(0.0555)}');
    // print('FontSize: ${util.responsiveFontSize(0.0186)}');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // if (!didPop & Platform.isAndroid) {
        if (hasProfileChanged()) {
          Future.microtask(() async {
            bool shouldLeave = await showUnsavedChangesDialog(context);
            if (shouldLeave) Get.to(() => BottomNavigationScreen());
          });
        } else {
          Get.to(() => BottomNavigationScreen());
        }
        // }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            scrolledUnderElevation: 0.0,
            backgroundColor: whiteColor,
            title: Text(
              widget.title.tr,
              style: TextStyle(
                  fontFamily: AppFont.get(FontType.bold),
                  fontSize: util.fontSize20,
                  // height: util.lineHeight24 / util.fontSize20,
                  color: blackColor),
            ),
            leading: !widget.isProfileUpdated
                ? SizedBox.shrink()
                : IconButton(
                    onPressed: () async {
                      if (hasProfileChanged()) {
                        bool shouldLeave =
                            await showUnsavedChangesDialog(context);
                        if (shouldLeave) {
                          if (Platform.isAndroid) {
                            Get.to(() => BottomNavigationScreen());
                          } else {
                            Get.to(() => SettingsPage());
                          }
                        }
                      } else {
                        if (Platform.isAndroid) {
                          Get.to(() => BottomNavigationScreen());
                        } else {
                          Get.to(() => SettingsPage());
                        }
                      }
                    },
                    icon: SvgPicture.asset(
                      backButton,
                    ),
                  ),
            actions: [
              !widget.isProfileUpdated
                  ? SizedBox.shrink()
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          enableEdit = true;
                          showEmailVerify = !emailVerified;
                          showMobileVerify = !mobileVerified;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: util.width20),
                        padding: EdgeInsets.all(util.width10),
                        child: Text(
                          enableEdit == true ? '' : 'Edit'.tr,
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: util.fontSize18,
                              height: 1.0,
                              color: Platform.isAndroid
                                  ? mainColor
                                  : iosMainColor),
                        ),
                      ),
                    )
            ],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FirstName
                    CustomTextField(
                      title: 'First Name'.tr,
                      isMandatory: true,
                      controller: firstNameController,
                      keyboardType: TextInputType.text,
                      readOnly: !enableEdit,
                      enableEdit: enableEdit,
                      isExist: false,
                      isFirst: widget.isProfileUpdated,
                      textStyle: TextCapitalization.sentences,
                      showCursor: enableEdit,
                    ),
                    Visibility(
                      visible: firstNameError,
                      child: Text(
                        'Please Enter the First Name'.tr,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize11,
                            color: errorColor),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // SecondName
                    CustomTextField(
                      title: 'Last Name'.tr,
                      isMandatory: true,
                      controller: secondNameController,
                      keyboardType: TextInputType.text,
                      readOnly: !enableEdit,
                      enableEdit: enableEdit,
                      isExist: false,
                      isFirst: widget.isProfileUpdated,
                      textStyle: TextCapitalization.sentences,
                      showCursor: enableEdit,
                    ),
                    Visibility(
                      visible: secondNameError,
                      child: Text(
                        'Please Enter the Second Name'.tr,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize11,
                            color: errorColor),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Email
                    CustomTextField(
                      title: 'Email',
                      isMandatory: true,
                      controller: emailController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        EmailInputFormatter(),
                      ],
                      keyboardType: TextInputType.emailAddress,
                      readOnly: !showEmailVerify,
                      enableEdit: enableEdit,
                      isEmail: true,
                      isExist: showEmailVerify,
                      isFirst: widget.isProfileUpdated,
                      onVerifiedChange: updateEmailVerification,
                      textStyle: TextCapitalization.none,
                      showCursor: showEmailVerify,
                    ),
                    Visibility(
                      visible: emailError,
                      child: Text(
                        emailErrMessage.tr,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize11,
                            color: errorColor),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // Mobile Number
                    CustomTextField(
                      title: 'Phone Number',
                      isMandatory: false,
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      readOnly: isPhoneVerifiedDB,
                      // readOnly: !enableEdit,
                      enableEdit: enableEdit,
                      isMobileNumber: true,
                      isExist: isPhoneVerifiedDB,
                      isFirst: widget.isProfileUpdated,
                      onVerifiedChange: updateMobileVerification,
                      textStyle: TextCapitalization.none,
                      showCursor: !isPhoneVerifiedDB,
                      // showCursor: enableEdit,
                      mobileVerifiedDB: isPhoneVerifiedDB,
                      selectedCountryCode: selectedCountryCode,
                      onCountryCodeChanged: (String code) {
                        setState(() {
                          selectedCountryCode = code;
                        });
                      },
                      onPhoneNumberValidationChanged: (bool isValid) {
                        setState(() {
                          isPhoneNumberValid = isValid;
                        });
                      },
                      onEditRequested: () {
                        setState(() {
                          enableEdit = true;
                        });
                      },
                    ),
                    // Visibility(
                    //   visible: mobileError,
                    //   child: Text(
                    //     mobileErrMessage,
                    //     style: TextStyle(fontFamily: AppFont.get(FontType.medium), fontSize: util.fontSize11, color: errorColor),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),

                    // Chat Preferred Language
                    CustomDropDown(
                      title: 'AI Chat Language',
                      textController: chatLanguage,
                      isMandatory: true,
                      enableEdit: enableEdit,
                      errorFlag: chatLanguageError,
                      onLanguageChanged: (String language) {
                        setState(() {
                          chatLanguage.text = language;
                          chatLanguageError = false;
                        });
                      },
                      onTapRestricted: () {},
                    ),
                    Visibility(
                      visible: chatLanguageError,
                      child: Text(
                        'Please enter the AI Chat Language'.tr,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize11,
                            color: errorColor),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    //Date of Birth
                    CustomTextField(
                      title: 'Date of Birth'.tr,
                      showCursor: false,
                      isMandatory: true,
                      controller: dobController,
                      readOnly: true,
                      enableEdit: !widget.isProfileUpdated
                          ? enableEdit
                          : (enableEdit && premiumUser),
                      onTap: !widget.isProfileUpdated
                          ? datePicker
                          : (enableEdit
                              ? (premiumUser ? datePicker : subscribeDialog)
                              : null),
                      // onTap: enableEdit ? (premiumUser ? timePicker : subscribeDialog) : null,
                      // onTap: !widget.isProfileUpdated ? (enableEdit ? (premiumUser ? datePicker : subscribeDialog) : null) : null,
                      isExist: false,
                      isFirst: widget.isProfileUpdated,
                      textStyle: TextCapitalization.none,
                    ),
                    Visibility(
                      visible: dobError,
                      child: Text(
                        'Please enter the Date of birth'.tr,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize11,
                            color: errorColor),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // Time of Birth
                    CustomTextField(
                      title: 'Time of Birth'.tr,
                      showCursor: false,
                      isMandatory: true,
                      controller: timeController,
                      readOnly: true,
                      enableEdit: !widget.isProfileUpdated
                          ? enableEdit
                          : (enableEdit && premiumUser),
                      // onTap: enableEdit ? (premiumUser ? timePicker : subscribeDialog) : null,
                      onTap: !widget.isProfileUpdated
                          ? timePicker
                          : (enableEdit
                              ? (premiumUser ? timePicker : subscribeDialog)
                              : null),
                      isExist: false,
                      isFirst: widget.isProfileUpdated,
                      textStyle: TextCapitalization.none,
                    ),
                    Visibility(
                      visible: tobError,
                      child: Text(
                        'Please enter the Time of birth'.tr,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize11,
                            color: errorColor),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // Place of Birth
                    CustomDropDown(
                      title: 'Place of Birth'.tr,
                      textController: placeOfBirth,
                      // selectedValue: placeOfBirth,
                      // options: locations,
                      isMandatory: true,
                      enableEdit: !widget.isProfileUpdated
                          ? enableEdit
                          : (enableEdit && premiumUser),
                      errorFlag: pobError,
                      onLocationChanged: (LocationSelection location) {
                        setState(() {
                          placeOfBirth.text = location.selectedText;
                          birthPlaceFullLocation = location.displayText;
                        });
                        updateRashiNakshatra();
                      },
                      onTapRestricted: () {
                        if (!premiumUser) {
                          subscribeDialog();
                        }
                      },
                    ),
                    Visibility(
                      visible: pobError,
                      child: Text(
                        'Please enter the Place of birth'.tr,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize11,
                            color: errorColor),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // Preferred Location
                    CustomDropDown(
                      title: 'Current Location'.tr,
                      textController: preferredLocation,
                      // selectedValue: preferredLocation,
                      enableEdit: !widget.isProfileUpdated
                          ? enableEdit
                          : (enableEdit && premiumUser),
                      isMandatory: false,
                      errorFlag: prefLocError,
                      onTapRestricted: () {
                        if (!premiumUser) {
                          subscribeDialog();
                        }
                      },
                      onLocationChanged: (LocationSelection location) {
                        setState(() {
                          preferredLocation.text = location.selectedText;
                          preferredPlaceFullLocation = location.displayText;
                        });
                        updateRashiNakshatra();
                      },
                    ),
                    // Visibility(
                    //   visible: prefLocError,
                    //   child: Text(
                    //     'Please enter the Preferred Location',
                    //     style: TextStyle(fontFamily: AppFont.get(FontType.medium), fontSize: util.fontSize11, color: errorColor),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),

                    // Rasi
                    RasiNakshatraComponent(
                      title: 'Rasi'.tr,
                      controller: selectedRasi,
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // Nakshatram
                    RasiNakshatraComponent(
                      title: 'Nakshatram'.tr,
                      controller: selectedNakshatra,
                    ),

                    // Referred By
                    !widget.isProfileUpdated
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              CustomDropDown(
                                title: 'How did you first hear about Teksage?',
                                textController: howYouKnow,
                                isMandatory: true,
                                enableEdit: enableEdit,
                                errorFlag: howYouKnowError,
                                onReferredByChanged: (String value) {
                                  setState(() {
                                    howYouKnow.text = value;
                                    howYouKnowError = false;
                                  });
                                },
                                onTapRestricted: () {},
                              ),
                              Visibility(
                                visible: howYouKnowError,
                                child: Text(
                                  'Please select one value'.tr,
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize11,
                                      color: errorColor),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),

                    //Fill all the fields error
                    SizedBox(
                      height: util.responsiveHeight(0.0124),
                    ),
                    Visibility(
                      visible: requiredField,
                      child: Text(
                        '*${'Please fill all the required fields'.tr}',
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize11,
                            color: errorColor),
                      ),
                    ),
                    // Submit Button
                    SizedBox(
                      height: util.responsiveHeight(0.0124),
                    ),
                    enableEdit == true
                        ? GestureDetector(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              print('isPhoneNumberValid: $mobileVerified');
                              if (validateInputs()) {
                                if (emailVerified == false) {
                                  setState(() {
                                    emailError = true;
                                    emailErrMessage =
                                        'Please verify your Email';
                                  });
                                }
                                // if (mobileVerified == false) {
                                //   setState(() {
                                //     mobileError = true;
                                //     mobileErrMessage = 'Please verify your mobile number';
                                //   });
                                // }
                                // if (emailVerified == true && isPhoneNumberValid && mobileVerified == true)
                                if (emailVerified == true &&
                                    (mobileController.text.isEmpty ||
                                        isPhoneNumberValid)) {
                                  setState(() {
                                    emailError = false;
                                    mobileError = false;
                                    requiredField = false;
                                  });
                                  DateTime parsedDate = DateFormat("dd/MM/yyyy")
                                      .parse(dobController.text);
                                  String formattedDate =
                                      DateFormat("yyyy-MM-dd")
                                          .format(parsedDate);

                                  DateTime parsedTime = DateFormat("hh:mm a")
                                      .parse(timeController.text);
                                  String formattedTime =
                                      DateFormat("HH:mm").format(parsedTime);

                                  Map<String, dynamic> profileData;

                                  if (widget.userData != null) {
                                    profileData = {
                                      "chat_languages": chatLanguage.text,
                                      "date_of_birth": formattedDate,
                                      "time_of_birth": formattedTime,
                                      "birth_location": birthPlaceFullLocation,
                                    };

                                    if (mobileController.text
                                        .trim()
                                        .isNotEmpty) {
                                      profileData["mobile_number"] =
                                          mobileController.text.trim();
                                    }
                                    if (selectedCountryCode != null &&
                                        selectedCountryCode!
                                            .trim()
                                            .isNotEmpty) {
                                      profileData["country_code"] =
                                          selectedCountryCode;
                                    }
                                    if (preferredPlaceFullLocation
                                        .trim()
                                        .isNotEmpty) {
                                      profileData["preferred_location"] =
                                          preferredPlaceFullLocation;
                                    } else {
                                      profileData["preferred_location"] =
                                          "Chennai, Tamil Nadu, India";
                                    }
                                  } else {
                                    profileData = {
                                      "chat_languages": chatLanguage.text,
                                      "date_of_birth": formattedDate,
                                      "time_of_birth": formattedTime,
                                      "birth_location": birthPlaceFullLocation,
                                      "first_name": firstNameController.text,
                                      "last_name": secondNameController.text,
                                      "referral_source": howYouKnow.text,
                                    };
                                    if (mobileController.text
                                        .trim()
                                        .isNotEmpty) {
                                      profileData["mobile_number"] =
                                          mobileController.text.trim();
                                    }
                                    if (selectedCountryCode != null &&
                                        selectedCountryCode!
                                            .trim()
                                            .isNotEmpty) {
                                      profileData["country_code"] =
                                          selectedCountryCode;
                                    }
                                    if (preferredPlaceFullLocation
                                        .trim()
                                        .isNotEmpty) {
                                      profileData["preferred_location"] =
                                          preferredPlaceFullLocation;
                                    } else {
                                      profileData["preferred_location"] =
                                          "Chennai, Tamil Nadu, India";
                                    }
                                  }

                                  CustomLoader.show(context);
                                  Future.delayed(Duration(milliseconds: 200),
                                      () async {
                                    print('profileData in save:$profileData');
                                    var result = await ProfileService()
                                        .updateProfile(profileData);
                                    CustomLoader.hide();
                                    if (result['success']) {
                                      await saveUserName(
                                          firstNameController.text);
                                      await saveLastName(
                                          secondNameController.text);
                                      await saveChatLanguage(chatLanguage.text);
                                      final timeZone = await TimeZoneService()
                                          .updateTimezone(
                                              result['data']['timezone']);
                                      if (kDebugMode) {
                                        print(
                                            'TimeZoneInProfilePage: $timeZone');
                                      }
                                      await saveTimezone(
                                          result['data']['timezone']);
                                      await NotificationService
                                          .generateFcmToken();

                                      navigateAfterDelay(
                                          firstNameController.text,
                                          result['data']['data']);
                                    } else {
                                      showErrorSnackBar(
                                          context, result['error']);
                                      // Get.snackbar('Hi ${firstNameController.text}!', result['error'], snackPosition: SnackPosition.BOTTOM);
                                    }
                                  });
                                } else {
                                  if (!isPhoneNumberValid) {
                                    showErrorSnackBar(
                                        context,
                                        'Please Enter the valid Mobile Number'
                                            .tr);
                                  }
                                }
                              } else {
                                print('Came here');
                                setState(() {
                                  requiredField = true;
                                });
                              }
                            },
                            child: Container(
                              width: util.width,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Platform.isAndroid
                                    ? mainColor
                                    : iosMainColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                  child: Text(
                                'Save'.tr,
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: util.fontSize18,
                                    height:
                                        util.lineHeight21_6 / util.fontSize18,
                                    color: whiteColor),
                              )),
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      height: util.responsiveHeight(0.1232),
                    )
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
