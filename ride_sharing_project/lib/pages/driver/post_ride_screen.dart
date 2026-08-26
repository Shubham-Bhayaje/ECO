import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/latlng.dart';
import '../../widgets/map_route_preview.dart';

class PostRideScreen extends StatefulWidget {
  const PostRideScreen({super.key});

  @override
  State<PostRideScreen> createState() => _PostRideScreenState();
}

class _PostRideScreenState extends State<PostRideScreen> {
  late final TextEditingController _originController;
  late final TextEditingController _destinationController;

  int _seats = 3;
  bool _womenOnly = false;

  final Color _bg = const Color(0xFFF8FAFC);
  final Color _emerald = const Color(0xFF059669);
  final Color _slate = const Color(0xFF0F172A);
  final Color _borderColor = const Color(0xFFE2E8F0);

  @override
  void initState() {
    super.initState();
    _originController = TextEditingController(text: 'Andheri West, Mumbai');
    _destinationController = TextEditingController(text: 'Bandra Kurla Complex (BKC)');
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _swapLocations() {
    final temp = _originController.text;
    setState(() {
      _originController.text = _destinationController.text;
      _destinationController.text = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text('Offer a Commute Ride', style: TextStyle(color: _slate, fontWeight: FontWeight.w700, fontSize: 18)),
        backgroundColor: _bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: _slate),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Spacious CARTO Route Map Preview (170px)
            const MapRoutePreview(
              height: 170,
              origin: LatLng(latitude: 19.1136, longitude: 72.8697),
              destination: LatLng(latitude: 19.0596, longitude: 72.8295),
            ),
            const SizedBox(height: 14),

            // Exact Same Clean Route Card as Home Screen
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
                                onTap: () => setState(() => _originController.clear()),
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
                                onTap: () => setState(() => _destinationController.clear()),
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.swap_vert_rounded,
                          size: 20,
                          color: _slate,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Vehicle & Seat Capacity Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.directions_car_filled_rounded, size: 20, color: _emerald),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Honda City (MH-02-CD-5678) • Petrol',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _slate),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Seats Offered', style: TextStyle(fontWeight: FontWeight.w700, color: _slate, fontSize: 14)),
                          const Text('Maximum carpool capacity', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (_seats > 1) setState(() => _seats--);
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.remove_circle_outline_rounded, color: _slate, size: 24),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('$_seats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _slate)),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              if (_seats < 4) setState(() => _seats++);
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.add_circle_outline_rounded, color: _emerald, size: 24),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Women-Only Safety Toggle Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.shield_rounded, color: _emerald, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Women-Only Commute',
                          style: TextStyle(fontWeight: FontWeight.w700, color: _slate, fontSize: 14),
                        ),
                        const Text(
                          'Only verified female co-passengers can request',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _womenOnly,
                    activeColor: _emerald,
                    onChanged: (val) => setState(() => _womenOnly = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Strict Fuel Recovery Engine Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.verified_rounded, color: Color(0xFF059669), size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Fuel Recovery Cost Engine',
                            style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF065F46), fontSize: 13),
                          ),
                        ],
                      ),
                      Text('₹89.90', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _emerald)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Formula: (14.2 km / 16.5 km/L) × ₹104.50 ÷ 1 seat = ₹89.90. Zero driver profit.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF059669)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Sticky Pinned Bottom Button - Always 100% Visible Without Squeezing Content!
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: _borderColor)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _emerald,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Commute route published! Co-commuters will now match your route.'),
                    backgroundColor: Color(0xFF059669),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                context.pop();
              },
              child: const Text('Publish Commute Route', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}
