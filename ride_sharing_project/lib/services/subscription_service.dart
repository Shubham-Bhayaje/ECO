import '../models/subscription_model.dart';

/// Manages the EcoRide carpooling membership.
/// Plan pricing: First Month FREE Trial, then ₹120 / Year (₹10/month).
abstract class SubscriptionService {
  Future<SubscriptionModel> getSubscriptionStatus(String userId);
  Future<SubscriptionModel> activateFreeTrial(String userId);
  Future<SubscriptionModel> purchaseYearlyPass({
    required String userId,
    required String paymentMethod,
  });
  Future<bool> hasActiveSubscription(String userId);
}

class DefaultSubscriptionService implements SubscriptionService {
  final Map<String, SubscriptionModel> _store = {};

  @override
  Future<SubscriptionModel> getSubscriptionStatus(String userId) async {
    if (_store.containsKey(userId)) {
      return _store[userId]!;
    }
    // Default to active 1st month free trial
    return activateFreeTrial(userId);
  }

  @override
  Future<SubscriptionModel> activateFreeTrial(String userId) async {
    final now = DateTime.now();
    final sub = SubscriptionModel(
      id: 'sub_trial_$userId',
      userId: userId,
      plan: '1st Month Free Trial',
      startDate: now,
      expiryDate: now.add(const Duration(days: 30)),
      paymentId: 'free_trial',
      status: 'active',
      createdAt: now,
    );
    _store[userId] = sub;
    return sub;
  }

  @override
  Future<SubscriptionModel> purchaseYearlyPass({
    required String userId,
    required String paymentMethod,
  }) async {
    final now = DateTime.now();
    final sub = SubscriptionModel(
      id: 'sub_yearly_$userId',
      userId: userId,
      plan: '₹120 / Year Pass',
      startDate: now,
      expiryDate: now.add(const Duration(days: 365)),
      paymentId: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      status: 'active',
      createdAt: now,
    );
    _store[userId] = sub;
    return sub;
  }

  @override
  Future<bool> hasActiveSubscription(String userId) async {
    final sub = await getSubscriptionStatus(userId);
    return sub.isActive;
  }
}
