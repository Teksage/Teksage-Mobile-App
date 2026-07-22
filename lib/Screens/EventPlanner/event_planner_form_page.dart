import 'package:astro_prompt/Components/Common/app_floating_bottom_nav.dart';
import 'package:astro_prompt/Components/Common/customDropDown.dart';
import 'package:astro_prompt/Components/Dashboard/LoginDialog.dart';
import 'package:astro_prompt/Components/Dashboard/subscribeDialog.dart';
import 'package:astro_prompt/Components/EventPlanner/event_planner_header.dart';
import 'package:astro_prompt/Model/location_selection_model.dart';
import 'package:astro_prompt/Screens/EventPlanner/event_planner_results_page.dart';
import 'package:astro_prompt/Screens/settings/profile_page.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/event_planner_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventPlannerFormPage extends StatefulWidget {
  const EventPlannerFormPage({super.key});

  @override
  State<EventPlannerFormPage> createState() => _EventPlannerFormPageState();
}

class _EventPlannerFormPageState extends State<EventPlannerFormPage> {
  String _event = EventPlannerConfig.eventTypes.first;
  DateTime _startDate = DateTime.now();
  final _locationController = TextEditingController();
  String _locationFull = '';
  bool _locationError = false;
  bool _loading = true;
  bool _isLoggedIn = false;
  bool _isPremium = false;
  bool _hasProfile = false;

  static const _mintBg = Color(0xffECF8EB);

