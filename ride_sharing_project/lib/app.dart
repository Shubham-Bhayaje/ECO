import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';

class EcoRideApp extends StatelessWidget {
  const EcoRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EcoRide',
      debugShowCheckedModeBanner: false,
      theme: EcoRideTheme.lightTheme,
      routerConfig: AppRoutes.router,
    );
  }
}
