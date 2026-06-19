import 'package:astro_prompt/Components/Common/dashedContianer.dart';
import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Components/Consultation-User/timeConversion.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userBookingSummary.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userCategory.dart';
import 'package:astro_prompt/Services/Astrologer-user/paymentService.dart';
import 'package:astro_prompt/Services/Astrologer-user/userAstrologer.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class UserBookingDetailsPage extends StatefulWidget {
  final List<String> selectedCategories;
  final List<String> selectedLanguages;
  final String astrologerFirstName;
  final String astrologerLastName;
  final String bookingDate;
  final String bookingTime;
  final double consultingFee;
  final String profileImage;
  final int astrologerId;
  final String currency;
  const UserBookingDetailsPage(
      {super.key,
      required this.selectedCategories,
      required this.selectedLanguages,
      required this.bookingDate,
      required this.bookingTime,
      required this.consultingFee,
      required this.profileImage,
      required this.astrologerId,
      required this.astrologerFirstName,
      required this.astrologerLastName,
      required this.currency});

  @override
  State<UserBookingDetailsPage> createState() => _UserBookingDetailsPageState();
}

class _UserBookingDetailsPageState extends State<UserBookingDetailsPage> {
  bool canShareHoroscope = false;
  bool showShareError = false;
  ProfileService profileService = ProfileService();
  AstrologerConsultationService consultationService =
      AstrologerConsultationService();
  PaymentService paymentService = PaymentService();
  late Razorpay _razorpay;

  String mobileNumber = '';
  String email = '';
  String dob = '';
  String tob = '';
  String pob = '';
  String rasi = '';
  String nakshatram = '';
  double cgst = 0.0;
  double sgst = 0.0;
  double totalAmount = 0.0;
  String couponId = '';
  late double originalConsultingFee;
  late double originalCgst;
  late double originalSgst;
  late double originalTotalAmount;
  double fee = 0.0;
  bool isLoading = false;

  String convertDateFormat(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    String formattedDate = DateFormat('dd MMMM yyyy').format(date);
    return formattedDate;
  }

  String convertTimeFormat(String timeStr) {
    DateTime time = DateFormat("HH:mm:ss").parse(timeStr);
    String formattedTime = DateFormat("hh:mm:ss a").format(time);
    return formattedTime;
  }

