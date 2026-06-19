class PaymentUpdateResult {
  final bool success;
  final String? errorMessage;
  final String? message;

  PaymentUpdateResult({required this.success, this.errorMessage, this.message});
}

