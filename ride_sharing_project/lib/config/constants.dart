class AppConstants {
  static const String appName = 'EcoRide';
  static const String apiBaseUrl = 'https://api.ecoride.placeholder.com';
  
  static const List<String> defaultFuelTypes = ['petrol', 'diesel', 'cng', 'electric'];
  
  // Ranges
  static const double minMileage = 5.0;
  static const double maxMileage = 50.0;
  static const double minFuelPrice = 50.0;
  static const double maxFuelPrice = 200.0;
  
  // Lengths
  static const int otpLength = 4;
  static const int phoneNumberLength = 10;
  static const int maxChatMessageLength = 1000;
  
  // Time limits
  static const int cancellationFreePeriodMinutes = 60;
  
  // Subscription
  static const int freeTrialDays = 30;
  static const double yearlyPrice = 120.0;
}
