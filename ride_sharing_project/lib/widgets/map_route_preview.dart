import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../models/latlng.dart' as domain;
import '../services/routing_service.dart';

class MapRoutePreview extends StatefulWidget {
  final domain.LatLng? origin;
  final domain.LatLng? destination;
  final double height;
  final List<domain.LatLng>? polylinePoints;

  const MapRoutePreview({
    super.key,
    this.origin,
    this.destination,
    this.height = 220,
    this.polylinePoints,
  });

  @override
  State<MapRoutePreview> createState() => _MapRoutePreviewState();
}

class _MapRoutePreviewState extends State<MapRoutePreview> {
  late final MapController _mapController;
  final RoutingService _routingService = RoutingService();
  List<ll.LatLng> _roadPoints = [];
  double _distanceKm = 14.2;
  int _durationMinutes = 32;
  bool _isLoadingRoute = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _fetchRoadRoute();
  }

  @override
  void didUpdateWidget(covariant MapRoutePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.origin != widget.origin || oldWidget.destination != widget.destination) {
      _fetchRoadRoute();
    }
  }

  Future<void> _fetchRoadRoute() async {
    final start = widget.origin != null
        ? ll.LatLng(widget.origin!.latitude, widget.origin!.longitude)
        : const ll.LatLng(19.1197, 72.8464); // Andheri West

    final end = widget.destination != null
        ? ll.LatLng(widget.destination!.latitude, widget.destination!.longitude)
        : const ll.LatLng(19.0607, 72.8644); // BKC

    if (widget.polylinePoints != null && widget.polylinePoints!.isNotEmpty) {
      setState(() {
        _roadPoints = widget.polylinePoints!.map((p) => ll.LatLng(p.latitude, p.longitude)).toList();
        _isLoadingRoute = false;
      });
      return;
    }

    try {
      final result = await _routingService.getRealRoadRoute(start, end);
      if (mounted) {
        setState(() {
          _roadPoints = result.points;
          _distanceKm = result.distanceKm;
          _durationMinutes = result.durationMinutes;
          _isLoadingRoute = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_roadPoints.isNotEmpty && mounted) {
            _mapController.fitCamera(
              CameraFit.coordinates(
                coordinates: _roadPoints,
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
              ),
            );
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingRoute = false);
      }
    }
  }

  void _openFullScreenMap(BuildContext context) {
    final start = widget.origin != null
        ? ll.LatLng(widget.origin!.latitude, widget.origin!.longitude)
        : const ll.LatLng(19.1197, 72.8464);

    final end = widget.destination != null
        ? ll.LatLng(widget.destination!.latitude, widget.destination!.longitude)
        : const ll.LatLng(19.0607, 72.8644);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenMapScreen(
          start: start,
          end: end,
          roadPoints: _roadPoints,
          distanceKm: _distanceKm,
          durationMinutes: _durationMinutes,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final start = widget.origin != null
        ? ll.LatLng(widget.origin!.latitude, widget.origin!.longitude)
        : const ll.LatLng(19.1197, 72.8464);

    final end = widget.destination != null
        ? ll.LatLng(widget.destination!.latitude, widget.destination!.longitude)
        : const ll.LatLng(19.0607, 72.8644);

    final center = ll.LatLng(
      (start.latitude + end.latitude) / 2,
      (start.longitude + end.longitude) / 2,
    );

    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Live Real OpenStreetMap Map with Real Turn-by-Turn Road Polylines
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

                // Real Road Turn-by-Turn Polyline
                if (_roadPoints.isNotEmpty) ...[
                  // Shadow Polyline
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _roadPoints,
                        strokeWidth: 7.0,
                        color: const Color(0xFF059669).withOpacity(0.25),
                      ),
                    ],
                  ),
                  // Sharp Emerald Road Polyline with white border
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _roadPoints,
                        strokeWidth: 4.5,
                        color: const Color(0xFF059669),
                        borderStrokeWidth: 1.5,
                        borderColor: Colors.white,
                      ),
                    ],
                  ),
                ],

                // Interactive Pickup & Dropoff Markers
                MarkerLayer(
                  markers: [
                    Marker(
                      point: start,
                      width: 90,
                      height: 36,
                      child: _buildPinBadge(
                        icon: Icons.circle,
                        color: const Color(0xFF059669),
                        label: 'Pickup',
                      ),
                    ),
                    Marker(
                      point: end,
                      width: 90,
                      height: 36,
                      child: _buildPinBadge(
                        icon: Icons.location_on_rounded,
                        color: const Color(0xFFEA580C),
                        label: 'Dropoff',
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Live Route Info Pill (Distance & Duration)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.directions_car_filled_rounded, size: 14, color: Color(0xFF059669)),
                    const SizedBox(width: 6),
                    Text(
                      '${_distanceKm.toStringAsFixed(1)} km • $_durationMinutes mins',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Map Controls & Fullscreen Button
            Positioned(
              top: 10,
              right: 10,
              child: Column(
                children: [
                  _buildMapButton(
                    icon: Icons.fullscreen_rounded,
                    tooltip: 'Full Screen',
                    onTap: () => _openFullScreenMap(context),
                  ),
                  const SizedBox(height: 6),
                  _buildMapButton(
                    icon: Icons.add_rounded,
                    onTap: () {
                      final currentZoom = _mapController.camera.zoom;
                      _mapController.move(_mapController.camera.center, currentZoom + 1);
                    },
                  ),
                  const SizedBox(height: 6),
                  _buildMapButton(
                    icon: Icons.remove_rounded,
                    onTap: () {
                      final currentZoom = _mapController.camera.zoom;
                      _mapController.move(_mapController.camera.center, currentZoom - 1);
                    },
                  ),
                ],
              ),
            ),

            // OSM Attribution
            Positioned(
              bottom: 6,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  '© OpenStreetMap',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapButton({required IconData icon, required VoidCallback onTap, String? tooltip}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFCBD5E1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF0F172A)),
      ),
    );
  }

  Widget _buildPinBadge({required IconData icon, required Color color, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: icon == Icons.circle ? 8 : 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
          ),
        ],
      ),
    );
  }
}

