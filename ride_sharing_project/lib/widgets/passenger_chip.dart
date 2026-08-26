import 'package:flutter/material.dart';
import '../models/user_model.dart';

class PassengerChip extends StatelessWidget {
  final String name;
  final String gender;
  final String avatarUrl;

  PassengerChip({
    super.key,
    String? name,
    String? gender,
    String? avatarUrl,
    dynamic passenger,
  })  : name = name ?? (passenger is UserModel ? passenger.firstName : passenger is Map ? (passenger['name'] ?? 'Passenger') : 'Passenger'),
        gender = gender ?? (passenger is UserModel ? passenger.gender : passenger is Map ? (passenger['gender'] ?? 'male') : 'male'),
        avatarUrl = avatarUrl ?? '';

  @override
  Widget build(BuildContext context) {
    final bool isFemale = gender.toLowerCase() == 'female';
    final Color iconColor = isFemale ? const Color(0xFFDB2777) : const Color(0xFF2563EB);
    final IconData genderIcon = isFemale ? Icons.female_rounded : Icons.male_rounded;
    final String initials = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'P';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFFE2E8F0),
            backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
            child: avatarUrl.isEmpty
                ? Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(width: 4),
          Icon(genderIcon, size: 14, color: iconColor),
        ],
      ),
    );
  }
}
