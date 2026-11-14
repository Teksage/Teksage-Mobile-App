import 'package:astro_prompt/Components/Common/customCountryDropDown.dart';
import 'package:astro_prompt/Components/Marathon/marathon_event_banner.dart';
import 'package:astro_prompt/Components/Marathon/marathon_flow_widgets.dart';
import 'package:astro_prompt/Components/Marathon/marathon_lead_capture.dart';
import 'package:astro_prompt/Model/country_model.dart';
import 'package:astro_prompt/Services/Marathon/astroconnect_lead_service.dart';
import 'package:astro_prompt/Services/countryService/countryCodeService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/LocallySavedData/name.dart';
import 'package:astro_prompt/config/login_constants.dart';
import 'package:astro_prompt/config/marathon_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

const _leadCategories = [
  'Career',
  'Wealth',
  'Marriage & Relationships',
  'Health',
  'All',
];

class MarathonLeadPage extends StatefulWidget {
  const MarathonLeadPage({super.key, required this.event});

  final Map<String, dynamic> event;

  @override
  State<MarathonLeadPage> createState() => _MarathonLeadPageState();
}

class _MarathonLeadPageState extends State<MarathonLeadPage> {
  final _service = AstroConnectLeadService();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  late List<String> _selectedCategories;
  String _dialCode = LoginConstants.defaultDialCode;
  String? _countryFlag;
  List<Country> _countries = [];
  bool _busy = false;
  bool _hydrated = false;
  String _error = '';
  Map<String, dynamic>? _result;

  @override
  void initState() {
    super.initState();
    final cats = (widget.event['categories'] as List?)
            ?.map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList() ??
        <String>[];
    _selectedCategories =
        cats.isNotEmpty ? List<String>.from(cats) : [_leadCategories.first];
    _hydrate();
  }

  Future<void> _hydrate() async {
    final eventId = widget.event['id'];
    final contact = await loadMarathonLeadContact(eventId);
    if (!mounted) return;
    if (contact != null) {
      final dial = (contact['country_code'] ?? '').trim();
      final phone = (contact['mobile_number'] ?? '').trim();
      final name = (contact['name'] ?? '').trim();
      if (dial.isNotEmpty) {
        _dialCode = dial.startsWith('+') ? dial : '+$dial';
      }
      if (phone.isNotEmpty) _phoneCtrl.text = phone;
      if (name.isNotEmpty) _nameCtrl.text = name;
    }

    final phone = _phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
    // Phone known → server is source of truth.
    if (phone.length >= 7) {
      final lookup = await _lookupSavedContact();
      if (!mounted) return;
      if (lookup != null) {
        setState(() {
          _result = lookup;
          _hydrated = true;
        });
        return;
      }
      // Lead deleted on server (or never existed) — show form again.
      await clearMarathonLeadLocal(eventId);
      if (!mounted) return;
      final savedName = await getUserName();
      if (!mounted) return;
      if (_nameCtrl.text.trim().isEmpty && savedName.trim().isNotEmpty) {
        _nameCtrl.text = savedName.trim();
      }
      setState(() {
        _result = null;
        _hydrated = true;
      });
      return;
    }

    // No phone yet — use cached success only if we still have a stored result.
    final cached = await loadMarathonLeadResult(eventId);
    if (!mounted) return;
    if (cached != null) {
      setState(() {
        _result = cached;
        _hydrated = true;
      });
      return;
    }

    // Stale notified flag without phone/result → treat as not registered.
    if (await isMarathonLeadNotified(eventId)) {
      await clearMarathonLeadLocal(eventId);
    }
    if (!mounted) return;

    final savedName = await getUserName();
    if (!mounted) return;
    if (_nameCtrl.text.trim().isEmpty && savedName.trim().isNotEmpty) {
      _nameCtrl.text = savedName.trim();
    }
    setState(() => _hydrated = true);
  }

  Future<Map<String, dynamic>?> _lookupSavedContact() async {
    final phone = _phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
    if (phone.length < 7) return null;
    try {
      final row = await _service.lookupLead(
        countryCode: _dialCode.replaceAll('+', ''),
        mobileNumber: phone,
        sourceMarathonId: int.tryParse('${widget.event['id']}') ?? 0,
      );
      if (row == null) return null;
      await saveMarathonLeadResult(
        widget.event['id'],
        row,
        countryCode: _dialCode.replaceAll('+', ''),
        mobileNumber: phone,
        name: _nameCtrl.text.trim().isNotEmpty
            ? _nameCtrl.text.trim()
            : row['name']?.toString(),
      );
      return row;
    } catch (_) {
      return null;
    }
  }

