import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/latlng.dart';
import '../../models/user_model.dart';
import '../../widgets/cost_breakdown_card.dart';
import '../../widgets/map_route_preview.dart';
import '../../widgets/passenger_chip.dart';

class RideDetailScreen extends StatelessWidget {
  const RideDetailScreen({super.key});

  final Color _bg = const Color(0xFFF8FAFC);
  final Color _cardBg = const Color(0xFFFFFFFF);
  final Color _borderColor = const Color(0xFFE2E8F0);
  final Color _emerald = const Color(0xFF059669);
  final Color _slate = const Color(0xFF0F172A);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final List<UserModel> mockCoPassengers = [
      UserModel(
        id: 'p1',
        firstName: 'Sneha',
        lastName: 'Patil',
        email: 'sneha@test.com',
        phone: '+919876543220',
        gender: 'female',
        isVerified: true,
        rating: 4.9,
        totalRides: 14,
        cancellationCount: 0,
        createdAt: now,
        updatedAt: now,
      ),
      UserModel(
        id: 'p2',
        firstName: 'Aniket',
        lastName: 'Deshmukh',
        email: 'aniket@test.com',
        phone: '+919876543221',
        gender: 'male',
        isVerified: true,
        rating: 4.7,
        totalRides: 8,
        cancellationCount: 0,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text('Ride Details', style: TextStyle(color: _slate, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: _cardBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: _slate),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Balanced Map Route Preview (190px height)
            const MapRoutePreview(
              origin: LatLng(latitude: 19.1136, longitude: 72.8697),
              destination: LatLng(latitude: 19.0596, longitude: 72.8295),
              height: 190,
            ),
            const SizedBox(height: 12),

            // Driver Profile Card
            Container(
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _emerald.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'R',
                      style: TextStyle(color: _emerald, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Rahul Verma', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _slate)),
                            const SizedBox(width: 4),
                            Icon(Icons.verified_rounded, color: _emerald, size: 16),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.star_rounded, color: Colors.orange.shade400, size: 15),
                            Text(
                              ' 4.85 (67 rides) • 0% drops',
                              style: TextStyle(fontSize: 12.5, color: _slate.withOpacity(0.7)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.directions_car_rounded, color: _slate, size: 15),
                            const SizedBox(width: 4),
                            Text(
                              'Maruti Swift • 16.5 km/L',
                              style: TextStyle(color: _slate, fontSize: 12.5, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Co-Passengers Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor),
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
                      Text("Co-Passengers", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _slate)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: _emerald.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '2 seats left',
                          style: TextStyle(color: _emerald, fontSize: 11.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: mockCoPassengers.map<Widget>((p) => PassengerChip(passenger: p)).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Fair Cost Breakdown Card
            CostBreakdownCard(
              distanceKm: 14.2,
              mileageKmPerL: 16.5,
              fuelPricePerL: 104.50,
              totalCost: 89.90,
              seatsBooked: 1,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: BoxDecoration(
          color: _cardBg,
          border: Border(top: BorderSide(color: _borderColor)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Fuel Share', style: TextStyle(color: _slate.withOpacity(0.7), fontSize: 11.5, fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      Text('₹ 89.90', style: TextStyle(color: _slate, fontSize: 20, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _emerald,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  _showConfirmationDialog(context);
                },
                child: const Text('Request Seat', style: TextStyle(fontSize: 15.5, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Seat Request'),
        content: const Text('You are requesting 1 seat in Rahul Verma\'s carpool. ₹89.90 will be settled after pickup via UPI/Escrow.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _emerald,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Seat requested! Driver will confirm shortly.'),
                  backgroundColor: Color(0xFF059669),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
