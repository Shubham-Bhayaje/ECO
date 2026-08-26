# 🌱 EcoRide (MY-GIG) — Smart Non-Profit Carpooling Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.27.4-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6.0-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/Riverpod-2.6.1-00D2B8)](https://riverpod.dev)
[![Maps](https://img.shields.io/badge/Maps-Esri%20%7C%20OSM-007AC2)](https://www.esri.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**EcoRide** is a modern, enterprise-grade commuter carpooling platform built with Flutter. Designed strictly under the **Non-Profit Cost Recovery Standard (Option B)**, EcoRide eliminates platform surcharges and driver profits, connecting daily commuters along overlapping routes to share exact fuel expenses seamlessly and securely.

---

## 📸 Key Features & Capabilities

### 1. 🛡️ Identity & Commuter Trust
- **Mobile Number Authentication (`+91`)**: Passwordless SMS OTP verification with automatic timeout handling and resend timers.
- **Live Front Camera Selfie Verification**: Real-time biometric face capture using native device hardware (`image_picker`) with an oval scanning viewfinder and encrypted safety verification badges.
- **Existing vs. New Commuter Intelligence**: Skips redundant selfie checks for logged-in users while enforcing verification for new signups.
- **Mandatory 3-Permission Security Gate**: Requires Location, Push Notifications, and In-App VoIP Calling before entering the platform to ensure ride security.

### 2. 🗺️ Minimalist Clean Maps & Route Overlap Matching
- **Watermark-Free Modern Canvas**: Powered by Esri World Light Gray Base tiles and OpenStreetMap for ultra-clean map rendering.
- **Pickup & Drop-off Route Previews**: Interactive polylines, start/destination pins, and live GPS geolocation.
- **Sub-Route Overlap Search**: Smart commuter matching based on distance and deviation limits along driver corridors.

### 3. ⛽ Strictly Non-Profit Fuel Cost Calculator
- Calculates exact fuel contributions without commercial markup:
  $$\text{Rider Share} = \frac{\text{Distance (km)}}{\text{Vehicle Mileage (km/L)}} \times \text{Fuel Price (₹/L)} \div (\text{Booked Seats} + 1)$$
- Displays transparent breakdowns for fuel, tolls, and maintenance wear-and-tear savings.

### 4. 📞 Privacy-Preserving VoIP Masked Calling & Real-Time Chat
- **In-App Encrypted Audio Calls**: Direct VoIP calling between drivers and riders without revealing personal phone numbers.
- **Live In-App Messaging**: Instant communication with clean single-pill input bars, unread counters, and instant trip status sync.

### 5. 🚗 Driver & Rider Hub
- **Post & Search Rides**: Detailed pickup/dropoff selectors, departure timings, seat availability, and luggage options.
- **My Rides Dashboard**: Interactive card previews with status tabs (*Upcoming*, *Completed*, *Cancelled*) and single-tap request management.
- **Profile & Safety Preferences**: Includes a dedicated **Women-Only Carpool Filter**, Auto-Accept for KYC-verified riders, vehicle management, and Annual Pass membership controls.

---

## 📱 Tech Stack & Libraries

| Category | Technology |
|---|---|
| **Framework** | Flutter 3.27.4 / Dart SDK `^3.6.0` |
| **Architecture** | Feature-First Clean Architecture with Service Contracts |
| **State Management** | Flutter Riverpod `^2.6.1` |
| **Navigation** | GoRouter `^14.8.1` |
| **Maps & Spatial** | `flutter_map: ^7.0.2`, `latlong2: ^0.9.1`, `google_maps_flutter: ^2.10.0` |
| **Hardware & Native** | `image_picker: ^1.1.2`, `geolocator: ^13.0.2`, `permission_handler: ^11.3.1` |
| **Networking & HTTP** | `dio: ^5.7.0`, `web_socket_channel: ^3.0.2` |
| **Storage & Caching** | `flutter_secure_storage: ^9.2.4`, `shared_preferences: ^2.3.5`, `cached_network_image: ^3.4.1` |

---

## 📂 Project Structure

```text
lib/
├── app.dart                    # App root, Theme, and GoRouter initialization
├── config/
│   ├── constants.dart          # Colors, typography, spacing, and fuel constants
│   ├── routes.dart             # GoRouter route definitions & page builders
│   └── theme.dart              # Custom Emerald/Slate executive design system
├── models/
│   ├── booking_model.dart      # Ride booking requests and seat tracking
│   ├── ride_model.dart         # Ride offers, waypoints, and pricing breakdown
│   ├── user_model.dart         # Commuter profile, KYC status, and ratings
│   └── vehicle_model.dart      # Car make, model, fuel type, and mileage
├── pages/
│   ├── auth/                   # PhoneAuthScreen, OtpScreen, SignUpScreen
│   ├── driver/                 # PostRideScreen, MyRidesScreen, RideRequestsScreen
│   ├── rider/                  # SearchRidesScreen, RideResultsScreen, RideDetailScreen
│   ├── chat/                   # ConversationsListScreen, ChatScreen
│   ├── calling/                # MaskedCallScreen (VoIP In-App Calling)
│   ├── profile/                # ProfileScreen, Settings Bottom Sheet
│   └── selfie_verification_screen.dart # Live camera biometric capture
├── providers/
│   └── service_providers.dart  # Riverpod dependency injection & service singletons
├── services/
│   ├── contracts/              # Abstract service interfaces (Auth, Map, Call, DB)
│   ├── cost_calculator_service.dart # Pure non-commercial fuel split logic
│   └── routing_service.dart    # Route polyline & distance calculation
└── widgets/
    ├── cost_breakdown_card.dart# Transparent cost sharing visualization
    ├── map_route_preview.dart  # Reusable Esri tile map widget
    └── ride_card.dart          # Interactive commuter ride card
```

---

## 🛠️ Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`v3.27.4` or higher)
- Android Studio / VS Code with Flutter extensions
- Android Device (API 26+) or Emulator

### 1. Clone the Repository
```bash
git clone https://github.com/Shubham-Bhayaje/MY-GIG.git
cd MY-GIG/ride_sharing_project
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the App
```bash
# Run on connected Android device
flutter run
```

---

## 🔒 Security & Privacy Guidelines

- **Encrypted Biometric Check**: Live selfie images are used strictly for identity verification and anti-fraud duplicate account prevention.
- **Masked Communication**: No commuter's personal phone number or email is publicly visible to co-passengers.
- **Safety First**: Emergency SOS and in-trip telemetry sharing provide real-time peace of mind.

---

## 📄 License
This project is open-source and licensed under the [MIT License](LICENSE).
