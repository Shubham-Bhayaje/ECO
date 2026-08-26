import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/contracts/auth_contract.dart';
import '../services/contracts/map_contract.dart';
import '../services/contracts/calling_contract.dart';
import '../services/firebase/firebase_auth_service.dart';
import '../services/google/google_maps_service.dart';
import '../services/fuel_price_service.dart';
import '../services/chat_service.dart';
import '../services/calling_service.dart';
import '../models/user_model.dart';

// Auth Provider
final authServiceProvider = Provider<AuthContract>((ref) => FirebaseAuthService());

// Maps Provider (Google Maps implementation of MapContract)
final mapServiceProvider = Provider<MapContract>((ref) => GoogleMapsService());

// Fuel Price Provider
final fuelPriceServiceProvider = Provider<FuelPriceService>((ref) => FuelPriceService());

// Chat Service Provider
final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

// Calling Service Provider
final callingServiceProvider = Provider<CallingContract>((ref) => CallingService());

// Auth state stream provider
final authStateProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});

// Current user provider
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).value;
});
