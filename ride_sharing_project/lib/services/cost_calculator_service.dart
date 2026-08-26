class CostCalculatorService {
  /// Core Formula: Rider Cost = (distanceInKm / carMileageKmPerL) * fuelPricePerL
  static double calculateRiderCost({
    required double distanceKm,
    required double mileageKmPerL,
    required double fuelPricePerL,
  }) {
    if (mileageKmPerL <= 0) return 0.0;
    final cost = (distanceKm / mileageKmPerL) * fuelPricePerL;
    // Round to 2 decimal places
    return double.parse(cost.toStringAsFixed(2));
  }

  /// Cost per kilometer for a specific vehicle and fuel price
  static double calculateCostPerKm({
    required double mileageKmPerL,
    required double fuelPricePerL,
  }) {
    if (mileageKmPerL <= 0) return 0.0;
    return double.parse((fuelPricePerL / mileageKmPerL).toStringAsFixed(2));
  }

  /// Option B: Shared segment splitting
  /// If multiple riders share the same segment, the segment's fuel cost is split equally.
  static double splitSegmentCost({
    required double segmentDistanceKm,
    required double mileageKmPerL,
    required double fuelPricePerL,
    required int numberOfCoRiders, // total riders on this segment
  }) {
    if (mileageKmPerL <= 0 || numberOfCoRiders <= 0) return 0.0;
    final totalSegmentFuelCost = (segmentDistanceKm / mileageKmPerL) * fuelPricePerL;
    final perRiderShare = totalSegmentFuelCost / numberOfCoRiders;
    return double.parse(perRiderShare.toStringAsFixed(2));
  }
}
