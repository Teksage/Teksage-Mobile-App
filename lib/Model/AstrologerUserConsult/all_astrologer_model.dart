class AllAstrologerConsultUserData {
  final String astrologerProfileInfo;
  final List<String> expertise;
  final String? picture;
  final int userId;
  final int astrologerId;
  final List<String> languages;
  final int experience;
  final double localConsultingFee;
  final double foreignConsultingFee;
  final int? customerRating;
  final AstrologerUser user;

  AllAstrologerConsultUserData({
    required this.astrologerProfileInfo,
    required this.expertise,
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

  factory AllAstrologerConsultUserData.fromJson(Map<String, dynamic> json) {
    return AllAstrologerConsultUserData(
      astrologerProfileInfo: json['astrologer_profile_info'] ?? '',
      // expertises: List<String>.from(json['expertises'] ?? []),
      expertise: List<String>.from(json['expertise'] ?? []),
      picture: json['picture'],
      userId: json['user_id'],
      astrologerId: json['astrologer_id'],
      languages: List<String>.from(json['languages'] ?? []),
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
  final String? mobileNumber;
  final String? userType;
  final int userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final bool emailVerified;
  final bool mobileVerified;
  final bool profileUpdated;
  final String? status;

  AstrologerUser({
    required this.mobileNumber,
    required this.userType,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.emailVerified,
    required this.mobileVerified,
    required this.profileUpdated,
    required this.status,
  });

  factory AstrologerUser.fromJson(Map<String, dynamic> json) {
    return AstrologerUser(
      mobileNumber: json['mobile_number'],
      userType: json['user_type'],
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      emailVerified: json['is_email_verified'] ?? false,
      mobileVerified: json['is_mobile_verified'] ?? false,
      profileUpdated: json['is_profile_updated'] ?? false,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobile_number': mobileNumber,
      'user_type': userType,
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'email_verified': emailVerified,
      'mobile_verified': mobileVerified,
      'profile_updated': profileUpdated,
      'status': status,
    };
  }
}
