import 'package:flutter/material.dart';
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
  String otp = "";

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context), // Go back
              ),
              const SizedBox(height: 20),
              const Text(
                "Please wait.\nWe will auto verify the OTP",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                "Send to ${widget.phoneNumber}",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              // OTP TextField Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      onChanged: (value) {
                        if (otp.length < 4) {
                          otp += value;
                        }
                        setState(() {});
                      },
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),

              // Countdown or Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: enableResend ? () {
                      setState(() {
                        secondsRemaining = 30;
                        enableResend = false;
                      });
                      startTimer();
                    } : null,
                    child: Text(
                      enableResend
                          ? "Resend OTP"
                          : "Auto verifying your OTP in ($secondsRemaining s)",
                      style: TextStyle(
                        fontSize: 14,
                        color: enableResend ? Colors.blue : Colors.black54,
                        decoration: enableResend ? TextDecoration.underline : null,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Verify Button
              ElevatedButton(
                onPressed: otp.length == 4
                    ? () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: otp.length == 4
                      ? Colors.redAccent
                      : Colors.orange.shade200,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Verify", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
