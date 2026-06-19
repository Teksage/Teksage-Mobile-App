class SubscriptionPlanModel {
  final String planName;
  final double localPlanPrice;
  final DateTime createdAt;
  final String status;
  final List<int> services;
  final String durationUnit;
  final int planId;
  final double foreignPlanPrice;
  final DateTime updatedAt;
  final String serviceType;
  final int durationValue;
  final double cgstPercentage;
  final double cgstAmount;
  final double sgstPercentage;
  final double sgstAmount;
  final double localTotalAmount;
  final double foreignTotalAmount;
  final String os;

  SubscriptionPlanModel({
    required this.planName,
    required this.localPlanPrice,
    required this.createdAt,
    required this.status,
    required this.services,
    required this.durationUnit,
    required this.planId,
    required this.foreignPlanPrice,
    required this.updatedAt,
    required this.serviceType,
    required this.durationValue,
    required this.cgstPercentage,
    required this.cgstAmount,
    required this.sgstPercentage,
    required this.sgstAmount,
    required this.localTotalAmount,
    required this.foreignTotalAmount,
    required this.os,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      planName: json['plan_name'],
      localPlanPrice: (json['local_plan_price'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'],
      services: List<int>.from(json['plan_services']),
      durationUnit: json['tenure_count'],
      planId: json['plan_id'],
      foreignPlanPrice: (json['foreign_plan_price'] ?? 0).toDouble(),
      updatedAt: DateTime.parse(json['updated_at']),
      serviceType: json['plan_type'],
      durationValue: json['tenure_value'],
      cgstPercentage: (json['cgst_percentage'] ?? 0).toDouble(),
      cgstAmount: (json['cgst'] ?? 0).toDouble(),
      sgstPercentage: (json['sgst_percentage'] ?? 0).toDouble(),
      sgstAmount: (json['sgst'] ?? 0).toDouble(),
      localTotalAmount: (json['local_total_amount'] ?? 0).toDouble(),
      foreignTotalAmount: (json['foreign_total_amount'] ?? 0).toDouble(),
      os: (json['os_type']),
    );
  }
}
