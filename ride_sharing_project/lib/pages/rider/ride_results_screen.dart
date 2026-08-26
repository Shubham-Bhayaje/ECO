import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../../models/latlng.dart' as domain;
import '../../services/ride_matching_service.dart';
import '../../services/routing_service.dart';
import '../../widgets/ride_card.dart';

class RideResultsScreen extends StatefulWidget {
  final bool initialWomenOnly;
  final String? origin;
  final String? destination;

  const RideResultsScreen({
    super.key,
    this.initialWomenOnly = false,
    this.origin,
    this.destination,
  });

  @override
  State<RideResultsScreen> createState() => _RideResultsScreenState();
}

class _RideResultsScreenState extends State<RideResultsScreen> with SingleTickerProviderStateMixin {
  final Color _bg = const Color(0xFFF8FAFC);
  final Color _cardBg = const Color(0xFFFFFFFF);
  final Color _borderColor = const Color(0xFFE2E8F0);
  final Color _emerald = const Color(0xFF059669);
  final Color _slate = const Color(0xFF0F172A);

  final RideMatchingService _matchingService = RideMatchingService();
  final RoutingService _routingService = RoutingService();
  final MapController _mapController = MapController();

  List<MatchedRide> _allRides = [];
  List<ll.LatLng> _roadRoutePoints = [];
  bool _isLoading = true;
  bool _isMapView = false;
  bool _isFullScreenMap = false;
  MatchedRide? _selectedRide;
  late int _selectedFilter;

  final ll.LatLng _riderPickup = const ll.LatLng(19.1197, 72.8464); // Andheri West
  final ll.LatLng _riderDropoff = const ll.LatLng(19.0607, 72.8644); // BKC

