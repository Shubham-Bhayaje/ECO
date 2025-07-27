import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'sign_up.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int secondsRemaining = 30;
  bool enableResend = false;
  Timer? timer;
  
  List<TextEditingController> otpControllers = [];
  List<FocusNode> otpFocusNodes = [];
  
  String get otpCode => otpControllers.map((controller) => controller.text).join();
  bool get isOtpComplete => otpCode.length == 6;

  @override
  void initState() {
    super.initState();
    // Initialize controllers and focus nodes for 6 digits
    for (int i = 0; i < 6; i++) {
      otpControllers.add(TextEditingController());
      otpFocusNodes.add(FocusNode());
    }
    startTimer();
  }

  void startTimer() {
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });
    
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        setState(() {
          enableResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  void resendOtp() {
    startTimer();
    // Clear all OTP fields
    for (var controller in otpControllers) {
      controller.clear();
    }
    // Focus on first field
    FocusScope.of(context).requestFocus(otpFocusNodes[0]);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP sent successfully!'),
        backgroundColor: Color(0xFF4CAF50),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field if current field is filled
      if (index < 5) {
        FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
      } else {
        // Last field, remove focus
        FocusScope.of(context).unfocus();
      }
    }
    setState(() {});
  }

  void onBackspace(int index) {
    if (index > 0 && otpControllers[index].text.isEmpty) {
      FocusScope.of(context).requestFocus(otpFocusNodes[index - 1]);
    }
  }

  void verifyOtp() {
    if (isOtpComplete) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
          ),
        ),
      );

      // Simulate verification delay
      Timer(const Duration(seconds: 2), () {
        Navigator.pop(context); // Close loading dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignUpScreen(),
          ),
        );
      });
    }
  }

  String get maskedPhoneNumber {
    if (widget.phoneNumber.length > 6) {
      return '${widget.phoneNumber.substring(0, 3)}****${widget.phoneNumber.substring(widget.phoneNumber.length - 3)}';
    }
    return widget.phoneNumber;
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF2D2D2D)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                "Enter Verification Code",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle with phone number
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6),
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: "We've sent a 6-digit code to\n"),
                    TextSpan(
                      text: maskedPhoneNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // OTP Input Fields
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 45,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: otpFocusNodes[index].hasFocus
                                  ? const Color(0xFFFF6B35)
                                  : Colors.black.withOpacity(0.1),
                              width: otpFocusNodes[index].hasFocus ? 2 : 1,
                            ),
                          ),
                          child: TextField(
                            controller: otpControllers[index],
                            focusNode: otpFocusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D2D2D),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) => onOtpChanged(value, index),
                            onTap: () {
                              // Clear field when tapped
                              otpControllers[index].clear();
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    
                    // Timer/Resend Section
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: enableResend 
                            ? const Color(0xFFE8F5E8)
                            : const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            enableResend ? Icons.refresh : Icons.timer,
                            size: 16,
                            color: enableResend 
                                ? Colors.green.shade600
                                : Colors.orange.shade600,
                          ),
                          const SizedBox(width: 8),
                          if (enableResend)
                            GestureDetector(
                              onTap: resendOtp,
                              child: Text(
                                "Resend Code",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          else
                            Text(
                              "Resend code in ${secondsRemaining}s",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Help Text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.shade100,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Didn't receive the code? Check your SMS or try resending",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isOtpComplete ? verifyOtp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOtpComplete
                        ? const Color(0xFFFF6B35)
                        : const Color(0xFFFFB899),
                    foregroundColor: Colors.white,
                    elevation: isOtpComplete ? 2 : 0,
                    shadowColor: const Color(0xFFFF6B35).withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isOtpComplete ? "Verify Code" : "Enter 6-digit code",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Alternative verification
              Center(
                child: TextButton(
                  onPressed: () {
                    // Handle alternative verification (e.g., call)
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Verification Help'),
                        content: const Text(
                          'Having trouble? You can also verify your number via phone call.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Handle call verification
                            },
                            child: const Text('Call Me'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    "Having trouble? Get help",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}