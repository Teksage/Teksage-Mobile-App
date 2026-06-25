import 'package:astro_prompt/Components/Consultation-User/FilterChips.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/all_astrologer_model.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/top_5_astrologer_model.dart';
import 'package:astro_prompt/Screens/ConsultationUser/astrologerDetailpage.dart';
import 'package:astro_prompt/Services/Astrologer-user/userAstrologer.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class UserAstrologerHomePage extends StatefulWidget {
  final List<String> selectedCategories;
  final List<String> selectedLanguages;
  final String currency;
  const UserAstrologerHomePage(
      {super.key,
      required this.selectedCategories,
      required this.selectedLanguages,
      required this.currency});

  @override
  State<UserAstrologerHomePage> createState() => _UserAstrologerHomePageState();
}

class _UserAstrologerHomePageState extends State<UserAstrologerHomePage> {
  List<Top5AstrologerConsultUserData> top5Astrologers = [];
  List<AllAstrologerConsultUserData> allAstrologers = [];
  bool isLoading = true;
  AstrologerConsultationService userConsultService =
      AstrologerConsultationService();
  List<String> selectedCategory = [];
  List<String> selectedLanguage = [];
  List<int> astrologerIds = [];

  late ScrollController scrollController;
  int currentDotIndex = 0;

  final int visibleCards = 5;
  final int totalDots = 3;

