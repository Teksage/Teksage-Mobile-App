class AskAstrologerPricing {
  final int planId;
  final double localPlanPrice;
  final double foreignPlanPrice;
  final double cgstPercentage;
  final double sgstPercentage;
  final double cgst;
  final double sgst;
  final double inrTotal;
  final double usdTotal;

  AskAstrologerPricing({
    required this.planId,
    required this.localPlanPrice,
    required this.foreignPlanPrice,
    required this.cgstPercentage,
    required this.sgstPercentage,
    required this.cgst,
    required this.sgst,
    required this.inrTotal,
    required this.usdTotal,
  });

  factory AskAstrologerPricing.fromJson(Map<String, dynamic> json) {
    return AskAstrologerPricing(
      planId: json['plan_id'] as int,
      localPlanPrice: (json['local_plan_price'] as num).toDouble(),
      foreignPlanPrice: (json['foreign_plan_price'] as num).toDouble(),
      cgstPercentage: (json['cgst_percentage'] as num).toDouble(),
      sgstPercentage: (json['sgst_percentage'] as num).toDouble(),
      cgst: (json['cgst'] as num).toDouble(),
      sgst: (json['sgst'] as num).toDouble(),
      inrTotal: (json['inr_total'] as num).toDouble(),
      usdTotal: (json['usd_total'] as num).toDouble(),
    );
  }
}

class AskAstrologerOrderResponse {
  final int requestId;
  final String razorpayOrderId;
  final int amount;
  final String currency;
  final String key;

  AskAstrologerOrderResponse({
    required this.requestId,
    required this.razorpayOrderId,
    required this.amount,
    required this.currency,
    required this.key,
  });

  factory AskAstrologerOrderResponse.fromJson(Map<String, dynamic> json) {
    return AskAstrologerOrderResponse(
      requestId: json['request_id'] as int,
      razorpayOrderId: json['razorpay_order_id'] as String,
      amount: json['amount'] as int,
      currency: json['currency'] as String,
      key: json['key'] as String,
    );
  }
}

class AskAstrologerRequest {
  final int id;
  final String status;
  final String userQuestion;
  final String aiResponse;
  final List<String> preferredLanguages;
  final String? answerText;
  final String? answerVoiceUrl;
  final int? answerVoiceDurationSec;
  final String? answeredAt;
  final String? paidAt;
  final String? createdAt;
  final String? answeredByAstrologerName;
  final String? answeredByAstrologerProfilePath;
  final bool answerReadyAcknowledged;
  final String? customerName;
  final String? dateOfBirth;
  final String? timeOfBirth;
  final String? placeOfBirth;
  final String? rashi;
  final String? nakshatra;

  AskAstrologerRequest({
    required this.id,
    required this.status,
    required this.userQuestion,
    required this.aiResponse,
    required this.preferredLanguages,
    this.answerText,
    this.answerVoiceUrl,
    this.answerVoiceDurationSec,
    this.answeredAt,
    this.paidAt,
    this.createdAt,
    this.answeredByAstrologerName,
    this.answeredByAstrologerProfilePath,
    this.answerReadyAcknowledged = false,
    this.customerName,
    this.dateOfBirth,
    this.timeOfBirth,
    this.placeOfBirth,
    this.rashi,
    this.nakshatra,
  });

  factory AskAstrologerRequest.fromJson(Map<String, dynamic> json) {
    return AskAstrologerRequest(
      id: json['id'] as int,
      status: json['status'] as String,
      userQuestion: json['user_question'] as String,
      aiResponse: json['ai_response'] as String,
      preferredLanguages: List<String>.from(json['preferred_languages'] ?? []),
      answerText: json['answer_text'] as String?,
      answerVoiceUrl: json['answer_voice_url'] as String?,
      answerVoiceDurationSec: json['answer_voice_duration_sec'] as int?,
      answeredAt: json['answered_at'] as String?,
      paidAt: json['paid_at'] as String?,
      createdAt: json['created_at'] as String?,
      answeredByAstrologerName: json['answered_by_astrologer_name'] as String?,
      answeredByAstrologerProfilePath:
          json['answered_by_astrologer_profile_path'] as String?,
      answerReadyAcknowledged: json['answer_ready_acknowledged'] == true,
      customerName: json['customer_name'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      timeOfBirth: json['time_of_birth'] as String?,
      placeOfBirth: json['place_of_birth'] as String?,
      rashi: json['rashi'] as String?,
      nakshatra: json['nakshatra'] as String?,
    );
  }
}

class AskAstrologerFlowState {
  final String userQuestion;
  final String aiResponse;
  final List<String>? preferredLanguages;

  AskAstrologerFlowState({
    required this.userQuestion,
    required this.aiResponse,
    this.preferredLanguages,
  });

  Map<String, dynamic> toJson() => {
        'user_question': userQuestion,
        'ai_response': aiResponse,
        if (preferredLanguages != null) 'preferred_languages': preferredLanguages,
      };

  factory AskAstrologerFlowState.fromJson(Map<String, dynamic> json) {
    return AskAstrologerFlowState(
      userQuestion: json['user_question'] as String,
      aiResponse: json['ai_response'] as String,
      preferredLanguages: json['preferred_languages'] != null
          ? List<String>.from(json['preferred_languages'])
          : null,
    );
  }
}