  @override
  void initState() {
    super.initState();
    fetchProfileData();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void fetchProfileData() async {
    UserProfile? profileData = await profileService.fetchUserProfile();
    if (profileData != null) {
      fee = widget.consultingFee;
      cgst = fee * 0.09;
      sgst = fee * 0.09;
      totalAmount = widget.consultingFee + cgst + sgst;

      // Save original values
      originalConsultingFee = fee;
      originalCgst = cgst;
      originalSgst = sgst;
      originalTotalAmount = totalAmount;

      setState(() {
        mobileNumber = profileData.mobileNumber;
        email = profileData.email;
        dob = convertDateFormat(profileData.dateOfBirth);
        tob = convertTimeFormat(profileData.timeOfBirth);
        pob = profileData.birthLocation;
        rasi = profileData.rashi;
        nakshatram = profileData.nakshatra;
      });
    } else {
      print("Profile data is null. Unable to update UI.");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    CustomLoader.show(context, loaderColor: astroUserConsultBG);
   
    final result = await paymentService.consultationVerifyPayment(
      orderId: response.orderId!,
      paymentId: response.paymentId!,
      signature: response.signature!,
    );
    CustomLoader.hide();
    if (result != null && result.status == 'success') {
      showSuccessSnackBar(context, 'Payment successful!');
      Get.to(() => UserConsultationSummary(
            bookingSummary: result,
            profilePicture: widget.profileImage,
            firstName: widget.astrologerFirstName,
            lastName: widget.astrologerLastName,
            currency: widget.currency,
          ));
    } else {
      showErrorSnackBar(
          context, 'Payment verification failed. Please try again.');
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (_) => UserCategoryPage()),
      //   (route) => false,
      // );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showErrorSnackBar(context, 'Payment failed. Please try again.');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (_) => UserCategoryPage(
                toHome: true,
              )),
      (route) => false,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet selected: ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final profileImage = widget.profileImage;
    final isAssetImage = profileImage.startsWith('assets/');
    bool isINR = widget.currency == 'INR';

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(appBackButton,
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Booking Details'.tr,
            style: TextStyle(
                color: blackColor,
                fontSize: util.fontSize20,
                fontFamily: AppFont.get(FontType.bold),
                height: 1.0)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: util.width,
                padding: EdgeInsets.symmetric(horizontal: util.width20),
                child: Column(
                  children: [
                    Container(
                      width: util.width,
                      padding: EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xfff3f3f3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: !isAssetImage
                                  ? Image.network(
                                      profileImage,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: lightGrey,
                                      child: Center(
                                        child: Image.asset(
                                          profileImage,
                                          width: 32,
                                          height: 32,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                              '${widget.astrologerFirstName} ${widget.astrologerLastName}',
                              style: TextStyle(
                                  color: blackColor,
                                  fontSize: util.fontSize16,
                                  fontFamily: 'FontSemiBold',
                                  height: 1.0)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: util.width,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xfff3f3f3),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 2.5,
                                  child: Text(
                                    'Date'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                                Text(':  '),
                                Expanded(
                                    child: Text(
                                  widget.bookingDate,
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 2.5,
                                  child: Text(
                                    'Time'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                                Text(':  '),
                                Expanded(
                                    child: Text(
                                  widget.bookingTime,
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 2.5,
                                  child: Text(
                                    'Consulting On'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                                Text(':  '),
                                Expanded(
                                    child: Text(
                                  widget.selectedCategories.map(
                                    (e) {
                                      final translated = e;
                                      return translated.isNotEmpty
                                          ? (translated[0].toUpperCase() +
                                                  translated.substring(1))
                                              .tr
                                          : translated.tr;
                                    },
                                  ).join(', '),
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 2.5,
                                  child: Text(
                                    'Language'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                                Text(':  '),
                                Expanded(
                                  child: Text(
                                    widget.selectedLanguages.map(
                                      (e) {
                                        final translated = e;
                                        return translated.isNotEmpty
                                            ? (translated[0].toUpperCase() +
                                                    translated.substring(1))
                                                .tr
                                            : translated.tr;
                                      },
                                    ).join(', '),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DashedLine(
                            color: blackColor.withValues(alpha: 0.2),
                            dashWidth: 3,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6, top: 12),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 2.5,
                                  child: Text(
                                    'Date of Birth'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                                Text(':  '),
                                Expanded(
                                    child: Text(
                                  dob,
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 2.5,
                                  child: Text(
                                    'Time of Birth'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                                Text(':  '),
                                Expanded(
                                    child: Text(
                                  tob,
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 2.5,
                                  child: Text(
                                    'Place of Birth'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                                Text(':  '),
                                Expanded(
                                    child: Text(
                                  pob,
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 2.5,
                                  child: Text(
                                    'Rasi'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                                Text(':  '),
                                Expanded(
                                    child: Text(
                                  rasi,
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 2.5,
                                  child: Text(
                                    'Nakshatram'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                                Text(':  '),
                                Expanded(
                                  child: Text(
                                    nakshatram,
                                    style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    ///Promo code Section
                    SizedBox(
                      height: 12,
                    ),
                    PromoCodeContainer(
                      // planId: null,
                      currency: widget.currency,
                      applyBorderColor: astroUserConsultBG,
                      applyFontColor: astroUserConsultBG,
                      backgroundColor: Color(0xfff3f3f3),
                      fontColor: blackColor.withValues(alpha: 0.5),
                      containerBorderColor: blackColor,
                      couponType: 'consultation',
                      amount: widget.consultingFee,
                      onCouponApplied: (amount) {
                        setState(() {
                          if (amount == null) {
                            fee = originalConsultingFee;
                            cgst = originalCgst;
                            sgst = originalSgst;
                            totalAmount = originalTotalAmount;
                          } else {
                            couponId = amount.couponId.toString();
                            fee = amount.discountedPrice;
                            cgst = amount.cgstAmount;
                            sgst = amount.sgstAmount;
                            totalAmount = amount.finalPrice;
                          }
                        });
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    DashedLine(
                      color: blackColor.withValues(alpha: 0.2),
                      dashWidth: 3,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Consultation Fee'.tr,
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: MyUtility(context).fontSize14,
                              color: blackColor.withValues(alpha: 0.8),
                              height: 1.0),
                        ),
                        Text(
                          '${widget.currency == 'INR' ? '₹' : '\$'} ${fee.toStringAsFixed(2)}/-',
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: MyUtility(context).fontSize14,
                              color: blackColor.withValues(alpha: 0.8),
                              height: 1.0),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CGST',
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: MyUtility(context).fontSize14,
                              color: blackColor.withValues(alpha: 0.8),
                              height: 1.0),
                        ),
                        Text(
                          '${widget.currency == 'INR' ? '₹' : '\$'} ${cgst.toStringAsFixed(2)}/-',
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: MyUtility(context).fontSize14,
                              color: blackColor.withValues(alpha: 0.8),
                              height: 1.0),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SGST',
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: MyUtility(context).fontSize14,
                              color: blackColor.withValues(alpha: 0.8),
                              height: 1.0),
                        ),
                        Text(
                          '${widget.currency == 'INR' ? '₹' : '\$'} ${sgst.toStringAsFixed(2)}/-',
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: MyUtility(context).fontSize14,
                              color: blackColor.withValues(alpha: 0.8),
                              height: 1.0),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    DashedLine(
                      color: blackColor.withValues(alpha: 0.2),
                      dashWidth: 3,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Fee'.tr,
                          style: TextStyle(
                              fontFamily: 'FontSemiBold',
                              fontSize: MyUtility(context).fontSize16,
                              color: blackColor,
                              height: 1.0),
                        ),
                        Text(
                          '${widget.currency == 'INR' ? '₹' : '\$'} ${totalAmount.toStringAsFixed(2)}/-',
                          style: TextStyle(
                              fontFamily: 'FontSemiBold',
                              fontSize: MyUtility(context).fontSize20,
                              color: blackColor,
                              height: 1.0),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    DashedLine(
                      color: blackColor.withValues(alpha: 0.2),
                      dashWidth: 3,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: canShareHoroscope,
                          onChanged: (value) {
                            setState(() {
                              canShareHoroscope = value!;
                              showShareError = false;
                            });
                          },
                          activeColor: Color(0xFFA2C14D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            PlatformTextConfig.astrologerUserShareHoroscope.tr,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.medium),
                                fontSize: util.fontSize14,
                                height: 1.3,
                                color: blackColor.withValues(alpha: 0.7)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: showShareError ? 20 : 5),
                    showShareError
                        ? Text(
                            PlatformTextConfig
                                .astrologerUserShareHoroscopeError.tr,
                            style: TextStyle(
                                fontSize: util.fontSize12,
                                fontFamily: AppFont.get(FontType.medium),
                                color: errorColor,
                                height: 1.0),
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      height: util.height20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (canShareHoroscope) {
                TimeRange result = convertDateAndTimeRangeToISO(
                    widget.bookingDate, widget.bookingTime);
                CustomLoader.show(context, loaderColor: astroUserConsultBG);
                var response = await consultationService.astroConsultBooking(
                  startTime: result.startTime,
                  endTime: result.endTime,
                  shareHoroscope: canShareHoroscope,
                  languages: widget.selectedLanguages,
                  category: widget.selectedCategories,
                  astrologerId: widget.astrologerId,
                  amount: fee.toInt(),
                  currency: widget.currency == 'INR' ? 'INR' : 'USD',
                  couponId: couponId,
                );
                CustomLoader.hide();
                print(
                    'Response: ${response?.key}, ${response?.amount}, ${response?.id}');

                ///Payment Process
                if (response != null) {
                  try {
                    var options = {
                      'key': response.key,
                      'amount': response.amount,
                      'currency': response.currency,
                      'name': 'Teksage',
                      'description': 'Consultation Payment',
                      'order_id': response.id,
                      'prefill': {'contact': mobileNumber, 'email': email},
                    };
                    _razorpay.open(options);
                  } catch (e) {
                    showErrorSnackBar(context, 'Please Contact Support team!');
                    setState(() => isLoading = false);
                  }
                } else {
                  print('Booking failed, response is null');
                }
              } else {
                setState(() {
                  showShareError = true;
                });
              }
            },
            child: Container(
              width: util.width,
              margin: EdgeInsets.symmetric(horizontal: util.width20),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: astroUserConsultBG),
              child: Text(
                'Confirm & Proceed to Pay'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'FontSemiBold',
                    fontSize: util.fontSize18,
                    height: 1.0,
                    color: whiteColor),
              ),
            ),
          ),
          SizedBox(
            height: util.height30,
          )
        ],
      ),
    );
  }
}
