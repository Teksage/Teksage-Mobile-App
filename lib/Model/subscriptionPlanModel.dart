class PlanModel {
  final double foreignPlanPrice;
  final int planId;
  final String updatedAt;
  final String planType;
  final int tenureValue;
  final String createdAt;
  final double localPlanPrice;
  final String planName;
  final String status;
  final List<int> planServices;
  final String tenureCount;

  PlanModel({
    required this.foreignPlanPrice,
    required this.planId,
    required this.updatedAt,
    required this.planType,
    required this.tenureValue,
    required this.createdAt,
    required this.localPlanPrice,
    required this.planName,
    required this.status,
    required this.planServices,
    required this.tenureCount,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      foreignPlanPrice: json['foreign_plan_price']?.toDouble() ?? 0.0,
      planId: json['plan_id'] ?? 0,
      updatedAt: json['updated_at'] ?? '',
      planType: json['plan_type'] ?? '',
      tenureValue: json['tenure_value'] ?? 0,
      createdAt: json['created_at'] ?? '',
      localPlanPrice: json['local_plan_price']?.toDouble() ?? 0.0,
      planName: json['plan_name'] ?? '',
      status: json['status'] ?? '',
      planServices: List<int>.from(json['plan_services'] ?? []),
      tenureCount: json['tenure_count'] ?? '',
    );
  }
}