  @override
  void initState() {
    super.initState();
    _initAccess();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _initAccess() async {
    final token = await getAccessToken();
    if (token.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    try {
      final profile = await ProfileService().fetchUserProfile();
      final planStatus =
          (profile?.subscription?.planStatus ?? '').toLowerCase().trim();
      final isPremium = planStatus == 'active';

      final location = (profile?.preferredLocation.isNotEmpty == true)
          ? profile!.preferredLocation
          : (profile?.birthLocation ?? '');
      if (location.isNotEmpty) {
        _locationController.text = location;
        _locationFull = location;
      }

      final hasProfile = (profile?.nakshatra.isNotEmpty == true) &&
          (profile?.rashi.isNotEmpty == true);

      if (mounted) {
        setState(() {
          _isLoggedIn = true;
          _isPremium = isPremium;
          _hasProfile = hasProfile;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoggedIn = true;
          _loading = false;
        });
      }
    }
  }

  void _submit() {
    final location = _locationFull.trim().isNotEmpty
        ? _locationFull.trim()
        : _locationController.text.trim();
    if (location.isEmpty) {
      setState(() => _locationError = true);
      return;
    }
    Get.to(() => EventPlannerResultsPage(
          event: _event,
          startDate: DateFormat('yyyy-MM-dd').format(_startDate),
          location: location,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Scaffold(
      backgroundColor: _mintBg,
      extendBody: true,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: mainColor))
          : _buildBody(util),
      bottomNavigationBar: const AppFloatingBottomNav(popToRootOnTap: true),
    );
  }

  Widget _buildBody(MyUtility util) {
    if (!_isLoggedIn) {
      return _gate(
        util,
        Icons.lock_outline_rounded,
        'Sign in to find Event Planner'.tr,
        'Use your email or mobile OTP on the login screen.'.tr,
        'Go to login'.tr,
        () => showDialog(
          context: context,
          barrierColor: Colors.black.withValues(alpha: 0.5),
          builder: (_) => const LoginPromptDialog(reDirectHome: false),
        ),
      );
    }
    if (!_isPremium) {
      return _gate(
        util,
        Icons.workspace_premium_rounded,
        'Event Planner is a premium feature'.tr,
        'Subscribe to unlock personalized auspicious dates for your life events.'
            .tr,
        'Upgrade Now'.tr,
        () => showDialog(
          context: context,
          barrierColor: Colors.black.withValues(alpha: 0.5),
          builder: (_) => const SubscribePromptDialog(reDirectHome: true),
        ),
        iconColor: const Color(0xffF9A825),
      );
    }
    if (!_hasProfile) {
      return _gate(
        util,
        Icons.person_outline_rounded,
        'Complete your profile'.tr,
        'Add your birth details (Rashi and Nakshatra) to use Event Planner.'.tr,
        'Go to Profile'.tr,
        () => Get.to(() => ProfilePage(
              title: 'Profile Details'.tr,
              isProfileUpdated: false,
            )),
      );
    }
    return _form(util);
  }

  Widget _gate(
    MyUtility util,
    IconData icon,
    String title,
    String description,
    String cta,
    VoidCallback onTap, {
    Color? iconColor,
  }) {
    return Column(
      children: [
        EventPlannerHeader(title: 'Event Planner (Muhurtha)'.tr),
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(util.width20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 360),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: (iconColor ?? mainColor).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon,
                          color: iconColor ?? mainColor, size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.bold),
                            fontSize: util.fontSize18)),
                    const SizedBox(height: 8),
                    Text(description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: util.fontSize14,
                            color: blackColor.withValues(alpha: 0.65),
                            height: 1.45)),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          minimumSize: const Size(double.infinity, 48),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(cta,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold),
                                color: whiteColor)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _form(MyUtility util) {
    final minDate = DateTime.now();
    final maxDate = DateTime.now()
        .add(const Duration(days: EventPlannerConfig.maxStartDaysAhead));

    return SingleChildScrollView(
      child: Column(
        children: [
          EventPlannerHeader(
            title: 'Event Planner (Muhurtha)'.tr,
            subtitle:
                'Select a life event and start date. We scan the next 7 days using your birth chart and Panchang.'
                    .tr,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: mainColor.withValues(alpha: 0.3), width: 2.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel(util, 'Event type'.tr),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _event,
                    decoration: _inputDecoration(),
                    items: EventPlannerConfig.eventTypes
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.tr,
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14)),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _event = v);
                    },
                  ),
                  SizedBox(height: util.height20),
                  _fieldLabel(util, 'Start date'.tr),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: minDate,
                        lastDate: maxDate,
                        builder: (ctx, child) => Theme(
                          data: Theme.of(ctx).copyWith(
                            colorScheme:
                                const ColorScheme.light(primary: mainColor),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) setState(() => _startDate = picked);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: blackColor.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateFormat('dd-MM-yyyy').format(_startDate),
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize14),
                            ),
                          ),
                          Icon(Icons.calendar_today_rounded,
                              size: 16,
                              color: blackColor.withValues(alpha: 0.45)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Searching the next 7 days from this date'.tr,
                    style: TextStyle(
                        fontSize: 11,
                        color: blackColor.withValues(alpha: 0.5)),
                  ),
                  SizedBox(height: util.height20),
                  Row(
                    children: [
                      _fieldLabel(util, 'Location'.tr),
                      Text(' *',
                          style: TextStyle(
                              color: errorColor,
                              fontFamily: AppFont.get(FontType.semiBold))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  CustomDropDown(
                    title: '',
                    isMandatory: true,
                    enableEdit: true,
                    textController: _locationController,
                    errorFlag: _locationError,
                    onLocationChanged: (LocationSelection sel) {
                      setState(() {
                        _locationFull = sel.displayText;
                        _locationError = false;
                      });
                    },
                  ),
                  if (_locationError)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text('Location is required'.tr,
                          style:
                              const TextStyle(color: errorColor, fontSize: 12)),
                    ),
                  SizedBox(height: util.height20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        minimumSize: const Size(double.infinity, 52),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        'Find Auspicious Dates'.tr,
                        style: TextStyle(
                          fontFamily: AppFont.get(FontType.semiBold),
                          color: whiteColor,
                          fontSize: util.fontSize15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() => InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: blackColor.withValues(alpha: 0.15))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: blackColor.withValues(alpha: 0.15))),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        fillColor: whiteColor,
        filled: true,
      );

  Widget _fieldLabel(MyUtility util, String text) => Text(
        text,
        style: TextStyle(
          fontFamily: AppFont.get(FontType.semiBold),
          fontSize: util.fontSize13,
          color: blackColor,
        ),
      );
}
