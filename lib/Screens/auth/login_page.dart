import 'package:astro_prompt/Components/auth/login_method_tabs.dart';
import 'package:astro_prompt/Screens/auth/password.dart';
import 'package:astro_prompt/Screens/settings/privacy_page.dart';
import 'package:astro_prompt/Screens/settings/t&c_page.dart';
import 'package:astro_prompt/Services/AuthService/authService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/login_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPage extends StatefulWidget {
  final LoginMethodTab initialTab;

  const LoginPage({
    super.key,
    this.initialTab = LoginMethodTab.mobile,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginMethodTab _activeTab;
  final AuthService _authService = AuthService();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  LoginDialOption _selectedDial = LoginConstants.dialOptions.first;
  String? _errorMessage;
  bool _isLoading = false;
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidMobile(String mobile) {
    return LoginConstants.mobileDigitsRegex.hasMatch(mobile);
  }

  void _validateMobile(String value) {
    setState(() {
      if (value.isEmpty || !_isValidMobile(value)) {
        _errorMessage = LoginConstants.invalidMobile;
        _canSubmit = false;
      } else {
        _errorMessage = null;
        _canSubmit = true;
      }
    });
  }

  void _validateEmail(String value) {
    final email = value.trim().toLowerCase();
    setState(() {
      if (email.isEmpty || !LoginConstants.emailRegex.hasMatch(email)) {
        _errorMessage = LoginConstants.invalidEmail;
        _canSubmit = false;
      } else {
        _errorMessage = null;
        _canSubmit = true;
      }
    });
  }

  void _onTabChanged(LoginMethodTab tab) {
    if (_activeTab == tab) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _activeTab = tab;
      _errorMessage = null;
      _canSubmit = tab == LoginMethodTab.mobile
          ? _isValidMobile(_mobileController.text)
          : LoginConstants.emailRegex.hasMatch(_emailController.text.trim());
    });
  }

  Future<void> _submitMobile() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    final mobile = _mobileController.text;
    try {
      final response = await _authService.login(
        'mobile_number',
        mobile,
        countryCode: _selectedDial.countryCodeNumeric,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (response['message'] == 'OTP sent successfully') {
        showSuccessSnackBar(context, response['message']);
        Get.to(() => OTPScreen(
              keyValue: 'mobile_number',
              userInfo: mobile,
              isMobileScreen: true,
              verifyScreen: false,
              isChange: false,
              countryCode: _selectedDial.dialCode,
            ));
      } else {
        showErrorSnackBar(
          context,
          response['error'] ?? 'Something went wrong',
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showErrorSnackBar(
        context,
        'Network error. Please check your connection and try again.',
      );
    }
  }

  Future<void> _submitEmail() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    final email = _emailController.text.trim().toLowerCase();
    try {
      final response = await _authService.login('email', email);
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (response['message'] == 'OTP sent successfully') {
        showLoginSuccessSnackBar(context, response['message']);
        Get.to(() => OTPScreen(
              keyValue: 'email',
              userInfo: email,
              isMobileScreen: false,
              verifyScreen: false,
              isChange: false,
            ));
      } else {
        showErrorSnackBar(
          context,
          response['error'] ?? 'Error: Contact Teksage.',
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showErrorSnackBar(
        context,
        'Network error. Please check your connection and try again.',
      );
    }
  }

  InputDecoration _fieldDecoration(MyUtility util, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: AppFont.get(FontType.medium),
        fontSize: util.fontSize16,
        color: blackColor.withValues(alpha: 0.6),
      ),
      filled: true,
      fillColor: whiteColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: util.width12,
        vertical: util.responsiveHeight(0.018),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: blackColor.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: _errorMessage != null ? errorColor : mainColor,
          width: 2,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: blackColor.withValues(alpha: 0.2)),
      ),
    );
  }

  Widget _buildMobileForm(MyUtility util) {
    final fieldHeight = util.responsiveHeight(0.0567);
    return SizedBox(
      height: fieldHeight,
      child: Row(
        children: [
          Container(
            height: fieldHeight,
            padding: EdgeInsets.symmetric(horizontal: util.width10),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: blackColor.withValues(alpha: 0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedDial.dialCode,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: util.fontSize20,
                color: blackColor.withValues(alpha: 0.6),
              ),
              items: LoginConstants.dialOptions
                  .map(
                    (option) => DropdownMenuItem<String>(
                      value: option.dialCode,
                      child: Text(
                        option.dialCode,
                        style: TextStyle(
                          fontFamily: AppFont.get(FontType.bold),
                          fontSize: util.fontSize16,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedDial = LoginConstants.dialOptions.firstWhere(
                    (option) => option.dialCode == value,
                  );
                  _errorMessage = null;
                  _canSubmit = _isValidMobile(_mobileController.text);
                });
              },
            ),
          ),
        ),
        SizedBox(width: util.width10),
        Expanded(
          child: TextField(
            controller: _mobileController,
            keyboardType: TextInputType.number,
            onChanged: _validateMobile,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.bold),
              fontSize: util.fontSize16,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(
                _selectedDial.mobileLength,
              ),
            ],
            decoration: _fieldDecoration(
              util,
              LoginConstants.mobilePlaceholder,
            ),
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildEmailForm(MyUtility util) {
    return SizedBox(
      height: util.responsiveHeight(0.0567),
      child: TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      onChanged: _validateEmail,
      style: TextStyle(
        fontFamily: AppFont.get(FontType.bold),
        fontSize: util.fontSize16,
      ),
      decoration: _fieldDecoration(util, LoginConstants.emailPlaceholder),
      ),
    );
  }

  Widget _buildLegalFootnote(MyUtility util) {
    final baseStyle = TextStyle(
      fontFamily: AppFont.get(FontType.medium),
      fontSize: util.fontSize12,
      color: blackColor.withValues(alpha: 0.45),
      height: 1.4,
    );
    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          const TextSpan(text: LoginConstants.legalPrefix),
          TextSpan(
            text: LoginConstants.termsLabel,
            style: baseStyle.copyWith(
              color: blackColor.withValues(alpha: 0.55),
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.to(() => const TermsAndConditionsPage()),
          ),
          const TextSpan(text: LoginConstants.legalMiddle),
          TextSpan(
            text: LoginConstants.privacyLabel,
            style: baseStyle.copyWith(
              color: blackColor.withValues(alpha: 0.55),
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.to(() => const PrivacyPolicyPage()),
          ),
          const TextSpan(text: LoginConstants.legalSuffix),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final canTap = _canSubmit && !_isLoading;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Stack(
          children: [
            Container(
              width: util.width,
              height: util.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFC2EDC0),
                    Color(0xFFEEF8ED),
                    Color(0xFFFFFFFF),
                  ],
                  stops: [0.0, 0.42, 1.0],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        appBackButton,
                        width: util.width20,
                        height: util.height20,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: util.responsiveHeight(0.0248),
                      ),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            brandLoginLogo,
                            width: util.responsiveWidth(0.25),
                          ),
                          SizedBox(height: util.responsiveHeight(0.04)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: SvgPicture.asset(dashLine)),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: util.width12,
                                ),
                                child: Text(
                                  LoginConstants.heading,
                                  style: TextStyle(
                                    fontFamily: AppFont.get(FontType.bold),
                                    fontSize: util.fontSize20,
                                  ),
                                ),
                              ),
                              Expanded(child: SvgPicture.asset(dashLine)),
                            ],
                          ),
                          SizedBox(height: util.responsiveHeight(0.03)),
                          LoginMethodTabs(
                            active: _activeTab,
                            onChange: _onTabChanged,
                          ),
                          SizedBox(height: util.responsiveHeight(0.024)),
                          SizedBox(
                            height: util.responsiveHeight(0.0567),
                            width: double.infinity,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: _activeTab == LoginMethodTab.mobile
                                  ? KeyedSubtree(
                                      key: const ValueKey(
                                        LoginMethodTab.mobile,
                                      ),
                                      child: _buildMobileForm(util),
                                    )
                                  : KeyedSubtree(
                                      key: const ValueKey(
                                        LoginMethodTab.email,
                                      ),
                                      child: _buildEmailForm(util),
                                    ),
                            ),
                          ),
                          if (_errorMessage != null) ...[
                            SizedBox(height: util.responsiveHeight(0.012)),
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: errorColor,
                                fontFamily: AppFont.get(FontType.semiBold),
                                fontSize: util.fontSize14,
                              ),
                            ),
                          ],
                          SizedBox(height: util.responsiveHeight(0.028)),
                          GestureDetector(
                            onTap: canTap
                                ? (_activeTab == LoginMethodTab.mobile
                                    ? _submitMobile
                                    : _submitEmail)
                                : null,
                            child: Container(
                              width: util.width,
                              height: util.responsiveHeight(0.056),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: canTap
                                    ? mainColor
                                    : mainColor.withValues(alpha: 0.2),
                              ),
                              child: Center(
                                child: _isLoading
                                    ? LoadingAnimationWidget.halfTriangleDot(
                                        color: whiteColor,
                                        size: util.height30,
                                      )
                                    : Text(
                                        LoginConstants.continueCta,
                                        style: TextStyle(
                                          color: canTap
                                              ? whiteColor
                                              : mainColor,
                                          fontFamily:
                                              AppFont.get(FontType.medium),
                                          fontSize: util.fontSize18,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(height: util.responsiveHeight(0.04)),
                          _buildLegalFootnote(util),
                          SizedBox(height: util.responsiveHeight(0.03)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Backward-compatible alias — prefer [LoginPage].
class LoginPageMobile extends StatelessWidget {
  const LoginPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}
