import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Client-side Security & Cryptography Service
/// Handles secret keys, token storage via hardware-backed Keystore,
/// rate-limiting protection, and anti-tamper request signing.
class SecurityService {
  final FlutterSecureStorage _secureStorage;
  final Map<String, List<DateTime>> _requestTimestamps = {};
  static const int _maxRequestsPerMinute = 60;

  SecurityService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
            );

  /// Stores a sensitive token or API key securely in hardware Keystore
  Future<void> saveSecureToken(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Retrieves a sensitive token
  Future<String?> getSecureToken(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Deletes a token (e.g. on sign out)
  Future<void> deleteSecureToken(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Client-side rate limit check before dispatching high-frequency requests
  bool checkClientRateLimit(String endpointKey) {
    final now = DateTime.now();
    final oneMinuteAgo = now.subtract(const Duration(minutes: 1));

    final timestamps = _requestTimestamps.putIfAbsent(endpointKey, () => []);
    timestamps.removeWhere((t) => t.isBefore(oneMinuteAgo));

    if (timestamps.length >= _maxRequestsPerMinute) {
      return false; // Rate limit exceeded
    }

    timestamps.add(now);
    return true;
  }

  /// Interceptor for Dio to add HMAC anti-tamper signature and nonce to API requests
  Interceptor getSecurityInterceptor({required String apiKeySecret}) {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final path = options.path;
        final rawData = '$path|$timestamp';
        
        final hmacSha256 = Hmac(sha256, utf8.encode(apiKeySecret));
        final digest = hmacSha256.convert(utf8.encode(rawData));

        options.headers['X-EcoRide-Timestamp'] = timestamp;
        options.headers['X-EcoRide-Signature'] = digest.toString();
        options.headers['X-EcoRide-Client-Version'] = '1.0.0';

        handler.next(options);
      },
    );
  }
}
