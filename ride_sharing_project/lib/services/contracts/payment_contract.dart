/// Result of a payment operation.
class PaymentResult {
  final bool success;
  final String? paymentId;
  final String? errorMessage;

  const PaymentResult({
    required this.success,
    this.paymentId,
    this.errorMessage,
  });
}

/// Abstract contract for payment services.
abstract class PaymentContract {
  /// Create a subscription for a user.
  Future<PaymentResult> createSubscription(String userId, String planId, double amount);
  
  /// Cancel an active subscription.
  Future<void> cancelSubscription(String userId);
  
  /// Verify if a payment was successful.
  Future<bool> verifyPayment(String paymentId);
}
