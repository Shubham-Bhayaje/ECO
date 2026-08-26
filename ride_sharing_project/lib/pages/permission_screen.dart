import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> with WidgetsBindingObserver {
  bool _isLocationGranted = false;
  bool _isNotificationGranted = false;
  bool _isMicGranted = false;
  bool _isRequesting = false;

  final Color _emerald = const Color(0xFF059669);
  final Color _slate = const Color(0xFF0F172A);
  final Color _borderColor = const Color(0xFFE2E8F0);

  bool get allGranted => _isLocationGranted && _isNotificationGranted && _isMicGranted;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkExistingPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-verify permissions when returning from Android system settings
      _checkExistingPermissions();
    }
  }

  Future<void> _checkExistingPermissions() async {
    try {
      final locStatus = await Geolocator.checkPermission();
      final notifStatus = await Permission.notification.status;
      final micStatus = await Permission.microphone.status;

      if (!mounted) return;
      setState(() {
        _isLocationGranted = locStatus == LocationPermission.always ||
            locStatus == LocationPermission.whileInUse;
        _isNotificationGranted = notifStatus.isGranted;
        _isMicGranted = micStatus.isGranted;
      });
    } catch (_) {}
  }

  Future<void> _requestLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      } else if (permission == LocationPermission.deniedForever) {
        await openAppSettings();
      }

      await _checkExistingPermissions();
    } catch (e) {
      debugPrint('Location request error: $e');
    }
  }

  Future<void> _requestNotification() async {
    try {
      final status = await Permission.notification.request();
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
      await _checkExistingPermissions();
    } catch (e) {
      debugPrint('Notification request error: $e');
    }
  }

  Future<void> _requestMicrophone() async {
    try {
      final status = await Permission.microphone.request();
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
      await _checkExistingPermissions();
    } catch (e) {
      debugPrint('Microphone request error: $e');
    }
  }

  Future<void> _handlePrimaryAction() async {
    if (allGranted) {
      _navigateForward();
      return;
    }

    if (_isRequesting) return;

    setState(() {
      _isRequesting = true;
    });

    try {
      if (!_isLocationGranted) await _requestLocation();
      if (!_isNotificationGranted) await _requestNotification();
      if (!_isMicGranted) await _requestMicrophone();

      await _checkExistingPermissions();

      if (!mounted) return;
      setState(() {
        _isRequesting = false;
      });

      if (allGranted) {
        _navigateForward();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All 3 permissions are mandatory for route matching & safety. Please allow them to continue.'),
            backgroundColor: Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isRequesting = false;
      });
    }
  }

  void _navigateForward() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // Hero Security Icon
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                    boxShadow: [
                      BoxShadow(
                        color: _emerald.withOpacity(0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.security_rounded,
                    size: 36,
                    color: _emerald,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Essential Permissions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: _slate,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'To match overlapping routes with precision and keep your phone number private, all 3 permissions are mandatory.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 28),

              // Interactive Permission Cards
              _buildPermissionItem(
                icon: Icons.my_location_rounded,
                title: 'Accurate Commute Location *',
                description: 'Detects pickup and drop-off points along driver routes.',
                isGranted: _isLocationGranted,
                onTap: _requestLocation,
              ),
              const SizedBox(height: 12),
              _buildPermissionItem(
                icon: Icons.notifications_active_rounded,
                title: 'Ride & Booking Alerts *',
                description: 'Real-time notifications when a driver accepts or arrives.',
                isGranted: _isNotificationGranted,
                onTap: _requestNotification,
              ),
              const SizedBox(height: 12),
              _buildPermissionItem(
                icon: Icons.mic_rounded,
                title: 'In-App Masked Calling *',
                description: 'Encrypted VoIP calling without sharing your mobile number.',
                isGranted: _isMicGranted,
                onTap: _requestMicrophone,
              ),

              const SizedBox(height: 36),

              // Primary CTA Button (Strict Enforcement)
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isRequesting ? null : _handlePrimaryAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: allGranted ? _emerald : const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isRequesting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          allGranted ? 'Continue to Home →' : 'Grant All 3 Permissions',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Mandatory Safety Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borderColor),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 16, color: Color(0xFF64748B)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'All 3 permissions are required for non-commercial carpool verification and commuter safety.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isGranted ? const Color(0xFFF0FDF4) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isGranted ? const Color(0xFFA7F3D0) : _borderColor,
            width: isGranted ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isGranted ? _emerald.withOpacity(0.04) : Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isGranted ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isGranted ? _emerald : _slate,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _slate,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Status Indicator (Allowed Checkmark or Grant Pill)
            if (isGranted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _emerald,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Allowed',
                      style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _borderColor),
                ),
                child: Text(
                  'Grant',
                  style: TextStyle(
                    color: _slate,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}