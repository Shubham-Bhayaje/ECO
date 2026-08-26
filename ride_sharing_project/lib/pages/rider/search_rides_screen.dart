import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchRidesScreen extends StatefulWidget {
  final String? initialOrigin;
  final String? initialDestination;

  const SearchRidesScreen({
    super.key,
    this.initialOrigin,
    this.initialDestination,
  });

  @override
  State<SearchRidesScreen> createState() => _SearchRidesScreenState();
}

class _SearchRidesScreenState extends State<SearchRidesScreen> {
  int _seats = 1;
  bool _womenOnly = true;
  DateTime _selectedDate = DateTime.now();
  late TextEditingController _originController;
  late TextEditingController _destinationController;

  final Color _bg = const Color(0xFFF8FAFC);
  final Color _cardBg = const Color(0xFFFFFFFF);
  final Color _borderColor = const Color(0xFFE2E8F0);
  final Color _emerald = const Color(0xFF059669);
  final Color _slate = const Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    _originController = TextEditingController(text: widget.initialOrigin ?? 'Andheri West, Mumbai');
    _destinationController = TextEditingController(text: widget.initialDestination ?? 'Bandra Kurla Complex (BKC)');
    _originController.addListener(() => setState(() {}));
    _destinationController.addListener(() => setState(() {}));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text('Find a Ride', style: TextStyle(color: _slate, fontWeight: FontWeight.w600)),
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Unified Modern Route Card
            Container(
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left: Route Connector
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
                        // Pickup Row
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _originController,
                                style: TextStyle(color: _slate, fontSize: 15, fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  hintText: 'Pickup location',
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
                        // Dropoff Row
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _destinationController,
                                style: TextStyle(color: _slate, fontSize: 15, fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  hintText: 'Drop-off destination',
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

                  // Right: Dedicated Swap Button
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
            const SizedBox(height: 20),

            // Quick Routes
            Text('Quick Routes', style: TextStyle(color: _slate, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildRouteChip('Andheri - BKC'),
                _buildRouteChip('Powai - Lower Parel'),
                _buildRouteChip('Thane - Navi Mumbai'),
              ],
            ),
            const SizedBox(height: 24),

            // Date & Seats
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _borderColor),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, color: _slate, size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                              style: TextStyle(color: _slate, fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_rounded, size: 18, color: _slate),
                          onPressed: () {
                            if (_seats > 1) {
                              setState(() => _seats--);
                            }
                          },
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                        ),
                        Text(
                          '$_seats',
                          style: TextStyle(color: _slate, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_rounded, size: 18),
                          color: _emerald,
                          onPressed: () {
                            if (_seats < 4) {
                              setState(() => _seats++);
                            }
                          },
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Women Only Switch
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _womenOnly ? _emerald.withOpacity(0.5) : _borderColor),
              ),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.shield_rounded, color: _emerald, size: 20),
                ),
                title: Text(
                  'Verified Female Drivers & Passengers Only',
                  style: TextStyle(color: _slate, fontWeight: FontWeight.w600, fontSize: 13),
                ),
                value: _womenOnly,
                activeColor: _emerald,
                onChanged: (bool value) {
                  setState(() {
                    _womenOnly = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 32),

            // Search Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _emerald,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  context.push('/ride-results', extra: {
                    'womenOnly': _womenOnly,
                    'origin': _originController.text.isNotEmpty ? _originController.text : 'Andheri West, Mumbai',
                    'destination': _destinationController.text.isNotEmpty ? _destinationController.text : 'Bandra Kurla Complex (BKC)',
                    'seats': _seats,
                  });
                },
                child: const Text(
                  'Search Commute Rides',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildRouteChip(String label) {
    return ActionChip(
      label: Text(label, style: TextStyle(color: _slate, fontSize: 13, fontWeight: FontWeight.w500)),
      backgroundColor: _cardBg,
      side: BorderSide(color: _borderColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        final parts = label.split(' - ');
        if (parts.length == 2) {
          setState(() {
            _originController.text = '${parts[0]}, Mumbai';
            _destinationController.text = '${parts[1]}, Mumbai';
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }
}
