class ChatPreference {
  final bool maintainHistory;
  final bool isPrimeCustomer;
  final int chatCountLast7Days;

  ChatPreference({
    required this.maintainHistory,
    required this.isPrimeCustomer,
    required this.chatCountLast7Days,
  });

  factory ChatPreference.fromJson(Map<String, dynamic> json) {
    return ChatPreference(
      maintainHistory: json['maintain_history'] ?? false,
      isPrimeCustomer: json['is_prime_customer'] ?? false,
      chatCountLast7Days: json['chat_count_last_7_days'] ?? 0,
    );
  }
}
