class UserBookingRazorPay {
  final String id;
  final int amount;
  final String currency;
  final String key;

  UserBookingRazorPay({
    required this.id,
    required this.amount,
    required this.currency,
    required this.key,
  });

  factory UserBookingRazorPay.fromJson(Map<String, dynamic> json) {
    return UserBookingRazorPay(
      id: json['id'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? '',
      key: json['key'] ?? '',
    );
  }
}
