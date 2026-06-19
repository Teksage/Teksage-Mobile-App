class SubscriptionPaymentData {
  final String id;
  final int amount;
  final String currency;
  final String key;

  SubscriptionPaymentData({
    required this.id,
    required this.amount,
    required this.currency,
    required this.key,
  });

  factory SubscriptionPaymentData.fromJson(Map<String, dynamic> json) {
    return SubscriptionPaymentData(
      id: json['id'],
      amount: json['amount'],
      currency: json['currency'],
      key: json['key'],
    );
  }
}

class AutoSubscriptionPaymentData {
  final String subscription_id;
  final String key;

  AutoSubscriptionPaymentData({
    required this.subscription_id,
    required this.key,
  });

  factory AutoSubscriptionPaymentData.fromJson(Map<String, dynamic> json) {
    return AutoSubscriptionPaymentData(
      subscription_id: json['subscription_id'],
      key: json['key'],
    );
  }
}

class SubscriptionPaymentVerification {
  final String status;
  final String message;

  SubscriptionPaymentVerification({
    required this.status,
    required this.message,
  });

  factory SubscriptionPaymentVerification.fromJson(Map<String, dynamic> json) {
    return SubscriptionPaymentVerification(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
