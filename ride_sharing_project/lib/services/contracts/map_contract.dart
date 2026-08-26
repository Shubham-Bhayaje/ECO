import 'package:ride_sharing_project/models/latlng.dart';

/// Suggestion for a place during search.
class PlaceSuggestion {
  final String placeId;
  final String description;
  final String? mainText;
  final String? secondaryText;

  const PlaceSuggestion({
    required this.placeId,
    required this.description,
    this.mainText,
    this.secondaryText,
  });

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'description': description,
      'mainText': mainText,
      'secondaryText': secondaryText,
    };
  }

  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    return PlaceSuggestion(
      placeId: json['placeId'] as String,
      description: json['description'] as String,
      mainText: json['mainText'] as String?,
      secondaryText: json['secondaryText'] as String?,
    );
  }
}

/// Information about a route.
class RouteInfo {
  final List<LatLng> polylinePoints;
  final double distanceKm;
  final int durationMinutes;
  final String distanceText;
  final String durationText;

  const RouteInfo({
    required this.polylinePoints,
    required this.distanceKm,
    required this.durationMinutes,
    required this.distanceText,
    required this.durationText,
  });
}

/// Abstract contract for map and location services.
abstract class MapContract {
  /// Get route information between two points.
  Future<RouteInfo> getRoute(LatLng origin, LatLng destination);
  
  /// Get direct distance in kilometers between two points.
  Future<double> getDistanceKm(LatLng from, LatLng to);
  
  /// Search for places matching a query.
  Future<List<PlaceSuggestion>> searchPlaces(String query);
  
  /// Geocode a string address into coordinates.
  Future<LatLng> geocodeAddress(String address);
  
  /// Reverse geocode coordinates into a string address.
  Future<String> reverseGeocode(LatLng coords);
  
  /// Get detailed coordinates for a place ID.
  Future<LatLng?> getPlaceDetails(String placeId);
}
