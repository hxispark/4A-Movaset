import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:ui' as ui;
import '../../theme/app_theme.dart';

// Model titik berhenti
class StopPoint {
  final LatLng position;
  final String label;      // misal "45 mnt"
  final bool isLongest;    // titik berhenti terlama

  const StopPoint({
    required this.position,
    required this.label,
    this.isLongest = false,
  });
}

// Data dummy rute — nanti ganti dari Firestore/API
final List<LatLng> dummyRoute = [
  const LatLng(1.1172, 104.0465),
  const LatLng(1.1176, 104.0470),
  const LatLng(1.1180, 104.0475),
  const LatLng(1.1183, 104.0480),
  const LatLng(1.1186, 104.0485),
  const LatLng(1.1190, 104.0490),
  const LatLng(1.1194, 104.0488),
  const LatLng(1.1197, 104.0483),
  const LatLng(1.1195, 104.0478),
];

final List<StopPoint> dummyStops = [
  const StopPoint(position: LatLng(1.1180, 104.0475), label: '12 mnt'),
  const StopPoint(position: LatLng(1.1186, 104.0485), label: '45 mnt', isLongest: true),
  const StopPoint(position: LatLng(1.1194, 104.0488), label: '8 mnt'),
];

class HistoryMap extends StatelessWidget {
  final List<LatLng> route;
  final List<StopPoint> stops;
  final double height;

  const HistoryMap({
    super.key,
    required this.route,
    required this.stops,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    // Hitung center dari rute
    final centerLat =
        route.map((p) => p.latitude).reduce((a, b) => a + b) / route.length;
    final centerLng =
        route.map((p) => p.longitude).reduce((a, b) => a + b) / route.length;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(centerLat, centerLng),
            initialZoom: 16.5,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none, // non-interactive di sheet
            ),
          ),
          children: [
            // Tile layer
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.movaset.app',
            ),

            // ── Garis rute ──
            PolylineLayer(
              polylines: [
                Polyline(
                  points: route,
                  strokeWidth: 4.0,
                  color: AppColors.blue,
                  borderStrokeWidth: 1.5,
                  borderColor: Colors.white.withOpacity(0.6),
                ),
              ],
            ),

            // ── Titik start & end ──
            MarkerLayer(
              markers: [
                // Titik start (hijau)
                Marker(
                  point: route.first,
                  width: 24,
                  height: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.green.withOpacity(0.4),
                            blurRadius: 6)
                      ],
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 12),
                  ),
                ),
                // Titik end (merah)
                Marker(
                  point: route.last,
                  width: 24,
                  height: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.red.withOpacity(0.4),
                            blurRadius: 6)
                      ],
                    ),
                    child: const Icon(Icons.stop_rounded,
                        color: Colors.white, size: 12),
                  ),
                ),
              ],
            ),

            // ── Titik berhenti ──
            MarkerLayer(
              markers: stops.map((stop) {
                final isMain = stop.isLongest;
                return Marker(
                  point: stop.position,
                  width: isMain ? 72 : 56,
                  height: isMain ? 52 : 42,
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge durasi
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: isMain
                              ? AppColors.orange
                              : AppColors.navy.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(8),
                          border: isMain
                              ? Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 1.5)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: (isMain ? AppColors.orange : AppColors.navy)
                                  .withOpacity(0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isMain
                                  ? Icons.star_rounded
                                  : Icons.pause_circle_outline_rounded,
                              color: Colors.white,
                              size: isMain ? 10 : 9,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              stop.label,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMain ? 10 : 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Panah ke bawah
                      CustomPaint(
                        size: const Size(8, 5),
                        painter: _ArrowPainter(
                          color: isMain
                              ? AppColors.orange
                              : AppColors.navy.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Painter untuk panah kecil di bawah badge
class _ArrowPainter extends CustomPainter {
  final Color color;
  const _ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}