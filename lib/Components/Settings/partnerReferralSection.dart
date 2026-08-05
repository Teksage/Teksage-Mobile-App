import 'package:astro_prompt/Services/PartnerService/partnerReferralService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
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
  String? _success;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final code = _controller.text.trim();
    if (code.isEmpty || _busy) return;
    setState(() => _busy = true);
    try {
      final data = await PartnerReferralService.redeem(code);
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
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Referral code'.tr,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.semibold),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: !_busy && _success == null,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'ASTRO001',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _busy || _success != null ? null : _apply,
                style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                child: Text(_busy ? '...' : 'Apply'.tr),
              ),
            ],
          ),
          if (_success != null) ...[
            const SizedBox(height: 8),
            Text(
              _success!,
              style: const TextStyle(color: mainColor, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}
