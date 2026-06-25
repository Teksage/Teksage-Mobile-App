class CouponModel {
  final double planPrice;
  final double discount;
  final double discountedPrice;
  final double cgstPercentage;
  final double cgstAmount;
  final double sgstPercentage;
  final double sgstAmount;
  final double finalPrice;
  final int couponId;

  CouponModel({
    required this.planPrice,
    required this.discount,
    required this.discountedPrice,
    required this.cgstPercentage,
    required this.cgstAmount,
    required this.sgstPercentage,
    required this.sgstAmount,
    required this.finalPrice,
    required this.couponId,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      planPrice: json['plan_price']?.toDouble() ?? 0.0,
      discount: json['discount']?.toDouble() ?? 0.0,
      discountedPrice: json['discounted_price']?.toDouble() ?? 0.0,
      cgstPercentage: json['cgst_percentage']?.toDouble() ?? 0.0,
      cgstAmount: json['cgst']?.toDouble() ?? 0.0,
      sgstPercentage: json['sgst_percentage']?.toDouble() ?? 0.0,
      sgstAmount: json['sgst']?.toDouble() ?? 0.0,
      finalPrice: json['final_price']?.toDouble() ?? 0.0,
      couponId: json['coupon_id'] ?? 0,
    );
  }
}
