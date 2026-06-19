class NotificationModel {
  final int id;
  final String title;
  final String message;
  final DateTime sentAt;
  final bool readBy;
  final String recipientType;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.sentAt,
    required this.readBy,
    required this.recipientType,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      sentAt: DateTime.parse(json['sent_at']),
      readBy: json['read_by'],
      recipientType: json['recipient_type'],
    );
  }
}
