import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/asset_data.dart';
import '../theme/app_theme.dart';
import '../widgets/asset_detail_sheet.dart';
import '../widgets/asset_list_tile.dart';
import '../widgets/live_dot.dart';
import '../widgets/map_layer_stack.dart';

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({super.key});

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  final MapController _mapController = MapController();
  final List<AssetData> _assets = appAssets;
  int _selectedAsset = 0;

  void _openDetail(AssetData asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, __) => AssetDetailSheet(asset: asset),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      body: Stack(
        children: [
          // ── Peta fullscreen ──────────────────────────────
          MapLayerStack(
            controller: _mapController,
            assets: _assets,
            selectedIndex: _selectedAsset,
            options: const MapOptions(
              initialCenter: LatLng(1.1186, 104.0485),
              initialZoom: 17,
            ),
          ),

          // ── Badge "Live Tracking" ────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: AppRadius.pill,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.20),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const LiveDot(),
                      const SizedBox(width: 8),
                      Text(
                        'Pelacakan Langsung',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: r.scaledFont(15),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Daftar aset bawah ────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(r.hPad, 14, r.hPad, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Daftar Aset',
                    style: GoogleFonts.poppins(
                      fontSize: r.scaledFont(14),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(_assets.length, (i) {
                    final a = _assets[i];
                    return AssetListTile(
                      asset: a,
                      isSelected: _selectedAsset == i,
                      showHint: true,
                      onTap: () {
                        setState(() => _selectedAsset = i);
                        _mapController.move(a.latLng, 17);
                      },
                      onLongPress: () => _openDetail(a),
                      onInfo: () => _openDetail(a),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}