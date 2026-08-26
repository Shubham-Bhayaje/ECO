import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/service_providers.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final bool isRegistration;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    this.isRegistration = false,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  int secondsRemaining = 30;
  bool enableResend = false;
  Timer? timer;
  late String _currentVerificationId;
  bool _isVerifying = false;

  final List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());

  String get otpCode => otpControllers.map((c) => c.text).join();
  bool get isOtpComplete => otpCode.length == 4;

  @override
  void initState() {
    super.initState();
    _currentVerificationId = widget.verificationId;
    for (var f in otpFocusNodes) {
      f.addListener(() {
        if (mounted) setState(() {});
      });
    }
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining == 0) {
        setState(() {
          enableResend = true;
        });
        t.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  Future<void> resendOtp() async {
    startTimer();
    for (var c in otpControllers) {
      c.clear();
    }
    FocusScope.of(context).requestFocus(otpFocusNodes[0]);

    try {
      final authService = ref.read(authServiceProvider);
      final newVerificationId = await authService.signInWithPhone(widget.phoneNumber);
      _currentVerificationId = newVerificationId;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification code resent (use any 4 digits in preview mode)'),
          backgroundColor: Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resend code: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _verifyOtp() async {
    if (!isOtpComplete || _isVerifying) return;

    setState(() {
      _isVerifying = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.verifyOtp(_currentVerificationId, otpCode);

      if (!mounted) return;
      setState(() {
        _isVerifying = false;
      });

      if (widget.isRegistration) {
        // New Registration -> Live Selfie Verification
        context.push('/selfie-verification', extra: {
          'firstName': user?.firstName,
          'phoneNumber': widget.phoneNumber,
        });
      } else {
        // Existing User Login -> Directly Go to App / Permissions
        context.go('/permissions');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification failed: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Code sent to ${widget.phoneNumber}',
                    style: const TextStyle(fontSize: 15, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.edit_rounded, size: 16, color: Color(0xFF059669)),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // 4 Pixel-Perfect Centered PIN Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isFocused = otpFocusNodes[index].hasFocus;
                  final hasValue = otpControllers[index].text.isNotEmpty;
                  final isActive = isFocused || hasValue;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 58,
                    height: 62,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFocused
                            ? const Color(0xFF059669)
                            : hasValue
                                ? const Color(0xFF059669).withOpacity(0.7)
                                : const Color(0xFFE2E8F0),
                        width: isFocused ? 2.0 : 1.2,
                      ),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: const Color(0xFF059669).withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: TextField(
                        controller: otpControllers[index],
                        focusNode: otpFocusNodes[index],
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.number,
                        cursorColor: const Color(0xFF059669),
                        cursorWidth: 2,
                        cursorHeight: 24,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).requestFocus(otpFocusNodes[index - 1]);
                          }
                          setState(() {});
                          if (isOtpComplete) {
                            _verifyOtp();
                          }
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),

              // Resend Timer
              Center(
                child: enableResend
                    ? TextButton.icon(
                        onPressed: resendOtp,
                        icon: const Icon(Icons.refresh_rounded, size: 18, color: Color(0xFF059669)),
                        label: const Text(
                          'Resend Verification Code',
                          style: TextStyle(
                            color: Color(0xFF059669),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.timer_outlined, size: 16, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 6),
                          Text(
                            'Resend code in ${secondsRemaining}s',
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 36),

              // Verify CTA
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isOtpComplete && !_isVerifying ? _verifyOtp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    disabledBackgroundColor: const Color(0xFFCBD5E1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isVerifying
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Verify & Proceed',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
