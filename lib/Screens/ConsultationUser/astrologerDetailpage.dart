import 'package:astro_prompt/Model/AstrologerUserConsult/astrologer_detail_model.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userBookingPage.dart';
import 'package:astro_prompt/Services/Astrologer-user/userAstrologer.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart' show MyUtility;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class AstrologerDetailPage extends StatefulWidget {
  final int astrologerId;
  final List<String> selectedCategories;
  final List<String> selectedLanguages;
  final String currency;
  const AstrologerDetailPage(
      {super.key,
      required this.astrologerId,
      required this.selectedCategories,
      required this.selectedLanguages,
      required this.currency});

  @override
  State<AstrologerDetailPage> createState() => _AstrologerDetailPageState();
}

class _AstrologerDetailPageState extends State<AstrologerDetailPage> {
  AstrologerConsultationService astrologerDetailService =
      AstrologerConsultationService();
  AstrologerDetails? astrologer;
  List<Event> review = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAstrologerDetails();
  }

  Future<void> loadAstrologerDetails() async {
    // print('Cate: ${widget.selectedCategories}, ${widget.selectedLanguages}');
    try {
      final result = await astrologerDetailService
          .fetchAstrologerDetail(widget.astrologerId);

      setState(() {
        astrologer = result['astrologer'];
        review = result['events'];
        isLoading = false;
      });
    } catch (e) {
      print('Error loadAstrologerDetails: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('currency,${widget.currency}');
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.0268)}');
    // print('Height: ${util.responsiveHeight(0.1232)}');
    // print('FontSize: ${util.responsiveFontSize(0.0253)}');

    return Scaffold(
      backgroundColor: astroUserConsultBG,
      appBar: AppBar(
        backgroundColor: astroUserConsultBG,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Expert Profile".tr,
            style: TextStyle(
                color: whiteColor,
                fontSize: util.fontSize20,
                fontFamily: AppFont.get(FontType.bold),
                height: 1.0)),
        leading: IconButton(
          icon: SvgPicture.asset(
            appBackButton,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: Container(
                width: MyUtility(context).responsiveWidth(0.2668),
                height: MyUtility(context).responsiveHeight(0.1232),
                margin: EdgeInsets.only(bottom: 100),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: astroUserConsultBG,
                  size: MyUtility(context).height30,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: util.width20),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        // Card Container
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          padding: EdgeInsets.only(top: 70),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(util.width12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Name
                              Text(
                                '${astrologer!.user.firstName![0].toUpperCase() + astrologer!.user.firstName!.substring(1)} ${astrologer!.user.lastName![0].toUpperCase() + astrologer!.user.lastName!.substring(1)}',
                                style: TextStyle(
                                    fontFamily: 'FontSemiBold',
                                    fontSize: util.fontSize24,
                                    height: 1.0,
                                    color: blackColor),
                              ),
                              SizedBox(height: 10),
                              // Languages
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(languageIcon),
                                  SizedBox(width: 10),
                                  Text(
                                    astrologer!.languages
                                        .map((e) =>
                                            e[0].toUpperCase() + e.substring(1))
                                        .join(', '),
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.semiBold),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),

                              // Divider
                              SvgPicture.asset(astroDashedLine),
                              SizedBox(height: 12),

                              // Price
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: widget.currency == 'INR'
                                          ? '₹ '
                                          : '\$ ',
                                      style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.semiBold),
                                          fontSize: widget.currency == 'INR'
                                              ? util.fontSize32
                                              : util.fontSize29,
                                          height: 1.0,
                                          color: astroUserConsultText),
                                    ),
                                    TextSpan(
                                      text: widget.currency == 'INR'
                                          ? astrologer!.localConsultingFee
                                              .toStringAsFixed(2)
                                          : astrologer!.foreignConsultingFee
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontFamily: 'FontSemiBold',
                                          fontSize: util.fontSize32,
                                          height: 1.0,
                                          color: astroUserConsultText),
                                    ),
                                    TextSpan(
                                      text: ' / 30 min',
                                      style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.semiBold),
                                          fontSize: util.fontSize14,
                                          height: 1.0,
                                          color: blackColor.withValues(
                                              alpha: 0.3)),
                                    ),
                                  ],
                                ),
                              ),
                              //Divider
                              SizedBox(height: 12),
                              SvgPicture.asset(astroDashedLine),
                              // Experience
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(astroWork),
                                  SizedBox(width: 10),
                                  Text(
                                    '${'Years of Experience'.tr} - ${astrologer!.experience} ${'years'.tr}',
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.semiBold),
                                        fontSize: util.fontSize16,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.4)),
                                  ),
                                ],
                              ),
                              SizedBox(height: util.height20),
                            ],
                          ),
                        ),
                        // Profile Image
                        Positioned(
                          top: 0,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: astrologer?.picture != null
                                  ? Image.network(
                                      astrologer!.picture!,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: lightGrey,
                                      child: Center(
                                        child: Image.asset(
                                          dummyImage,
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: util.height10,
                    ),
                    Container(
                      // height: 50,
                      width: util.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                              astrologer!.expertises.length * 2 - 1, (index) {
                            if (index.isOdd) {
                              return Container(
                                height: 16,
                                width: 1,
                                color: blackColor.withValues(alpha: 0.3),
                              );
                            } else {
                              final item = astrologer!.expertises[index ~/ 2];
                              return Text(
                                item[0].toUpperCase() + item.substring(1),
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize14,
                                  height: 1.0,
                                  color: blackColor,
                                ),
                              );
                            }
                          }),
                        ),
                      ),
                    ),
                    //Rating
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        'Reviews'.tr,
                        style: TextStyle(
                            fontFamily: 'FontSemiBold',
                            fontSize: util.responsiveFontSize(0.0253),
                            height: 1.0,
                            color: whiteColor),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: util.width,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: review.isEmpty
                          ? Center(
                              child: Text(
                              'No reviews available'.tr,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize14,
                                  color: blackColor.withValues(alpha: 0.5),
                                  height: 1.0),
                            ))
                          : ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: review.length,
                              separatorBuilder: (_, __) => Container(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: SvgPicture.asset(astroRatingLine),
                              ),
                              itemBuilder: (context, index) {
                                final user = review[index];
                                final double safeRating =
                                    (user.rating ?? 0).toDouble();

                                return Row(
                                  children: [
                                    // Profile Avatar
                                    Container(
                                      width: 43,
                                      height: 43,
                                      margin: EdgeInsets.only(right: 12),
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xff7DA111),
                                            width: 1.4),
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircleAvatar(
                                        radius: 24,
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.person,
                                            color: Colors.white),
                                      ),
                                    ),

                                    // Name and Stars
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${user.firstName} ${user.lastName}',
                                            style: TextStyle(
                                                fontFamily: 'FontSemiBold',
                                                fontSize: util.fontSize16,
                                                height: 1.0,
                                                color: blackColor),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children:
                                                List.generate(5, (starIndex) {
                                              final rating = user.rating;
                                              return Padding(
                                                padding:
                                                    EdgeInsets.only(right: 3),
                                                child: SvgPicture.asset(
                                                  starIndex < safeRating
                                                      ? ratingSelect
                                                      : ratingUnSelect,
                                                ),
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Rating Text + Star
                                    Row(
                                      children: [
                                        Text(
                                          safeRating.toStringAsFixed(1),
                                          style: TextStyle(
                                              fontFamily: 'FontSemiBold',
                                              fontSize: util.fontSize16,
                                              height: 1.0,
                                              color: blackColor),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        SvgPicture.asset(ratingSelect)
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                    SizedBox(
                      height: util.height20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => BookingPage(
                              astrologerId: astrologer!.userId,
                              astrologerFirstName: astrologer!.user.firstName!,
                              astrologerSecondName: astrologer!.user.lastName!,
                              selectedCategories: widget.selectedCategories,
                              selectedLanguages: widget.selectedLanguages,
                              consultingFee: widget.currency == 'INR'
                                  ? astrologer!.localConsultingFee
                                  : astrologer!.foreignConsultingFee,
                              profileImage: astrologer?.picture != null
                                  ? astrologer!.picture!
                                  : dummyImage,
                              currency: widget.currency,
                            ));
                      },
                      child: Container(
                        width: util.width,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: whiteColor),
                        child: Text(
                          'Book Consultation'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'FontSemiBold',
                              fontSize: util.fontSize18,
                              height: 1.0,
                              color: astroUserConsultBG),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: util.height50,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
