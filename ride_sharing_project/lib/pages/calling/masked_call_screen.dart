import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MaskedCallScreen extends StatefulWidget {
  const MaskedCallScreen({super.key});

  @override
  State<MaskedCallScreen> createState() => _MaskedCallScreenState();
}

class _MaskedCallScreenState extends State<MaskedCallScreen> {
  bool _isMuted = false;
  bool _isSpeaker = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: const Color(0xFF0F172A).withOpacity(0.8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_rounded, color: Color(0xFF059669), size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Private Masked VoIP Call • Numbers Hidden',
                    style: TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE2E8F0).withOpacity(0.1),
                      border: Border.all(color: const Color(0xFF059669).withOpacity(0.5), width: 2),
                    ),
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF8FAFC),
                        ),
                        child: const Center(
                          child: Text(
                            'R',
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Rahul Verma',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Connected • Honda City',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '00:45',
                    style: TextStyle(
                      color: Color(0xFF059669),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 32, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    label: _isMuted ? 'Muted' : 'Mute',
                    isActive: _isMuted,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  _buildControlButton(
                    icon: Icons.dialpad_rounded,
                    label: 'Keypad',
                    isActive: false,
                    onTap: () {},
                  ),
                  _buildControlButton(
                    icon: _isSpeaker ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                    label: _isSpeaker ? 'Speaker On' : 'Speaker',
                    isActive: _isSpeaker,
                    onTap: () => setState(() => _isSpeaker = !_isSpeaker),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: InkWell(
                onTap: () => context.pop(),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDC2626),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 36),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? const Color(0xFF059669) : const Color(0xFFE2E8F0).withOpacity(0.12),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF34D399) : const Color(0xFFE2E8F0),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
