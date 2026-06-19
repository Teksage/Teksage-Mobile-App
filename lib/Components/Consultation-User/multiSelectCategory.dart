import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class MultiSelectCategory extends StatefulWidget {
  final Function(List<String>) onSelectionChanged;

  const MultiSelectCategory({super.key, required this.onSelectionChanged});

  @override
  State<MultiSelectCategory> createState() => _MultiSelectCategoryState();
}

class _MultiSelectCategoryState extends State<MultiSelectCategory> {
  List<Map<String, dynamic>> categories = [
    {"name": "Career", "image": categoryCareer, "selected": false},
    {"name": "Wealth", "image": categoryWealth, "selected": false},
    {
      "name": "Marriage & Relationships",
      "image": categoryMarriage,
      "selected": false
    },
    {"name": "Health", "image": categoryBusiness, "selected": false},
    {"name": "All", "image": categoryAll, "selected": false},
  ];

  List<String> selectedCategories = [];

  void toggleSelection(int index) {
    setState(() {
      final isAllSelected = categories[index]["name"] == "All";

      if (isAllSelected) {
        final newSelectedState = !categories[index]["selected"];
        for (int i = 0; i < categories.length; i++) {
          categories[i]["selected"] = newSelectedState;
        }
        selectedCategories = newSelectedState
            ? categories
                .where((cat) => cat["name"] != "All")
                .map<String>((cat) => cat["name"] as String)
                .toList()
            : [];
      } else {
        categories[index]["selected"] = !categories[index]["selected"];
        if (categories[index]["selected"]) {
          selectedCategories.add(categories[index]["name"]);
        } else {
          selectedCategories.remove(categories[index]["name"]);
        }
        categories.last["selected"] =
            selectedCategories.length == categories.length - 1 ? true : false;
        if (categories.last["selected"] &&
            selectedCategories.length != categories.length - 1) {
          categories.last["selected"] = false;
        }
      }

      widget.onSelectionChanged(selectedCategories);
    });
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(categories.length, (index) {
        return GestureDetector(
          onTap: () => toggleSelection(index),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 11),
            decoration: BoxDecoration(
              color: categories[index]["selected"] ? homeBanner : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: blackColor.withValues(alpha: 0.12), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  categories[index]["image"],
                  width: 18,
                  height: 18,
                ),
                SizedBox(width: util.width10),
                Text(
                  categories[index]["name"].toString().tr,
                  style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      fontSize: util.fontSize18,
                      height: 1.0,
                      color: categories[index]["selected"]
                          ? whiteColor
                          : blackColor.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
