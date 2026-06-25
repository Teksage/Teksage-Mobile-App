class UserQuestion {
  final int id;
  final int eventId;
  final String question;
  String? answer;

  UserQuestion({
    required this.id,
    required this.eventId,
    required this.question,
    this.answer,
  });

  factory UserQuestion.fromJson(Map<String, dynamic> json) {
    return UserQuestion(
      id: json['id'],
      eventId: json['event_id'],
      question: json['question'],
      answer: json['answer'] ?? '',
    );
  }
}
