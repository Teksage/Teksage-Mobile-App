class ChatMessageModel {
  final int id;
  final String apiInput;
  final String userFeedback;
  final int customerId;
  final int horoscopeId;
  final int? chatId;
  final String userQuestion;
  final String apiResponse;
  final DateTime queryDate;

  ChatMessageModel({
    required this.id,
    required this.apiInput,
    required this.userFeedback,
    required this.customerId,
    required this.horoscopeId,
    this.chatId,
    required this.userQuestion,
    required this.apiResponse,
    required this.queryDate,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      apiInput: json['api_input'] ?? '',
      userFeedback: json['user_feedback'] ?? '',
      customerId: json['customer_id'],
      horoscopeId: json['horoscope_id'],
      chatId: json['chat_id'],
      userQuestion: json['user_question'] ?? '',
      apiResponse: json['api_response'] ?? '',
      queryDate: DateTime.parse(json['query_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'api_input': apiInput,
      'user_feedback': userFeedback,
      'customer_id': customerId,
      'horoscope_id': horoscopeId,
      'chat_id': chatId,
      'user_question': userQuestion,
      'api_response': apiResponse,
      'query_date': queryDate.toIso8601String(),
    };
  }
}
