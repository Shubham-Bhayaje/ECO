import 'latlng.dart';

class BookingModel {
  final String id;
  final String rideId;
  final String riderId;
  final LatLng pickup;
  final LatLng dropoff;
  final String pickupAddress;
  final String dropoffAddress;
  final double distanceKm;
  final double estimatedCost;
  final String status;
  final DateTime bookedAt;

  const BookingModel({
    required this.id,
    required this.rideId,
    required this.riderId,
    required this.pickup,
    required this.dropoff,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.distanceKm,
    required this.estimatedCost,
    required this.status,
    required this.bookedAt,
  });

  BookingModel copyWith({
    String? id,
    String? rideId,
    String? riderId,
    LatLng? pickup,
    LatLng? dropoff,
    String? pickupAddress,
    String? dropoffAddress,
    double? distanceKm,
    double? estimatedCost,
    String? status,
    DateTime? bookedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      rideId: rideId ?? this.rideId,
      riderId: riderId ?? this.riderId,
      pickup: pickup ?? this.pickup,
      dropoff: dropoff ?? this.dropoff,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropoffAddress: dropoffAddress ?? this.dropoffAddress,
      distanceKm: distanceKm ?? this.distanceKm,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      status: status ?? this.status,
      bookedAt: bookedAt ?? this.bookedAt,
    );
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      rideId: json['rideId'] as String,
      riderId: json['riderId'] as String,
      pickup: LatLng.fromJson(json['pickup'] as Map<String, dynamic>),
      dropoff: LatLng.fromJson(json['dropoff'] as Map<String, dynamic>),
      pickupAddress: json['pickupAddress'] as String,
      dropoffAddress: json['dropoffAddress'] as String,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
      status: json['status'] as String,
      bookedAt: DateTime.parse(json['bookedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rideId': rideId,
      'riderId': riderId,
      'pickup': pickup.toJson(),
      'dropoff': dropoff.toJson(),
      'pickupAddress': pickupAddress,
      'dropoffAddress': dropoffAddress,
      'distanceKm': distanceKm,
      'estimatedCost': estimatedCost,
      'status': status,
      'bookedAt': bookedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'BookingModel(id: $id, rideId: $rideId, riderId: $riderId, status: $status)';
  }
}
