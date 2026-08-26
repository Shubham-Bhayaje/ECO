import 'package:ride_sharing_project/models/user_model.dart';

/// Abstract contract for authentication services.
abstract class AuthContract {
  /// Sign in with phone number — returns verification ID for OTP.
  Future<String> signInWithPhone(String phoneNumber);
  
  /// Verify OTP code — returns authenticated user.
  Future<UserModel?> verifyOtp(String verificationId, String otp);
  
  /// Sign in with Google — returns authenticated user.
  Future<UserModel?> signInWithGoogle();
  
  /// Sign out current user.
  Future<void> signOut();
  
  /// Stream of auth state changes.
  Stream<UserModel?> authStateChanges();
  
  /// Get current user.
  UserModel? get currentUser;
  
  /// Get current user's Firebase UID (or equivalent auth ID).
  String? get currentUserId;
}
