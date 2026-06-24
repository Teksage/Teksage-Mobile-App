class ConsultationEventModel {
  final int id;
  final int customerId;
  final int astrologerId;
  final String startTime;
  final String endTime;
  final String bookingDate;
  final String status;
  final bool shareHoroscope;
  final String? eventLink;
  final String? feedback;
  final double? rating;
  final double? consultationFee;
  final double? astrologerShare;
  final String? currency;
  final int consultationDuration;
  final List<String> languages;
  final List<String> category;
  final UserHoroscope? userHoroscope;
  final List<EventQuestions> questions;
  final Customer customer;
  // final Horoscope horoscope;

  ConsultationEventModel({
    required this.id,
    required this.customerId,
    required this.astrologerId,
    required this.startTime,
    required this.endTime,
    required this.bookingDate,
    required this.status,
    required this.shareHoroscope,
    required this.eventLink,
    required this.feedback,
    required this.rating,
    this.consultationFee,
    this.astrologerShare,
    this.currency,
    required this.consultationDuration,
    required this.languages,
    required this.category,
    required this.userHoroscope,
    required this.questions,
    required this.customer,
    // required this.horoscope,
  });

  factory ConsultationEventModel.fromJson(Map<String, dynamic> json) {
    return ConsultationEventModel(
      id: json['id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      astrologerId: json['astrologer_id'] ?? 0,
      startTime: json['start_datetime'] ?? '',
      endTime: json['end_datetime'] ?? '',
      bookingDate: json['booking_date'] ?? '',
      status: json['status'] ?? '',
      shareHoroscope: json['share_horoscope'] ?? false,
      eventLink: json['event_link'],
      feedback: json['feedback'],
      rating: (json['rating'] != null) ? double.tryParse(json['rating'].toString()) : null,
      consultationFee: _parseDouble(json['consultation_fee']),
      astrologerShare: _parseDouble(json['astrologer_share']),
      currency: json['currency']?.toString(),
      consultationDuration: json['consultation_duration'] ?? 0,
      languages: _parseStringList(json['languages']),
      category: _parseStringList(json['category']),
      userHoroscope: json['user_horoscope'] != null ? UserHoroscope.fromJson(json['user_horoscope']) : null,
      questions: (json['questions'] != null && json['questions'] is List)
          ? (json['questions'] as List).map((e) => EventQuestions.fromJson(e)).toList()
          : <EventQuestions>[],
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : Customer(customerId: 0, userId: 0, horoscopeId: 0, createdAt: ''),
      // userHoroscope:  json['horoscope'] != null ? UserHoroscope.fromJson(json['horoscope']) : null,
      // horoscope: Horoscope.fromJson(json['horoscope']),
    );
  }
}

double? _parseDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  final s = v.toString();
  return double.tryParse(s);
}

int? _parseInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  final s = v.toString();
  return int.tryParse(s);
}

List<String> _parseStringList(dynamic v) {
  if (v == null) return <String>[];
  try {
    return List<String>.from(v);
  } catch (_) {
    try {
      return (v as List).map((e) => e?.toString() ?? '').where((e) => e.isNotEmpty).toList();
    } catch (__) {
      return <String>[];
    }
  }
}

class UserHoroscope {
  final String lagna;
  final String rashi;
  final String nakshatra;
  final String rasiChart;
  final String navamsaChart;
  final String currentDasa;
  final int horoscopeId;
  final String dateOfBirth;
  final String timeOfBirth;
  // final Map<String, PlanetData> horoscopeData;
  final String placeOfBirth;
  final String? saturnTransit;
  final String? jupiterTransit;
  final String dasaBukthiImage;
  final String horoscopeDetails;
  final String? rahuKetuTransit;
  final String dasaBukthiDetails;

  UserHoroscope({
    required this.lagna,
    required this.rashi,
    required this.nakshatra,
    required this.rasiChart,
    required this.navamsaChart,
    required this.currentDasa,
    required this.horoscopeId,
    required this.dateOfBirth,
    required this.timeOfBirth,
    // required this.horoscopeData,
    required this.placeOfBirth,
    required this.saturnTransit,
    required this.jupiterTransit,
    required this.dasaBukthiImage,
    required this.horoscopeDetails,
    required this.rahuKetuTransit,
    required this.dasaBukthiDetails,
  });

  factory UserHoroscope.fromJson(Map<String, dynamic> json) {
    return UserHoroscope(
      lagna: json['lagna'],
      rashi: json['rashi'],
      nakshatra: json['nakshatra'],
      rasiChart: json['rasi_chart'],
      navamsaChart: json['navamsa_chart'],
      currentDasa: json['current_dasa'],
      horoscopeId: json['horoscope_id'],
      dateOfBirth: json['date_of_birth'],
      timeOfBirth: json['time_of_birth'],
      // horoscopeData: (json['horoscope_data'] as Map<String, dynamic>).map(
      //   (key, value) => MapEntry(key, PlanetData.fromJson(value)),
      // ),
      placeOfBirth: json['place_of_birth'],
      saturnTransit: json['saturn_transit'],
      jupiterTransit: json['jupiter_transit'],
      dasaBukthiImage: json['dasa_bukti_image'],
      horoscopeDetails: json['horoscope_details'],
      rahuKetuTransit: json['rahu_ketu_transit'],
      dasaBukthiDetails: json['dasa_bukti_details'],
    );
  }
}

class PlanetData {
  final String planet;
  final String sign;
  final bool isRetro;
  final double position;
  final double signPosition;
  final NakshatraPada nakshatraPada;

  PlanetData({
    required this.planet,
    required this.sign,
    required this.isRetro,
    required this.position,
    required this.signPosition,
    required this.nakshatraPada,
  });

  factory PlanetData.fromJson(Map<String, dynamic> json) {
    return PlanetData(
      planet: json['planet'],
      sign: json['sign'],
      isRetro: json['isRetro'],
      position: _parseDouble(json['position']) ?? 0.0,
      signPosition: _parseDouble(json['signPosition']) ?? 0.0,
      nakshatraPada: NakshatraPada.fromJson(json['nakshatraPada']),
    );
  }
}

class NakshatraPada {
  final String nak;
  final int pada;

  NakshatraPada({required this.nak, required this.pada});

  factory NakshatraPada.fromJson(Map<String, dynamic> json) {
    return NakshatraPada(
      nak: json['nak'],
      pada: _parseInt(json['pada']) ?? 0,
    );
  }
}

class EventQuestions {
  final int id;
  final String question;
  final String? answer;
  final int eventId;

  EventQuestions({
    required this.id,
    required this.question,
    this.answer,
    required this.eventId,
  });

  factory EventQuestions.fromJson(Map<String, dynamic> json) {
    return EventQuestions(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      eventId: json['event_id'],
    );
  }

  EventQuestions copyWith({String? answer}) {
    return EventQuestions(
      id: id,
      question: question,
      answer: answer ?? this.answer,
      eventId: eventId,
    );
  }
}

class Customer {
  final int customerId;
  final int userId;
  final int? customerPlanId;
  final int horoscopeId;
  final String createdAt;

  Customer({
    required this.customerId,
    required this.userId,
    this.customerPlanId,
    required this.horoscopeId,
    required this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id'],
      userId: json['user_id'],
      customerPlanId: _parseInt(json['customer_plan_id']),
      horoscopeId: _parseInt(json['horoscope_id']) ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }
}
