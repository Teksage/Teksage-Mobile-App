class UserBookingConsultation {
  final String status;
  final BookingEvent event;

  UserBookingConsultation({
    required this.status,
    required this.event,
  });

  factory UserBookingConsultation.fromJson(Map<String, dynamic> json) {
    return UserBookingConsultation(
      status: json['status'],
      event: BookingEvent.fromJson(json['data']),
    );
  }
}

class BookingEvent {
  final String startTime;
  final String endTime;
  final String bookingDate;
  final String status;
  final bool shareHoroscope;
  final int consultationDuration;
  final int customerId;
  final int astrologerId;
  final int id;
  final List<String> languages;
  final List<String> category;
  final String? eventLink;
  final String? feedback;
  final double consultationFee;
  final dynamic rating;
  final dynamic astrologerShare;
  final dynamic astropromptShare;
  final bool queriesAnswered;

  BookingEvent({
    required this.startTime,
    required this.endTime,
    required this.bookingDate,
    required this.status,
    required this.shareHoroscope,
    required this.consultationDuration,
    required this.customerId,
    required this.astrologerId,
    required this.id,
    required this.languages,
    required this.category,
    this.eventLink,
    this.feedback,
    required this.consultationFee,
    this.rating,
    this.astrologerShare,
    this.astropromptShare,
    required this.queriesAnswered,
  });

  factory BookingEvent.fromJson(Map<String, dynamic> json) {
    return BookingEvent(
      startTime: json['start_datetime'],
      endTime: json['end_datetime'],
      bookingDate: json['booking_date'],
      status: json['status'],
      shareHoroscope: json['share_horoscope'],
      consultationDuration: json['consultation_duration'],
      customerId: json['customer_id'],
      astrologerId: json['astrologer_id'],
      id: json['id'],
      languages: List<String>.from(json['languages']),
      category: List<String>.from(json['category']),
      eventLink: json['event_link'],
      feedback: json['feedback'],
      consultationFee: json['consultation_fee'] != null ? (json['consultation_fee'] as num).toDouble() : 0.0,
      rating: json['rating'],
      astrologerShare: json['astrologer_share'],
      astropromptShare: json['astroprompt_share'],
      queriesAnswered: json['queries_answered'],
    );
  }
}
