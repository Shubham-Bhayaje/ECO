import 'package:flutter/material.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E6), // Light beige
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration Image
              Image.asset(
                'assets/permission_illustration.png', // Replace with your asset
                height: 200,
              ),
              const SizedBox(height: 30),

              // Title
              const Text(
                "Welcome to EcoRide",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Subtitle
              const Text(
                "To get you riding faster, we’ll need a couple of quick permissions.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Bullet Points
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("• Location (find nearby rides & pickup points)",
                      style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
                  Text("• Phone (connect with drivers & secure account)",
                      style: TextStyle(fontSize: 14)),
                ],
              ),

              const SizedBox(height: 40),

              // Allow Button
              ElevatedButton(
                onPressed: () {
                  // Ask for permissions here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Allow",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
