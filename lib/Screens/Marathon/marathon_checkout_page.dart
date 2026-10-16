import 'package:astro_prompt/Components/Common/customCountryDropDown.dart';
import 'package:astro_prompt/Components/Marathon/marathon_event_banner.dart';
import 'package:astro_prompt/Model/country_model.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_fee.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_summary_page.dart';
import 'package:astro_prompt/Services/AuthService/authService.dart';
import 'package:astro_prompt/Services/countryService/countryCodeService.dart';
import 'package:astro_prompt/Services/Marathon/marathon_service.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/Helper/profile_currency.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/login_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class MarathonCheckoutPage extends StatefulWidget {
  const MarathonCheckoutPage({super.key, required this.marathonId, required this.slotId});

  final int marathonId;
  final int slotId;

  @override
  State<MarathonCheckoutPage> createState() => _MarathonCheckoutPageState();
}

class _MarathonCheckoutPageState extends State<MarathonCheckoutPage> {
  final MarathonService _service = MarathonService();
  final AuthService _auth = AuthService();
  late Razorpay _razorpay;
  Map<String, dynamic>? event;
  List<Map<String, dynamic>> mine = [];
  int step = 1;
  bool loading = true;
  String error = '';
  bool emailTab = false;
  bool otpSent = false;
  final contact = TextEditingController();
  String dialCode = LoginConstants.defaultDialCode;
  String? countryFlag;
  List<Country> countries = [];
  final otp = TextEditingController();
  final first = TextEditingController();
  final last = TextEditingController();
  final dob = TextEditingController();
  final tob = TextEditingController();
  final birth = TextEditingController();
  final current = TextEditingController();
  String payCurrency = 'INR';
  double? payBase;
  bool needsEmail = true;
  bool emailVerified = false;
  bool emailOtpSent = false;
  bool phoneOtpSent = false;
  bool phoneVerified = false;
  final emailContact = TextEditingController();
  final emailOtp = TextEditingController();
  final phoneContact = TextEditingController();
  final phoneOtp = TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
    _load();
  }

  @override
  void dispose() {
    _razorpay.clear();
    contact.dispose();
    otp.dispose();
    first.dispose();
    last.dispose();
    dob.dispose();
    tob.dispose();
    birth.dispose();
    current.dispose();
    emailContact.dispose();
    emailOtp.dispose();
    phoneContact.dispose();
    phoneOtp.dispose();
    super.dispose();
  }

  bool _ready(UserProfile? profile) {
    if (profile == null) return false;
    return profile.firstName.trim().isNotEmpty &&
        profile.dateOfBirth.trim().isNotEmpty &&
        profile.timeOfBirth.trim().isNotEmpty &&
        profile.birthLocation.trim().isNotEmpty &&
        profile.email.trim().isNotEmpty;
  }

  void _fill(UserProfile profile) {
    first.text = profile.firstName;
    last.text = profile.lastName;
    dob.text = profile.dateOfBirth.split('T').first;
    tob.text = profile.timeOfBirth.length >= 5 ? profile.timeOfBirth.substring(0, 5) : profile.timeOfBirth;
    birth.text = profile.birthLocation;
    current.text = profile.preferredLocation;
  }

  Future<void> _load() async {
    try {
      final row = await _service.publicDetail(widget.marathonId);
      final token = await getAccessToken();
      var next = 1;
      if (token.isNotEmpty) {
        final profile = await ProfileService().fetchUserProfile();
        await _refreshBookings();
        if (profile != null) {
          _fill(profile);
          _rememberFee(profile, row);
          needsEmail = profile.email.trim().isEmpty;
          emailVerified = !needsEmail;
        }
        next = _ready(profile) ? 3 : 2;
      }
      if (!mounted) return;
      setState(() {
        event = row;
        step = next;
        loading = false;
      });
    } catch (err) {
      if (!mounted) return;
      setState(() {
        error = err.toString().replaceFirst('Exception: ', '');
        loading = false;
      });
    }
  }

  void _rememberFee(UserProfile profile, Map<String, dynamic> row) {
    payCurrency = ProfileCurrency.fromProfile(profile);
    final raw = payCurrency == 'USD' && row['usd_fee'] != null ? row['usd_fee'] : row['fee'];
    payBase = double.tryParse('$raw');
  }

  String _fmt(double amount) => payCurrency == 'USD' ? '\$${amount.toStringAsFixed(2)}' : '₹${amount.toStringAsFixed(2)}';

  Map<String, dynamic>? get _slot {
    final slots = List<Map<String, dynamic>>.from(event?['slots'] ?? []);
    for (final slot in slots) {
      final id = slot['id'];
      final parsed = id is int ? id : int.tryParse('$id');
      if (parsed == widget.slotId) return slot;
    }
    return null;
  }

  Future<void> _refreshBookings() async {
    final token = await getAccessToken();
    if (token.isEmpty) {
      mine = [];
      return;
    }
    mine = await _service.mine();
  }

  bool _overlaps(Map<String, dynamic> row) {
    final slot = _slot;
    if (slot == null) return false;
    final start = DateTime.tryParse('${slot['starts_at']}');
    final end = DateTime.tryParse('${slot['ends_at']}');
    final otherStart = DateTime.tryParse('${row['starts_at']}');
    final otherEnd = DateTime.tryParse('${row['ends_at']}');
    if (start == null || end == null || otherStart == null || otherEnd == null) return false;
    return otherStart.isBefore(end) && otherEnd.isAfter(start);
  }

  Future<void> _sendOtp() async {
    final value = contact.text.trim();
    if (value.isEmpty) return;
    setState(() => error = '');
    final code = dialCode.replaceAll(RegExp(r'\D'), '');
    final result = emailTab
        ? await _auth.login('email', value)
        : await _auth.login('mobile_number', value, countryCode: code.isEmpty ? LoginConstants.defaultCountryCodeNumeric : code);
    if (!mounted) return;
    if (result['error'] != null) {
      setState(() => error = '${result['error']}');
      return;
    }
    setState(() => otpSent = true);
  }

  Future<void> _confirmOtp() async {
    if (otp.text.trim().length != LoginConstants.otpLength) {
      setState(() => error = 'Enter the code we sent you.'.tr);
      return;
    }
    final value = contact.text.trim();
    final code = dialCode.replaceAll(RegExp(r'\D'), '');
    final result = emailTab
        ? await _auth.loginOTP('email', value, otp.text.trim())
        : await _auth.loginOTP('mobile_number', value, otp.text.trim(), code.isEmpty ? LoginConstants.defaultCountryCodeNumeric : code);
    if (!mounted) return;
    if (result['status'] != 'success' && result['access_token'] == null && result['userId'] == null) {
      setState(() => error = 'That code is incorrect or has expired. Try again.'.tr);
      return;
    }
    final profile = await ProfileService().fetchUserProfile();
    if (profile != null) {
      _fill(profile);
      if (event != null) _rememberFee(profile, event!);
      needsEmail = profile.email.trim().isEmpty;
      emailVerified = !needsEmail;
    }
    await _refreshBookings();
    if (!mounted) return;
    setState(() => step = _ready(profile) ? 3 : 2);
  }

  Future<void> _saveProfile() async {
    if (first.text.trim().isEmpty || last.text.trim().isEmpty || dob.text.trim().isEmpty || tob.text.trim().isEmpty || birth.text.trim().isEmpty || current.text.trim().isEmpty) {
      setState(() => error = 'Add your name, date of birth, time of birth, and place of birth to continue.'.tr);
      return;
    }
    if (needsEmail && !emailVerified) {
      setState(() => error = 'Please verify your Email'.tr);
      return;
    }
    final saved = await ProfileService().updateProfile({
      'first_name': first.text.trim(),
      'last_name': last.text.trim(),
      'date_of_birth': dob.text.trim(),
      'time_of_birth': tob.text.trim().length == 5 ? '${tob.text.trim()}:00' : tob.text.trim(),
      'birth_location': birth.text.trim(),
      'preferred_location': current.text.trim().isEmpty ? birth.text.trim() : current.text.trim(),
    });
    if (!mounted) return;
    if (saved['success'] != true) {
      setState(() => error = '${saved['error'] ?? ''}');
      return;
    }
    final profile = await ProfileService().fetchUserProfile();
    if (profile != null && event != null) _rememberFee(profile, event!);
    await _refreshBookings();
    if (!mounted) return;
    setState(() {
      error = '';
      step = 3;
    });
  }

  Future<void> _pay() async {
    setState(() => error = '');
    CustomLoader.show(context);
    try {
      final profile = await ProfileService().fetchUserProfile();
      final currency = ProfileCurrency.fromProfile(profile);
      final order = await _service.checkout(widget.slotId, currency: currency);
      CustomLoader.hide();
      _razorpay.open({
        'key': order['key'],
        'amount': order['amount'],
        'currency': order['currency'],
        'order_id': order['id'],
        'name': 'Teksage',
        'description': event?['name']?.toString() ?? 'Consultation marathon',
      });
    } catch (err) {
      CustomLoader.hide();
      if (!mounted) return;
      setState(() => error = err.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _onError(PaymentFailureResponse response) {
    showErrorSnackBar(context, 'Payment did not go through. This seat is still open. Try again.'.tr);
  }

  Future<void> _onSuccess(PaymentSuccessResponse response) async {
    CustomLoader.show(context);
    try {
      final result = await _service.verify(
        orderId: response.orderId!,
        paymentId: response.paymentId!,
        signature: response.signature!,
      );
      final rawId = result['booking_id'];
      final bookingId = rawId is int ? rawId : int.tryParse('$rawId') ?? 0;
      CustomLoader.hide();
      if (!mounted) return;
      Get.off(() => MarathonSummaryPage(bookingId: bookingId, justPaid: true));
    } catch (err) {
      CustomLoader.hide();
      if (!mounted) return;
      showErrorSnackBar(context, err.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final slot = _slot;
    final zone = event?['timezone']?.toString();
    final start = marathonWallParts(slot?['starts_at']?.toString(), zone: zone);
    final end = marathonWallParts(slot?['ends_at']?.toString(), zone: zone);
    Map<String, dynamic>? clash;
    for (final row in mine) {
      if (_overlaps(row)) {
        clash = row;
        break;
      }
    }
    return Scaffold(
      backgroundColor: const Color(0xffF4FBF3),
      appBar: AppBar(
        backgroundColor: const Color(0xffF4FBF3),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(appBackButton, colorFilter: const ColorFilter.mode(blackColor, BlendMode.srcIn)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Go back'.tr,
          style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize16, color: blackColor),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: mainColor))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(color: blackColor.withValues(alpha: 0.08)),
                      boxShadow: [BoxShadow(color: blackColor.withValues(alpha: 0.05), blurRadius: 24, offset: const Offset(0, 8))],
                    ),
                    child: Column(
                      children: [
                        _stepper(util),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                          child: event?['admin_ended'] == true
                              ? Text('Event ended by admin'.tr, style: TextStyle(color: blackColor.withValues(alpha: 0.6)))
                              : _body(util, clash),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (event != null) MarathonEventBanner(event: event!, linked: false, onTap: () {}),
                if (start != null && end != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: blackColor.withValues(alpha: 0.08)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(23),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(width: 4, color: mainColor),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Select a time slot'.tr, style: TextStyle(fontFamily: AppFont.get(FontType.bold), fontSize: util.fontSize16)),
                                    Text('10 minutes'.tr, style: TextStyle(color: blackColor.withValues(alpha: 0.6), fontSize: util.fontSize12)),
                                    const SizedBox(height: 8),
                                    Text('${start.time} – ${end.time}', style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize13)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _stepper(MyUtility util) {
    const titles = ['Step 1', 'Step 2', 'Step 3'];
    const captions = ['Login', 'Birth details', 'Pay'];
    return Container(
      width: double.infinity,
      color: const Color(0xffE7F6E3),
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(3, (index) {
          final number = index + 1;
          final done = number < step;
          final active = number == step;
          final on = active || done;
          Color line(bool show, bool lit) {
            if (!show) return const Color(0x00000000);
            return lit ? mainColor : blackColor.withValues(alpha: 0.1);
          }

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Container(height: 2, color: line(index > 0, step > index))),
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: on ? mainColor : whiteColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: on ? mainColor : blackColor.withValues(alpha: 0.15), width: 2),
                        boxShadow: on ? [BoxShadow(color: mainColor.withValues(alpha: 0.28), blurRadius: 12, offset: const Offset(0, 4))] : null,
                      ),
                      child: Text(
                        done ? '✓' : '$number',
                        style: TextStyle(color: on ? whiteColor : blackColor.withValues(alpha: 0.4), fontFamily: AppFont.get(FontType.bold), fontSize: 13),
                      ),
                    ),
                    Expanded(child: Container(height: 2, color: line(index < 2, step > index + 1))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(titles[index].tr, style: TextStyle(fontSize: util.fontSize11, color: on ? mainColor : blackColor.withValues(alpha: 0.4), fontFamily: AppFont.get(FontType.semiBold))),
                Text(captions[index].tr, style: TextStyle(fontSize: util.fontSize10, color: blackColor.withValues(alpha: 0.55))),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _body(MyUtility util, Map<String, dynamic>? clash) {
    if (step == 1) return _login(util);
    if (step == 2) return _profile(util);
    return _payment(util, clash);
  }

  Widget _login(MyUtility util) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Login'.tr, style: TextStyle(fontFamily: AppFont.get(FontType.bold), fontSize: util.fontSize18)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: blackColor.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              _tab('Mobile'.tr, !emailTab, () => setState(() { emailTab = false; otpSent = false; })),
              _tab('Email'.tr, emailTab, () => setState(() { emailTab = true; otpSent = false; })),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (emailTab)
          TextField(
            controller: contact,
            enabled: !otpSent,
            keyboardType: TextInputType.emailAddress,
            decoration: _hintField('Enter Email'.tr),
          )
        else
          Row(
            children: [
              _dialPicker(locked: otpSent),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: contact,
                  enabled: !otpSent,
                  keyboardType: TextInputType.phone,
                  decoration: _hintField('Enter Mobile Number'.tr),
                ),
              ),
            ],
          ),
        if (!otpSent) ...[
          if (error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(error, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red))),
          const SizedBox(height: 16),
          _green('Continue'.tr, _sendOtp),
        ],
        if (otpSent) ...[
          const SizedBox(height: 16),
          Text(
            'We have sent OTP to @contact'.trParams({'contact': emailTab ? contact.text.trim() : '$dialCode ${contact.text.trim()}'}),
            textAlign: TextAlign.center,
            style: TextStyle(color: blackColor.withValues(alpha: 0.6)),
          ),
          Text('OTP is valid for 5 Minutes.'.tr, textAlign: TextAlign.center, style: TextStyle(color: blackColor.withValues(alpha: 0.6))),
          const SizedBox(height: 12),
          _otpBoxes(),
          if (error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(error, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red))),
          const SizedBox(height: 16),
          _green('Continue'.tr, _confirmOtp),
          TextButton(onPressed: _sendOtp, child: Text('Resend OTP'.tr, style: TextStyle(color: mainColor, fontFamily: AppFont.get(FontType.semiBold)))),
        ],
      ],
    );
  }

  Widget _profile(MyUtility util) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Birth details'.tr, style: TextStyle(fontFamily: AppFont.get(FontType.bold), fontSize: util.fontSize18)),
        const SizedBox(height: 6),
        Text('Add your name, date of birth, time of birth, and place of birth to continue.'.tr, style: TextStyle(color: blackColor.withValues(alpha: 0.6))),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: TextField(controller: first, decoration: _field('First name'.tr))),
          const SizedBox(width: 8),
          Expanded(child: TextField(controller: last, decoration: _field('Last name'.tr))),
        ]),
        const SizedBox(height: 8),
        TextField(controller: dob, readOnly: true, onTap: _pickDate, decoration: _field('Date of birth'.tr)),
        const SizedBox(height: 8),
        TextField(controller: tob, readOnly: true, onTap: _pickTime, decoration: _field('Time of birth'.tr)),
        const SizedBox(height: 8),
        TextField(controller: birth, decoration: _field('Place of birth'.tr)),
        const SizedBox(height: 8),
        TextField(controller: current, decoration: _field('Current location'.tr)),
        const SizedBox(height: 8),
        Text(
          needsEmail
              ? 'Verify your email. Your meeting link is sent there.'.tr
              : 'Phone is optional. Your meeting link is sent to your email.'.tr,
          style: TextStyle(color: blackColor.withValues(alpha: 0.6)),
        ),
        if (needsEmail) ..._emailVerify() else ..._phoneVerify(),
        if (error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(error, style: const TextStyle(color: Colors.red))),
        const SizedBox(height: 16),
        _green('Continue'.tr, _saveProfile),
      ],
    );
  }

  List<Widget> _feeSummary(MyUtility util) {
    final parts = marathonFeeAdded(payBase ?? 0, payCurrency);
    Widget line(String label, String value, {bool bold = false}) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            Expanded(child: Text(label, style: TextStyle(color: blackColor.withValues(alpha: 0.6), fontSize: util.fontSize13))),
            Text(
              value,
              style: TextStyle(
                fontFamily: AppFont.get(bold ? FontType.bold : FontType.semiBold),
                fontSize: bold ? util.fontSize16 : util.fontSize13,
              ),
            ),
          ],
        ),
      );
    }

    return [
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Payment summary'.tr,
            textAlign: TextAlign.left,
            style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize14, color: blackColor),
          ),
        ),
      ),
      line('Consultation fee'.tr, _fmt(parts.base)),
      if (parts.taxed) line('${'CGST'.tr} (${parts.cgstPct}%)', _fmt(parts.cgst)),
      if (parts.taxed) line('${'SGST'.tr} (${parts.sgstPct}%)', _fmt(parts.sgst)),
      line('Total'.tr, _fmt(parts.total), bold: true),
    ];
  }

  Widget _payment(MyUtility util, Map<String, dynamic>? clash) {
    final rawId = clash?['id'];
    final bookingId = rawId is int ? rawId : int.tryParse('$rawId') ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Pay'.tr, style: TextStyle(fontFamily: AppFont.get(FontType.bold), fontSize: util.fontSize18)),
        const SizedBox(height: 6),
        Text(event?['name']?.toString() ?? '', style: TextStyle(color: blackColor.withValues(alpha: 0.6))),
        if (payBase != null) ..._feeSummary(util),
        const SizedBox(height: 8),
        Text(
          clash != null
              ? 'You already have a consultation at this time.'.tr
              : 'Your astrologer will be assigned and the meeting link will be shared within 8 hours.'.tr,
          style: TextStyle(color: blackColor.withValues(alpha: 0.6)),
        ),
        if (clash == null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'You can also contact us immediately for inquiries through WhatsApp after payment.'.tr,
              style: TextStyle(color: blackColor.withValues(alpha: 0.6)),
            ),
          ),
        if (error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(error, style: const TextStyle(color: Colors.red))),
        const SizedBox(height: 16),
        clash != null
            ? _green('View booking'.tr, () => Get.off(() => MarathonSummaryPage(bookingId: bookingId)))
            : _green('Pay & Book Session'.tr, _pay),
      ],
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: now,
    );
    if (picked == null) return;
    final month = picked.month.toString().padLeft(2, '0');
    final day = picked.day.toString().padLeft(2, '0');
    setState(() => dob.text = '${picked.year}-$month-$day');
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 6, minute: 0));
    if (picked == null) return;
    final hour = picked.hour.toString().padLeft(2, '0');
    final minute = picked.minute.toString().padLeft(2, '0');
    setState(() => tob.text = '$hour:$minute');
  }

  List<Widget> _emailVerify() {
    return [
      const SizedBox(height: 8),
      TextField(
        controller: emailContact,
        enabled: !emailVerified,
        keyboardType: TextInputType.emailAddress,
        decoration: _field('Email'.tr),
      ),
      if (emailOtpSent && !emailVerified) ...[
        const SizedBox(height: 8),
        Text('We have sent OTP to @contact'.trParams({'contact': emailContact.text.trim()}), textAlign: TextAlign.center),
        Text('OTP is valid for 5 Minutes.'.tr, textAlign: TextAlign.center, style: TextStyle(color: blackColor.withValues(alpha: 0.6))),
        const SizedBox(height: 8),
        TextField(
          controller: emailOtp,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(LoginConstants.otpLength)],
          decoration: _field(''),
        ),
        const SizedBox(height: 8),
        _green('Confirm'.tr, _confirmEmail),
      ] else if (!emailVerified)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: _green('Verify'.tr, _sendEmail),
        ),
    ];
  }

  Future<void> _sendEmail() async {
    final value = emailContact.text.trim();
    if (value.isEmpty || !value.contains('@')) return;
    final result = await ProfileService().profileVerify('email', value);
    if (!mounted) return;
    if (result['error'] != null) {
      setState(() => error = '${result['error']}');
      return;
    }
    setState(() {
      error = '';
      emailOtpSent = true;
    });
  }

  Future<void> _confirmEmail() async {
    if (emailOtp.text.trim().length != LoginConstants.otpLength) {
      setState(() => error = 'Enter the code we sent you.'.tr);
      return;
    }
    final result = await ProfileService().profileVerifyOtp('email', emailContact.text.trim(), emailOtp.text.trim(), true);
    if (!mounted) return;
    if (result != 'success') {
      setState(() => error = 'That code is incorrect or has expired. Try again.'.tr);
      return;
    }
    setState(() {
      error = '';
      emailVerified = true;
      needsEmail = false;
    });
  }

  List<Widget> _phoneVerify() {
    final code = dialCode.replaceAll(RegExp(r'\D'), '');
    return [
      const SizedBox(height: 8),
      Row(
        children: [
          _dialPicker(locked: phoneVerified),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: phoneContact,
              enabled: !phoneVerified,
              keyboardType: TextInputType.phone,
              decoration: _field('Phone Number'.tr),
            ),
          ),
          if (!phoneVerified) ...[
            const SizedBox(width: 8),
            FilledButton(
              onPressed: phoneOtpSent ? _confirmPhone : _sendPhone,
              style: FilledButton.styleFrom(
                backgroundColor: mainColor,
                foregroundColor: whiteColor,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(phoneOtpSent ? 'Confirm'.tr : 'Verify'.tr, style: TextStyle(fontFamily: AppFont.get(FontType.bold))),
            ),
          ],
        ],
      ),
      if (phoneOtpSent && !phoneVerified) ...[
        const SizedBox(height: 8),
        Text(
          'We have sent OTP to @contact'.trParams({'contact': '+$code ${phoneContact.text.trim()}'}),
          textAlign: TextAlign.center,
          style: TextStyle(color: blackColor.withValues(alpha: 0.6)),
        ),
        Text('OTP is valid for 5 Minutes.'.tr, textAlign: TextAlign.center, style: TextStyle(color: blackColor.withValues(alpha: 0.6))),
        const SizedBox(height: 8),
        TextField(
          controller: phoneOtp,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(LoginConstants.otpLength)],
          decoration: _field(''),
        ),
      ],
    ];
  }

  Future<void> _sendPhone() async {
    final digits = phoneContact.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return;
    final code = dialCode.replaceAll(RegExp(r'\D'), '');
    final result = await ProfileService().profileVerify('mobile_number', digits, countryCode: code);
    if (!mounted) return;
    if (result['error'] != null) {
      setState(() => error = '${result['error']}');
      return;
    }
    setState(() {
      error = '';
      phoneOtpSent = true;
    });
  }

  Future<void> _confirmPhone() async {
    if (phoneOtp.text.trim().length != LoginConstants.otpLength) {
      setState(() => error = 'Enter the code we sent you.'.tr);
      return;
    }
    final digits = phoneContact.text.replaceAll(RegExp(r'\D'), '');
    final code = dialCode.replaceAll(RegExp(r'\D'), '');
    final result = await ProfileService().profileVerifyOtp('mobile_number', digits, phoneOtp.text.trim(), true, countryCode: code);
    if (!mounted) return;
    if (result != 'success') {
      setState(() => error = 'That code is incorrect or has expired. Try again.'.tr);
      return;
    }
    setState(() {
      error = '';
      phoneVerified = true;
    });
  }

  Future<void> _openCountryPicker() async {
    CustomLoader.show(context);
    try {
      if (countries.isEmpty) {
        countries = await CountryCodeService().fetchCountries();
      }
      CustomLoader.hide();
      if (!mounted) return;
      final result = await showDialog<Map<String, String>>(
        context: context,
        builder: (_) => CountryDropdownDialog(countries: countries),
      );
      if (result == null || !mounted) return;
      setState(() {
        dialCode = result['dialCode'] ?? LoginConstants.defaultDialCode;
        countryFlag = result['countryFlag'];
      });
    } catch (_) {
      CustomLoader.hide();
      if (!mounted) return;
      showErrorSnackBar(context, 'Error in Fetching Country code'.tr);
    }
  }

  Widget _dialPicker({required bool locked}) {
    return GestureDetector(
      onTap: locked ? null : _openCountryPicker,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: blackColor.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (countryFlag != null && countryFlag!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Image.network(
                  countryFlag!,
                  width: 22,
                  height: 16,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            Text(dialCode, style: TextStyle(fontFamily: AppFont.get(FontType.bold), fontSize: 16, color: blackColor)),
            Icon(Icons.keyboard_arrow_down_rounded, color: blackColor.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }

  Widget _otpBoxes() {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(LoginConstants.otpLength, (index) {
              final filled = index < otp.text.length;
              return Container(
                width: 44,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: filled ? mainColor : blackColor.withValues(alpha: 0.1), width: 2),
                ),
                child: Text(
                  filled ? otp.text[index] : '',
                  style: TextStyle(fontFamily: AppFont.get(FontType.bold), fontSize: 18, color: blackColor),
                ),
              );
            }),
          ),
          TextField(
            controller: otp,
            keyboardType: TextInputType.number,
            showCursor: false,
            enableInteractiveSelection: false,
            style: const TextStyle(color: Colors.transparent),
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
              filled: true,
              fillColor: Color(0x00000000),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(LoginConstants.otpLength)],
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _tab(String label, bool on, VoidCallback tap) {
    return Expanded(
      child: InkWell(
        onTap: tap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: on ? mainColor : const Color(0x00000000),
            borderRadius: BorderRadius.circular(8),
            boxShadow: on ? [BoxShadow(color: mainColor.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(0, 1))] : null,
          ),
          child: Text(label, style: TextStyle(color: on ? whiteColor : blackColor.withValues(alpha: 0.5), fontFamily: AppFont.get(FontType.semiBold))),
        ),
      ),
    );
  }

  InputDecoration _hintField(String hint) {
    final side = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: blackColor.withValues(alpha: 0.08)),
    );
    return InputDecoration(
      hintText: hint.isEmpty ? null : hint,
      filled: true,
      fillColor: whiteColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: side,
      enabledBorder: side,
      focusedBorder: side.copyWith(borderSide: const BorderSide(color: mainColor)),
    );
  }

  InputDecoration _field(String label) {
    return InputDecoration(
      labelText: label.isEmpty ? null : label,
      filled: true,
      fillColor: whiteColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: blackColor.withValues(alpha: 0.1))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: blackColor.withValues(alpha: 0.1))),
    );
  }

  Widget _green(String label, VoidCallback tap) {
    return FilledButton(
      onPressed: tap,
      style: FilledButton.styleFrom(
        backgroundColor: mainColor,
        foregroundColor: whiteColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: const StadiumBorder(),
      ),
      child: Text(label, style: TextStyle(fontFamily: AppFont.get(FontType.bold))),
    );
  }
}