  @override
  void initState() {
    super.initState();
    selectedCategory = List.from(widget.selectedCategories);
    selectedLanguage = List.from(widget.selectedLanguages);
    fetchAstrologersConsult();

    scrollController = ScrollController()
      ..addListener(() {
        final maxScroll = scrollController.position.maxScrollExtent;
        final scrollPosition = scrollController.offset;

        if (maxScroll > 0) {
          final scrollPercent = scrollPosition / maxScroll;
          final newIndex =
              (scrollPercent * totalDots).clamp(0, totalDots - 1).round();

          if (newIndex != currentDotIndex) {
            setState(() {
              currentDotIndex = newIndex;
            });
          }
        }
      });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchAstrologersConsult() async {
    setState(() => isLoading = true);

    top5Astrologers = (await userConsultService.fetchTop5AstroConsult(
      categories: selectedCategory,
      languages: selectedLanguage,
    ))!;
    print('top5Astrologers body,top5Astrologers');
    astrologerIds = top5Astrologers.map((astro) => astro.userId).toList();

    allAstrologers =
        await userConsultService.fetchAllAstroConsult(astrologerIds);
    setState(() => isLoading = false);
  }

  void removeCategory(String category) {
    if (selectedCategory.length <= 1) {
      showInfoSnackBarDual(context, 'At least one category must be selected.');
      return;
    }

    selectedCategory.remove(category);
    fetchAstrologersConsult();
  }

  void removeLanguage(String language) {
    if (selectedLanguage.length <= 1) {
      showInfoSnackBarDual(context, 'At least one language must be selected.');
      return;
    }
    selectedLanguage.remove(language);
    fetchAstrologersConsult();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.0268)}');
    // print('Height: ${util.responsiveHeight(0.1232)}');
    // print('FontSize: ${util.responsiveFontSize(0.0153)}');

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: astroUserConsultBG,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(PlatformTextConfig.astrologerUserHomeTitle.tr,
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              astroUserConsultBG,
              whiteColor,
            ],
            stops: [0.3, 0.3],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: astroUserConsultBG,
                // height: allAstrologers.isNotEmpty ? util.height * 0.6 : null,
                width: util.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: whiteColor.withValues(alpha: 0.2)))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: util.width20, top: util.width20),
                      child: Text(
                        PlatformTextConfig.astrologerListingTop5.tr,
                        style: TextStyle(
                            fontSize: util.fontSize24,
                            fontFamily: AppFont.get(FontType.semiBold),
                            height: 1.2,
                            color: whiteColor),
                      ),
                    ),
                    SizedBox(height: 15),
                    FilterChipsWidget(
                      selectedCategory: selectedCategory,
                      selectedLanguage: selectedLanguage,
                      onRemoveCategory: removeCategory,
                      onRemoveLanguage: removeLanguage,
                    ),
                    allAstrologers.isNotEmpty
                        ? SizedBox(height: util.height20)
                        : SizedBox.shrink(),
                    allAstrologers.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: SizedBox(
                              height: 230,
                              child: ListView.builder(
                                shrinkWrap: true,
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: top5Astrologers.length.clamp(0, 5),
                                itemBuilder: (context, index) {
                                  final astro = top5Astrologers[index];
                                  final image = astro.picture;
                                  final astrologerName = astro.user.firstName;
                                  final language = astro.languages.join(', ');
                                  final fee, currencyUnit;
                                  if (widget.currency == 'INR') {
                                    fee = astro.localConsultingFee
                                            .toStringAsFixed(0) ??
                                        '0';
                                    currencyUnit = '₹';
                                  } else {
                                    fee = astro.foreignConsultingFee
                                            .toStringAsFixed(0) ??
                                        '0';
                                    currencyUnit = '\$';
                                  }
                                  final percentage =
                                      '${astro.matchPercentage}% Match';
                                  final convertPercentage =
                                      astro.matchPercentage / 100;

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Container(
                                      width: 158,
                                      decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                              width: 1,
                                              color: blackColor.withValues(
                                                  alpha: 0.12))),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              LinearPercentIndicator(
                                                width: 50,
                                                animation: true,
                                                lineHeight: 5,
                                                animationDuration: 1000,
                                                percent: convertPercentage,
                                                barRadius: Radius.circular(15),
                                                backgroundColor:
                                                    percentageProgress,
                                                progressColor: mainColor,
                                              ),
                                              Text(
                                                percentage,
                                                style: TextStyle(
                                                  fontFamily: AppFont.get(
                                                      FontType.semiBold),
                                                  fontSize: util.fontSize12,
                                                  height: 1.0,
                                                  color: mainColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // SizedBox(height: 9),
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: astroUserConsultBG,
                                              shape: BoxShape.circle,
                                            ),
                                            child: ClipOval(
                                              child: image != null
                                                  ? Image.network(
                                                      image,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container(
                                                      color: lightGrey,
                                                      child: Center(
                                                        child: Image.asset(
                                                          dummyImage,
                                                          width: 40,
                                                          height: 40,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          // SizedBox(height: 8),
                                          Column(
                                            children: [
                                              Text(
                                                astrologerName![0]
                                                        .toUpperCase() +
                                                    astrologerName.substring(1),
                                                style: TextStyle(
                                                  fontFamily: AppFont.get(
                                                      FontType.semiBold),
                                                  fontSize: util.fontSize16,
                                                  height: 1.0,
                                                  color: blackColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                language
                                                    .split(' ')
                                                    .map((e) =>
                                                        e[0].toUpperCase() +
                                                        e.substring(1))
                                                    .join(' '),
                                                style: TextStyle(
                                                  fontFamily: AppFont.get(
                                                      FontType.semiBold),
                                                  fontSize: util.fontSize12,
                                                  height: 1.3,
                                                  color: blackColor.withValues(
                                                      alpha: 0.5),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                currencyUnit,
                                                style: TextStyle(
                                                    fontFamily: AppFont.get(
                                                        FontType.semiBold),
                                                    fontSize:
                                                        widget.currency == 'INR'
                                                            ? util.fontSize20
                                                            : util.fontSize18,
                                                    height: 1.0,
                                                    color:
                                                        astroUserConsultText),
                                              ),
                                              Text(
                                                '$fee',
                                                style: TextStyle(
                                                    fontFamily: AppFont.get(
                                                        FontType.semiBold),
                                                    fontSize: util.fontSize20,
                                                    height: 1.0,
                                                    color:
                                                        astroUserConsultText),
                                              ),
                                              Text(
                                                ' /30 min',
                                                style: TextStyle(
                                                    fontFamily: AppFont.get(
                                                        FontType.semiBold),
                                                    fontSize: util.fontSize14,
                                                    height: 1.0,
                                                    color:
                                                        blackColor.withValues(
                                                            alpha: 0.3)),
                                              ),
                                            ],
                                          ),
                                          // SizedBox(height: 9),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() => AstrologerDetailPage(
                                                    astrologerId: astro.userId,
                                                    selectedCategories:
                                                        selectedCategory,
                                                    selectedLanguages:
                                                        selectedLanguage,
                                                    currency: widget.currency,
                                                  ));
                                            },
                                            child: Container(
                                              width: util.width,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 6),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          util.width20),
                                                  color: mainColor),
                                              child: Text(
                                                'Book Now'.tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: AppFont.get(
                                                        FontType.semiBold),
                                                    fontSize: util.fontSize14,
                                                    height: 1.0,
                                                    color: whiteColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 25),
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: top5Astrologers.length.clamp(0, 5),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 20,
                                childAspectRatio: 0.8,
                              ),
                              itemBuilder: (context, index) {
                                final astrologer = top5Astrologers[index];
                                final fee, currencyUnit;
                                if (widget.currency == 'INR') {
                                  fee = astrologer.localConsultingFee
                                          .toStringAsFixed(0) ??
                                      '0';
                                  currencyUnit = '₹';
                                } else {
                                  fee = astrologer.foreignConsultingFee
                                          .toStringAsFixed(0) ??
                                      '0';
                                  currencyUnit = '\$';
                                }
                                final language =
                                    astrologer.languages.join(', ');
                                return Container(
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          width: 1,
                                          color: blackColor.withValues(
                                              alpha: 0.12))),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: astroUserConsultBG,
                                          shape: BoxShape.circle,
                                        ),
                                        child: ClipOval(
                                          child:
                                              astrologer.picture?.isNotEmpty ==
                                                      true
                                                  ? Image.network(
                                                      astrologer.picture!,
                                                      fit: BoxFit.cover,
                                                      width: 60,
                                                      height: 60,
                                                    )
                                                  : Container(
                                                      color: lightGrey,
                                                      child: Center(
                                                        child: Image.asset(
                                                          dummyImage,
                                                          width: 40,
                                                          height: 40,
                                                        ),
                                                      ),
                                                    ),
                                        ),
                                      ),
                                      // SizedBox(height: 8),
                                      Text(
                                        astrologer.user.firstName!,
                                        style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.semiBold),
                                          fontSize: util.fontSize16,
                                          height: 1.0,
                                          color: blackColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      // SizedBox(height: 7),
                                      Column(
                                        children: [
                                          Text(
                                            language
                                                .split(' ')
                                                .where((e) => e.isNotEmpty)
                                                .map((e) =>
                                                    e[0].toUpperCase() +
                                                    e.substring(1))
                                                .join(' '),
                                            style: TextStyle(
                                              fontFamily: AppFont.get(
                                                  FontType.semiBold),
                                              fontSize: util.fontSize12,
                                              height: 1.0,
                                              color: blackColor.withValues(
                                                  alpha: 0.5),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            currencyUnit,
                                            style: TextStyle(
                                                fontFamily: AppFont.get(
                                                    FontType.semiBold),
                                                fontSize:
                                                    widget.currency == 'INR'
                                                        ? util.fontSize20
                                                        : util.fontSize18,
                                                height: 1.0,
                                                color: astroUserConsultText),
                                          ),
                                          Text(
                                            '$fee',
                                            style: TextStyle(
                                                fontFamily: AppFont.get(
                                                    FontType.semiBold),
                                                fontSize: util.fontSize20,
                                                height: 1.0,
                                                color: astroUserConsultText),
                                          ),
                                          Text(
                                            ' /30 min',
                                            style: TextStyle(
                                                fontFamily: AppFont.get(
                                                    FontType.semiBold),
                                                fontSize: util.fontSize14,
                                                height: 1.0,
                                                color: blackColor.withValues(
                                                    alpha: 0.3)),
                                          ),
                                        ],
                                      ),
                                      // SizedBox(height: 9),
                                      GestureDetector(
                                        onTap: () {
                                          print('UserId: ${astrologer.userId}');
                                          Get.to(() => AstrologerDetailPage(
                                                astrologerId: astrologer.userId,
                                                selectedCategories:
                                                    selectedCategory,
                                                selectedLanguages:
                                                    selectedLanguage,
                                                currency: widget.currency,
                                              ));
                                        },
                                        child: Container(
                                          width: util.width,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 6),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      util.width20),
                                              color: mainColor),
                                          child: Text(
                                            'Book Now'.tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: AppFont.get(
                                                    FontType.semiBold),
                                                fontSize: util.fontSize14,
                                                height: 1.0,
                                                color: whiteColor),
                                          ),
                                        ),
                                      ),
                                      // SizedBox(height: 10),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                    const SizedBox(height: 25),
                    allAstrologers.isNotEmpty
                        ? Column(
                          children: [
                            Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(totalDots, (index) {
                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      margin:
                                          const EdgeInsets.symmetric(horizontal: 4),
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: currentDotIndex == index
                                            ? whiteColor
                                            : whiteColor.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            const SizedBox(height: 10),
                          ],
                        )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              allAstrologers.isNotEmpty
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      child: Column(
                        children: [
                          Text(
                            PlatformTextConfig.astrologerListing.tr,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold),
                                fontSize: util.fontSize16,
                                height: 1.0,
                                color: blackColor.withValues(alpha: 0.6)),
                          ),
                          SizedBox(
                            height: util.height20,
                          ),
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: allAstrologers.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 20,
                              childAspectRatio: 0.8,
                            ),
                            itemBuilder: (context, index) {
                              final astrologer = allAstrologers[index];
                              final fee, currencyUnit;
                              if (widget.currency == 'INR') {
                                fee = astrologer.localConsultingFee
                                        .toStringAsFixed(0) ??
                                    '0';
                                currencyUnit = '₹';
                              } else {
                                fee = astrologer.foreignConsultingFee
                                        .toStringAsFixed(0) ??
                                    '0';
                                currencyUnit = '\$';
                              }
                              final language = astrologer.languages.join(', ');
                              return Container(
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        width: 1,
                                        color: blackColor.withValues(
                                            alpha: 0.12))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: astroUserConsultBG,
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipOval(
                                        child: astrologer.picture?.isNotEmpty ==
                                                true
                                            ? Image.network(
                                                astrologer.picture!,
                                                fit: BoxFit.cover,
                                                width: 60,
                                                height: 60,
                                              )
                                            : Container(
                                                color: lightGrey,
                                                child: Center(
                                                  child: Image.asset(
                                                    dummyImage,
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      astrologer.user.firstName!,
                                      style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.semiBold),
                                        fontSize: util.fontSize16,
                                        height: 1.0,
                                        color: blackColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      language
                                          .split(' ')
                                          .where((e) => e.isNotEmpty)
                                          .map((e) =>
                                              e[0].toUpperCase() +
                                              e.substring(1))
                                          .join(' '),
                                      style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.semiBold),
                                        fontSize: util.fontSize12,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          currencyUnit,
                                          style: TextStyle(
                                              fontFamily: AppFont.get(
                                                  FontType.semiBold),
                                              fontSize: widget.currency == 'INR'
                                                  ? util.fontSize20
                                                  : util.fontSize18,
                                              height: 1.0,
                                              color: astroUserConsultText),
                                        ),
                                        Text(
                                          '$fee',
                                          style: TextStyle(
                                              fontFamily: AppFont.get(
                                                  FontType.semiBold),
                                              fontSize: util.fontSize20,
                                              height: 1.0,
                                              color: astroUserConsultText),
                                        ),
                                        Text(
                                          ' /30 min',
                                          style: TextStyle(
                                              fontFamily: AppFont.get(
                                                  FontType.semiBold),
                                              fontSize: util.fontSize14,
                                              height: 1.0,
                                              color: blackColor.withValues(
                                                  alpha: 0.3)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => AstrologerDetailPage(
                                              astrologerId: astrologer.userId,
                                              selectedCategories:
                                                  selectedCategory,
                                              selectedLanguages:
                                                  selectedLanguage,
                                              currency: widget.currency,
                                            ));
                                      },
                                      child: Container(
                                        width: util.width,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 6),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                util.width20),
                                            color: mainColor),
                                        child: Text(
                                          'Book Now'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: AppFont.get(
                                                  FontType.semiBold),
                                              fontSize: util.fontSize14,
                                              height: 1.0,
                                              color: whiteColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
