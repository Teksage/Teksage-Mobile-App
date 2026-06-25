class AstroConsultationEventModel {
  final int id;
  final int astrologerId;
  final int customerId;
  final double consultationFee;
  final String currency;
  final int consultationDuration;
  final String status;
  final String eventLink;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final List<String>? category;
  final List<String>? languages;
  final bool shareHoroscope;
  final String? customerFirstName;
  final String? customerLastName;
  final String? astrologerFirstName;
  final String? astrologerLastName;
  final int? rating;
  final String profileImage;
  final bool? queriesAnswered;

  AstroConsultationEventModel({
    required this.id,
    required this.astrologerId,
    required this.customerId,
    required this.consultationFee,
    required this.currency,
    required this.consultationDuration,
    required this.status,
    required this.eventLink,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.languages,
    required this.shareHoroscope,
    this.customerFirstName,
    this.customerLastName,
    this.astrologerFirstName,
    this.astrologerLastName,
    this.rating,
    required this.profileImage,
    this.queriesAnswered,
  });

  factory AstroConsultationEventModel.fromJson(Map<String, dynamic> json) {
    return AstroConsultationEventModel(
      id: json['id'],
      astrologerId: json['astrologer_id'],
      customerId: json['customer_id'],
      consultationFee: (json['consultation_fee'] ?? 0).toDouble(),
      currency: json['currency'],
      // consultationFee: json['local_consutation_fee'] != null
      //     ? (json['local_consutation_fee'] as num).toDouble()
      //     : 0.0,
      consultationDuration: json['consultation_duration'] ?? 0,
      status: json['status'] ?? '',
      eventLink: json['event_link'] ?? '',
      bookingDate: json['booking_date'] ?? '',
      startTime: json['start_datetime'] ?? '',
      endTime: json['end_datetime'] ?? '',
      category: (json['category'] as List?)?.map((e) => e.toString()).toList(),
      languages: (json['languages'] as List?)?.map((e) => e.toString()).toList(),
      shareHoroscope: json['share_horoscope'] ?? false,
      customerFirstName: json['customer_first_name'],
      customerLastName: json['customer_last_name'],
      rating: json['rating'],
      profileImage: json['astrologer_picture'] ?? '',
      queriesAnswered: json['queries_answered'] ?? false,
      astrologerFirstName: json['astrologer_first_name'],
      astrologerLastName: json['astrologer_last_name'],
    );
  }
}

extension AstroConsultationEventModelCopy on AstroConsultationEventModel {
  AstroConsultationEventModel copyWith({
    int? id,
    int? astrologerId,
    int? customerId,
    double? consultationFee,
    String? currency,
    int? consultationDuration,
    String? status,
    String? eventLink,
    String? bookingDate,
    String? startTime,
    String? endTime,
    List<String>? category,
    List<String>? languages,
    bool? shareHoroscope,
    String? customerFirstName,
    String? customerLastName,
    String? astrologerFirstName,
    String? astrologerLastName,
    int? rating,
    String? profileImage,
    bool? queriesAnswered,
  }) {
    return AstroConsultationEventModel(
      id: id ?? this.id,
      astrologerId: astrologerId ?? this.astrologerId,
      customerId: customerId ?? this.customerId,
      consultationFee: consultationFee ?? this.consultationFee,
      currency: currency ?? this.currency,
      consultationDuration: consultationDuration ?? this.consultationDuration,
      status: status ?? this.status,
      eventLink: eventLink ?? this.eventLink,
      bookingDate: bookingDate ?? this.bookingDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      languages: languages ?? this.languages,
      shareHoroscope: shareHoroscope ?? this.shareHoroscope,
      customerFirstName: customerFirstName ?? this.customerFirstName,
      customerLastName: customerLastName ?? this.customerLastName,
      astrologerFirstName: astrologerFirstName ?? this.astrologerFirstName,
      astrologerLastName: astrologerLastName ?? this.astrologerLastName,
      rating: rating ?? this.rating,
      profileImage: profileImage ?? this.profileImage,
      queriesAnswered: queriesAnswered ?? this.queriesAnswered,
    );
  }
}
