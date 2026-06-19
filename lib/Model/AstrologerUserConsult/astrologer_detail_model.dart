class AstrologerResponse {
  final AstrologerDetails astrologer;
  final List<Event> events;

  AstrologerResponse({
    required this.astrologer,
    required this.events,
  });

  factory AstrologerResponse.fromJson(Map<String, dynamic> json) {
    return AstrologerResponse(
      astrologer: AstrologerDetails.fromJson(json['astrologer']),
      events:json['events'] != null
          ?  List<Event>.from(json['events'].map((e) => Event.fromJson(e))) : [],
    );
  }
}

class AstrologerDetails {
  final String astrologerProfileInfo;
  final List<String> expertises;
  final String? picture;
  final int userId;
  final int astrologerId;
  final List<String> languages;
  final int experience;
  final double localConsultingFee;
  final double foreignConsultingFee;
  final int? customerRating;
  final AstrologerUser user;

  AstrologerDetails({
    required this.astrologerProfileInfo,
    required this.expertises,
    required this.picture,
    required this.userId,
    required this.astrologerId,
    required this.languages,
    required this.experience,
    required this.localConsultingFee,
    required this.foreignConsultingFee,
    required this.customerRating,
    required this.user,
  });

  factory AstrologerDetails.fromJson(Map<String, dynamic> json) {
    return AstrologerDetails(
      astrologerProfileInfo: json['astrologer_profile_info'],
      expertises: List<String>.from(json['expertise']),
      picture: json['picture'],
      userId: json['user_id'],
      astrologerId: json['astrologer_id'],
      languages: List<String>.from(json['languages']),
      experience: json['experience'],
      // consultingFee: (json['consulting_fee'] as num).toDouble(),
      localConsultingFee: (json['local_consulting_fee'] as num).toDouble(),
      foreignConsultingFee: (json['foreign_consulting_fee'] as num).toDouble(),
      customerRating: json['customer_rating'],
      user: AstrologerUser.fromJson(json['user']),
    );
  }
}

class AstrologerUser {
  final int userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobileNumber;
  final String? preferredLocation;
  final bool mobileVerified;
  final bool emailVerified;
  final bool profileUpdated;
  final String? status;

  AstrologerUser({
    required this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNumber,
    this.preferredLocation,
    required this.mobileVerified,
    required this.emailVerified,
    required this.profileUpdated,
    this.status,
  });

  factory AstrologerUser.fromJson(Map<String, dynamic> json) {
    return AstrologerUser(
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      mobileNumber: json['mobile_number'],
      preferredLocation: json['preferred_location'],
      mobileVerified: json['is_mobile_verified'] ?? false,
      emailVerified: json['is_email_verified'] ?? false,
      profileUpdated: json['is_profile_updated'] ?? false,
      status: json['status'],
    );
  }
}

class Event {
  final int? rating;
  final int customerId;
  final String firstName;
  final String lastName;

  Event({
    required this.rating,
    required this.customerId,
    required this.firstName,
    required this.lastName,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      rating: json['rating'],
      customerId: json['customer_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}
