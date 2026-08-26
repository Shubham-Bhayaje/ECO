import 'latlng.dart';

class RideModel {
  final String id;
  final String driverId;
  final String vehicleId;
  final LatLng origin;
  final LatLng destination;
  final String originAddress;
  final String destinationAddress;
  final List<LatLng>? routePolyline;
  final DateTime departureTime;
  final int totalSeats;
  final int availableSeats;
  final double fuelPrice;
  final bool womenOnly;
  final String status;
  final DateTime createdAt;

  const RideModel({
    required this.id,
    required this.driverId,
    required this.vehicleId,
    required this.origin,
    required this.destination,
    required this.originAddress,
    required this.destinationAddress,
    this.routePolyline,
    required this.departureTime,
    required this.totalSeats,
    required this.availableSeats,
    required this.fuelPrice,
    required this.womenOnly,
    required this.status,
    required this.createdAt,
  });

  RideModel copyWith({
    String? id,
    String? driverId,
    String? vehicleId,
    LatLng? origin,
    LatLng? destination,
    String? originAddress,
    String? destinationAddress,
    List<LatLng>? routePolyline,
    DateTime? departureTime,
    int? totalSeats,
    int? availableSeats,
    double? fuelPrice,
    bool? womenOnly,
    String? status,
    DateTime? createdAt,
  }) {
    return RideModel(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      vehicleId: vehicleId ?? this.vehicleId,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      originAddress: originAddress ?? this.originAddress,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      routePolyline: routePolyline ?? this.routePolyline,
      departureTime: departureTime ?? this.departureTime,
      totalSeats: totalSeats ?? this.totalSeats,
      availableSeats: availableSeats ?? this.availableSeats,
      fuelPrice: fuelPrice ?? this.fuelPrice,
      womenOnly: womenOnly ?? this.womenOnly,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'] as String,
      driverId: json['driverId'] as String,
      vehicleId: json['vehicleId'] as String,
      origin: LatLng.fromJson(json['origin'] as Map<String, dynamic>),
      destination: LatLng.fromJson(json['destination'] as Map<String, dynamic>),
      originAddress: json['originAddress'] as String,
      destinationAddress: json['destinationAddress'] as String,
      routePolyline: (json['routePolyline'] as List<dynamic>?)
          ?.map((e) => LatLng.fromJson(e as Map<String, dynamic>))
          .toList(),
      departureTime: DateTime.parse(json['departureTime'] as String),
      totalSeats: json['totalSeats'] as int,
      availableSeats: json['availableSeats'] as int,
      fuelPrice: (json['fuelPrice'] as num).toDouble(),
      womenOnly: json['womenOnly'] as bool,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'vehicleId': vehicleId,
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'originAddress': originAddress,
      'destinationAddress': destinationAddress,
      'routePolyline': routePolyline?.map((e) => e.toJson()).toList(),
      'departureTime': departureTime.toIso8601String(),
      'totalSeats': totalSeats,
      'availableSeats': availableSeats,
      'fuelPrice': fuelPrice,
      'womenOnly': womenOnly,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'RideModel(id: $id, driverId: $driverId, originAddress: $originAddress, destinationAddress: $destinationAddress)';
  }
}
