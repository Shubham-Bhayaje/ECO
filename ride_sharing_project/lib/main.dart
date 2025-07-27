import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'phone_auth_screen.dart';
import 'otp_screen.dart';
import 'permission_screen.dart';
import 'sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoRide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(), // Start from WelcomeScreen
    );
  }
}
