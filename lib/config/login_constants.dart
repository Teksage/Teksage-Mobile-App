/// Login screen copy and defaults — mirrors website `LOGIN_SCREEN` / forms.
class LoginConstants {
  LoginConstants._();

  static const heading = 'Login or Sign up';
  static const tabMobile = 'Mobile';
  static const tabEmail = 'Email';
  static const mobilePlaceholder = 'Enter Mobile Number';
  static const emailPlaceholder = 'Enter Email';
  static const continueCta = 'Continue';
  static const invalidMobile = 'Enter a valid mobile number';
  static const invalidEmail = 'Enter a valid email address';
  static const legalPrefix = 'By continuing, you agree to our ';
  static const termsLabel = 'Terms of Service';
  static const legalMiddle = ' and ';
  static const privacyLabel = 'Privacy Policy';
  static const legalSuffix = '.';
  static const defaultDialCode = '+91';
  static const defaultCountryCodeNumeric = '91';
  static const defaultMobileLength = 10;
  static const countryDialPickerTitle = 'Select Country Dial Code';

  static final RegExp emailRegex = RegExp(
    r"^[a-z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-z0-9.-]+\.[a-z]{2,}$",
    caseSensitive: false,
  );

  static bool isValidNationalMobile(String mobile, int expectedLength) {
    final digits = mobile.replaceAll(RegExp(r'\D'), '');
    if (expectedLength > 0) {
      return digits.length == expectedLength;
    }
    return digits.length >= 4 && digits.length <= 15;
  }
}

enum LoginMethodTab { mobile, email }
