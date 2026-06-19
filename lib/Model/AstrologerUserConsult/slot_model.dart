class SlotModel {
  final String startTime;
  final String endTime;
  final bool eventBooked;

  SlotModel({
    required this.startTime,
    required this.endTime,
    required this.eventBooked,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      startTime: json['start_datetime'],
      endTime: json['end_datetime'],
      eventBooked: json['event_booked'],
    );
  }
}
