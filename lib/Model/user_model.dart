class UserProfile {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNumber;
  final String chatLanguage;
  final String countryCode;
  final String preferredLocation;
  final String dateOfBirth;
  final String timeOfBirth;
  final String birthLocation;
  final String rashi;
  final String nakshatra;
  final Subscription? subscription;
  final PlanDetails? planDetails;
  final UserNotify? userNotify;
  final bool mobileVerified;
  final String? howYouKnow;

  UserProfile({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNumber,
    required this.chatLanguage,
    required this.countryCode,
    required this.preferredLocation,
    required this.dateOfBirth,
    required this.timeOfBirth,
    required this.birthLocation,
    required this.rashi,
    required this.nakshatra,
    this.subscription,
    this.planDetails,
    this.userNotify,
    required this.mobileVerified,
    this.howYouKnow,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      chatLanguage: json['chat_languages'] ?? '',
      countryCode: json['country_code'] ?? '',
      preferredLocation: json['preferred_location'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      timeOfBirth: json['time_of_birth'] ?? '',
      birthLocation: json['birth_location'] ?? '',
      rashi: json['rashi'] ?? '',
      nakshatra: json['nakshatra'] ?? '',
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'])
          : null,
      planDetails: json['plan_details'] != null
          ? PlanDetails.fromJson(json['plan_details'])
          : null,
      userNotify: json['user_notify'] != null
          ? UserNotify.fromJson(json['user_notify'])
          : null,
      mobileVerified: json['is_mobile_verified'] ?? false,
      howYouKnow: json['referral_source'] ?? '',
    );
  }
}

class Subscription {
  final int id;
  final int userId;
  final int? planId;
  final int? couponId;
  final String subscriptionStartDate;
  final String subscriptionEndDate;
  final String planStatus;
  final bool? isAutoPay;
  final String? autoPayStatus;

  Subscription(
      {required this.id,
      required this.userId,
      this.planId,
      this.couponId,
      required this.subscriptionStartDate,
      required this.subscriptionEndDate,
      required this.planStatus,
      this.isAutoPay,
      this.autoPayStatus
      });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      userId: json['user_id'],
      planId: json['plan_id'],
      couponId: json['coupon_id'],
      subscriptionStartDate: json['subscription_start_date'],
      subscriptionEndDate: json['subscription_end_date'],
      planStatus: json['plan_status'],
      isAutoPay: json['is_auto_pay'],
      autoPayStatus: json['auto_pay_status'],
    ); //auto_pay_status
  }
}

class PlanDetails {
  final int planId;
  final String planName;
  final double localPlanPrice;
  final double foreignPlanPrice;
  final String createdAt;
  final String updatedAt;
  final String status;
  final List<int> planServices;
  final String planType;
  final int tenureValue;
  final String tenureCount;

  PlanDetails({
    required this.planId,
    required this.planName,
    required this.localPlanPrice,
    required this.foreignPlanPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.planServices,
    required this.planType,
    required this.tenureValue,
    required this.tenureCount,
  });

  factory PlanDetails.fromJson(Map<String, dynamic> json) {
    return PlanDetails(
      planId: json['plan_id'],
      planName: json['plan_name'],
      localPlanPrice: (json['local_plan_price'] as num).toDouble(),
      foreignPlanPrice: (json['foreign_plan_price'] as num).toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      planServices: List<int>.from(json['plan_services'] ?? []),
      planType: json['plan_type'],
      tenureValue: json['tenure_value'],
      tenureCount: json['tenure_count'],
    );
  }
}

class UserNotify {
  final int notificationId;
  final int customerId;
  final int horoscopeId;
  final bool dailyPredictions;
  final bool weeklyPredictions;
  final bool yearlyPredictions;
  final bool lifePredictions;
  final bool dailyPanchang;
  final bool promotionOffers;
  final bool warnings;

  UserNotify({
    required this.notificationId,
    required this.customerId,
    required this.horoscopeId,
    required this.dailyPredictions,
    required this.weeklyPredictions,
    required this.yearlyPredictions,
    required this.lifePredictions,
    required this.dailyPanchang,
    required this.promotionOffers,
    required this.warnings,
  });

  factory UserNotify.fromJson(Map<String, dynamic> json) {
    return UserNotify(
      notificationId: json['notification_id'],
      customerId: json['customer_id'],
      horoscopeId: json['horoscope_id'],
      dailyPredictions: json['daily_predictions'],
      weeklyPredictions: json['weekly_predictions'],
      yearlyPredictions: json['yearly_predictions'],
      lifePredictions: json['life_predictions'],
      dailyPanchang: json['daily_panchang'],
      promotionOffers: json['promotion_offers'],
      warnings: json['warnings'],
    );
  }

  UserNotify copyWith({
    int? notificationId,
    int? customerId,
    int? horoscopeId,
    bool? dailyPredictions,
    bool? weeklyPredictions,
    bool? yearlyPredictions,
    bool? lifePredictions,
    bool? dailyPanchang,
    bool? promotionOffers,
    bool? warnings,
  }) {
    return UserNotify(
      notificationId: notificationId ?? this.notificationId,
      customerId: customerId ?? this.customerId,
      horoscopeId: horoscopeId ?? this.horoscopeId,
      dailyPredictions: dailyPredictions ?? this.dailyPredictions,
      weeklyPredictions: weeklyPredictions ?? this.weeklyPredictions,
      yearlyPredictions: yearlyPredictions ?? this.yearlyPredictions,
      lifePredictions: lifePredictions ?? this.lifePredictions,
      dailyPanchang: dailyPanchang ?? this.dailyPanchang,
      promotionOffers: promotionOffers ?? this.promotionOffers,
      warnings: warnings ?? this.warnings,
    );
  }
}
