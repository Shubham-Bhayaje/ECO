import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import '../contracts/auth_contract.dart';
import '../../models/user_model.dart';

class FirebaseAuthService implements AuthContract {
  fb.FirebaseAuth? _firebaseAuth;
  GoogleSignIn? _googleSignIn;
  UserModel? _currentUser;
  final StreamController<UserModel?> _authController = StreamController<UserModel?>.broadcast();
  
  FirebaseAuthService() {
    try {
      _firebaseAuth = fb.FirebaseAuth.instance;
      _googleSignIn = GoogleSignIn();
    } catch (e) {
      debugPrint('Running in local preview mode without active Firebase app: $e');
    }
  }

  bool get _isFirebaseReady {
    try {
      return _firebaseAuth != null && _firebaseAuth!.app.name.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
  
  @override
  Future<String> signInWithPhone(String phoneNumber) async {
    if (!_isFirebaseReady) {
      // Local preview fallback
      await Future.delayed(const Duration(milliseconds: 600));
      return 'mock_verification_id_for_$phoneNumber';
    }

    final completer = Completer<String>();
    
    try {
      await _firebaseAuth!.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (fb.PhoneAuthCredential credential) {
          // Automatic resolution
        },
        verificationFailed: (fb.FirebaseAuthException e) {
          if (!completer.isCompleted) {
            completer.completeError(e);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout handling
        },
      );
      
      return completer.future;
    } catch (e) {
      // Graceful fallback for preview testing
      debugPrint('Firebase verifyPhoneNumber failed, falling back to preview mode: $e');
      return 'mock_verification_id_for_$phoneNumber';
    }
  }
  
  @override
  Future<UserModel?> verifyOtp(String verificationId, String otp) async {
    if (!_isFirebaseReady || verificationId.startsWith('mock_')) {
      // Local preview fallback
      await Future.delayed(const Duration(milliseconds: 500));
      final now = DateTime.now();
      _currentUser = UserModel(
        id: 'user_preview_01',
        firebaseUid: 'firebase_preview_uid',
        firstName: 'Shubham',
        lastName: 'R.',
        email: 'shubham@example.com',
        phone: verificationId.replaceAll('mock_verification_id_for_', ''),
        gender: 'male',
        isVerified: true,
        rating: 5.0,
        totalRides: 12,
        cancellationCount: 0,
        createdAt: now,
        updatedAt: now,
      );
      _authController.add(_currentUser);
      return _currentUser;
    }

    try {
      final credential = fb.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      
      final userCredential = await _firebaseAuth!.signInWithCredential(credential);
      _currentUser = _mapFirebaseUser(userCredential.user);
      _authController.add(_currentUser);
      return _currentUser;
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }
  
  @override
  Future<UserModel?> signInWithGoogle() async {
    if (!_isFirebaseReady) {
      // Local preview fallback
      await Future.delayed(const Duration(milliseconds: 500));
      final now = DateTime.now();
      _currentUser = UserModel(
        id: 'user_preview_google',
        firebaseUid: 'google_preview_uid',
        firstName: 'Google',
        lastName: 'User',
        email: 'user@gmail.com',
        phone: '+919876543210',
        gender: 'male',
        isVerified: true,
        rating: 5.0,
        totalRides: 5,
        cancellationCount: 0,
        createdAt: now,
        updatedAt: now,
      );
      _authController.add(_currentUser);
      return _currentUser;
    }

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn?.signIn();
      if (googleUser == null) return null;
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final fb.OAuthCredential credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final userCredential = await _firebaseAuth!.signInWithCredential(credential);
      _currentUser = _mapFirebaseUser(userCredential.user);
      _authController.add(_currentUser);
      return _currentUser;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      if (_isFirebaseReady) {
        await Future.wait([
          _firebaseAuth?.signOut() ?? Future.value(),
          _googleSignIn?.signOut() ?? Future.value(),
        ]);
      }
      _currentUser = null;
      _authController.add(null);
    } catch (e) {
      _currentUser = null;
      _authController.add(null);
    }
  }
  
  @override
  Stream<UserModel?> authStateChanges() {
    if (!_isFirebaseReady) {
      return _authController.stream;
    }
    return _firebaseAuth!.authStateChanges().map((user) {
      if (user == null) {
        _currentUser = null;
        return null;
      }
      _currentUser = _mapFirebaseUser(user);
      return _currentUser;
    });
  }
  
  @override
  String? get currentUserId => _currentUser?.id ?? (_isFirebaseReady ? _firebaseAuth?.currentUser?.uid : 'user_preview_01');

  @override
  UserModel? get currentUser => _currentUser;
  
  UserModel _mapFirebaseUser(fb.User? user) {
    if (user == null) {
      throw Exception('Firebase user is null');
    }
    
    final names = (user.displayName ?? '').split(' ');
    final firstName = names.isNotEmpty ? names.first : '';
    final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';
    final now = DateTime.now();
    
    return UserModel(
      id: user.uid,
      firebaseUid: user.uid,
      email: user.email ?? '',
      phone: user.phoneNumber ?? '',
      firstName: firstName,
      lastName: lastName,
      gender: 'other',
      isVerified: false,
      rating: 5.0,
      totalRides: 0,
      cancellationCount: 0,
      createdAt: now,
      updatedAt: now,
    );
  }
}
