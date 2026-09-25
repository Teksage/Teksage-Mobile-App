import 'package:astro_prompt/Components/Consultation-User/consultation_astrologer_listing_card.dart';
import 'package:astro_prompt/Screens/ConsultationUser/consultation_listing_entry.dart';
import 'package:astro_prompt/Screens/ConsultationUser/astrologerDetailpage.dart';
import 'package:astro_prompt/Services/Astrologer-user/userAstrologer.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/ask_astrologer_config.dart';
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
  /// Empty string = All Languages.
  String _languageFilter = '';

  @override
  void initState() {
    super.initState();
    _loadAstrologers();
  }

  Future<void> _loadAstrologers() async {
    setState(() => _isLoading = true);
    final more = await _service.fetchAllAstroConsult([]);
    if (!mounted) return;
    final entries = more
        .map(
          (astro) => ConsultationListingEntry(
            userId: astro.userId,
            picture: astro.picture,
            firstName: astro.user.firstName,
            lastName: astro.user.lastName,
            languages: astro.languages,
            localConsultingFee: astro.localConsultingFee,
            foreignConsultingFee: astro.foreignConsultingFee,
          ),
        )
        .toList()
      ..sort((a, b) => _fullDisplayName(a)
          .toLowerCase()
          .compareTo(_fullDisplayName(b).toLowerCase()));
    setState(() {
      _astrologers = entries;
      _isLoading = false;
    });
  }

  List<ConsultationListingEntry> get _filteredAstrologers {
    if (_languageFilter.isEmpty) return _astrologers;
    return _astrologers
        .where(
          (astro) => AskAstrologerLanguages.speaksLanguage(
            astro.languages,
            _languageFilter,
          ),
        )
        .toList();
  }

  List<Map<String, String>> get _availableLanguageOptions {
    final ids = <String>{};
    for (final astro in _astrologers) {
      for (final lang in astro.languages) {
        final id = AskAstrologerLanguages.normalizeId(lang);
        if (id.isNotEmpty) ids.add(id);
      }
    }
    return AskAstrologerLanguages.options
        .where((opt) => ids.contains(opt['id']))
        .toList();
  }

  String _formatLanguages(List<String> languages) {
    return languages
        .join(', ')
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  String _titleCase(String value) {
    if (value.isEmpty) return '';
    return value
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  String _fullDisplayName(ConsultationListingEntry astro) {
    final first = astro.firstName?.trim() ?? '';
    final last = astro.lastName?.trim() ?? '';
    return _titleCase([first, last].where((p) => p.isNotEmpty).join(' '));
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
    final filtered = _filteredAstrologers;

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
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    util.width20,
                    util.height10,
                    util.width20,
                    util.height10,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _languageFilter,
                    decoration: InputDecoration(
                      labelText: 'Language'.tr,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: blackColor.withValues(alpha: 0.12),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: mainColor),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: '',
                        child: Text('All Languages'.tr),
                      ),
                      ..._availableLanguageOptions.map(
                        (opt) => DropdownMenuItem(
                          value: opt['id']!,
                          child: Text(
                            (opt['native'] ?? opt['label']!).tr,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _languageFilter = value ?? '');
                    },
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(util.width20),
                            child: Text(
                              'No astrologers match this language.'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppFont.get(FontType.medium),
                                fontSize: util.fontSize14,
                                color: blackColor.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.fromLTRB(
                            util.width20,
                            util.height10,
                            util.width20,
                            util.height50,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 20,
                            childAspectRatio: 0.72,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final astro = filtered[index];
                            final fee = isInr
                                ? astro.localConsultingFee.toStringAsFixed(0)
                                : astro.foreignConsultingFee
                                    .toStringAsFixed(0);
                            return ConsultationAstrologerListingCard(
                              picture: astro.picture,
                              name: _fullDisplayName(astro),
                              languages: _formatLanguages(astro.languages),
                              feeAmount: fee,
                              currencyUnit: currencyUnit,
                              onTap: () =>
                                  _openAstrologerDetail(astro.userId),
                              onBookNow: () =>
                                  _openAstrologerDetail(astro.userId),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
