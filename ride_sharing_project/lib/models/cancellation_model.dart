/// Model representing a ride cancellation for penalty tracking.
class CancellationModel {
  final String id;
  final String userId;
  final String rideId;
  final DateTime cancelledAt;
  final DateTime departureTime;
  final bool wasLate; // true if cancelled within 1 hour of departure
  final bool penaltyApplied;

  const CancellationModel({
    required this.id,
    required this.userId,
    required this.rideId,
    required this.cancelledAt,
    required this.departureTime,
    required this.wasLate,
    this.penaltyApplied = false,
  });

  factory CancellationModel.fromJson(Map<String, dynamic> json) {
    return CancellationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      rideId: json['ride_id'] as String,
      cancelledAt: DateTime.parse(json['cancelled_at'] as String),
      departureTime: DateTime.parse(json['departure_time'] as String),
      wasLate: json['was_late'] as bool,
      penaltyApplied: json['penalty_applied'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'ride_id': rideId,
      'cancelled_at': cancelledAt.toIso8601String(),
      'departure_time': departureTime.toIso8601String(),
      'was_late': wasLate,
      'penalty_applied': penaltyApplied,
    };
  }

  CancellationModel copyWith({
    String? id,
    String? userId,
    String? rideId,
    DateTime? cancelledAt,
    DateTime? departureTime,
    bool? wasLate,
    bool? penaltyApplied,
  }) {
    return CancellationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      rideId: rideId ?? this.rideId,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      departureTime: departureTime ?? this.departureTime,
      wasLate: wasLate ?? this.wasLate,
      penaltyApplied: penaltyApplied ?? this.penaltyApplied,
    );
  }

  @override
  String toString() {
    return 'CancellationModel(id: $id, userId: $userId, rideId: $rideId, wasLate: $wasLate, penaltyApplied: $penaltyApplied)';
  }
}
