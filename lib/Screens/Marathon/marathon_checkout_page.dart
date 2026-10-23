import 'package:astro_prompt/Components/Common/customCountryDropDown.dart';
import 'package:astro_prompt/Components/Consultation-User/LanguageDropDown.dart';
import 'package:astro_prompt/Components/Marathon/marathon_event_banner.dart';
import 'package:astro_prompt/Components/Marathon/marathon_flow_widgets.dart';
import 'package:astro_prompt/Model/country_model.dart';
import 'package:astro_prompt/Model/location_selection_model.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_fee.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_slots.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_summary_page.dart';
import 'package:astro_prompt/Services/Analytics/installAttributionService.dart';
import 'package:astro_prompt/Services/AuthService/authService.dart';
import 'package:astro_prompt/Services/countryService/countryCodeService.dart';
import 'package:astro_prompt/Services/Marathon/marathon_service.dart';
import 'package:astro_prompt/Services/PlacesService/googlePlacesApiService.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/Helper/display_timezone.dart';
import 'package:astro_prompt/config/Helper/profile_currency.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/name.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:astro_prompt/config/LocallySavedData/timezone.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart';
import 'package:astro_prompt/config/LocallySavedData/userType.dart';
import 'package:astro_prompt/config/ask_astrologer_config.dart';
import 'package:astro_prompt/config/login_constants.dart';
import 'package:astro_prompt/config/otp_contact_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  final GooglePlacesService _places = GooglePlacesService();
  late Razorpay _razorpay;
  Map<String, dynamic>? event;
  List<Map<String, dynamic>> mine = [];

  /// Starts on the slot picked from the list. Step 2 lets the user change it.
  late int slotId = widget.slotId;
  int step = 1;
  bool loading = true;
  String error = '';
  String queryError = '';
  bool emailTab = false;
  bool otpSent = false;
  final contact = TextEditingController();
  String dialCode = LoginConstants.defaultDialCode;
  String? countryFlag;
  List<Country> countries = [];
  final otp = TextEditingController();
  final otpFocus = FocusNode();
  bool otpFocused = false;
  final first = TextEditingController();
  final last = TextEditingController();
  final dob = TextEditingController();
  final tob = TextEditingController();
  final birth = TextEditingController();
  final current = TextEditingController();
  String birthFull = '';
  String currentFull = '';
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
  final query = TextEditingController();
  String customerQuery = '';
  String preferredLanguage = '';
  String languageError = '';
  String? viewerZone;
  bool forOthers = false;
  List<Map<String, dynamic>> relatedPeople = [];
  int? selectedRelatedId;
  bool addingRelated = false;
  String relationship = '';
  String relationshipError = '';
  String relatedBaseline = '';
  UserProfile? ownerProfile;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
    otpFocus.addListener(() {
      if (!mounted) return;
      setState(() => otpFocused = otpFocus.hasFocus);
    });
    loadViewerTimezone().then((zone) {
      if (mounted) setState(() => viewerZone = zone);
    });
    _load();
  }

  @override
  void dispose() {
    _razorpay.clear();
    contact.dispose();
    otp.dispose();
    otpFocus.dispose();
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
    query.dispose();
    super.dispose();
  }

  void _fill(UserProfile profile) {
    first.text = profile.firstName;
    last.text = profile.lastName;
    dob.text = profile.dateOfBirth.split('T').first;
    tob.text = profile.timeOfBirth.length >= 5 ? profile.timeOfBirth.substring(0, 5) : profile.timeOfBirth;
    birth.text = profile.birthLocation;
    current.text = profile.preferredLocation;
    birthFull = profile.birthLocation;
    currentFull = profile.preferredLocation;
  }

  void _fillVerifiedContact(UserProfile profile) {
    final email = profile.email.trim();
    final mobile = profile.mobileNumber.trim();
    final emailReady = profile.emailVerified && email.isNotEmpty;
    final phoneReady = profile.mobileVerified && mobile.isNotEmpty;
    needsEmail = !(emailReady && !phoneReady);
    emailContact.text = emailReady ? email : emailContact.text;
    emailVerified = emailReady;
    if (phoneReady) {
      phoneContact.text = mobile;
      phoneVerified = true;
      final code = profile.countryCode.replaceAll(RegExp(r'\D'), '');
      if (code.isNotEmpty) dialCode = '+$code';
    }
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
          ownerProfile = profile;
          _fill(profile);
          _fillVerifiedContact(profile);
          _rememberFee(profile, row);
        }
        relatedPeople = await _service.relatedProfiles();
        // Always collect birth details + required customer query before pay.
        next = 2;
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
      if (parsed == slotId) return slot;
    }
    return null;
  }

  /// Same session fields the normal login screen stores, so home stays signed in as a customer.
  Future<void> _rememberLogin(Map<String, dynamic> result) async {
    final rawType = '${result['user_type'] ?? ''}'.trim().toLowerCase();
    final isCustomer = rawType.isEmpty || rawType == 'customer';
    final rawId = result['userId'];
    final userId = rawId is int ? rawId : int.tryParse('$rawId');
    if (userId != null) {
      await saveUserId(userId);
      await InstallAttributionService.instance.onLoginSuccess(userId: '$userId');
    }
    await saveUserName('${result['name'] ?? ''}');
    await saveLastName('${result['lastName'] ?? ''}');
    await saveUserType(isCustomer);
    if (result['premiumUser'] is bool) {
      await savePremiumUser(result['premiumUser'] as bool);
    }
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) otpFocus.requestFocus();
    });
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
    await _rememberLogin(result);
    final profile = await ProfileService().fetchUserProfile();
    if (profile != null) {
      ownerProfile = profile;
      _fill(profile);
      _fillVerifiedContact(profile);
      if (event != null) _rememberFee(profile, event!);
    }
    relatedPeople = await _service.relatedProfiles();
    await _refreshBookings();
    if (!mounted) return;
    // Always collect birth details / query / language on step 2 before pay.
    setState(() => step = 2);
  }

  String _languageId(String label) {
    final match = AskAstrologerLanguages.options.firstWhere(
      (o) => o['label']!.tr == label || o['label'] == label || o['native'] == label,
      orElse: () => {'id': label.toLowerCase(), 'label': label},
    );
    return match['id']!;
  }

  String? _languageDisplay(String id) {
    if (id.isEmpty) return null;
    final label = AskAstrologerLanguages.labelFor(id);
    return label.tr;
  }

  static const _relatedProfileLimit = 3;
  static const _relationships = <String, String>{
    'spouse': 'Spouse',
    'brother': 'Brother',
    'sister': 'Sister',
    'father': 'Father',
    'mother': 'Mother',
    'son': 'Son',
    'daughter': 'Daughter',
    'friend': 'Friend',
    'other': 'Others',
  };

  bool get _showBirth => true;

  bool get _profileReady {
    final profile = ownerProfile;
    if (profile == null) return false;
    return profile.firstName.trim().isNotEmpty &&
        profile.dateOfBirth.trim().isNotEmpty &&
        profile.timeOfBirth.trim().isNotEmpty &&
        profile.birthLocation.trim().isNotEmpty;
  }

  String _relatedFingerprint() {
    return '${first.text}|${last.text}|${dob.text}|${tob.text}|$birthFull|$currentFull|$relationship';
  }

  Map<String, dynamic> _relatedBody() {
    final clock = tob.text.trim().length == 5 ? '${tob.text.trim()}:00' : tob.text.trim();
    return {
      'first_name': first.text.trim(),
      'last_name': last.text.trim(),
      'date_of_birth': dob.text.trim(),
      'time_of_birth': clock,
      'place_of_birth': birthFull.trim().isNotEmpty ? birthFull.trim() : birth.text.trim(),
      'preferred_location': currentFull.trim().isNotEmpty ? currentFull.trim() : current.text.trim(),
      'relationship': relationship,
    };
  }

  void _clearBirth() {
    first.clear();
    last.clear();
    dob.clear();
    tob.clear();
    birth.clear();
    current.clear();
    birthFull = '';
    currentFull = '';
    relationship = '';
    relatedBaseline = '';
  }

  void _applyRelated(Map<String, dynamic> person) {
    final place = '${person['place_of_birth'] ?? ''}';
    final where = '${person['preferred_location'] ?? ''}';
    final clock = '${person['time_of_birth'] ?? ''}';
    selectedRelatedId = person['id'] is int ? person['id'] as int : int.tryParse('${person['id']}');
    addingRelated = false;
    first.text = '${person['first_name'] ?? ''}';
    last.text = '${person['last_name'] ?? ''}';
    dob.text = '${person['date_of_birth'] ?? ''}'.split('T').first;
    tob.text = clock.length >= 5 ? clock.substring(0, 5) : clock;
    birth.text = place;
    current.text = where;
    birthFull = place;
    currentFull = where;
    relationship = '${person['relationship'] ?? ''}';
    relatedBaseline = _relatedFingerprint();
  }

  void _chooseSelf() {
    setState(() {
      forOthers = false;
      selectedRelatedId = null;
      addingRelated = false;
      relationship = '';
      relationshipError = '';
      error = '';
      if (ownerProfile != null) _fill(ownerProfile!);
    });
  }

  void _chooseOthers() {
    setState(() {
      forOthers = true;
      selectedRelatedId = null;
      addingRelated = relatedPeople.isEmpty;
      relationshipError = '';
      error = '';
      _clearBirth();
    });
  }

  Future<void> _saveProfile() async {
    setState(() {
      error = '';
      queryError = '';
      languageError = '';
      relationshipError = '';
    });
    if (first.text.trim().isEmpty || last.text.trim().isEmpty || dob.text.trim().isEmpty || tob.text.trim().isEmpty || birth.text.trim().isEmpty || current.text.trim().isEmpty) {
      setState(() => error = forOthers
          ? 'Add their birth details to continue.'.tr
          : 'Add your name, date of birth, time of birth, and place of birth to continue.'.tr);
      return;
    }
    if (forOthers && relationship.trim().isEmpty) {
      setState(() => relationshipError = 'Select a relationship.'.tr);
      return;
    }
    if (needsEmail && !emailVerified) {
      setState(() => error = 'Please verify your Email'.tr);
      return;
    }
    if (preferredLanguage.trim().isEmpty) {
      setState(() => languageError = 'Select your preferred consultation language.'.tr);
      return;
    }
    final asked = query.text.trim();
    if (asked.isEmpty) {
      setState(() => queryError = 'Enter your question before payment.'.tr);
      return;
    }
    if (!forOthers || !_profileReady) {
      final saved = await ProfileService().updateProfile({
        'first_name': first.text.trim(),
        'last_name': last.text.trim(),
        'date_of_birth': dob.text.trim(),
        'time_of_birth': tob.text.trim().length == 5 ? '${tob.text.trim()}:00' : tob.text.trim(),
        'birth_location': birthFull.trim().isNotEmpty ? birthFull.trim() : birth.text.trim(),
        'preferred_location': currentFull.trim().isNotEmpty
            ? currentFull.trim()
            : (current.text.trim().isEmpty
                ? (birthFull.trim().isNotEmpty ? birthFull.trim() : birth.text.trim())
                : current.text.trim()),
      });
      if (!mounted) return;
      if (saved['success'] != true) {
        setState(() => error = '${saved['error'] ?? ''}');
        return;
      }
      final profile = await ProfileService().fetchUserProfile();
      if (profile != null) {
        ownerProfile = profile;
        if (event != null) _rememberFee(profile, event!);
      }
      final tzFromSave = saved['data'] is Map ? saved['data']['timezone']?.toString() : null;
      if (tzFromSave != null && tzFromSave.trim().isNotEmpty) {
        await saveTimezone(tzFromSave.trim());
      }
      selectedRelatedId = null;
    } else {
      try {
        final body = _relatedBody();
        if (selectedRelatedId == null) {
          if (relatedPeople.length >= _relatedProfileLimit) {
            setState(() => error = 'You can add only 3 people.'.tr);
            return;
          }
          final created = await _service.createRelated(body);
          selectedRelatedId = created['id'] is int ? created['id'] as int : int.tryParse('${created['id']}');
        } else if (_relatedFingerprint() != relatedBaseline) {
          await _service.updateRelated(selectedRelatedId!, body);
        }
        relatedPeople = await _service.relatedProfiles();
        relatedBaseline = _relatedFingerprint();
      } catch (err) {
        if (!mounted) return;
        setState(() => error = err.toString().replaceFirst('Exception: ', ''));
        return;
      }
    }
    final zone = await loadViewerTimezone();
    await _refreshBookings();
    if (!mounted) return;
    setState(() {
      error = '';
      customerQuery = asked;
      viewerZone = zone;
      step = 3;
    });
  }

  Future<void> _pay() async {
    setState(() {
      error = '';
      queryError = '';
      languageError = '';
    });
    if (preferredLanguage.trim().isEmpty) {
      setState(() {
        languageError = 'Select your preferred consultation language.'.tr;
        step = 2;
      });
      return;
    }
    if (customerQuery.trim().isEmpty) {
      setState(() {
        queryError = 'Enter your question before payment.'.tr;
        step = 2;
      });
      return;
    }
    CustomLoader.show(context);
    try {
      final profile = await ProfileService().fetchUserProfile();
      final currency = ProfileCurrency.fromProfile(profile);
      final order = await _service.checkout(
        slotId,
        currency: currency,
        customerQuery: customerQuery.trim(),
        preferredLanguage: preferredLanguage.trim(),
        relatedProfileId: forOthers ? selectedRelatedId : null,
      );
      CustomLoader.hide();
      _razorpay.open({
        'key': order['key'],
        'amount': order['amount'],
        'currency': order['currency'],
        'order_id': order['id'],
        'name': 'Teksage',
        'description': event?['name']?.toString() ?? 'Teksage Expert Hours',
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
    Map<String, dynamic>? clash;
    for (final row in mine) {
      if (_overlaps(row)) {
        clash = row;
        break;
      }
    }
    final ended = event?['admin_ended'] == true;
    final blocks = <Widget>[
      if (event == null && error.isNotEmpty) Text(error, style: const TextStyle(color: Colors.red)),
      if (ended)
        MarathonCard(
          child: Text('Event ended by admin'.tr, style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.6))),
        ),
      if (event != null && !ended) ..._stepBlocks(util, clash),
    ];
    return Scaffold(
      backgroundColor: marathonPageBg,
      body: Column(
        children: [
          MarathonFlowBar(
            title: event == null ? 'Teksage Expert Hours'.tr : marathonDisplayName(event?['name']?.toString()).tr,
            onBack: () => Get.back(),
            steps: ['Login'.tr, 'Time Slot & Birth Details'.tr, 'Payment'.tr],
            step: step,
            onStep: (number) {
              // From Payment only, allow opening Birth details — never Login again.
              if (number != 2 || step != 3) return;
              setState(() {
                step = 2;
                if (customerQuery.isNotEmpty) query.text = customerQuery;
              });
            },
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator(color: mainColor))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    itemCount: blocks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, index) => blocks[index],
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _stepBlocks(MyUtility util, Map<String, dynamic>? clash) {
    if (step == 1) {
      return [MarathonCard(child: _login(util))];
    }
    if (step == 2) {
      return [_timeCard(util), MarathonCard(child: _profile(util)), _aside(util, clash)];
    }
    return [..._review(util), _aside(util, clash)];
  }

  int _slotMinutes(Map<String, dynamic>? slot) {
    final start = DateTime.tryParse('${slot?['starts_at'] ?? ''}');
    final end = DateTime.tryParse('${slot?['ends_at'] ?? ''}');
    if (start == null || end == null) return 0;
    final minutes = end.difference(start).inMinutes;
    return minutes > 0 ? minutes : 0;
  }

  String _titleMonth(String month) {
    if (month.isEmpty) return month;
    return '${month[0]}${month.substring(1).toLowerCase()}';
  }

  /// Time card on step 2: pick or change the slot before paying.
  Widget _timeCard(MyUtility util) {
    final slots = List<Map<String, dynamic>>.from(event?['slots'] ?? []);
    final current = _slot ?? (slots.isEmpty ? null : slots.first);
    final when = marathonWallDetail('${current?['starts_at'] ?? event?['starts_at'] ?? ''}', zone: viewerZone)?.shortDay ?? '';
    final booked = marathonBookedSlotIds(event, mine);
    final shut = event?['booking_open'] != true || event?['admin_ended'] == true;
    return MarathonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose a time – @when'.trParams({'when': when}), style: marathonText(util, FontType.bold, size: util.fontSize18, height: 1.3)),
          const SizedBox(height: 4),
          Text(
            'Each one-to-one slot is @minutes.'.trParams({'minutes': '15 minutes'.tr}),
            style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in slots)
                () {
                  final id = marathonInt(item['id']);
                  final left = marathonInt(item['seats_left']);
                  final mineBooked = booked.contains(id);
                  final full = left == 0;
                  final taken = mineBooked || full;
                  final open = !taken && !shut;
                  final selected = slotId == id && open;
                  final low = open && !selected && left <= marathonLowSeats;
                  final label = mineBooked || full
                      ? 'Booked'.tr
                      : shut
                          ? 'Closed'.tr
                          : '@count seats'.trParams({'count': '$left'});
                  final time = marathonWallParts('${item['starts_at']}', zone: viewerZone)?.time ?? '';
                  return MarathonSlotPill(
                    time: time.replaceAll('AM', 'am').replaceAll('PM', 'pm'),
                    label: label,
                    selected: selected,
                    low: low,
                    booked: taken,
                    open: open,
                    onTap: () => setState(() => slotId = id),
                  );
                }(),
            ],
          ),
        ],
      ),
    );
  }

  /// Booking summary on step 2, payment summary on step 3.
  Widget _aside(MyUtility util, Map<String, dynamic>? clash) {
    final slot = _slot;
    final start = marathonWallDetail(slot?['starts_at']?.toString(), zone: viewerZone);
    final end = marathonWallDetail(slot?['ends_at']?.toString(), zone: viewerZone);
    final minutes = _slotMinutes(slot);
    final minutesLabel = minutes > 0 ? '@count min'.trParams({'count': '$minutes'}) : '15 minutes'.tr;
    final parts = marathonFeeAdded(payBase ?? double.tryParse('${event?['fee']}') ?? 0, payCurrency);
    final name = marathonDisplayName(event?['name']?.toString()).tr;
    final range = start != null && end != null ? marathonTimeRange(start.time, end.time) : '';
    final dateLine = start == null ? '' : '${start.weekday}, ${start.day} ${_titleMonth(start.month)}';
    if (step != 3) {
      return MarathonSummaryCard(
        kicker: 'Booking summary'.tr,
        rows: [
          MarathonSummaryRow('Session'.tr, name),
          MarathonSummaryRow('Date'.tr, dateLine),
          MarathonSummaryRow('Time slot'.tr, range, accent: true),
          MarathonSummaryRow('Duration'.tr, minutesLabel),
          MarathonSummaryRow('Session fee'.tr, _fmt(parts.base)),
          if (parts.taxed) MarathonSummaryRow('${'CGST'.tr} ${parts.cgstPct}%', _fmt(parts.cgst)),
          if (parts.taxed) MarathonSummaryRow('${'SGST'.tr} ${parts.sgstPct}%', _fmt(parts.sgst)),
        ],
        totalLabel: 'Total'.tr,
        total: _fmt(parts.total),
        children: [
          MarathonNote(icon: Icons.verified_user_outlined, text: 'Your details are private and shared only with your assigned astrologer.'.tr),
        ],
      );
    }
    final rawId = clash?['id'];
    final bookingId = rawId is int ? rawId : int.tryParse('$rawId') ?? 0;
    return MarathonSummaryCard(
      kicker: 'Payment summary'.tr,
      lead: start == null
          ? null
          : Row(
              children: [
                MarathonDateTile(day: start.day, month: start.month),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: marathonText(util, FontType.bold)),
                      Text('$range · $minutesLabel', style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.5))),
                    ],
                  ),
                ),
              ],
            ),
      rows: [
        MarathonSummaryRow('Session fee'.tr, _fmt(parts.base)),
        if (parts.taxed) MarathonSummaryRow('${'CGST'.tr} ${parts.cgstPct}%', _fmt(parts.cgst)),
        if (parts.taxed) MarathonSummaryRow('${'SGST'.tr} ${parts.sgstPct}%', _fmt(parts.sgst)),
      ],
      totalLabel: 'Total'.tr,
      total: _fmt(parts.total),
      children: [
        if (clash != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'You already have a consultation at this time.'.tr,
              style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.55)),
            ),
          ),
        if (error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error, style: const TextStyle(color: Colors.red))),
        MarathonPlainNote(text: "You'll be taken to our secure payment partner · UPI, cards, net banking".tr),
        MarathonNote(icon: Icons.chat_bubble_outline_rounded, text: 'Questions after paying? Message us on WhatsApp right away.'.tr),
        const SizedBox(height: 16),
        MarathonPrimaryButton(
          wide: true,
          label: clash != null ? 'View booking'.tr : 'Pay & Book Session'.tr,
          onTap: clash != null ? () => Get.off(() => MarathonSummaryPage(bookingId: bookingId)) : _pay,
        ),
      ],
    );
  }

  /// Born line on the review: "Jun 19, 1970, 11:54 AM · Dindigul".
  String _bornLine() {
    final locale = Get.locale?.toString() ?? 'en_US';
    var date = '';
    final parsed = DateTime.tryParse(dob.text.trim().split('T').first);
    if (parsed != null) {
      try {
        date = DateFormat('MMM d, y', locale).format(parsed);
      } catch (_) {
        date = DateFormat('MMM d, y').format(parsed);
      }
    }
    var time = '';
    final match = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(tob.text.trim());
    if (match != null) {
      final hour = int.parse(match.group(1)!);
      final h12 = hour % 12 == 0 ? 12 : hour % 12;
      time = '$h12:${match.group(2)} ${hour >= 12 ? 'PM' : 'AM'}';
    }
    final when = [date, time].where((part) => part.isNotEmpty).join(', ');
    final place = (birthFull.trim().isNotEmpty ? birthFull : birth.text).trim();
    return [when, place].where((part) => part.isNotEmpty).join(' · ');
  }

  Widget _reviewItem(MyUtility util, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.4))),
        const SizedBox(height: 2),
        Text(value, style: marathonText(util, FontType.bold)),
      ],
    );
  }

  /// Step 3 cards: review of the booking and what happens after paying.
  List<Widget> _review(MyUtility util) {
    final name = '${first.text.trim()} ${last.text.trim()}'.trim();
    final relation = forOthers && relationship.isNotEmpty ? (_relationships[relationship] ?? relationship).tr : '';
    final readingFor = [name, relation].where((part) => part.isNotEmpty).join(' · ');
    final email = emailContact.text.trim().isNotEmpty ? emailContact.text.trim() : (ownerProfile?.email ?? '').trim();
    final steps = [
      ('Payment confirmed'.tr, 'You get an email for payment confirmation.'.tr),
      ('Astrologer assigned'.tr, 'Within 1 hour, based on your question and language.'.tr),
      ('Meeting link shared'.tr, 'Sent to your email about the invitation once astrologer assigned and also you can join through our app'.tr),
    ];
    final bubble = Color.alphaBlend(mainColor.withValues(alpha: 0.14), whiteColor);
    return [
      MarathonCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text('Review your booking'.tr, style: marathonText(util, FontType.bold, size: util.fontSize18, height: 1.3))),
                InkWell(
                  onTap: () => setState(() {
                    step = 2;
                    if (customerQuery.isNotEmpty) query.text = customerQuery;
                  }),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_outlined, size: 14, color: mainColor),
                      const SizedBox(width: 4),
                      Text('Edit'.tr, style: marathonText(util, FontType.semiBold, color: mainColor)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: marathonRowGray, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _reviewItem(util, 'Reading for'.tr, readingFor),
                  const SizedBox(height: 16),
                  _reviewItem(util, 'Born'.tr, _bornLine()),
                  const SizedBox(height: 16),
                  _reviewItem(util, 'Language'.tr, _languageDisplay(preferredLanguage) ?? preferredLanguage),
                  const SizedBox(height: 16),
                  _reviewItem(util, 'Meeting link to'.tr, email),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Your question'.tr, style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.4))),
            const SizedBox(height: 2),
            Text(customerQuery.trim(), style: marathonText(util, FontType.bold)),
          ],
        ),
      ),
      MarathonCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What happens next'.tr, style: marathonText(util, FontType.bold)),
            const SizedBox(height: 20),
            Stack(
              children: [
                Positioned(left: 11.5, top: 12, bottom: 12, width: 1, child: ColoredBox(color: blackColor.withValues(alpha: 0.1))),
                Column(
                  children: [
                    for (var index = 0; index < steps.length; index++)
                      Padding(
                        padding: EdgeInsets.only(top: index == 0 ? 0 : 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: bubble),
                              child: Text('${index + 1}', style: marathonText(util, FontType.semiBold, size: util.fontSize12, color: mainColor, height: 1)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(steps[index].$1, style: marathonText(util, FontType.bold)),
                                  Text(steps[index].$2, style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.55))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  Widget _login(MyUtility util) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Login'.tr, style: marathonText(util, FontType.bold)),
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
            'We have sent OTP to @contact'.trParams({
              'contact': emailTab
                  ? maskEmailForOtpDisplay(contact.text.trim())
                  : '$dialCode ${maskMobileForOtpDisplay(contact.text.trim())}',
            }),
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
    // Field titles are bold. Typed answers are semibold, same as chat text.
    final labelStyle = marathonText(util, FontType.bold);
    final hintStyle = marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.55));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Who is this reading for?'.tr, style: labelStyle),
        const SizedBox(height: 4),
        Text('The astrologer reads your chart from these details.'.tr, style: hintStyle),
        if (_profileReady) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: marathonRowGray, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Booking for someone else'.tr, style: marathonText(util, FontType.bold)),
                      Text("Turn on to enter a family member's or friend's details.".tr, style: hintStyle),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Switch(
                  value: forOthers,
                  onChanged: (on) => on ? _chooseOthers() : _chooseSelf(),
                  activeThumbColor: whiteColor,
                  activeTrackColor: mainColor,
                  inactiveThumbColor: whiteColor,
                  inactiveTrackColor: blackColor.withValues(alpha: 0.15),
                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ],
            ),
          ),
        ],
        if (forOthers) ...[
          const SizedBox(height: 12),
          Text('People you\'ve added before'.tr, style: labelStyle),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 176,
                child: InputDecorator(
                  decoration: _outline().copyWith(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      key: ValueKey(addingRelated ? 'new' : selectedRelatedId),
                      value: addingRelated ? null : selectedRelatedId,
                      isExpanded: true,
                      isDense: true,
                      menuWidth: MediaQuery.sizeOf(context).width - 32,
                      style: marathonText(util, FontType.semiBold),
                      hint: Text(
                        'Select'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.55)),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      selectedItemBuilder: (context) => [
                        for (final person in relatedPeople)
                          if (person['id'] is int || int.tryParse('${person['id']}') != null)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${person['display_name']} (${(_relationships['${person['relationship']}'] ?? '${person['relationship']}').tr})',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: marathonText(util, FontType.semiBold),
                              ),
                            ),
                      ],
                      items: [
                        for (final person in relatedPeople)
                          if (person['id'] is int || int.tryParse('${person['id']}') != null)
                            DropdownMenuItem<int>(
                              value: person['id'] is int ? person['id'] as int : int.parse('${person['id']}'),
                              child: Text(
                                '${person['display_name']} (${(_relationships['${person['relationship']}'] ?? '${person['relationship']}').tr})',
                              ),
                            ),
                      ],
                      onChanged: (id) {
                        Map<String, dynamic>? match;
                        for (final row in relatedPeople) {
                          final rowId = row['id'] is int ? row['id'] as int : int.tryParse('${row['id']}');
                          if (rowId == id) match = row;
                        }
                        if (match == null) return;
                        setState(() => _applyRelated(match!));
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {
                  if (relatedPeople.length >= _relatedProfileLimit) {
                    setState(() => error = 'You can add only 3 people.'.tr);
                    return;
                  }
                  setState(() {
                    error = '';
                    addingRelated = true;
                    selectedRelatedId = null;
                    _clearBirth();
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: addingRelated ? mainColor : blackColor.withValues(alpha: 0.7),
                  backgroundColor: addingRelated ? mainColor.withValues(alpha: 0.12) : whiteColor,
                  side: BorderSide(color: addingRelated ? mainColor : blackColor.withValues(alpha: 0.1)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  minimumSize: const Size(0, 48),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('Add new'.tr, style: marathonText(util, FontType.semiBold, color: addingRelated ? mainColor : blackColor.withValues(alpha: 0.7))),
              ),
            ],
          ),
        ],
        if (_showBirth) ...[
        const SizedBox(height: 16),
        _pairRow(
          _labeledInput(
            label: 'First name'.tr,
            labelStyle: labelStyle,
            child: TextField(controller: first, style: _inputStyle(util), decoration: _outline()),
          ),
          _labeledInput(
            label: 'Last name'.tr,
            labelStyle: labelStyle,
            child: TextField(controller: last, style: _inputStyle(util), decoration: _outline()),
          ),
        ),
        const SizedBox(height: 12),
        _pairRow(
          _labeledInput(
            label: 'Date of birth'.tr,
            labelStyle: labelStyle,
            child: TextField(
              controller: dob,
              readOnly: true,
              onTap: _pickDate,
              style: _inputStyle(util),
              decoration: _outline(suffix: Icon(Icons.calendar_today_outlined, size: 18, color: blackColor.withValues(alpha: 0.45))),
            ),
          ),
          _labeledInput(
            label: 'Time of birth'.tr,
            labelStyle: labelStyle,
            child: TextField(
              controller: tob,
              readOnly: true,
              onTap: _pickTime,
              style: _inputStyle(util),
              decoration: _outline(suffix: Icon(Icons.access_time_rounded, size: 20, color: blackColor.withValues(alpha: 0.45))),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _pairRow(
          _labeledInput(
            label: 'Place of birth'.tr,
            labelStyle: labelStyle,
            child: _locationField(
              util,
              birth,
              'City, e.g. Chennai'.tr,
              () => _pickLocation(
                title: 'Place of Birth'.tr,
                hint: 'Enter place of birth'.tr,
                controller: birth,
                onPicked: (location) {
                  setState(() {
                    birth.text = location.selectedText;
                    birthFull = location.displayText;
                  });
                },
              ),
            ),
          ),
          _labeledInput(
            label: 'Current Location'.tr,
            labelStyle: labelStyle,
            child: _locationField(
              util,
              current,
              'City you live in'.tr,
              () => _pickLocation(
                title: 'Current Location'.tr,
                hint: 'Enter Current location'.tr,
                controller: current,
                onPicked: (location) {
                  setState(() {
                    current.text = location.selectedText;
                    currentFull = location.displayText;
                  });
                },
              ),
            ),
          ),
        ),
        if (forOthers) ...[
          const SizedBox(height: 12),
          UserLanguageDropDown(
            title: 'Relationship to you'.tr,
            isMandatory: true,
            neutral: true,
            options: _relationships.values.map((label) => label.tr).toList(),
            selectedValue: relationship.isEmpty ? null : _relationships[relationship]?.tr,
            errorFlag: relationshipError.isNotEmpty,
            errorText: relationshipError.isEmpty ? null : relationshipError,
            onChanged: (label) {
              final code = _relationships.entries
                  .firstWhere((entry) => entry.value.tr == label || entry.value == label, orElse: () => const MapEntry('', ''))
                  .key;
              setState(() {
                relationship = code;
                relationshipError = '';
              });
            },
          ),
        ],
        ],
        const SizedBox(height: 12),
        if (needsEmail) ..._emailVerify(util, labelStyle) else ..._phoneVerify(util, labelStyle),
        const SizedBox(height: 12),
        UserLanguageDropDown(
          title: 'Preferred consultation language'.tr,
          isMandatory: true,
          neutral: true,
          options: AskAstrologerLanguages.choices.map((o) => o['label']!.tr).toList(),
          selectedValue: _languageDisplay(preferredLanguage),
          errorFlag: languageError.isNotEmpty,
          errorText: languageError.isEmpty ? null : languageError,
          onChanged: (label) {
            setState(() {
              preferredLanguage = _languageId(label);
              languageError = '';
            });
          },
        ),
        const SizedBox(height: 12),
        Text('Your question'.tr, style: labelStyle),
        if (queryError.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(queryError, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 6),
        TextField(
          controller: query,
          maxLines: 3,
          minLines: 3,
          style: _inputStyle(util),
          onChanged: (_) {
            if (queryError.isNotEmpty) setState(() => queryError = '');
          },
          decoration: _outline(
            hint: 'e.g. Is 2027 a good year to switch jobs?'.tr,
          ),
        ),
        if (error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(error, style: const TextStyle(color: Colors.red))),
        const SizedBox(height: 16),
        MarathonPrimaryButton(label: 'Continue'.tr, onTap: _saveProfile),
      ],
    );
  }

  Widget _pairRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }

  Widget _labeledInput({
    required String label,
    required TextStyle labelStyle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _locationField(MyUtility util, TextEditingController controller, String hint, VoidCallback onTap) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      style: _inputStyle(util),
      decoration: _outline(
        hint: hint,
        suffix: Icon(Icons.place_outlined, size: 18, color: blackColor.withValues(alpha: 0.45)),
      ),
    );
  }

  Future<void> _pickLocation({
    required String title,
    required String hint,
    required TextEditingController controller,
    required ValueChanged<LocationSelection> onPicked,
  }) async {
    final search = TextEditingController(text: controller.text);
    var locations = <Map<String, String>>[];

    Future<void> fetch(String query, void Function(void Function()) setModal) async {
      if (query.isEmpty) {
        setModal(() => locations = []);
        return;
      }
      try {
        final results = await _places.fetchPlaceSuggestions(query);
        setModal(() => locations = results);
      } catch (_) {
        setModal(() => locations = []);
      }
    }

    await showGeneralDialog<void>(
      context: context,
      barrierLabel: title,
      barrierDismissible: true,
      barrierColor: blackColor.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (dialogContext, _, __) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: StatefulBuilder(
              builder: (context, setModal) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.5,
                  margin: const EdgeInsets.only(top: 60, left: 12, right: 12),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: AppFont.get(FontType.bold),
                          fontSize: 16,
                          color: blackColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          controller: search,
                          autofocus: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\s,.'/-]")),
                          ],
                          onChanged: (query) {
                            setModal(() {});
                            fetch(query, setModal);
                          },
                          decoration: InputDecoration(
                            hintText: hint,
                            filled: true,
                            fillColor: whiteColor,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: mainColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: mainColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            suffixIcon: search.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      search.clear();
                                      fetch('', setModal);
                                      setModal(() {});
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: locations.length,
                          itemBuilder: (context, index) {
                            final row = locations[index];
                            return ListTile(
                              title: Text(row['displayText'] ?? ''),
                              onTap: () {
                                final selected = row['selectedText'] ?? '';
                                final display = row['displayText'] ?? '';
                                Navigator.of(dialogContext).pop();
                                onPicked(LocationSelection(selected, display));
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, -1), end: Offset.zero).animate(anim),
          child: child,
        );
      },
    );
    search.dispose();
  }

  TextStyle _inputStyle(MyUtility util) {
    return TextStyle(
      fontFamily: AppFont.get(FontType.semiBold),
      fontSize: util.fontSize14,
      color: blackColor,
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

  List<Widget> _emailVerify(MyUtility util, TextStyle labelStyle) {
    return [
      Text(
        forOthers && _profileReady
            ? 'Registered user email (not relationship email)'.tr
            : 'Email'.tr,
        style: labelStyle,
      ),
      const SizedBox(height: 6),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: emailContact,
              enabled: !emailVerified,
              keyboardType: TextInputType.emailAddress,
              style: _inputStyle(util),
              decoration: _outline(),
            ),
          ),
          if (emailVerified)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SvgPicture.asset(verified, width: 28, height: 28),
            )
          else ...[
            const SizedBox(width: 8),
            _verifyChip(emailOtpSent ? 'Confirm'.tr : 'Verify'.tr, emailOtpSent ? _confirmEmail : _sendEmail),
          ],
        ],
      ),
      const SizedBox(height: 6),
      Text(
        'Your meeting link is sent here.'.tr,
        style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize12, color: blackColor.withValues(alpha: 0.55), height: 1.35),
      ),
      if (emailOtpSent && !emailVerified) ...[
        const SizedBox(height: 8),
        Text('We have sent OTP to @contact'.trParams({'contact': maskEmailForOtpDisplay(emailContact.text.trim())}), textAlign: TextAlign.center, style: TextStyle(color: blackColor.withValues(alpha: 0.6), fontSize: util.fontSize13)),
        Text('OTP is valid for 5 Minutes.'.tr, textAlign: TextAlign.center, style: TextStyle(color: blackColor.withValues(alpha: 0.6), fontSize: util.fontSize13)),
        const SizedBox(height: 8),
        TextField(
          controller: emailOtp,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: _inputStyle(util),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(LoginConstants.otpLength)],
          decoration: _outline(),
        ),
      ],
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

  List<Widget> _phoneVerify(MyUtility util, TextStyle labelStyle) {
    final code = dialCode.replaceAll(RegExp(r'\D'), '');
    return [
      Text(
        forOthers && _profileReady
            ? 'Registered user contact number (not relationship contact)'.tr
            : 'Phone Number'.tr,
        style: labelStyle,
      ),
      const SizedBox(height: 6),
      Row(
        children: [
          _dialPicker(locked: phoneVerified),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: phoneContact,
              enabled: !phoneVerified,
              keyboardType: TextInputType.phone,
              style: _inputStyle(util),
              decoration: _outline(),
            ),
          ),
          if (phoneVerified)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SvgPicture.asset(verified, width: 28, height: 28),
            )
          else ...[
            const SizedBox(width: 8),
            _verifyChip(phoneOtpSent ? 'Confirm'.tr : 'Verify'.tr, phoneOtpSent ? _confirmPhone : _sendPhone),
          ],
        ],
      ),
      const SizedBox(height: 6),
      Text(
        'Phone is optional. Your meeting link is sent to your email.'.tr,
        style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize12, color: blackColor.withValues(alpha: 0.55), height: 1.35),
      ),
      if (phoneOtpSent && !phoneVerified) ...[
        const SizedBox(height: 8),
        Text(
          'We have sent OTP to @contact'.trParams({'contact': '+$code ${maskMobileForOtpDisplay(phoneContact.text)}'}),
          textAlign: TextAlign.center,
          style: TextStyle(color: blackColor.withValues(alpha: 0.6), fontSize: util.fontSize13),
        ),
        Text('OTP is valid for 5 Minutes.'.tr, textAlign: TextAlign.center, style: TextStyle(color: blackColor.withValues(alpha: 0.6), fontSize: util.fontSize13)),
        const SizedBox(height: 8),
        TextField(
          controller: phoneOtp,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: _inputStyle(util),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(LoginConstants.otpLength)],
          decoration: _outline(),
        ),
      ],
    ];
  }

  Widget _verifyChip(String label, VoidCallback onTap) {
    return SizedBox(
      height: 44,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: mainColor,
          foregroundColor: whiteColor,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label, style: TextStyle(fontFamily: AppFont.get(FontType.extraBold), fontSize: 13)),
      ),
    );
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
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: blackColor.withValues(alpha: 0.1)),
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
            Text(dialCode, style: TextStyle(fontFamily: AppFont.get(FontType.bold), fontSize: 14, color: blackColor)),
            Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: blackColor.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }

  Widget _otpBoxes() {
    final activeIndex = otp.text.length >= LoginConstants.otpLength
        ? LoginConstants.otpLength - 1
        : otp.text.length;
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(LoginConstants.otpLength, (index) {
              final filled = index < otp.text.length;
              final active = otpFocused && index == activeIndex;
              return Container(
                width: 44,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (filled || active) ? mainColor : blackColor.withValues(alpha: 0.1),
                    width: 2,
                  ),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: mainColor.withValues(alpha: 0.22),
                            blurRadius: 0,
                            spreadRadius: 3,
                          ),
                        ]
                      : null,
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
            focusNode: otpFocus,
            keyboardType: TextInputType.number,
            showCursor: false,
            enableInteractiveSelection: false,
            style: const TextStyle(color: Colors.transparent),
            cursorColor: mainColor,
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
              filled: true,
              fillColor: Color(0x00000000),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(LoginConstants.otpLength)],
            onChanged: (_) => setState(() {}),
            onTap: () => setState(() {}),
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

  InputDecoration _outline({String? hint, Widget? suffix}) {
    final side = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: blackColor.withValues(alpha: 0.1)),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontFamily: AppFont.get(FontType.semiBold), color: blackColor.withValues(alpha: 0.35), fontSize: 14),
      filled: true,
      fillColor: whiteColor,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      suffixIcon: suffix,
      suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      border: side,
      enabledBorder: side,
      disabledBorder: side,
      focusedBorder: side.copyWith(borderSide: const BorderSide(color: mainColor, width: 1.5)),
    );
  }

  Widget _green(String label, VoidCallback tap) {
    return MarathonPrimaryButton(label: label, onTap: tap, wide: true);
  }
}