// ----------------- FULL SCREEN INTERACTIVE MAP -----------------
class _FullScreenMapScreen extends StatefulWidget {
  final ll.LatLng start;
  final ll.LatLng end;
  final List<ll.LatLng> roadPoints;
  final double distanceKm;
  final int durationMinutes;

  const _FullScreenMapScreen({
    required this.start,
    required this.end,
    required this.roadPoints,
    required this.distanceKm,
    required this.durationMinutes,
  });

  @override
  State<_FullScreenMapScreen> createState() => _FullScreenMapScreenState();
}

class _FullScreenMapScreenState extends State<_FullScreenMapScreen> {
  late final MapController _fullMapController;

  @override
  void initState() {
    super.initState();
    _fullMapController = MapController();
  }

  @override
  void dispose() {
    _fullMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final center = ll.LatLng(
      (widget.start.latitude + widget.end.latitude) / 2,
      (widget.start.longitude + widget.end.longitude) / 2,
    );

    return Scaffold(
      body: Stack(
        children: [
          // Full Edge-to-Edge OpenStreetMap
          FlutterMap(
            mapController: _fullMapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 12.8,
              minZoom: 6.0,
              maxZoom: 19.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}',
                userAgentPackageName: 'com.ecoride.app',
                maxZoom: 18,
              ),
              if (widget.roadPoints.isNotEmpty) ...[
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: widget.roadPoints,
                      strokeWidth: 8.0,
                      color: const Color(0xFF059669).withOpacity(0.25),
                    ),
                    Polyline(
                      points: widget.roadPoints,
                      strokeWidth: 5.0,
                      color: const Color(0xFF059669),
                      borderStrokeWidth: 2.0,
                      borderColor: Colors.white,
                    ),
                  ],
                ),
              ],
              MarkerLayer(
                markers: [
                  Marker(
                    point: widget.start,
                    width: 96,
                    height: 38,
                    child: _buildBadge(icon: Icons.circle, color: const Color(0xFF059669), label: 'Pickup'),
                  ),
                  Marker(
                    point: widget.end,
                    width: 96,
                    height: 38,
                    child: _buildBadge(icon: Icons.location_on_rounded, color: const Color(0xFFEA580C), label: 'Dropoff'),
                  ),
                ],
              ),
            ],
          ),

          // Top Header Bar with Close Button & Live Route Metric
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF0F172A)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.directions_car_filled_rounded, size: 16, color: Color(0xFF059669)),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.distanceKm.toStringAsFixed(1)} km • ${widget.durationMinutes} mins',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Action Buttons on Right (Recenter, Zoom In/Out, GPS)
          Positioned(
            right: 16,
            bottom: 36,
            child: Column(
              children: [
                _buildCircleBtn(
                  icon: Icons.center_focus_strong_rounded,
                  onTap: () {
                    if (widget.roadPoints.isNotEmpty) {
                      _fullMapController.fitCamera(
                        CameraFit.coordinates(
                          coordinates: widget.roadPoints,
                          padding: const EdgeInsets.all(40),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _fullMapController.move(_fullMapController.camera.center, _fullMapController.camera.zoom + 1),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.add_rounded, size: 22, color: Color(0xFF0F172A)),
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      GestureDetector(
                        onTap: () => _fullMapController.move(_fullMapController.camera.center, _fullMapController.camera.zoom - 1),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.remove_rounded, size: 22, color: Color(0xFF0F172A)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _buildCircleBtn(
                  icon: Icons.my_location_rounded,
                  iconColor: const Color(0xFF059669),
                  onTap: () => _fullMapController.move(widget.start, 14.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleBtn({required IconData icon, Color? iconColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 22, color: iconColor ?? const Color(0xFF0F172A)),
      ),
    );
  }

  Widget _buildBadge({required IconData icon, required Color color, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: icon == Icons.circle ? 8 : 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
        ],
      ),
    );
  }
}
