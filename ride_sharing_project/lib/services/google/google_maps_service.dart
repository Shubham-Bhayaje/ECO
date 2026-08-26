import 'dart:math' as math;
import 'package:ride_sharing_project/models/latlng.dart';
import 'package:ride_sharing_project/services/contracts/map_contract.dart';

class GoogleMapsService implements MapContract {
  // In a real implementation, you would inject an HTTP client and use Google Maps API.
  
  @override
  Future<RouteInfo> getRoute(LatLng origin, LatLng destination) async {
    // Simulated fallback points so UI never breaks
    final distanceKm = await getDistanceKm(origin, destination);
    final durationMinutes = (distanceKm / 40.0) * 60.0; // Assuming 40km/h avg speed

    return RouteInfo(
      polylinePoints: [origin, destination],
      distanceKm: distanceKm,
      durationMinutes: durationMinutes.round(),
      distanceText: '${distanceKm.toStringAsFixed(1)} km',
      durationText: '${durationMinutes.toStringAsFixed(0)} mins',
    );
  }

  @override
  Future<double> getDistanceKm(LatLng from, LatLng to) async {
    // Haversine formula
    const double earthRadius = 6371; // km
    final dLat = _degreesToRadians(to.latitude - from.latitude);
    final dLon = _degreesToRadians(to.longitude - from.longitude);
    
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(from.latitude)) *
            math.cos(_degreesToRadians(to.latitude)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
            
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }
  
  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  @override
  Future<List<PlaceSuggestion>> searchPlaces(String query) async {
    // Simulated
    return [
      PlaceSuggestion(placeId: 'sim_1', description: '$query City Center'),
      PlaceSuggestion(placeId: 'sim_2', description: '$query Station'),
    ];
  }

  @override
  Future<LatLng> geocodeAddress(String address) async {
    // Simulated
    return const LatLng(latitude: 28.6139, longitude: 77.2090); // New Delhi
  }

  @override
  Future<String> reverseGeocode(LatLng coords) async {
    // Simulated
    return '123 Main St, Near City Center';
  }

  @override
  Future<LatLng?> getPlaceDetails(String placeId) async {
    // Simulated
    return const LatLng(latitude: 28.6139, longitude: 77.2090);
  }

  /// Polyline decoding utility
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      final p = LatLng(
        latitude: lat / 1E5,
        longitude: lng / 1E5,
      );
      poly.add(p);
    }
    return poly;
  }
}
