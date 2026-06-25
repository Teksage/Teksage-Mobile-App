import 'package:astro_prompt/Components/Consultation-User/consultation_astrologer_listing_card.dart';
import 'package:astro_prompt/Screens/ConsultationUser/consultation_listing_entry.dart';
import 'package:astro_prompt/Screens/ConsultationUser/astrologerDetailpage.dart';
import 'package:astro_prompt/Services/Astrologer-user/userAstrologer.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ConsultationAstrologerListingPage extends StatefulWidget {
  final List<String> selectedCategories;
  final List<String> selectedLanguages;
  final String currency;

  const ConsultationAstrologerListingPage({
    super.key,
    required this.selectedCategories,
    required this.selectedLanguages,
    required this.currency,
  });

  @override
  State<ConsultationAstrologerListingPage> createState() =>
      _ConsultationAstrologerListingPageState();
}

class _ConsultationAstrologerListingPageState
    extends State<ConsultationAstrologerListingPage> {
  final AstrologerConsultationService _service = AstrologerConsultationService();
  List<ConsultationListingEntry> _astrologers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAstrologers();
  }

  Future<void> _loadAstrologers() async {
    setState(() => _isLoading = true);
    final top = await _service.fetchTop5AstroConsult(
      categories: widget.selectedCategories,
      languages: widget.selectedLanguages,
    );
    final topList = top ?? [];
    final excludeIds = topList.map((astro) => astro.userId).toList();
    final more = await _service.fetchAllAstroConsult(excludeIds);
    if (!mounted) return;
    setState(() {
      _astrologers = [
        ...topList.map(
          (astro) => ConsultationListingEntry(
            userId: astro.userId,
            picture: astro.picture,
            firstName: astro.user.firstName,
            languages: astro.languages,
            localConsultingFee: astro.localConsultingFee,
            foreignConsultingFee: astro.foreignConsultingFee,
          ),
        ),
        ...more.map(
          (astro) => ConsultationListingEntry(
            userId: astro.userId,
            picture: astro.picture,
            firstName: astro.user.firstName,
            languages: astro.languages,
            localConsultingFee: astro.localConsultingFee,
            foreignConsultingFee: astro.foreignConsultingFee,
          ),
        ),
      ];
      _isLoading = false;
    });
  }

  String _formatLanguages(List<String> languages) {
    return languages
        .join(', ')
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  String _displayName(String? firstName) {
    if (firstName == null || firstName.isEmpty) return '';
    return firstName[0].toUpperCase() + firstName.substring(1);
  }

  void _openAstrologerDetail(int astrologerId) {
    Get.to(
      () => AstrologerDetailPage(
        astrologerId: astrologerId,
        selectedCategories: widget.selectedCategories,
        selectedLanguages: widget.selectedLanguages,
        currency: widget.currency,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final isInr = widget.currency == 'INR';
    final currencyUnit = isInr ? '₹' : '\$';

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: astroUserConsultBG,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          PlatformTextConfig.astrologerConsultationListingTitle.tr,
          style: TextStyle(
            color: whiteColor,
            fontSize: util.fontSize20,
            fontFamily: AppFont.get(FontType.bold),
            height: 1.0,
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(appBackButton),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: mainColor))
          : GridView.builder(
              padding: EdgeInsets.fromLTRB(
                util.width20,
                util.height20,
                util.width20,
                util.height50,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 20,
                childAspectRatio: 0.72,
              ),
              itemCount: _astrologers.length,
              itemBuilder: (context, index) {
                final astro = _astrologers[index];
                final fee = isInr
                    ? astro.localConsultingFee.toStringAsFixed(0)
                    : astro.foreignConsultingFee.toStringAsFixed(0);
                return ConsultationAstrologerListingCard(
                  picture: astro.picture,
                  name: _displayName(astro.firstName),
                  languages: _formatLanguages(astro.languages),
                  feeAmount: fee,
                  currencyUnit: currencyUnit,
                  onBookNow: () => _openAstrologerDetail(astro.userId),
                );
              },
            ),
    );
  }
}
