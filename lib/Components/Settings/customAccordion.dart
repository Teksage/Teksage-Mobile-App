import 'package:astro_prompt/Model/faq_model.dart';
import 'package:astro_prompt/Services/SettingService/faqService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class CustomAccordion extends StatefulWidget {
  const CustomAccordion({super.key});

  @override
  State<CustomAccordion> createState() => _CustomAccordionState();
}

class _CustomAccordionState extends State<CustomAccordion> {
  final FaqService _faqService = FaqService();
  List<FaqModel> _allFaqs = [];
  List<FaqModel> _filteredFaqs = [];
  int? expandedIndex;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFaqs();
  }

  void _loadFaqs() async {
    try {
      List<FaqModel> faqs = await _faqService.fetchFaqs();
      setState(() {
        _allFaqs = faqs;
        _filteredFaqs = faqs;
      });
    } catch (e) {
      print('Error loading FAQs: $e');
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        _filteredFaqs = _allFaqs;
      } else {
        _filteredFaqs = _allFaqs
            .where((faq) =>
                faq.question.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      expandedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(util.width8),
            color: notEditable,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  onChanged: _onSearchChanged,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.medium),
                    fontSize: util.fontSize16,
                    height: 1.0,
                    color: blackColor.withValues(alpha: 0.8),
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'search_help'.tr,
                    hintStyle: TextStyle(
                      fontFamily: AppFont.get(FontType.medium),
                      fontSize: util.fontSize16,
                      height: 1.0,
                      color: blackColor.withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SvgPicture.asset(search),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ACCORDION LIST
        _filteredFaqs.isEmpty
            ? Center(
                child: Text('No FAQs found'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: AppFont.get(FontType.medium),
                        fontSize: MyUtility(context).fontSize16,
                        height: 1.2,
                        color: blackColor.withValues(alpha: 0.5))))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredFaqs.length,
                itemBuilder: (context, index) {
                  final item = _filteredFaqs[index];

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            expandedIndex =
                                (expandedIndex == index) ? null : index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: blackColor.withValues(alpha: 0.08),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.question,
                                  style: TextStyle(
                                    fontFamily: AppFont.get(FontType.semiBold),
                                    fontSize: util.fontSize16,
                                    height: 1.0,
                                    color: blackColor,
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                expandedIndex == index ? crossFaq : addFaq,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (expandedIndex == index)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Text(
                            item.answer,
                            style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: util.fontSize14,
                              height: 1.3,
                              color: blackColor.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
      ],
    );
  }
}
