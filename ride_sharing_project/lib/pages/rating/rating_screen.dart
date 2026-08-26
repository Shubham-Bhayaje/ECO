import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RatingScreen extends StatefulWidget {
  final String revieweeName;

  const RatingScreen({
    super.key,
    this.revieweeName = 'Rahul Verma',
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 5;
  final List<String> _ratingLabels = ["Poor", "Fair", "Good", "Very Good", "Excellent"];
  final Set<String> _selectedCompliments = {};

  final List<String> _compliments = [
    'Punctual',
    'Clean Vehicle',
    'Safe Driving',
    'Courteous',
    'Smooth Ride',
    'Great Music',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Rate Commute',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Carbon Impact Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.eco_rounded, color: Color(0xFF059669), size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Commute Completed',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF065F46),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'You saved 4.2 kg CO2 and ₹140 on this ride.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Reviewee Profile
            CircleAvatar(
              radius: 36,
              backgroundColor: const Color(0xFFE2E8F0),
              child: Text(
                widget.revieweeName.isNotEmpty ? widget.revieweeName.substring(0, 1) : 'R',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'How was your ride with ${widget.revieweeName}?',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final isFilled = index < _rating;
                return IconButton(
                  icon: Icon(
                    isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                    color: isFilled ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                    size: 38,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            if (_rating > 0)
              Text(
                _ratingLabels[_rating - 1],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF059669),
                ),
              ),

            const SizedBox(height: 24),

            // Compliment Chips
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Give Compliments',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _compliments.map((label) {
                final isSelected = _selectedCompliments.contains(label);
                return FilterChip(
                  label: Text(label),
                  selected: isSelected,
                  selectedColor: const Color(0xFFECFDF5),
                  checkmarkColor: const Color(0xFF059669),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0),
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFF059669) : const Color(0xFF334155),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCompliments.add(label);
                      } else {
                        _selectedCompliments.remove(label);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Feedback Notes
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Additional Notes (Optional)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Share more details about your commute...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(14),
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Feedback submitted successfully! Thank you.'),
                      backgroundColor: Color(0xFF059669),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  context.go('/home');
                },
                child: const Text(
                  'Submit Feedback',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