  void _toggleCategory(String item) {
    setState(() {
      if (_selectedCategories.contains(item)) {
        _selectedCategories = _selectedCategories.where((name) => name != item).toList();
      } else {
        _selectedCategories = [..._selectedCategories, item];
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _openCountryPicker() async {
    CustomLoader.show(context);
    try {
      if (_countries.isEmpty) {
        _countries = await CountryCodeService().fetchCountries();
      }
      CustomLoader.hide();
      if (!mounted) return;
      final result = await showDialog<Map<String, String>>(
        context: context,
        builder: (_) => CountryDropdownDialog(countries: _countries),
      );
      if (result == null || !mounted) return;
      setState(() {
        _dialCode = result['dialCode'] ?? LoginConstants.defaultDialCode;
        _countryFlag = result['countryFlag'];
        _phoneCtrl.clear();
      });
    } catch (_) {
      CustomLoader.hide();
      if (!mounted) return;
      showErrorSnackBar(context, 'Error in Fetching Country code'.tr);
    }
  }

  Future<void> _checkExistingPhone() async {
    if (_result != null) return;
    final phone = _phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
    if (phone.length < 7) return;
    try {
      final row = await _service.lookupLead(
        countryCode: _dialCode.replaceAll('+', ''),
        mobileNumber: phone,
        sourceMarathonId: int.tryParse('${widget.event['id']}') ?? 0,
      );
      if (!mounted || row == null) return;
      await saveMarathonLeadResult(
        widget.event['id'],
        row,
        countryCode: _dialCode.replaceAll('+', ''),
        mobileNumber: phone,
        name: _nameCtrl.text.trim(),
      );
      setState(() => _result = row);
    } catch (_) {}
  }

  Future<void> _submit() async {
    setState(() => _error = '');
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
    final dial = _dialCode.replaceAll('+', '');
    if (name.isEmpty) {
      setState(() => _error = 'Please enter your name.'.tr);
      return;
    }
    final dialDigits = _dialCode.replaceAll(RegExp(r'\D'), '');
    final expectedLen = dialDigits == '91' ? 10 : null;
    if (phone.length < 7 || (expectedLen != null && phone.length != expectedLen)) {
      setState(() => _error = 'Please enter a valid mobile number.'.tr);
      return;
    }
    if (_selectedCategories.isEmpty) {
      setState(() => _error = 'Please select a category.'.tr);
      return;
    }
    setState(() => _busy = true);
    try {
      final row = await _service.submitLead(
        name: name,
        countryCode: dial,
        mobileNumber: phone,
        categories: _selectedCategories,
        sourceMarathonId: int.tryParse('${widget.event['id']}') ?? 0,
      );
      if (!mounted) return;
      await saveMarathonLeadResult(
        widget.event['id'],
        row,
        countryCode: dial,
        mobileNumber: phone,
        name: name,
      );
      setState(() => _result = row);
      // Always open WhatsApp after submit (same as website). If already granted,
      // this still opens chat so the user can resend / confirm.
      final click = row['whatsapp_click_url']?.toString().trim() ?? '';
      final url = click.isNotEmpty
          ? click
          : MarathonConfig.consentWhatsAppUrl(
              name: name,
              categories: _selectedCategories,
            );
      await _openExternalUrl(url);
    } catch (err) {
      if (!mounted) return;
      setState(() => _error = err.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _channelUrl(Map<String, dynamic> row) {
    final raw = (row['channel_url']?.toString() ?? '').trim();
    if (raw.isEmpty) return MarathonConfig.channelUrl;
    return raw.replaceFirst('https://whatsapp.com/', 'https://www.whatsapp.com/');
  }

  String _instagramUrl(Map<String, dynamic> row) {
    final raw = (row['instagram_url']?.toString() ?? '').trim();
    return raw.isEmpty ? MarathonConfig.instagramUrl : raw;
  }

  String _whatsappUrl(Map<String, dynamic> row) {
    final raw = (row['whatsapp_click_url']?.toString() ?? '').trim();
    if (raw.isNotEmpty) return raw;
    return MarathonConfig.consentWhatsAppUrl(
      name: row['name']?.toString(),
      categories: (row['categories'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final title = marathonDisplayName(widget.event['name']?.toString());
    return Scaffold(
      backgroundColor: marathonPageBg,
      body: Column(
        children: [
          MarathonFlowBar(title: title.tr, onBack: () => Get.back()),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                MarathonCard(
                  child: !_hydrated
                      ? const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()))
                      : _result != null
                          ? _success(util, _result!)
                          : _form(util),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _success(MyUtility util, Map<String, dynamic> row) {
    final granted = row['whatsapp_opt_in'] == true;
    final already = row['already_submitted'] == true;
    final title = granted
        ? "You're all set".tr
        : already
            ? "You're already registered for this event.".tr
            : "You're on the list".tr;
    final body = granted
        ? 'WhatsApp alerts are enabled for your interests. Follow us for more updates.'.tr
        : already
            ? "Confirm on WhatsApp if you haven't yet, or follow us for updates.".tr
            : 'WhatsApp is opening with prefilled message. Tap Send to confirm updates.'.tr;

    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: mainColor.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(verified, width: 28, height: 28),
        ),
        const SizedBox(height: 16),
        Text(title, textAlign: TextAlign.center, style: marathonText(util, FontType.bold)),
        const SizedBox(height: 6),
        Text(
          body,
          textAlign: TextAlign.center,
          style: marathonText(util, FontType.medium, color: blackColor.withValues(alpha: 0.55)),
        ),
        const SizedBox(height: 16),
        _primaryWhatsApp(util, _whatsappUrl(row)),
        const SizedBox(height: 20),
        Text(
          'Follow us'.tr,
          textAlign: TextAlign.center,
          style: marathonText(util, FontType.medium, color: blackColor.withValues(alpha: 0.45)),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _followLink(
                util,
                icon: whatsappBrand,
                label: 'WhatsApp Channel'.tr,
                url: _channelUrl(row),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _followLink(
                util,
                icon: instagramBrand,
                label: 'Instagram'.tr,
                url: _instagramUrl(row),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _openExternalUrl(String url) async {
    if (url.trim().isEmpty) return;
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (_) {}
    }
  }

  Widget _primaryWhatsApp(MyUtility util, String url) {
    return Material(
      color: mainColor,
      shape: const StadiumBorder(),
      child: InkWell(
        onTap: () => _openExternalUrl(url),
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(whatsappBrand, width: 20, height: 20),
              const SizedBox(width: 8),
              Text(
                'Open WhatsApp'.tr,
                style: marathonText(util, FontType.semiBold, color: whiteColor, height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _followLink(
    MyUtility util, {
    required String icon,
    required String label,
    required String url,
  }) {
    return Material(
      color: mainColor.withValues(alpha: 0.1),
      shape: StadiumBorder(side: BorderSide(color: mainColor.withValues(alpha: 0.28))),
      child: InkWell(
        onTap: () => _openExternalUrl(url),
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(icon, width: 20, height: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: marathonText(util, FontType.semiBold, color: mainColor, height: 1.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: whiteColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: blackColor.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: blackColor.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: mainColor.withValues(alpha: 0.55)),
      ),
    );
  }

  Widget _dialPicker() {
    return GestureDetector(
      onTap: _busy ? null : _openCountryPicker,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: blackColor.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_countryFlag != null && _countryFlag!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Image.network(
                  _countryFlag!,
                  width: 22,
                  height: 16,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            Text(
              _dialCode,
              style: TextStyle(
                fontFamily: AppFont.get(FontType.bold),
                fontSize: 14,
                color: blackColor,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: blackColor.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }

  Widget _form(MyUtility util) {
    final labelStyle = marathonText(util, FontType.semiBold, size: util.fontSize12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Stay in the loop'.tr, style: marathonText(util, FontType.bold)),
        const SizedBox(height: 4),
        Text(
          'Share your details and confirm on WhatsApp. No login needed.'.tr,
          style: marathonText(util, FontType.medium, color: blackColor.withValues(alpha: 0.55)),
        ),
        const SizedBox(height: 16),
        Text('Name'.tr, style: labelStyle),
        const SizedBox(height: 6),
        TextField(
          controller: _nameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: _fieldDecoration(hint: 'Your name'.tr),
        ),
        const SizedBox(height: 16),
        Text('Phone'.tr, style: labelStyle),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dialPicker(),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                onEditingComplete: _checkExistingPhone,
                onSubmitted: (_) => _checkExistingPhone(),
                decoration: _fieldDecoration(hint: 'Mobile number'.tr),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Category you are interested'.tr, style: labelStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _leadCategories.map((item) {
            final on = _selectedCategories.contains(item);
            return GestureDetector(
              onTap: () => _toggleCategory(item),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: on ? mainColor : whiteColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: on ? mainColor : blackColor.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  item.tr,
                  style: marathonText(
                    util,
                    FontType.semiBold,
                    color: on ? whiteColor : blackColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(_error, style: TextStyle(color: Colors.red.shade700, fontSize: 13)),
        ],
        const SizedBox(height: 20),
        MarathonPrimaryButton(
          label: _busy ? 'Saving…'.tr : 'Notify me'.tr,
          onTap: _busy ? null : _submit,
          wide: true,
        ),
      ],
    );
  }
}
