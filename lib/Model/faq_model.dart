class FaqModel {
  final String question;
  final String answer;
  final int faqId;

  FaqModel({
    required this.question,
    required this.answer,
    required this.faqId,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      faqId: json['faq_id'] ?? 0,
    );
  }
}
