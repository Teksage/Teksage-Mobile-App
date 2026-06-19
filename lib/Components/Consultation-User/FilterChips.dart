import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> selectedCategory;
  final List<String> selectedLanguage;
  final void Function(String category) onRemoveCategory;
  final void Function(String language) onRemoveLanguage;

  const FilterChipsWidget({
    super.key,
    required this.selectedCategory,
    required this.selectedLanguage,
    required this.onRemoveCategory,
    required this.onRemoveLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 10,
          children: [
            ...selectedCategory.map((category) => Chip(
                  label: Text(
                    (category[0].toUpperCase() + category.substring(1)).tr,
                    style: TextStyle(
                        fontFamily: 'FontSemiBold',
                        fontSize: util.fontSize14,
                        height: 1.0,
                        color: whiteColor),
                  ),
                  deleteIcon: SvgPicture.asset(closeAstroUser),
                  onDeleted: () => onRemoveCategory(category),
                  backgroundColor: astroFilterChip,
                )),
            ...selectedLanguage.map((language) {
              String lang = language[0].toUpperCase() + language.substring(1);
              return Chip(
                label: Text(
                  lang.tr,
                  style: TextStyle(
                    fontFamily: 'FontSemiBold',
                    fontSize: util.fontSize14,
                    height: 1.0,
                    color: whiteColor,
                  ),
                ),
                deleteIcon: SvgPicture.asset(closeAstroUser),
                onDeleted: () => onRemoveLanguage(language),
                backgroundColor: astroFilterChip,
              );
            }),
          ],
        ),
      ),
    );
  }
}