  final List<Map<String, dynamic>> _filters = [
    {'icon': Icons.bolt_rounded, 'label': 'Best Match'},
    {'icon': Icons.currency_rupee_rounded, 'label': 'Lowest Cost'},
    {'icon': Icons.schedule_rounded, 'label': 'Earliest'},
    {'icon': Icons.shield_rounded, 'label': 'Women Only'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialWomenOnly ? 3 : 0;
    _loadMatchingRidesAndRoute();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _loadMatchingRidesAndRoute() async {
    setState(() => _isLoading = true);

    // 1. Fetch matching carpool rides
    final rides = await _matchingService.findMatchingRides(
      riderPickup: const domain.LatLng(latitude: 19.1136, longitude: 72.8697),
      riderDropoff: const domain.LatLng(latitude: 19.0596, longitude: 72.8295),
      departureDate: DateTime.now().add(const Duration(hours: 3)),
    );

    // 2. Fetch real road geometry (OSRM)
    final routeResult = await _routingService.getRealRoadRoute(_riderPickup, _riderDropoff);

    if (mounted) {
      setState(() {
        _allRides = rides;
        _roadRoutePoints = routeResult.points;
        if (rides.isNotEmpty) {
          _selectedRide = rides.first;
        }
        _isLoading = false;
      });
    }
  }

  List<MatchedRide> get _filteredRides {
    var list = List<MatchedRide>.from(_allRides);
    switch (_selectedFilter) {
      case 0: // Best Match
        list.sort((a, b) => b.overlapPercentage.compareTo(a.overlapPercentage));
        break;
      case 1: // Lowest Cost
        list.sort((a, b) => a.estimatedCost.compareTo(b.estimatedCost));
        break;
      case 2: // Earliest Departure
        list.sort((a, b) => a.ride.departureTime.compareTo(b.ride.departureTime));
        break;
      case 3: // Women Only
        list = list.where((r) => r.ride.womenOnly || r.driver.gender.toLowerCase() == 'female').toList();
        break;
    }
    return list;
  }

  int _getOverlapDisplay(double overlap) {
    if (overlap <= 1.0) {
      return (overlap * 100).round().clamp(1, 100);
    }
    return overlap.round().clamp(1, 100);
  }

  void _recenterMap() {
    final center = ll.LatLng(
      (_riderPickup.latitude + _riderDropoff.latitude) / 2,
      (_riderPickup.longitude + _riderDropoff.longitude) / 2,
    );
    _mapController.move(center, 12.5);
  }

  @override
  Widget build(BuildContext context) {
    final displayedRides = _filteredRides;
    final originLabel = widget.origin ?? 'Andheri West';
    final destLabel = widget.destination ?? 'BKC';

    final hideAppBar = _isMapView && _isFullScreenMap;

    return Scaffold(
      backgroundColor: _bg,
      appBar: hideAppBar
          ? null
          : AppBar(
              title: Text(
                _isMapView ? 'Live Commute Map' : 'Available Carpools',
                style: TextStyle(color: _slate, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              backgroundColor: _cardBg,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF0F172A)),
                onPressed: () => context.pop(),
              ),
              actions: [
                // Segmented Toggle between List View and Map View
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _borderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildViewToggleButton(
                          icon: Icons.format_list_bulleted_rounded,
                          label: 'List',
                          isSelected: !_isMapView,
                          onTap: () => setState(() {
                            _isMapView = false;
                            _isFullScreenMap = false;
                          }),
                        ),
                        _buildViewToggleButton(
                          icon: Icons.map_rounded,
                          label: 'Map',
                          isSelected: _isMapView,
                          onTap: () => setState(() => _isMapView = true),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: _emerald))
          : _isMapView
              ? _buildInteractiveMapView(displayedRides, originLabel, destLabel)
              : _buildListView(displayedRides, originLabel, destLabel),
    );
  }

  Widget _buildViewToggleButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? _emerald : const Color(0xFF64748B),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? _slate : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------- LIST VIEW -----------------
  Widget _buildListView(List<MatchedRide> displayedRides, String originLabel, String destLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Summary Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$originLabel → $destLabel • Today • 1 Seat',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _slate),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _emerald.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${displayedRides.length} found',
                  style: TextStyle(fontSize: 12, color: _emerald, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),

        // Filter Chips Row
        _buildFilterChipsRow(),
        const SizedBox(height: 6),

        // Results List
        Expanded(
          child: displayedRides.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: displayedRides.length,
                  itemBuilder: (context, index) {
                    final matchedRide = displayedRides[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RideCard(
                        matchedRide: matchedRide,
                        onTap: () => context.push('/ride-detail'),
                      ),
                    );
                  },
                )
              : _buildEmptyState(),
        ),
      ],
    );
  }

  // ----------------- CARTO POSITRON / OSM CLEAN MAP -----------------
  Widget _buildInteractiveMapView(List<MatchedRide> displayedRides, String originLabel, String destLabel) {
    final center = ll.LatLng(
      (_riderPickup.latitude + _riderDropoff.latitude) / 2,
      (_riderPickup.longitude + _riderDropoff.longitude) / 2,
    );

    return Stack(
      children: [
        // Real-Time High-DPI OpenStreetMap / CARTO Clean Map
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 12.5,
            minZoom: 8.0,
            maxZoom: 18.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag | InteractiveFlag.doubleTapZoom,
            ),
          ),
          children: [
            // Esri Light Gray Minimalist Map Layer (Zero Watermarks, Clean Modern Theme)
            TileLayer(
              urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}',
              userAgentPackageName: 'com.ecoride.app',
              maxZoom: 18,
            ),

            // Live Road Turn-by-Turn Route Polyline (OSRM Western Express Highway corridor)
            if (_roadRoutePoints.isNotEmpty) ...[
              // Soft emerald road glow
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _roadRoutePoints,
                    strokeWidth: 8.0,
                    color: _emerald.withOpacity(0.2),
                  ),
                ],
              ),
              // Sharp emerald highway line
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _roadRoutePoints,
                    strokeWidth: 4.5,
                    color: _emerald,
                    borderStrokeWidth: 1.5,
                    borderColor: Colors.white,
                  ),
                ],
              ),
            ],

            // Real-Time Interactive Markers: Pickup Radar, Dropoff & Driver Pins
            MarkerLayer(
              markers: [
                // Pickup Location with Radar Ring
                Marker(
                  point: _riderPickup,
                  width: 96,
                  height: 48,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _emerald.withOpacity(0.4)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(color: _emerald, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 4),
                            const Text('Pickup', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: _emerald,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: _emerald.withOpacity(0.4),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Dropoff Pin
                Marker(
                  point: _riderDropoff,
                  width: 96,
                  height: 48,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFEA580C).withOpacity(0.4)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on_rounded, size: 10, color: Color(0xFFEA580C)),
                            SizedBox(width: 3),
                            Text('Dropoff', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEA580C),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ],
                  ),
                ),

                // Driver Position Markers Along Real Highway Corridor
                ...displayedRides.asMap().entries.map((entry) {
                  final index = entry.key;
                  final ride = entry.value;
                  final isSelected = _selectedRide?.ride.id == ride.ride.id;
                  final overlapPct = _getOverlapDisplay(ride.overlapPercentage);

                  // Distribute along road route points
                  final pointIndex = _roadRoutePoints.isNotEmpty
                      ? ((index + 1) * (_roadRoutePoints.length ~/ (displayedRides.length + 1)))
                          .clamp(0, _roadRoutePoints.length - 1)
                      : 0;

                  final driverPos = _roadRoutePoints.isNotEmpty
                      ? _roadRoutePoints[pointIndex]
                      : ll.LatLng(_riderPickup.latitude - (0.015 * (index + 1)), _riderPickup.longitude + (0.005 * (index + 1)));

                  return Marker(
                    point: driverPos,
                    width: 124,
                    height: 42,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedRide = ride);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? _slate : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? _emerald : _borderColor,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: isSelected ? _emerald : const Color(0xFFECFDF5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.directions_car_filled_rounded,
                                  size: 11,
                                  color: isSelected ? Colors.white : _emerald,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '₹${ride.estimatedCost.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : _slate,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '• $overlapPct%',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? const Color(0xFFA7F3D0) : const Color(0xFF059669),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ],
        ),

        // Full Screen Top Overlay (When In Full Screen Mode)
        if (_isFullScreenMap)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  _buildMapActionButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => setState(() => _isFullScreenMap = false),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.directions_car_filled_rounded, size: 16, color: _emerald),
                        const SizedBox(width: 6),
                        Text(
                          '${displayedRides.length} active carpools',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _slate),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          // Floating Filter Chips at Top of Map
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: _buildFilterChipsRow(),
          ),

        // Floating Action Controls on Right Side (Full Screen, Compass, Zoom, GPS Target)
        Positioned(
          right: 14,
          bottom: (!_isFullScreenMap && _selectedRide != null)
              ? MediaQuery.of(context).padding.bottom + 200
              : MediaQuery.of(context).padding.bottom + 30,
          child: Column(
            children: [
              // Full Screen Toggle Button
              _buildMapActionButton(
                icon: _isFullScreenMap ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                iconColor: _isFullScreenMap ? _emerald : _slate,
                onTap: () {
                  setState(() => _isFullScreenMap = !_isFullScreenMap);
                },
              ),
              const SizedBox(height: 10),

              // Compass / Recenter Button
              _buildMapActionButton(
                icon: Icons.explore_outlined,
                onTap: _recenterMap,
              ),
              const SizedBox(height: 10),

              // Zoom In / Out Pill
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildZoomButton(
                      icon: Icons.add_rounded,
                      onTap: () {
                        final currentZoom = _mapController.camera.zoom;
                        _mapController.move(_mapController.camera.center, currentZoom + 1);
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    _buildZoomButton(
                      icon: Icons.remove_rounded,
                      onTap: () {
                        final currentZoom = _mapController.camera.zoom;
                        _mapController.move(_mapController.camera.center, currentZoom - 1);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // GPS My Location Target
              _buildMapActionButton(
                icon: Icons.my_location_rounded,
                iconColor: _emerald,
                onTap: () {
                  _mapController.move(_riderPickup, 14.0);
                },
              ),
            ],
          ),
        ),

        // Floating Bottom Driver Preview Card (Lifted above Android Navigation Bar!)
        if (!_isFullScreenMap && _selectedRide != null)
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 16,
            left: 16,
            right: 16,
            child: _buildDriverMapPreviewCard(_selectedRide!),
          ),
      ],
    );
  }

  // ----------------- FLOATING DRIVER CARD ON MAP -----------------
  Widget _buildDriverMapPreviewCard(MatchedRide matchedRide) {
    final driver = matchedRide.driver;
    final ride = matchedRide.ride;
    final overlapPct = _getOverlapDisplay(matchedRide.overlapPercentage);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Driver Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFECFDF5),
                child: Text(
                  driver.firstName[0],
                  style: TextStyle(color: _emerald, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${driver.firstName} ${driver.lastName[0]}.',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _slate),
                        ),
                        if (driver.isVerified) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.verified_rounded, size: 14, color: _emerald),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Honda City • ${ride.availableSeats} seats left',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${matchedRide.estimatedCost.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _emerald),
                  ),
                  const Text('fuel share', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$overlapPct% Route Overlap',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _emerald),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.push('/ride-detail'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _slate,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChipsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isSelected = _selectedFilter == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              avatar: Icon(
                _filters[index]['icon'] as IconData,
                size: 15,
                color: isSelected ? _emerald : _slate,
              ),
              label: Text(_filters[index]['label'] as String),
              selected: isSelected,
              showCheckmark: false,
              selectedColor: _emerald.withOpacity(0.12),
              labelStyle: TextStyle(
                color: isSelected ? _emerald : _slate,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
              backgroundColor: _cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? _emerald : _borderColor,
                ),
              ),
              onSelected: (bool selected) {
                setState(() {
                  _selectedFilter = selected ? index : 0;
                });
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMapActionButton({required IconData icon, Color? iconColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: _borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: iconColor ?? _slate),
      ),
    );
  }

  Widget _buildZoomButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        color: Colors.transparent,
        child: Icon(icon, size: 18, color: _slate),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_filled_rounded, size: 64, color: _slate.withOpacity(0.2)),
            const SizedBox(height: 16),
            Text(
              'No exact carpools found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _slate),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search radius or time window.',
              style: TextStyle(color: _slate.withOpacity(0.6), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Change Search'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _emerald,
                side: BorderSide(color: _emerald),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
