import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VehicleVerificationScreen extends StatelessWidget {
  const VehicleVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Driver & Vehicle Verification', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Trust & safety banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_rounded, color: Color(0xFF059669), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Mandatory DL & RC verification for all drivers to ensure strict safety and legal carpooling compliance.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF065F46), height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildDocumentCard(
              title: 'Driving License (DL Front)',
              status: 'Verified',
              isVerified: true,
              subtitle: 'DL Number: DL-0420180092341',
            ),
            const SizedBox(height: 12),
            _buildDocumentCard(
              title: 'Driving License (DL Back)',
              status: 'Verified',
              isVerified: true,
              subtitle: 'Class: LMV-NT (Private Light Motor Vehicle)',
            ),
            const SizedBox(height: 12),
            _buildDocumentCard(
              title: 'Vehicle RC Certificate',
              status: 'Verified',
              isVerified: true,
              subtitle: 'Reg: MH 02 EE 4589 • Honda City',
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.upload_file_rounded, color: Color(0xFF059669)),
                label: const Text('Upload Updated Document', style: TextStyle(fontSize: 15, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF059669)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Document selector opened. File uploaded for instant AI verification.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard({required String title, required String status, required bool isVerified, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isVerified ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isVerified ? Icons.check_circle_rounded : Icons.pending_rounded,
                      size: 12,
                      color: isVerified ? const Color(0xFF059669) : const Color(0xFFD97706),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isVerified ? const Color(0xFF059669) : const Color(0xFFD97706),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}
