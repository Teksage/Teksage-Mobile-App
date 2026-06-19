import 'package:astro_prompt/Model/life_prediction_model.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class CustomCardSwiper extends StatefulWidget {
  final List<LifePredictions> predictions;
  final Function(int) onIndexChanged;

  const CustomCardSwiper(
      {super.key, required this.predictions, required this.onIndexChanged});

  @override
  State<CustomCardSwiper> createState() => _CustomCardSwiperState();
}

class _CustomCardSwiperState extends State<CustomCardSwiper>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  double dragOffset = 0.0;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  double? maxCardHeight;
  final List<GlobalKey> cardKeys = [];
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(animationController);

    cardKeys.addAll(
        List.generate(widget.predictions.length, (index) => GlobalKey()));

    WidgetsBinding.instance.addPostFrameCallback((_) => _measureCardHeights());
  }

  /// Measures the tallest card and sets `maxCardHeight`
  void _measureCardHeights() {
    double maxHeight = 0;
    print("Measuring card heights...");

    for (var key in cardKeys) {
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        double height = renderBox.size.height;
        // print("Card height: $height");
        maxHeight = maxHeight > height ? maxHeight : height;
      }
    }

    // print("Max height calculated: $maxHeight");
    if (maxHeight > 0 && maxHeight != maxCardHeight) {
      // print("Updating maxCardHeight from $maxCardHeight to $maxHeight");
      setState(() {
        maxCardHeight = maxHeight;
      });
    }
    // else {
    //   print("No change in maxCardHeight");
    // }
  }

  void _onSwipe(bool isLeft) {
    int nextIndex = isLeft ? currentIndex + 1 : currentIndex - 1;
    if (nextIndex >= widget.predictions.length) {
      nextIndex = 0;
    } else if (nextIndex < 0) {
      nextIndex = widget.predictions.length - 1;
    }
    scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));
    animationController.forward().then((_) {
      setState(() {
        currentIndex = nextIndex;
        widget.onIndexChanged(currentIndex);
        dragOffset = 0.0;
        animationController.reset();
      });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  String formatText(String text) {
    // print('Text: $text');
    return text.replaceAll('. ', '.\n\n');
  }

  String getTitle(String title) {
    final Map<String, String> titleText = {
      'General': 'General\nCharacteristics',
      'Career': 'Career\nPredictions',
      'Relationship': 'Relationship\nPredictions',
      'Wealth': 'Wealth\nPredictions',
      'Health': 'Health\nPredictions',
      'Current Time Period': 'Current\nTime Period',
    };
    return titleText[title]!;
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
// print('Width: ${util.responsiveWidth(0.7227)}');
//     print('Height: ${util.responsiveHeight(0.0198)}');
    // print('FontSize: ${util.responsiveFontSize(0.0153)}');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: util.width20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // NEXT CARD (Static behind effect)
              if (widget.predictions.length > 1)
                Positioned(
                  top: -12,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    // width: cardWidth - 20,
                    width: util.width - 60,
                    decoration: BoxDecoration(
                      color: whiteColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Allow dynamic height
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(widget
                                    .predictions[(currentIndex + 1) %
                                        widget.predictions.length]
                                    .icon),
                                SizedBox(width: util.width20),
                                Text(
                                  getTitle(widget
                                      .predictions[(currentIndex + 1) %
                                          widget.predictions.length]
                                      .title).tr,
                                  style: TextStyle(
                                      fontSize: util.fontSize22,
                                      fontFamily: AppFont.get(FontType.bold),
                                      height: 1.0,
                                      color: lifeTitleText),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: lifeTitleText),
                              child: Text(
                                '${(currentIndex + 2) > widget.predictions.length ? 1 : (currentIndex + 2)}/${widget.predictions.length}',
                                style: TextStyle(
                                    color: whiteColor,
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: util.fontSize16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: util.height20),
                        Text(
                          widget
                              .predictions[(currentIndex + 1) %
                                  widget.predictions.length]
                              .content,
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: util.fontSize16,
                              height: 1.2,
                              color: blackColor.withValues(alpha: 0.8)),
                        ),
                      ],
                    ),
                  ),
                ),

              // CURRENT CARD
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    dragOffset += details.primaryDelta!;
                  });
                },
                onHorizontalDragEnd: (details) {
                  double threshold = MediaQuery.of(context).size.width * 0.1;
                  if (dragOffset.abs() > threshold) {
                    _onSwipe(dragOffset < 0);
                  } else {
                    setState(() {
                      dragOffset = 0.0;
                    });
                  }
                },
                child: Transform.translate(
                  offset: Offset(dragOffset, 0),
                  child: Container(
                    key: cardKeys[currentIndex],
                    padding: EdgeInsets.all(20),
                    width: util.width,
                    decoration: BoxDecoration(
                      color: lifeContainer,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: whiteColor.withValues(alpha: 0.3), width: 3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Allow dynamic height
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                    widget.predictions[currentIndex].icon),
                                SizedBox(width: util.width20),
                                Text(
                                  getTitle(widget
                                          .predictions[currentIndex].title)
                                      .tr,
                                  style: TextStyle(
                                      fontSize: util.fontSize22,
                                      fontFamily: AppFont.get(FontType.bold),
                                      height: 1.0,
                                      color: lifeTitleText),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: lifeTitleText),
                              child: Text(
                                '${(currentIndex + 1)}/${widget.predictions.length}',
                                style: TextStyle(
                                    color: whiteColor,
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: util.fontSize16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: util.height20),
                        Text(
                          formatText(widget.predictions[currentIndex].content),
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: util.fontSize16,
                              height: 1.2,
                              color: blackColor.withValues(alpha: 0.8)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: util.responsiveHeight(0.0308)),

          // Pagination Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.predictions.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: util.width8,
                height: util.width8,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? lifePredictionButtonText
                      : whiteColor.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          SizedBox(height: util.responsiveHeight(0.0198)),
        ],
      ),
    );
  }
}
