import 'package:ride_sharing_project/models/user_model.dart';
import 'package:ride_sharing_project/models/vehicle_model.dart';
import 'package:ride_sharing_project/models/ride_model.dart';
import 'package:ride_sharing_project/models/booking_model.dart';
import 'package:ride_sharing_project/models/chat_model.dart';
import 'package:ride_sharing_project/models/message_model.dart';
import 'package:ride_sharing_project/models/review_model.dart';
import 'package:ride_sharing_project/models/subscription_model.dart';
import 'package:ride_sharing_project/models/cancellation_model.dart';
import 'package:ride_sharing_project/models/driver_document_model.dart';

/// Abstract contract for database operations.
abstract class DatabaseContract {
  // Users
  /// Create a new user.
  Future<void> createUser(UserModel user);
  /// Get a user by ID.
  Future<UserModel?> getUser(String id);
  /// Update an existing user.
  Future<void> updateUser(UserModel user);
  /// Delete a user.
  Future<void> deleteUser(String id);

  // Vehicles
  /// Create a new vehicle.
  Future<void> createVehicle(VehicleModel vehicle);
  /// Get all vehicles for a specific user.
  Future<List<VehicleModel>> getVehiclesByUser(String userId);
  /// Update an existing vehicle.
  Future<void> updateVehicle(VehicleModel vehicle);
  /// Delete a vehicle.
  Future<void> deleteVehicle(String id);

  // Rides
  /// Create a new ride.
  Future<void> createRide(RideModel ride);
  /// Get a ride by ID.
  Future<RideModel?> getRideById(String id);
  /// Update an existing ride.
  Future<void> updateRide(RideModel ride);
  /// Get all upcoming rides.
  Future<List<RideModel>> getUpcomingRides();
  /// Search for nearby rides within a specific radius.
  Future<List<RideModel>> searchNearbyRides(double lat, double lng, double radiusKm);
  /// Get all rides associated with a specific driver.
  Future<List<RideModel>> getRidesByDriver(String driverId);

  // Bookings
  /// Create a new booking.
  Future<void> createBooking(BookingModel booking);
  /// Get all bookings for a specific ride.
  Future<List<BookingModel>> getBookingsByRide(String rideId);
  /// Get all bookings for a specific rider.
  Future<List<BookingModel>> getBookingsByRider(String riderId);
  /// Update the status of a booking.
  Future<void> updateBookingStatus(String id, String status);

  // Chats
  /// Create a new chat.
  Future<void> createChat(ChatModel chat);
  /// Get all chats for a specific user.
  Future<List<ChatModel>> getChatsByUser(String userId);
  /// Get a chat by ID.
  Future<ChatModel?> getChatById(String id);

  // Messages
  /// Send a new message.
  Future<void> sendMessage(MessageModel message);
  /// Get a stream of messages for a specific chat.
  Stream<List<MessageModel>> getMessagesByChat(String chatId);
  /// Mark a message as read.
  Future<void> markMessageAsRead(String messageId);

  // Reviews
  /// Create a new review.
  Future<void> createReview(ReviewModel review);
  /// Get all reviews left by a specific user.
  Future<List<ReviewModel>> getReviewsByUser(String userId);
  /// Get all reviews for a specific ride.
  Future<List<ReviewModel>> getReviewsByRide(String rideId);

  // Subscriptions
  /// Create a new subscription.
  Future<void> createSubscription(SubscriptionModel subscription);
  /// Get a subscription for a specific user.
  Future<SubscriptionModel?> getSubscriptionByUser(String userId);
  /// Update an existing subscription.
  Future<void> updateSubscription(SubscriptionModel subscription);

  // Cancellations
  /// Create a new cancellation.
  Future<void> createCancellation(CancellationModel cancellation);
  /// Get all cancellations by a specific user.
  Future<List<CancellationModel>> getCancellationsByUser(String userId);
  /// Get the total count of cancellations for a specific user.
  Future<int> getCancellationCountByUser(String userId);

  // Driver Documents
  /// Upload a driver document.
  Future<void> uploadDriverDocument(DriverDocumentModel document);
  /// Get all documents for a specific driver.
  Future<List<DriverDocumentModel>> getDriverDocumentsByUser(String userId);
  /// Update the status of a driver document.
  Future<void> updateDriverDocumentStatus(String id, String status);
}
