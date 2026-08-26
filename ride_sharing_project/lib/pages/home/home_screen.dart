import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seats = 1;
  bool _womenOnly = false;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _originController = TextEditingController(text: 'Andheri West, Mumbai');
  final TextEditingController _destinationController = TextEditingController(text: 'Bandra Kurla Complex (BKC)');

  final Color _bg = const Color(0xFFF8FAFC);
  final Color _cardBg = const Color(0xFFFFFFFF);
  final Color _borderColor = const Color(0xFFE2E8F0);
  final Color _emerald = const Color(0xFF059669);
  final Color _slate = const Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    _originController.addListener(() => setState(() {}));
    _destinationController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final isToday = date.day == DateTime.now().day && date.month == DateTime.now().month;
    final prefix = isToday ? 'Today, ' : '';
    return '$prefix${date.day} ${months[date.month - 1]}';
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _emerald,
              onPrimary: Colors.white,
              surface: _cardBg,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _swapLocations() {
    final temp = _originController.text;
    _originController.text = _destinationController.text;
    _destinationController.text = temp;
    setState(() {});
  }

  void _searchCarpools() {
    context.push('/ride-results', extra: {
      'womenOnly': _womenOnly,
      'origin': _originController.text.isNotEmpty ? _originController.text : 'Andheri West, Mumbai',
      'destination': _destinationController.text.isNotEmpty ? _destinationController.text : 'Bandra Kurla Complex (BKC)',
      'seats': _seats,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _cardBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.directions_car_filled_rounded, color: _emerald, size: 22),
            ),
            const SizedBox(width: 10),
            Text(
              'EcoRide',
              style: TextStyle(
                color: _slate,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _emerald,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Network Active',
                    style: TextStyle(
                      color: const Color(0xFF065F46),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 32.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              'Where are you commuting?',
              style: TextStyle(
                color: _slate,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Find verified daily carpools along your route',
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Executive Route Card (Uber/Citymapper styled)
            Container(
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left: Route Indicator
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _emerald,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 1.5,
                        height: 28,
                        color: const Color(0xFFE2E8F0),
                        margin: const EdgeInsets.symmetric(vertical: 3),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEA580C),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  // Middle: Text Inputs Column
                  Expanded(
                    child: Column(
                      children: [
                        // Pickup Input Row
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _originController,
                                style: TextStyle(color: _slate, fontSize: 15, fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  hintText: 'Pickup location (e.g. Andheri West)',
                                  hintStyle: TextStyle(color: _slate.withOpacity(0.35), fontSize: 14, fontWeight: FontWeight.normal),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                            if (_originController.text.isNotEmpty)
                              GestureDetector(
                                onTap: () => _originController.clear(),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                  child: Icon(Icons.close_rounded, size: 16, color: _slate.withOpacity(0.4)),
                                ),
                              ),
                          ],
                        ),
                        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                        // Dropoff Input Row
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _destinationController,
                                style: TextStyle(color: _slate, fontSize: 15, fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  hintText: 'Drop-off destination (e.g. BKC)',
                                  hintStyle: TextStyle(color: _slate.withOpacity(0.35), fontSize: 14, fontWeight: FontWeight.normal),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                            if (_destinationController.text.isNotEmpty)
                              GestureDetector(
                                onTap: () => _destinationController.clear(),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                  child: Icon(Icons.close_rounded, size: 16, color: _slate.withOpacity(0.4)),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Right: Dedicated Swap Button with generous breathing space
                  InkWell(
                    onTap: _swapLocations,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        shape: BoxShape.circle,
                        border: Border.all(color: _borderColor),
                      ),
                      child: Icon(Icons.swap_vert_rounded, color: _slate, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Popular Commute Shortcuts
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildRouteChip('Andheri ➔ BKC', 'Andheri West, Mumbai', 'Bandra Kurla Complex (BKC)'),
                  const SizedBox(width: 8),
                  _buildRouteChip('Powai ➔ Lower Parel', 'Powai, Mumbai', 'Lower Parel, Mumbai'),
                  const SizedBox(width: 8),
                  _buildRouteChip('Thane ➔ Navi Mumbai', 'Thane West', 'Vashi, Navi Mumbai'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Date & Seats Selectors
            Row(
              children: [
                // Date
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _borderColor),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, color: _slate, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _formatDate(_selectedDate),
                              style: TextStyle(color: _slate, fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Seats Counter
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            if (_seats > 1) {
                              setState(() => _seats--);
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.remove_rounded, size: 16, color: _slate),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '$_seats',
                              style: TextStyle(color: _slate, fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _seats == 1 ? 'Seat' : 'Seats',
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            if (_seats < 4) {
                              setState(() => _seats++);
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.add_rounded, size: 16, color: _emerald),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Women-Only Safety Switch Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _womenOnly ? _emerald.withOpacity(0.5) : _borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.shield_rounded, color: _emerald, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Women-Only Carpool',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Verified female drivers & riders only',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _womenOnly,
                    activeColor: _emerald,
                    activeTrackColor: const Color(0xFFA7F3D0),
                    onChanged: (bool value) {
                      setState(() {
                        _womenOnly = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search CTA
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _emerald,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.search_rounded, size: 20),
                label: const Text(
                  'Search Commute Rides',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                onPressed: _searchCarpools,
              ),
            ),
            const SizedBox(height: 18),

            // Driver Card: Offer a Ride
            GestureDetector(
              onTap: () => context.push('/post-ride'),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _slate,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _slate.withOpacity(0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.directions_car_filled_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Driving your car today?',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Share seats & recover fuel costs',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: _emerald,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Offer Ride',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Commute Impact Dashboard
            Text(
              'Community Impact',
              style: TextStyle(
                color: _slate,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'CO2 Saved',
                      value: '124.5 kg',
                      icon: Icons.eco_rounded,
                      color: _emerald,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Fuel Saved',
                      value: '₹4,500',
                      icon: Icons.savings_rounded,
                      color: _slate,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildRouteChip(String label, String origin, String destination) {
    return ActionChip(
      label: Text(label, style: TextStyle(color: _slate, fontSize: 12, fontWeight: FontWeight.w600)),
      backgroundColor: Colors.white,
      side: BorderSide(color: _borderColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        setState(() {
          _originController.text = origin;
          _destinationController.text = destination;
        });
      },
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color == _emerald ? const Color(0xFFECFDF5) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: _slate,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
