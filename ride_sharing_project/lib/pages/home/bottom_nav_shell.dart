import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        indicatorColor: const Color(0xFF059669).withOpacity(0.15),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined, color: Color(0xFF0F172A)),
            selectedIcon: Icon(Icons.explore_rounded, color: Color(0xFF059669)),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_car_outlined, color: Color(0xFF0F172A)),
            selectedIcon: Icon(Icons.directions_car_filled_rounded, color: Color(0xFF059669)),
            label: 'My Rides',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF0F172A)),
            selectedIcon: Icon(Icons.chat_bubble_rounded, color: Color(0xFF059669)),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded, color: Color(0xFF0F172A)),
            selectedIcon: Icon(Icons.person_rounded, color: Color(0xFF059669)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
