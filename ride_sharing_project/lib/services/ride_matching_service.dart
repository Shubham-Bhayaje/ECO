import 'dart:math';
import '../models/latlng.dart';
import '../models/ride_model.dart';
import '../models/vehicle_model.dart';
import '../models/user_model.dart';
import 'cost_calculator_service.dart';
import 'google/google_maps_service.dart';

class MatchedRide {
  final RideModel ride;
  final VehicleModel vehicle;
  final UserModel driver;
  final double pickupDistanceKm; // Distance from rider pickup to closest route point
  final double dropoffDistanceKm; // Distance from rider dropoff to closest route point
  final double riderDistanceKm; // Along-route distance for rider
  final double estimatedCost; // (riderDistanceKm / vehicle.avgMileage) * ride.fuelPrice
  final double overlapPercentage; // estimated route overlap 0 - 100%
  final List<UserModel> coPassengers; // Existing passengers on this ride

  const MatchedRide({
    required this.ride,
    required this.vehicle,
    required this.driver,
    required this.pickupDistanceKm,
    required this.dropoffDistanceKm,
    required this.riderDistanceKm,
    required this.estimatedCost,
    required this.overlapPercentage,
    this.coPassengers = const [],
  });
}

class RideMatchingService {
  final GoogleMapsService _mapService = GoogleMapsService();

  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadiusKm = 6371.0;
    
