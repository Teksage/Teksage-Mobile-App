/// Login screen copy and defaults — mirrors website `LOGIN_SCREEN` / forms.
class LoginDialOption {
  final String dialCode;
  final String countryCodeNumeric;
  final int mobileLength;

  const LoginDialOption({
    required this.dialCode,
    required this.countryCodeNumeric,
    required this.mobileLength,
  });
}

class LoginConstants {
  LoginConstants._();

  static const heading = 'Login or Sign up';
  static const tabMobile = 'Mobile';
  static const tabEmail = 'Email';
  static const mobilePlaceholder = 'Enter Mobile Number';
  static const emailPlaceholder = 'Enter Email';
  static const continueCta = 'Continue';
  static const invalidMobile = 'Enter a valid 10-digit mobile number';
  static const invalidEmail = 'Enter a valid email address';
  static const legalPrefix = 'By continuing, you agree to our ';
  static const termsLabel = 'Terms of Service';
  static const legalMiddle = ' and ';
  static const privacyLabel = 'Privacy Policy';
  static const legalSuffix = '.';
  static const defaultDialCode = '+91';

  /// Same as website `LOGIN_MOBILE_COUNTRY_DIAL_OPTIONS`.
  static const List<LoginDialOption> dialOptions = [
    LoginDialOption(
      dialCode: '+91',
      countryCodeNumeric: '91',
      mobileLength: 10,
    ),
    LoginDialOption(
      dialCode: '+1',
      countryCodeNumeric: '1',
      mobileLength: 10,
    ),
  ];

  static final RegExp mobileDigitsRegex = RegExp(r'^[1-9]\d{9}$');

  static final RegExp emailRegex = RegExp(
    r"^[a-z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-z0-9.-]+\.[a-z]{2,}$",
    caseSensitive: false,
  );
}

enum LoginMethodTab { mobile, email }
