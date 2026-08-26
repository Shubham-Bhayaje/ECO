import 'package:flutter/material.dart';
import '../services/ride_matching_service.dart';
import 'passenger_chip.dart';

class RideCard extends StatelessWidget {
  final String driverName;
  final double rating;
  final bool womenOnly;
  final String origin;
  final String destination;
  final int routeMatchPercent;
  final int walkDistanceMeters;
  final int seatsAvailable;
  final double price;
  final VoidCallback? onTap;

  RideCard({
    super.key,
    MatchedRide? matchedRide,
    String? driverName,
    double? rating,
    bool? womenOnly,
    String? origin,
    String? destination,
    int? routeMatchPercent,
    int? walkDistanceMeters,
    int? seatsAvailable,
    double? price,
    this.onTap,
  })  : driverName = driverName ?? (matchedRide != null ? '${matchedRide.driver.firstName} ${matchedRide.driver.lastName}'.trim() : 'Verified Driver'),
        rating = rating ?? (matchedRide?.driver.rating ?? 4.9),
        womenOnly = womenOnly ?? (matchedRide?.ride.womenOnly ?? false),
        origin = origin ?? (matchedRide?.ride.originAddress ?? 'Origin'),
        destination = destination ?? (matchedRide?.ride.destinationAddress ?? 'Destination'),
        routeMatchPercent = routeMatchPercent ?? (matchedRide != null ? matchedRide.overlapPercentage.toInt() : 88),
        walkDistanceMeters = walkDistanceMeters ?? (matchedRide != null ? (matchedRide.pickupDistanceKm * 1000).toInt() : 350),
        seatsAvailable = seatsAvailable ?? (matchedRide?.ride.availableSeats ?? 2),
        price = price ?? (matchedRide?.estimatedCost ?? 89.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Driver Profile & Women-Only Badge
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFECFDF5),
                  child: Text(
                    driverName.isNotEmpty ? driverName.substring(0, 1).toUpperCase() : 'D',
                    style: const TextStyle(
                      color: Color(0xFF059669),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              driverName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF059669)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 2),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (womenOnly)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF2F8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFBCFE8)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield_rounded, size: 13, color: Color(0xFFDB2777)),
                        SizedBox(width: 4),
                        Text(
                          'Women-Only',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFDB2777),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),

            // Route with Vertical Timeline Connector
            Row(
              children: [
                Column(
                  children: [
                    const Icon(Icons.circle, size: 10, color: Color(0xFF059669)),
                    Container(
                      width: 2,
                      height: 24,
                      color: const Color(0xFFCBD5E1),
                    ),
                    const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFFEA580C)),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        origin,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        destination,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Route Overlap Capsule
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.alt_route_rounded, size: 14, color: Color(0xFF059669)),
                  const SizedBox(width: 6),
                  Text(
                    '$routeMatchPercent% Route Match • ${walkDistanceMeters}m pickup walk',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 12),

            // Bottom Row: Seats & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.airline_seat_recline_normal_rounded, size: 16, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      '$seatsAvailable seats left',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const Text(
                      'Shared Fuel Cost',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
