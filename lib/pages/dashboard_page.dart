import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movaset',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF2F4F7),
      ),
      home: const MainPage(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODEL ASET
// ─────────────────────────────────────────────────────────────────────────────

class AssetData {
  final String id;
  final String name;
  final LatLng latLng;
  final String status;
  final int statusColorValue;
  final String sumberPeminjaman;
  final String penanggungjawab;
  final String geoFencingArea;
  final String imagePath;

  const AssetData({
    required this.id,
    required this.name,
    required this.latLng,
    required this.status,
    required this.statusColorValue,
    required this.sumberPeminjaman,
    required this.penanggungjawab,
    required this.geoFencingArea,
    required this.imagePath,
  });

  Color get statusColor => Color(statusColorValue);
}

// ─────────────────────────────────────────────────────────────────────────────
// ASSET MARKER WIDGET — discord-style
// ─────────────────────────────────────────────────────────────────────────────

class AssetMarker extends StatelessWidget {
  final String name;
  final String status;
  final bool isSelected;

  const AssetMarker({
    super.key,
    required this.name,
    required this.status,
    this.isSelected = false,
  });

  Color get _dotColor {
    switch (status) {
      case 'Aktif': return const Color(0xFF23A55A);
      case 'Luar Zona': return const Color(0xFFEF4444);
      default: return const Color(0xFF80848E);
    }
  }

  IconData get _icon {
  if (name.toLowerCase().contains('camera') ||
      name.toLowerCase().contains('tripod')) {
    return Icons.videocam_rounded;
  }
  if (name.toLowerCase().contains('drone')) {
    return Icons.flight_rounded; // pengganti
  }
  return Icons.devices_other_rounded;
}

  @override
  Widget build(BuildContext context) {
    final size = isSelected ? 52.0 : 44.0;
    final dotSize = isSelected ? 14.0 : 12.0;

    return SizedBox(
      width: size, height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size, height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isSelected
                    ? [const Color(0xFF3A5BD9), const Color(0xFF0D1B4B)]
                    : [const Color(0xFF0D1B4B), const Color(0xFF1A2E6E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: isSelected ? const Color(0xFF3A5BD9) : Colors.white,
                width: isSelected ? 2.5 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isSelected ? const Color(0xFF3A5BD9) : Colors.black).withOpacity(0.30),
                  blurRadius: isSelected ? 14 : 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(_icon, color: Colors.white, size: isSelected ? 22 : 18),
          ),
          Positioned(
            right: 0, bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: dotSize, height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _dotColor,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [BoxShadow(color: _dotColor.withOpacity(0.5), blurRadius: 6)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN PAGE
// ─────────────────────────────────────────────────────────────────────────────

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    LiveTrackingPage(),
    NotificationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: KeyedSubtree(key: ValueKey(_currentIndex), child: _pages[_currentIndex]),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF0D1B4B)),
      child: SafeArea(
        child: SizedBox(
          height: 68,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // ── Row: kiri, tengah (spacer), kanan ──
              Row(
                children: [
                  // Tab 0 — Dashboard
                  Expanded(child: _buildTabItem(0, Icons.manage_search_rounded, 'Dashboard')),
                  // Spacer tengah untuk FAB
                  const SizedBox(width: 72),
                  // Tab 2 — Notifikasi
                  Expanded(child: _buildTabItem(2, Icons.notifications_outlined, 'Notifikasi')),
                ],
              ),

              // ── FAB oranye TETAP di tengah ──
              Positioned(
                top: -20,
                child: GestureDetector(
                  onTap: () => setState(() => _currentIndex = 1),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B1A),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B1A).withOpacity(0.45),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.location_on_outlined, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon dengan indikator titik aktif
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Icon(icon,
                    color: isSelected ? Colors.white : Colors.white38,
                    size: 23),
                if (isSelected)
                  Positioned(
                    bottom: -6,
                    child: Container(
                      width: 4, height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B1A),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white38,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DASHBOARD PAGE
// ─────────────────────────────────────────────────────────────────────────────

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static final List<AssetData> assets = [
    AssetData(
      id: '01',
      name: 'Tripod Camera',
      latLng: const LatLng(1.1192, 104.0488),
      status: 'Aktif',
      statusColorValue: 0xFF1DBF8A,
      sumberPeminjaman: 'RTF',
      penanggungjawab: 'Mega',
      geoFencingArea: 'Gedung Utama',
      imagePath: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Leica_Geosystems_TPS1200.jpg/320px-Leica_Geosystems_TPS1200.jpg',
    ),
    AssetData(
      id: '02',
      name: 'Drones',
      latLng: const LatLng(1.1155, 104.0510),
      status: 'Luar Zona',
      statusColorValue: 0xFFFF9A2E,
      sumberPeminjaman: 'Logistik',
      penanggungjawab: 'Budi',
      geoFencingArea: 'Area Parkir',
      imagePath: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/PNG_transparency_demonstration_1.png/280px-PNG_transparency_demonstration_1.png',
    ),
  ];

  // Konversi AssetData → Map untuk kompatibilitas
  static List<Map<String, dynamic>> get assetsMap => assets.map((a) => {
    'id': a.id,
    'name': a.name,
    'latLng': a.latLng,
    'status': a.status,
    'statusColorValue': a.statusColorValue,
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('System Status',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF2D3142))),
                  const SizedBox(height: 8),
                  GridView.count(
                    crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
                    childAspectRatio: 1.65, shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      _StatusCard(icon: Icons.inventory_2_outlined, iconBgColor: Color(0xFFDDE8FF), iconColor: Color(0xFF3A5BD9), value: '2', label: 'TOTAL ASET'),
                      _StatusCard(icon: Icons.check_circle_outline, iconBgColor: Color(0xFFD6F5EC), iconColor: Color(0xFF1DBF8A), value: '1', label: 'AKTIF'),
                      _StatusCard(icon: Icons.location_off_outlined, iconBgColor: Color(0xFFFFF0DC), iconColor: Color(0xFFFF9A2E), value: '1', label: 'LUAR ZONA'),
                      _StatusCard(icon: Icons.cloud_off_outlined, iconBgColor: Color(0xFFEEEFF2), iconColor: Color(0xFF9AA0B2), value: '0', label: 'OFFLINE'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Live Tracking',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF2D3142))),
                  const SizedBox(height: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showMapPopup(context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            SizedBox.expand(
                              child: IgnorePointer(
                                child: FlutterMap(
                                  options: const MapOptions(initialCenter: LatLng(1.1186, 104.0485), initialZoom: 17),
                                  children: [
                                    TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.trakker.app'),
                                    PolygonLayer(
                                      polygons: [
                                        Polygon(
                                          points: [
                                            LatLng(1.1200, 104.0472),
                                            LatLng(1.1200, 104.0500),
                                            LatLng(1.1168, 104.0500),
                                            LatLng(1.1168, 104.0472),
                                          ],
                                          color: Color(0x1AFF6B1A),
                                          borderColor: Color(0xFFFF6B1A),
                                          borderStrokeWidth: 2.5,
                                        ),
                                      ],
                                    ),
                                    MarkerLayer(
                                      markers: assets.map((a) => Marker(
                                        point: a.latLng, width: 50, height: 50,
                                        child: AssetMarker(name: a.name, status: a.status),
                                      )).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10, right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(color: const Color(0xFF0D1B4B).withOpacity(0.82), borderRadius: BorderRadius.circular(20)),
                                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                                  Icon(Icons.open_in_full, color: Colors.white, size: 11),
                                  SizedBox(width: 4),
                                  Text('Perluas peta', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMapPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, animation, _, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
        return ScaleTransition(scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved), child: FadeTransition(opacity: animation, child: child));
      },
      pageBuilder: (ctx, _, __) => const _MapPopup(),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0D1B4B),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 18),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), shape: BoxShape.circle),
            child: const Icon(Icons.person_outline, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          RichText(
            text: TextSpan(
              text: 'Halo, ',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
              children: [TextSpan(text: 'Hapiss!', style: GoogleFonts.poppins(color: const Color(0xFFFF6B1A), fontWeight: FontWeight.w700))],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ASSET DETAIL BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class AssetDetailSheet extends StatelessWidget {
  final AssetData asset;

  const AssetDetailSheet({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D1B4B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(2)),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Gambar aset ──
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      color: Colors.white,
                      child: Image.network(
                        asset.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image_not_supported_outlined, color: Color(0xFF9AA0B2), size: 48),
                        ),
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B1A)));
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Koordinat ──
                  _buildSectionTitle('Koordinat', subtitle: 'terakhir update 2 menit lalu', showEdit: true),
                  const SizedBox(height: 8),
                  _buildInfoRow('Latitude', asset.latLng.latitude.toStringAsFixed(6)),
                  const SizedBox(height: 4),
                  _buildInfoRow('Longitude', asset.latLng.longitude.toStringAsFixed(6)),

                  const SizedBox(height: 18),
                  _buildDivider(),
                  const SizedBox(height: 18),

                  // ── Detail Aset ──
                  _buildSectionTitle('Detail Aset'),
                  const SizedBox(height: 8),
                  _buildInfoRow('Nama', asset.name),
                  const SizedBox(height: 4),
                  _buildInfoRow('Sumber peminjaman', asset.sumberPeminjaman),
                  const SizedBox(height: 4),
                  _buildInfoRow('Penanggung jawab', asset.penanggungjawab),

                  const SizedBox(height: 18),
                  _buildDivider(),
                  const SizedBox(height: 18),

                  // ── Geo Fencing ──
                  _buildSectionTitle('Geo Fencing'),
                  const SizedBox(height: 8),
                  _buildInfoRow('Area', asset.geoFencingArea),

                  const SizedBox(height: 8),

                  // Badge status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: asset.statusColor.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: asset.statusColor.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7, height: 7,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: asset.statusColor),
                            ),
                            const SizedBox(width: 6),
                            Text(asset.status,
                                style: TextStyle(color: asset.statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String? subtitle, bool showEdit = false}) {
    return Row(
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        if (subtitle != null) ...[
          const SizedBox(width: 6),
          Text('($subtitle)',
              style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w400)),
        ],
        if (showEdit) ...[
          const SizedBox(width: 8),
          const Icon(Icons.edit_rounded, color: Colors.white54, size: 16),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w400),
        children: [
          TextSpan(text: '$label : '),
          TextSpan(text: value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.white.withOpacity(0.15), Colors.transparent],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATUS CARD
// ─────────────────────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String value;
  final String label;

  const _StatusCard({required this.icon, required this.iconBgColor, required this.iconColor, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(width: 32, height: 32,
              decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 16)),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFF2D3142), height: 1.0)),
            const SizedBox(height: 2),
            Text(label, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w600, color: const Color(0xFF9AA0B2), letterSpacing: 0.4)),
          ]),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAP POPUP
// ─────────────────────────────────────────────────────────────────────────────

class _MapPopup extends StatefulWidget {
  const _MapPopup();

  @override
  State<_MapPopup> createState() => _MapPopupState();
}

class _MapPopupState extends State<_MapPopup> {
  final MapController _mapController = MapController();
  int _selectedAsset = 0;
  final List<AssetData> _assets = DashboardPage.assets;

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
          height: screenH * 0.78,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 32, offset: const Offset(0, 8))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 12, 14),
                  decoration: const BoxDecoration(color: Color(0xFF0D1B4B)),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFFFF6B1A), size: 20),
                      const SizedBox(width: 8),
                      Text('Live Tracking', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                      const Spacer(),
                      _buildLegend(),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: const MapOptions(initialCenter: LatLng(1.1186, 104.0485), initialZoom: 17),
                    children: [
                      TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.trakker.app'),
                      PolygonLayer(
                        polygons: [
                          Polygon(
                            points: [
                              LatLng(1.1200, 104.0472),
                              LatLng(1.1200, 104.0500),
                              LatLng(1.1168, 104.0500),
                              LatLng(1.1168, 104.0472),
                            ],
                            color: Color(0x1AFF6B1A),
                            borderColor: Color(0xFFFF6B1A),
                            borderStrokeWidth: 2.5,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: List.generate(_assets.length, (i) {
                          final a = _assets[i];
                          final sel = _selectedAsset == i;
                          return Marker(
                            point: a.latLng, width: sel ? 58 : 50, height: sel ? 58 : 50,
                            child: AssetMarker(name: a.name, status: a.status, isSelected: sel),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pilih Aset', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF9AA0B2), letterSpacing: 0.5)),
                      const SizedBox(height: 8),
                      ...List.generate(_assets.length, (i) {
                        final a = _assets[i];
                        final sel = _selectedAsset == i;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedAsset = i);
                            _mapController.move(a.latLng, 17.5);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                            decoration: BoxDecoration(
                              color: sel ? const Color(0xFFDDE8FF) : const Color(0xFFF2F4F7),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: sel ? const Color(0xFF3A5BD9) : Colors.transparent, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                AssetMarker(name: a.name, status: a.status, isSelected: sel),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text('ID: ${a.id} — ${a.name}',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                                          color: sel ? const Color(0xFF0D1B4B) : const Color(0xFF3A5BD9))),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: a.statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                                  child: Text(a.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: a.statusColor)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final items = [('Aktif', const Color(0xFF23A55A)), ('Idle', const Color(0xFFF0B232)), ('Offline', const Color(0xFF80848E))];
    return Row(
      children: items.map((e) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Row(children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: e.$2, boxShadow: [BoxShadow(color: e.$2.withOpacity(0.5), blurRadius: 4)])),
          const SizedBox(width: 3),
          Text(e.$1, style: const TextStyle(color: Colors.white60, fontSize: 9, fontWeight: FontWeight.w500)),
        ]),
      )).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LIVE DOT — titik merah pulsing seperti tanda live siaran
// ─────────────────────────────────────────────────────────────────────────────

class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

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
    _opacityAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
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
          // Lingkaran luar — pulsing
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
          // Dot merah inti
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

// ─────────────────────────────────────────────────────────────────────────────
// LIVE TRACKING PAGE
// ─────────────────────────────────────────────────────────────────────────────

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({super.key});

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  final MapController _mapController = MapController();
  final List<AssetData> _assets = DashboardPage.assets;
  int _selectedAsset = 0;

  // Tampilkan bottom sheet detail aset
  void _showAssetDetail(BuildContext context, AssetData asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, controller) => AssetDetailSheet(asset: asset),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(initialCenter: LatLng(1.1186, 104.0485), initialZoom: 17),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.trakker.app'),
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: [
                      LatLng(1.1200, 104.0472),
                      LatLng(1.1200, 104.0500),
                      LatLng(1.1168, 104.0500),
                      LatLng(1.1168, 104.0472),
                    ],
                    color: Color(0x1AFF6B1A),
                    borderColor: Color(0xFFFF6B1A),
                    borderStrokeWidth: 2.5,
                  ),
                ],
              ),
              MarkerLayer(
                markers: List.generate(_assets.length, (i) {
                  final a = _assets[i];
                  final sel = _selectedAsset == i;
                  return Marker(
                    point: a.latLng, width: sel ? 58 : 50, height: sel ? 58 : 50,
                    child: AssetMarker(name: a.name, status: a.status, isSelected: sel),
                  );
                }),
              ),
            ],
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Center(
                  child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1B4B),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 12, offset: const Offset(0, 4)),
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
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, -4))],
              ),
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36, height: 4,
                      decoration: BoxDecoration(color: Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Daftar Aset',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF2D3142))),
                  const SizedBox(height: 10),
                  ...List.generate(_assets.length, (i) {
                    final a = _assets[i];
                    final sel = _selectedAsset == i;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedAsset = i);
                        _mapController.move(a.latLng, 17);
                      },
                      // ── Tahan (long press) → buka detail aset ──
                      onLongPress: () => _showAssetDetail(context, a),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFFDDE8FF) : const Color(0xFFF2F4F7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: sel ? const Color(0xFF3A5BD9) : Colors.transparent, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            AssetMarker(name: a.name, status: a.status, isSelected: sel),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${a.id} — ${a.name}',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                                          color: sel ? const Color(0xFF0D1B4B) : const Color(0xFF3A5BD9))),
                                  const SizedBox(height: 2),
                                  Text('Ketuk tahan untuk detail',
                                      style: const TextStyle(fontSize: 9, color: Color(0xFFBDBDBD), fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: a.statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                              child: Text(a.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: a.statusColor)),
                            ),
                            const SizedBox(width: 6),
                            // Tombol info → buka detail
                            GestureDetector(
                              onTap: () => _showAssetDetail(context, a),
                              child: Container(
                                width: 28, height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D1B4B).withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF0D1B4B)),
                              ),
                            ),
                          ],
                        ),
                      ),
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

