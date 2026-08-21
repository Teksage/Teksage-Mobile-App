import 'dart:io';

import 'package:astro_prompt/Services/PartnerService/partnerReferralService.dart';
import 'package:astro_prompt/Services/PartnerService/partnerRefStorage.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PartnerReferralSection extends StatefulWidget {
  final bool show;
  final VoidCallback? onApplied;

  const PartnerReferralSection({
    super.key,
    required this.show,
    this.onApplied,
  });

  @override
  State<PartnerReferralSection> createState() => _PartnerReferralSectionState();
}

class _PartnerReferralSectionState extends State<PartnerReferralSection> {
  final _controller = TextEditingController();
  bool _busy = false;
  bool _focused = false;
  String? _success;

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  Future<void> _prefill() async {
    final saved = await PartnerRefStorage.read();
    if (!mounted || saved == null || saved.isEmpty) return;
    setState(() => _controller.text = saved);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final code = _controller.text.trim().toUpperCase();
    if (code.isEmpty || _busy) return;
    setState(() {
      _busy = true;
      _controller.text = code;
    });
    try {
      final data = await PartnerReferralService.redeem(code);
      await PartnerRefStorage.clear();
      final days = data['days_left'] ?? data['valid_days'];
      setState(() {
        _success = days != null
            ? '${'Referral code applied'.tr} ($days)'
            : 'Referral code applied'.tr;
      });
      showLoginSuccessSnackBar(context, 'Referral code applied'.tr);
      widget.onApplied?.call();
    } catch (e) {
      showErrorSnackBar(
        context,
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return const SizedBox.shrink();

    final util = MyUtility(context);
    final applied = _success != null;
    final canEdit = !_busy && !applied;
    final accent = Platform.isAndroid ? mainColor : iosMainColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'Referral code'.tr,
          style: TextStyle(
            color: blackColor,
            fontSize: util.fontSize10,
            height: util.lineHeight12 / util.fontSize10,
            fontFamily: AppFont.get(FontType.medium),
          ),
        ),
        SizedBox(height: util.responsiveHeight(0.005)),
        FocusScope(
          child: Focus(
            onFocusChange: (focus) {
              setState(() => _focused = focus);
            },
            child: Container(
              height: util.responsiveHeight(0.0555),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _focused
                      ? accent
                      : blackColor.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: canEdit,
                      showCursor: canEdit,
                      textCapitalization: TextCapitalization.characters,
                      style: TextStyle(
                        fontSize: util.fontSize14,
                        fontFamily: AppFont.get(FontType.medium),
                        height: 1.0,
                        color: blackColor,
                      ),
                      onChanged: (v) {
                        final upper = v.toUpperCase();
                        if (upper != v) {
                          _controller.value = TextEditingValue(
                            text: upper,
                            selection: TextSelection.collapsed(
                              offset: upper.length,
                            ),
                          );
                        }
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'ASTRO001',
                        hintStyle: TextStyle(
                          fontSize: util.fontSize14,
                          fontFamily: AppFont.get(FontType.medium),
                          color: blackColor.withValues(alpha: 0.35),
                        ),
                        filled: true,
                        fillColor: canEdit ? whiteColor : notEditable,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      cursorColor: blackColor,
                    ),
                  ),
                  if (!applied)
                    Row(
                      children: [
                        Container(
                          height: 21,
                          width: 1,
                          color: blackColor.withValues(alpha: 0.2),
                        ),
                        GestureDetector(
                          onTap: canEdit && _controller.text.trim().isNotEmpty
                              ? _apply
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            height: util.responsiveHeight(0.0555),
                            padding: const EdgeInsets.only(left: 12, right: 18),
                            child: Center(
                              child: Text(
                                _busy ? '...' : 'Apply'.tr,
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize14,
                                  color: accent.withValues(
                                    alpha: canEdit &&
                                            _controller.text.trim().isNotEmpty
                                        ? 1
                                        : 0.45,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Container(
                      height: util.responsiveHeight(0.0555),
                      padding: const EdgeInsets.only(right: 10.0),
                      decoration: const BoxDecoration(
                        color: notEditable,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: SvgPicture.asset(verified),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (_success != null) ...[
          const SizedBox(height: 5),
          Text(
            _success!,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.medium),
              fontSize: util.fontSize11,
              color: accent,
            ),
          ),
        ],
      ],
    );
  }
}
