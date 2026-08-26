/// Abstract contract for notification services.
abstract class NotificationContract {
  /// Initialize notification service.
  Future<void> initialize();
  
  /// Get FCM token (or equivalent device token).
  Future<String?> getDeviceToken();
  
  /// Subscribe to a topic.
  Future<void> subscribeToTopic(String topic);
  
  /// Unsubscribe from a topic.
  Future<void> unsubscribeFromTopic(String topic);
  
  /// Handle incoming notification when app is in foreground.
  Stream<Map<String, dynamic>> onForegroundMessage();
  
  /// Handle notification tap (app opened from notification).
  Stream<Map<String, dynamic>> onNotificationTap();
}
