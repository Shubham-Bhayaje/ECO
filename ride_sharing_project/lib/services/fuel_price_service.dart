class FuelPriceService {
  static const Map<String, double> _basePrices = {
    'petrol': 104.50,
    'diesel': 92.50,
    'cng': 86.00,
    'electric': 15.00,
  };

  static const List<String> supportedFuelTypes = [
    'petrol',
    'diesel',
    'cng',
    'electric'
  ];

  double getFuelPrice(String fuelType, {String? city}) {
    final normalizedType = fuelType.toLowerCase();
    if (_basePrices.containsKey(normalizedType)) {
      // In a real app, adjust based on city if needed.
      return _basePrices[normalizedType]!;
    }
    return 104.50; // Fallback to petrol
  }

  Map<String, double> getAllPrices({String? city}) {
    // In a real app, adjust based on city if needed.
    return Map<String, double>.from(_basePrices);
  }
}