// ─────────────────────────────────────────────────────────────────────────────
// NOTIFICATION PAGE
// ─────────────────────────────────────────────────────────────────────────────

class _NotifItem {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;

  const _NotifItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isRead = false,
  });
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _tabIndex = 0; // 0 = Hari ini, 1 = Semua

  static const List<_NotifItem> _todayNotifs = [
    _NotifItem(
      icon: Icons.warning_rounded,
      iconBgColor: Color(0xFFFFEDED),
      iconColor: Color(0xFFEF4444),
      title: 'Drone left Zone',
      subtitle: 'Aset ID:02 telah keluar dari zona aman',
      time: '2 menit lalu',
      isRead: false,
    ),
    _NotifItem(
      icon: Icons.location_on_rounded,
      iconBgColor: Color(0xFFEDF4FF),
      iconColor: Color(0xFF3A5BD9),
      title: 'Tripod Camera in Zone',
      subtitle: 'Aset ID:01 berada di dalam zona aman',
      time: '15 menit lalu',
      isRead: true,
    ),
    _NotifItem(
      icon: Icons.battery_alert_rounded,
      iconBgColor: Color(0xFFFFF7ED),
      iconColor: Color(0xFFFF9A2E),
      title: 'Low Power',
      subtitle: 'Aset ID:02 daya dibawah 25%',
      time: '45 menit lalu',
      isRead: true,
    ),
  ];

  static const List<_NotifItem> _allNotifs = [
    _NotifItem(
      icon: Icons.warning_rounded,
      iconBgColor: Color(0xFFFFEDED),
      iconColor: Color(0xFFEF4444),
      title: 'Drones left Zone',
      subtitle: 'Aset ID:02 telah keluar dari zona aman',
      time: '2 menit lalu',
      isRead: false,
    ),
    _NotifItem(
      icon: Icons.location_on_rounded,
      iconBgColor: Color(0xFFEDF4FF),
      iconColor: Color(0xFF3A5BD9),
      title: 'Drones in Zone',
      subtitle: 'Aset ID:01 berada di dalam zona aman',
      time: '15 menit lalu',
      isRead: true,
    ),
    _NotifItem(
      icon: Icons.battery_alert_rounded,
      iconBgColor: Color(0xFFFFF7ED),
      iconColor: Color(0xFFFF9A2E),
      title: 'Low Power',
      subtitle: 'Aset ID:02 daya dibawah 25%',
      time: '45 menit lalu',
      isRead: true,
    ),
    _NotifItem(
      icon: Icons.warning_rounded,
      iconBgColor: Color(0xFFFFEDED),
      iconColor: Color(0xFFEF4444),
      title: 'Drones left Zone',
      subtitle: 'Aset ID:02 keluar zona — kemarin',
      time: '1 hari lalu',
      isRead: true,
    ),
    _NotifItem(
      icon: Icons.check_circle_rounded,
      iconBgColor: Color(0xFFEDFDF5),
      iconColor: Color(0xFF1DBF8A),
      title: 'Drones back to Zone',
      subtitle: 'Aset ID:02 kembali masuk zona aman',
      time: '1 hari lalu',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final notifs = _tabIndex == 0 ? _todayNotifs : _allNotifs;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: Column(
        children: [
          // ── Header ──
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0D1B4B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 18),
            child: Center(
              child: Text('Notifikasi',
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
            ),
          ),

          const SizedBox(height: 12),

          // ── Tab toggle ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
              ),
              child: Row(
                children: [
                  _buildTab(0, 'Hari ini'),
                  _buildTab(1, 'Semua Notifikasi'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── List notifikasi ──
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: notifs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _buildNotifCard(notifs[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final isSelected = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0D1B4B) : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF9AA0B2),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotifCard(_NotifItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: item.iconBgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(item.icon, color: item.iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          // Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF2D3142))),
                const SizedBox(height: 3),
                Text(item.subtitle,
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xFF9AA0B2))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Waktu + dot
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(item.time,
                  style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF9AA0B2), fontWeight: FontWeight.w400)),
              const SizedBox(height: 4),
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.isRead ? const Color(0xFFCBD5E1) : const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}