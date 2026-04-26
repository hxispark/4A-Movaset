import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../providers/asset_providers.dart';
import '../widgets/asset_marker.dart';
import '../widgets/asset_detail_sheet.dart';

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({super.key});

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  late final MapController _mapController;
  int _selectedAsset = 0;

  // ── Mode panel bawah: 'asset' atau 'geofence' ──
  String _panelMode = 'asset';

  // ── State Geo Fence Settings ──
  bool _geofenceActive = true;
  String _zoneName = 'Polibatam';
  String _alertOn = 'Entry & Exit';
  String _assetClass = 'TRIPOD';

  final List<String> _alertOptions = ['Entry & Exit', 'Entry Only', 'Exit Only'];
  final List<String> _assetClassOptions = ['TRIPOD', 'DRONE', 'SEMUA'];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssetProvider>(
      builder: (context, provider, _) {
        final assets = provider.assets;

        return Scaffold(
          body: Stack(
            children: [
              // ── Peta ──
              FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: LatLng(1.1186, 104.0485),
                  initialZoom: 17,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.trakker.app',
                  ),
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: const [
                          LatLng(1.1200, 104.0472),
                          LatLng(1.1200, 104.0500),
                          LatLng(1.1168, 104.0500),
                          LatLng(1.1168, 104.0472),
                        ],
                        color: const Color(0x1AFF6B1A),
                        borderColor: const Color(0xFFFF6B1A),
                        borderStrokeWidth: 2.5,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: List.generate(assets.length, (i) {
                      final a = assets[i];
                      final sel = _selectedAsset == i;
                      return Marker(
                        point: a.latLng,
                        width: sel ? 58 : 50,
                        height: sel ? 58 : 50,
                        child: AssetMarker(
                            name: a.name,
                            status: a.status,
                            isSelected: sel),
                      );
                    }),
                  ),
                ],
              ),

              // ── Top bar: Badge Live + tombol Geo Fence ──
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Badge Live Tracking
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D1B4B),
                            borderRadius: BorderRadius.circular(30),
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
                              const _LiveDot(),
                              const SizedBox(width: 8),
                              Text(
                                'Live Tracking',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tombol toggle Geo Fence
                        GestureDetector(
                          onTap: () => setState(() => _panelMode =
                              _panelMode == 'geofence' ? 'asset' : 'geofence'),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: _panelMode == 'geofence'
                                  ? const Color(0xFFFF6B1A)
                                  : const Color(0xFF0D1B4B),
                              borderRadius: BorderRadius.circular(30),
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
                                const Icon(Icons.fence_rounded,
                                    color: Colors.white, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  'Geo Fence',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Panel bawah (animated switch) ──
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) => SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.12),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                        parent: anim, curve: Curves.easeOut)),
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: _panelMode == 'geofence'
                      ? _buildGeofencePanel()
                      : _buildAssetPanel(provider, assets),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PANEL: DAFTAR ASET
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildAssetPanel(AssetProvider provider, List assets) {
    return Container(
      key: const ValueKey('asset'),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 16, offset: Offset(0, -4))
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
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
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 12),
          Text('Daftar Aset',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D3142))),
          const SizedBox(height: 10),
          if (provider.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child:
                    CircularProgressIndicator(color: Color(0xFFFF6B1A)),
              ),
            )
          else
            ...List.generate(assets.length, (i) {
              final a = assets[i];
              final sel = _selectedAsset == i;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedAsset = i);
                  _mapController.move(a.latLng, 17);
                },
                onLongPress: () => _showAssetDetail(context, a),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: sel
                        ? const Color(0xFFDDE8FF)
                        : const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: sel
                          ? const Color(0xFF3A5BD9)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      AssetMarker(
                          name: a.name,
                          status: a.status,
                          isSelected: sel),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID: ${a.id} — ${a.name}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: sel
                                    ? const Color(0xFF0D1B4B)
                                    : const Color(0xFF3A5BD9),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Ketuk tahan untuk detail',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFFBDBDBD),
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: a.statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          a.status,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: a.statusColor),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _showAssetDetail(context, a),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF0D1B4B).withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.info_outline_rounded,
                              size: 16, color: Color(0xFF0D1B4B)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PANEL: GEO FENCE SETTINGS
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildGeofencePanel() {
    return Container(
      key: const ValueKey('geofence'),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 16, offset: Offset(0, -4))
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),

          // ── Header: judul + badge ACTIVE/INACTIVE ──
          Row(
            children: [
              const Icon(Icons.edit_location_alt_rounded,
                  color: Color(0xFF3A5BD9), size: 22),
              const SizedBox(width: 8),
              Text(
                'Geo Fence Settings',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3142)),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    setState(() => _geofenceActive = !_geofenceActive),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: _geofenceActive
                        ? const Color(0xFFEDF4FF)
                        : const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _geofenceActive
                          ? const Color(0xFF3A5BD9)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                  child: Text(
                    _geofenceActive ? 'ACTIVE' : 'INACTIVE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _geofenceActive
                          ? const Color(0xFF3A5BD9)
                          : const Color(0xFF9AA0B2),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          Container(height: 1, color: const Color(0xFFF0F0F0)),
          const SizedBox(height: 16),

          // ── Zone Name ──
          Text(
            'ZONE NAME',
            style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9AA0B2),
                letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: _zoneName,
            onChanged: (v) => _zoneName = v,
            style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D3142)),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              filled: true,
              fillColor: const Color(0xFFF2F4F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFF3A5BD9), width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Alert On + Asset Class ──
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ALERT ON',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF9AA0B2),
                          letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: _alertOn,
                      items: _alertOptions,
                      onChanged: (v) => setState(() => _alertOn = v!),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ASSET CLASS',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF9AA0B2),
                          letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: _assetClass,
                      items: _assetClassOptions,
                      onChanged: (v) =>
                          setState(() => _assetClass = v!),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Cancel + Save Zone ──
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _panelMode = 'asset'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF9AA0B2)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    // TODO: simpan ke Firestore / backend
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Zona "$_zoneName" disimpan!',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: const Color(0xFF1DBF8A),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                    setState(() => _panelMode = 'asset');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A5BD9),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF3A5BD9).withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Save Zone',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Helper: Dropdown ─────────────────────────────────────────────────────
  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF2D3142), size: 20),
          style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3142)),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Colors.white,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _showAssetDetail(BuildContext context, asset) {
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
}

// ─────────────────────────────────────────────────────────────────────────────
// LIVE DOT
// ─────────────────────────────────────────────────────────────────────────────

class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.7, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => Opacity(
              opacity: 1 - _controller.value,
              child: Transform.scale(
                scale: _scaleAnim.value,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFF3B30).withOpacity(0.35),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFF3B30),
            ),
          ),
        ],
      ),
    );
  }
}