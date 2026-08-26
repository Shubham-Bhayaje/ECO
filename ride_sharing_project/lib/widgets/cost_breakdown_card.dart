import 'package:flutter/material.dart';

class CostBreakdownCard extends StatelessWidget {
  final double distanceKm;
  final double vehicleEfficiencyKmPerL;
  final double fuelRatePerL;
  final int totalSeats;
  final double? totalCost;

  CostBreakdownCard({
    super.key,
    required this.distanceKm,
    double? vehicleEfficiencyKmPerL,
    double? mileageKmPerL,
    double? fuelRatePerL,
    double? fuelPricePerL,
    int? totalSeats,
    int? seatsBooked,
    this.totalCost,
  })  : vehicleEfficiencyKmPerL = vehicleEfficiencyKmPerL ?? mileageKmPerL ?? 16.5,
        fuelRatePerL = fuelRatePerL ?? fuelPricePerL ?? 104.5,
        totalSeats = totalSeats ?? seatsBooked ?? 1;

  @override
  Widget build(BuildContext context) {
    final double calculatedFuel = distanceKm / vehicleEfficiencyKmPerL;
    final double calculatedTotal = totalCost ?? (calculatedFuel * fuelRatePerL);
    final double costPerSeat = calculatedTotal / (totalSeats > 0 ? totalSeats : 1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.02),
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
              const Row(
                children: [
                  Icon(Icons.local_gas_station_rounded, size: 18, color: Color(0xFF059669)),
                  SizedBox(width: 6),
                  Text(
                    'Fair Fuel Cost Recovery',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Text(
                '₹${costPerSeat.toStringAsFixed(2)} / seat',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF059669)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatPill('Distance', '${distanceKm.toStringAsFixed(1)} km'),
                Container(width: 1, height: 20, color: const Color(0xFFE2E8F0)),
                _buildStatPill('Mileage', '${vehicleEfficiencyKmPerL.toStringAsFixed(1)} km/L'),
                Container(width: 1, height: 20, color: const Color(0xFFE2E8F0)),
                _buildStatPill('Fuel Rate', '₹${fuelRatePerL.toStringAsFixed(0)}/L'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.verified_user_outlined, size: 13, color: Color(0xFF059669)),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Zero driver profit or platform commission. 100% direct fuel cost sharing.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
      ],
    );
  }
}
