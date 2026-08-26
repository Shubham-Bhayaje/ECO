import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _womenOnlyFilter = true;
  bool _autoAcceptVerified = true;
  bool _liveLocationSharing = true;
  bool _pushNotifications = true;

  final Color _emerald = const Color(0xFF059669);
  final Color _slate = const Color(0xFF0F172A);
  final Color _borderColor = const Color(0xFFE2E8F0);

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (modalContext, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Modal Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Settings & Preferences',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: _slate,
                          letterSpacing: -0.4,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 22, color: Color(0xFF64748B)),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Section: Commute & Matching
                  const Text(
                    'Commute & Safety Preferences',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 8),
                  _buildSettingSwitch(
                    icon: Icons.female_rounded,
                    title: 'Women-Only Carpool Filter',
                    subtitle: 'Match exclusively with verified female commuters',
                    value: _womenOnlyFilter,
                    onChanged: (v) {
                      setModalState(() => _womenOnlyFilter = v);
                      setState(() => _womenOnlyFilter = v);
                    },
                  ),
                  _buildSettingSwitch(
                    icon: Icons.verified_user_rounded,
                    title: 'Auto-Accept Verified Riders',
                    subtitle: 'Instantly confirm seats for 100% verified KYC commuters',
                    value: _autoAcceptVerified,
                    onChanged: (v) {
                      setModalState(() => _autoAcceptVerified = v);
                      setState(() => _autoAcceptVerified = v);
                    },
                  ),
                  _buildSettingSwitch(
                    icon: Icons.my_location_rounded,
                    title: 'Live Trip Location Sharing',
                    subtitle: 'Share real-time GPS telemetry along active route',
                    value: _liveLocationSharing,
                    onChanged: (v) {
                      setModalState(() => _liveLocationSharing = v);
                      setState(() => _liveLocationSharing = v);
                    },
                  ),
                  _buildSettingSwitch(
                    icon: Icons.notifications_active_rounded,
                    title: 'Instant Push Alerts',
                    subtitle: 'Get notified when driver starts commute or arrives',
                    value: _pushNotifications,
                    onChanged: (v) {
                      setModalState(() => _pushNotifications = v);
                      setState(() => _pushNotifications = v);
                    },
                  ),

                  const SizedBox(height: 20),

                  // Section: Privacy & App
                  const Text(
                    'Privacy & System Permissions',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 8),
                  _buildSettingTile(
                    icon: Icons.security_rounded,
                    title: 'Manage App Permissions',
                    subtitle: 'Location, Microphone, Notifications',
                    onTap: () {
                      Navigator.pop(ctx);
                      context.push('/permissions');
                    },
                  ),
                  _buildSettingTile(
                    icon: Icons.edit_note_rounded,
                    title: 'Edit Commuter Profile',
                    subtitle: 'Update name, gender, or corporate email',
                    onTap: () {
                      Navigator.pop(ctx);
                      context.push('/sign-up');
                    },
                  ),

                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showLogoutConfirmation(context);
                      },
                      icon: const Icon(Icons.logout_rounded, size: 18, color: Color(0xFFDC2626)),
                      label: const Text(
                        'Log Out of EcoRide',
                        style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold, fontSize: 14.5),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFECACA)),
                        backgroundColor: const Color(0xFFFEF2F2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'EcoRide • v1.0.0 (Build 2026.1) • Non-Commercial Carpooling',
                      style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade300, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out?'),
        content: const Text('Are you sure you want to log out of your verified EcoRide profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/');
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: _slate),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: _slate)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: _emerald,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: _slate),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: _slate)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Color(0xFF94A3B8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: _slate,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: _slate, size: 24),
            tooltip: 'Settings & Preferences',
            onPressed: () => _showSettingsModal(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Executive User Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 16),

            // Membership Card
            _buildMembershipCard(context),
            const SizedBox(height: 20),

            Text(
              'Account',
              style: TextStyle(
                color: _slate,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildActionTile(
              icon: Icons.verified_user_rounded,
              title: 'Driver Verification',
              subtitle: 'Verify your ID and driving license',
              onTap: () => context.push('/verify-vehicle'),
            ),
            const SizedBox(height: 16),

            Text(
              'Vehicles',
              style: TextStyle(
                color: _slate,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildActionTile(
              icon: Icons.directions_car_rounded,
              title: 'Registered Vehicles',
              subtitle: 'Manage your cars & mileage',
              trailing: GestureDetector(
                onTap: () => context.push('/add-vehicle'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    '+ Add Vehicle',
                    style: TextStyle(
                      color: _slate,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              onTap: () => context.push('/add-vehicle'),
            ),
            const SizedBox(height: 16),

            Text(
              'Support & Safety',
              style: TextStyle(
                color: _slate,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildActionTile(
              icon: Icons.help_outline_rounded,
              title: 'Help Center',
              subtitle: 'FAQs, non-profit rules & support',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Help Center: 24/7 Commuter Support active'),
                    backgroundColor: Color(0xFF059669),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            _buildActionTile(
              icon: Icons.shield_outlined,
              title: 'Safety Guidelines & SOS',
              subtitle: 'Emergency SOS and in-app protocols',
              onTap: () => context.push('/masked-call'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFFECFDF5),
            child: Text(
              'S',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _emerald),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Shubham Patil',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _slate,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.verified_rounded, size: 18, color: _emerald),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Member since 2024',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 16, color: Colors.orange.shade400),
                    const SizedBox(width: 4),
                    Text(
                      '4.95',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _slate),
                    ),
                    const Text(
                      ' • 128 verified rides',
                      style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'EcoRide Annual Pass',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF059669)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 12),
                    SizedBox(width: 4),
                    Text(
                      'Trial Active (24d)',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Zero commission on fuel split & priority matching.',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => context.push('/subscription'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0F172A),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Manage Plan',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _slate, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: _slate,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                ),
              )
            : null,
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
        onTap: onTap,
      ),
    );
  }
}