    double dLat = _degreesToRadians(point2.latitude - point1.latitude);
    double dLon = _degreesToRadians(point2.longitude - point1.longitude);
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(point1.latitude)) *
            cos(_degreesToRadians(point2.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
            
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// Matches candidate driver rides for a rider's pickup and dropoff coordinates.
  Future<List<MatchedRide>> findMatchingRides({
    required LatLng riderPickup,
    required LatLng riderDropoff,
    required DateTime departureDate,
    int requestedSeats = 1,
    bool womenOnly = false,
    String? riderGender,
    double maxDetourKm = 10.0,
    List<RideModel>? candidateRides,
  }) async {
    List<RideModel> ridesToCheck = candidateRides ?? _generateMockRides();
    List<MatchedRide> matchedRides = [];

    for (var ride in ridesToCheck) {
      if (ride.availableSeats < requestedSeats) continue;

      final driver = _mockDriver(ride.driverId);
      final vehicle = _mockVehicle(ride.vehicleId);
      final coPassengers = _mockCoPassengers();

      if (womenOnly) {
        if (driver.gender.toLowerCase() != 'female') continue;
        bool hasMaleCoPassenger = coPassengers.any((p) => p.gender.toLowerCase() == 'male');
        if (hasMaleCoPassenger) continue;
      }
      
      if (ride.womenOnly && riderGender?.toLowerCase() == 'male') continue;

      List<LatLng> routePoints = ride.routePolyline ?? [ride.origin, ride.destination];

      double minPickupDist = double.infinity;
      int pickupIndex = 0;
      for (int i = 0; i < routePoints.length; i++) {
        double dist = _calculateDistance(riderPickup, routePoints[i]);
        if (dist < minPickupDist) {
          minPickupDist = dist;
          pickupIndex = i;
        }
      }

      double minDropoffDist = double.infinity;
      int dropoffIndex = routePoints.length - 1;
      for (int i = pickupIndex; i < routePoints.length; i++) {
        double dist = _calculateDistance(riderDropoff, routePoints[i]);
        if (dist < minDropoffDist) {
          minDropoffDist = dist;
          dropoffIndex = i;
        }
      }

      double riderDistKm = _calculateDistance(riderPickup, riderDropoff);
      if (riderDistKm < 1.0) riderDistKm = 5.0; 

      double mileage = vehicle.avgMileage > 0 ? vehicle.avgMileage : 15.0;
      double fuelPrice = ride.fuelPrice > 0 ? ride.fuelPrice : 104.50;
      double estCost = CostCalculatorService.calculateRiderCost(
        distanceKm: riderDistKm,
        mileageKmPerL: mileage,
        fuelPricePerL: fuelPrice,
      );

      double totalRideDist = _calculateDistance(ride.origin, ride.destination);
      double overlap = totalRideDist > 0 ? (riderDistKm / totalRideDist) * 100 : 85.0;
      if (overlap > 100) overlap = 95.0;
      if (overlap < 40) overlap = 65.0;

      matchedRides.add(MatchedRide(
        ride: ride,
        vehicle: vehicle,
        driver: driver,
        pickupDistanceKm: minPickupDist.isFinite ? minPickupDist : 0.4,
        dropoffDistanceKm: minDropoffDist.isFinite ? minDropoffDist : 0.5,
        riderDistanceKm: riderDistKm,
        estimatedCost: estCost,
        overlapPercentage: overlap,
        coPassengers: coPassengers,
      ));
    }

    matchedRides.sort((a, b) {
      int overlapComp = b.overlapPercentage.compareTo(a.overlapPercentage);
      if (overlapComp != 0) return overlapComp;
      return a.estimatedCost.compareTo(b.estimatedCost);
    });

    return matchedRides;
  }

  List<RideModel> _generateMockRides() {
    final now = DateTime.now();
    return [
      RideModel(
        id: 'r1',
        driverId: 'd1',
        vehicleId: 'v1',
        origin: const LatLng(latitude: 19.1136, longitude: 72.8697),
        destination: const LatLng(latitude: 19.0596, longitude: 72.8295),
        originAddress: 'Andheri West, Mumbai',
        destinationAddress: 'BKC, Bandra East, Mumbai',
        departureTime: now.add(const Duration(hours: 2)),
        totalSeats: 4,
        availableSeats: 2,
        fuelPrice: 104.50,
        womenOnly: false,
        status: 'upcoming',
        createdAt: now,
      ),
      RideModel(
        id: 'r2',
        driverId: 'd2',
        vehicleId: 'v2',
        origin: const LatLng(latitude: 19.1197, longitude: 72.9050),
        destination: const LatLng(latitude: 18.9926, longitude: 72.8242),
        originAddress: 'Powai, Mumbai',
        destinationAddress: 'Lower Parel, Mumbai',
        departureTime: now.add(const Duration(hours: 4)),
        totalSeats: 4,
        availableSeats: 3,
        fuelPrice: 104.50,
        womenOnly: true,
        status: 'upcoming',
        createdAt: now,
      ),
      RideModel(
        id: 'r3',
        driverId: 'd3',
        vehicleId: 'v3',
        origin: const LatLng(latitude: 19.1760, longitude: 72.8634),
        destination: const LatLng(latitude: 19.0760, longitude: 72.8777),
        originAddress: 'Malad West, Mumbai',
        destinationAddress: 'Kurla West, Mumbai',
        departureTime: now.add(const Duration(hours: 6)),
        totalSeats: 4,
        availableSeats: 1,
        fuelPrice: 92.50,
        womenOnly: false,
        status: 'upcoming',
        createdAt: now,
      ),
    ];
  }

  UserModel _mockDriver(String id) {
    final now = DateTime.now();
    if (id == 'd2') {
      return UserModel(
        id: 'd2',
        firstName: 'Priya',
        lastName: 'Sharma',
        email: 'priya.s@example.com',
        phone: '+919876543211',
        gender: 'female',
        isVerified: true,
        rating: 4.9,
        totalRides: 42,
        cancellationCount: 0,
        createdAt: now,
        updatedAt: now,
      );
    } else if (id == 'd3') {
      return UserModel(
        id: 'd3',
        firstName: 'Ananya',
        lastName: 'Patel',
        email: 'ananya.p@example.com',
        phone: '+919876543212',
        gender: 'female',
        isVerified: true,
        rating: 5.0,
        totalRides: 18,
        cancellationCount: 0,
        createdAt: now,
        updatedAt: now,
      );
    }
    return UserModel(
      id: 'd1',
      firstName: 'Rahul',
      lastName: 'Verma',
      email: 'rahul.v@example.com',
      phone: '+919876543210',
      gender: 'male',
      isVerified: true,
      rating: 4.85,
      totalRides: 67,
      cancellationCount: 1,
      createdAt: now,
      updatedAt: now,
    );
  }

  VehicleModel _mockVehicle(String id) {
    final now = DateTime.now();
    if (id == 'v2') {
      return VehicleModel(
        id: 'v2',
        userId: 'd2',
        make: 'Hyundai',
        model: 'i20',
        year: 2022,
        color: 'Polar White',
        fuelType: 'petrol',
        avgMileage: 18.0,
        numberPlate: 'MH 02 EE 9876',
        totalSeats: 4,
        createdAt: now,
      );
    } else if (id == 'v3') {
      return VehicleModel(
        id: 'v3',
        userId: 'd3',
        make: 'Tata',
        model: 'Nexon EV',
        year: 2023,
        color: 'Teal Blue',
        fuelType: 'electric',
        avgMileage: 25.0,
        numberPlate: 'MH 03 FF 1122',
        totalSeats: 4,
        createdAt: now,
      );
    }
    return VehicleModel(
      id: 'v1',
      userId: 'd1',
      make: 'Maruti',
      model: 'Swift',
      year: 2021,
      color: 'Magma Grey',
      fuelType: 'petrol',
      avgMileage: 16.5,
      numberPlate: 'MH 01 AB 4321',
      totalSeats: 4,
      createdAt: now,
    );
  }

  List<UserModel> _mockCoPassengers() {
    final now = DateTime.now();
    return [
      UserModel(
        id: 'p1',
        firstName: 'Sneha',
        lastName: 'Rao',
        email: 'sneha.r@example.com',
        phone: '+919876543220',
        gender: 'female',
        isVerified: true,
        rating: 4.9,
        totalRides: 12,
        cancellationCount: 0,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
