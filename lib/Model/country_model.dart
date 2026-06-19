class Country {
  final String countryName;
  final String countryCode;
  final String dialCode;
  final int mobileNumberLength;
  final String countryFlag;

  Country({
    required this.countryName,
    required this.countryCode,
    required this.countryFlag,
    required this.dialCode,
    required this.mobileNumberLength,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
        countryName: json['name'],
        countryCode: json['country_code'],
        countryFlag: json['flag'],
        dialCode: json['dial_code'],
        mobileNumberLength: json['mobile_number_length']);
  }
}
