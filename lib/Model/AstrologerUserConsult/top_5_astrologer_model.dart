class Top5AstrologerConsultUserData {
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
  final AstroUser user;
  final int matchPercentage;

  Top5AstrologerConsultUserData({
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
    required this.matchPercentage,
  });

  factory Top5AstrologerConsultUserData.fromJson(Map<String, dynamic> json) {
    return Top5AstrologerConsultUserData(
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
      user: AstroUser.fromJson(json['user']),
      matchPercentage: json['match_percentage'],
    );
  }
}

class AstroUser {
  final String? mobileNumber;
  final bool mobileVerified;
  final bool profileUpdated;
  final String userType;
  final int userId;
  final String? firstName;
  final String? lastName;
  final String email;
  final bool emailVerified;
  final String? preferredLocation;
  final String? status;

  AstroUser({
    required this.mobileNumber,
    required this.mobileVerified,
    required this.profileUpdated,
    required this.userType,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.emailVerified,
    required this.preferredLocation,
    required this.status,
  });

  factory AstroUser.fromJson(Map<String, dynamic> json) {
    return AstroUser(
      mobileNumber: json['mobile_number'],
      mobileVerified: json['is_mobile_verified'],
      profileUpdated: json['is_profile_updated'],
      userType: json['user_type'],
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      emailVerified: json['is_email_verified'],
      preferredLocation: json['preferred_location'],
      status: json['status'],
    );
  }
}
