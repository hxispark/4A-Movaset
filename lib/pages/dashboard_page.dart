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
// ASSET MARKER WIDGET — avatar bulat + dot status discord-style
// ─────────────────────────────────────────────────────────────────────────────

class AssetMarker extends StatelessWidget {
  final String name;
  final String status;   // 'Aktif' | 'Luar Zona' | 'Offline'
  final bool isSelected;

  const AssetMarker({
    super.key,
    required this.name,
    required this.status,
    this.isSelected = false,
  });

  // Warna dot status
  Color get _dotColor {
    switch (status) {
      case 'Aktif':
        return const Color(0xFF23A55A);    // hijau — online
      case 'Luar Zona':
        return const Color(0xFFF0B232);    // kuning — idle
      default:
        return const Color(0xFF80848E);    // abu — offline
    }
  }

  // Ikon aset
  IconData get _icon {
    if (name.toLowerCase().contains('camera')) return Icons.videocam_rounded;
    if (name.toLowerCase().contains('mobil') ||
        name.toLowerCase().contains('pickup')) return Icons.directions_car_rounded;
    return Icons.devices_other_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final size = isSelected ? 52.0 : 44.0;
    final dotSize = isSelected ? 14.0 : 12.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Avatar bulat utama ──
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size,
            height: size,
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
                color: isSelected
                    ? const Color(0xFF3A5BD9)
                    : Colors.white,
                width: isSelected ? 2.5 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isSelected
                      ? const Color(0xFF3A5BD9)
                      : Colors.black).withOpacity(0.30),
                  blurRadius: isSelected ? 14 : 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              _icon,
              color: Colors.white,
              size: isSelected ? 22 : 18,
            ),
          ),

          // ── Dot status (discord-style) pojok kanan bawah ──
          Positioned(
            right: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _dotColor,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: _dotColor.withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
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
// MAIN PAGE
// ─────────────────────────────────────────────────────────────────────────────

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  static const List<_TabConfig> _tabs = [
    _TabConfig(icon: Icons.manage_search_rounded, label: 'Dashboard', fabColor: Color(0xFFFF6B1A)),
    _TabConfig(icon: Icons.location_on_outlined, label: 'Tracking', fabColor: Color(0xFFFF6B1A)),
    _TabConfig(icon: Icons.notifications_outlined, label: 'Notifikasi', fabColor: Color(0xFFFF6B1A)),
  ];

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
    final screenWidth = MediaQuery.of(context).size.width;
    final slotWidth = screenWidth / _tabs.length;
    final fabLeft = (slotWidth * _currentIndex) + (slotWidth / 2) - 29;
    final fabColor = _tabs[_currentIndex].fabColor;

    return Container(
      decoration: const BoxDecoration(color: Color(0xFF0D1B4B)),
      child: SafeArea(
        child: SizedBox(
          height: 68,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: List.generate(_tabs.length, (i) {
                  final isSelected = _currentIndex == i;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _currentIndex = i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),
                          Icon(_tabs[i].icon,
                              color: isSelected ? Colors.white : Colors.white38,
                              size: 22),
                          const SizedBox(height: 3),
                          Text(_tabs[i].label,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white38,
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                              )),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOutCubic,
                left: fabLeft,
                top: -22,
                child: GestureDetector(
                  onTap: () {},
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: fabColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: fabColor.withOpacity(0.45),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(_tabs[_currentIndex].icon,
                          key: ValueKey(_currentIndex),
                          color: Colors.white, size: 26),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabConfig {
  final IconData icon;
  final String label;
  final Color fabColor;
  const _TabConfig({required this.icon, required this.label, required this.fabColor});
}

// ─────────────────────────────────────────────────────────────────────────────
// DASHBOARD PAGE
// ─────────────────────────────────────────────────────────────────────────────

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static final List<Map<String, dynamic>> assets = [
    {
      'id': '123',
      'name': 'Tripod Camera',
      'latLng': LatLng(1.1290, 104.0515),
      'status': 'Aktif',
      'statusColor': Color(0xFF1DBF8A),
    },
    {
      'id': '321',
      'name': 'Mobil Pickup',
      'latLng': LatLng(1.1315, 104.0540),
      'status': 'Luar Zona',
      'statusColor': Color(0xFFFF9A2E),
    },
  ];

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
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w800,
                          color: const Color(0xFF2D3142))),
                  const SizedBox(height: 8),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.65,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      _StatusCard(icon: Icons.inventory_2_outlined, iconBgColor: Color(0xFFDDE8FF), iconColor: Color(0xFF3A5BD9), value: '2', label: 'TOTAL ASET'),
                      _StatusCard(icon: Icons.check_circle_outline, iconBgColor: Color(0xFFD6F5EC), iconColor: Color(0xFF1DBF8A), value: '2', label: 'AKTIF'),
                      _StatusCard(icon: Icons.location_off_outlined, iconBgColor: Color(0xFFFFF0DC), iconColor: Color(0xFFFF9A2E), value: '1', label: 'LUAR ZONA'),
                      _StatusCard(icon: Icons.cloud_off_outlined, iconBgColor: Color(0xFFEEEFF2), iconColor: Color(0xFF9AA0B2), value: '0', label: 'OFFLINE'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Live Tracking',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w800,
                          color: const Color(0xFF2D3142))),
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
                                  options: const MapOptions(
                                    initialCenter: LatLng(1.1301, 104.0527),
                                    initialZoom: 16,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName: 'com.trakker.app',
                                    ),
                                    MarkerLayer(
                                      markers: assets.map((a) {
                                        return Marker(
                                          point: a['latLng'] as LatLng,
                                          width: 50,
                                          height: 50,
                                          child: AssetMarker(
                                            name: a['name'] as String,
                                            status: a['status'] as String,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10, right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D1B4B).withOpacity(0.82),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.open_in_full, color: Colors.white, size: 11),
                                    SizedBox(width: 4),
                                    Text('Perluas peta',
                                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                                  ],
                                ),
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
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (ctx, _, __) => const _MapPopup(),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0D1B4B),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 18),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          RichText(
            text: TextSpan(
              text: 'Halo, ',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                  text: 'Hapiss!',
                  style: GoogleFonts.poppins(color: const Color(0xFFFF6B1A), fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
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

  const _StatusCard({
    required this.icon, required this.iconBgColor,
    required this.iconColor, required this.value, required this.label,
  });

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
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFF2D3142), height: 1.0)),
              const SizedBox(height: 2),
              Text(label, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w600, color: const Color(0xFF9AA0B2), letterSpacing: 0.4)),
            ],
          ),
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
  final List<Map<String, dynamic>> _assets = DashboardPage.assets;

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
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 32, offset: const Offset(0, 8))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 12, 14),
                  decoration: const BoxDecoration(color: Color(0xFF0D1B4B)),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFFFF6B1A), size: 20),
                      const SizedBox(width: 8),
                      Text('Live Tracking',
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                      const Spacer(),
                      // Legenda status
                      _buildLegend(),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                // Peta
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: const MapOptions(
                      initialCenter: LatLng(1.1301, 104.0527),
                      initialZoom: 16,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.trakker.app',
                      ),
                      MarkerLayer(
                        markers: List.generate(_assets.length, (i) {
                          final a = _assets[i];
                          final sel = _selectedAsset == i;
                          return Marker(
                            point: a['latLng'] as LatLng,
                            width: sel ? 58 : 50,
                            height: sel ? 58 : 50,
                            child: AssetMarker(
                              name: a['name'] as String,
                              status: a['status'] as String,
                              isSelected: sel,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                // Panel aset
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pilih Aset',
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF9AA0B2), letterSpacing: 0.5)),
                      const SizedBox(height: 8),
                      ...List.generate(_assets.length, (i) {
                        final a = _assets[i];
                        final sel = _selectedAsset == i;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedAsset = i);
                            _mapController.move(a['latLng'] as LatLng, 17.5);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                            decoration: BoxDecoration(
                              color: sel ? const Color(0xFFDDE8FF) : const Color(0xFFF2F4F7),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: sel ? const Color(0xFF3A5BD9) : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Mini marker preview
                                AssetMarker(
                                  name: a['name'] as String,
                                  status: a['status'] as String,
                                  isSelected: sel,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ID: ${a['id']} — ${a['name']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: sel ? const Color(0xFF0D1B4B) : const Color(0xFF3A5BD9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: (a['statusColor'] as Color).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(a['status'] as String,
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: a['statusColor'] as Color)),
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

  // Legenda kecil di header popup
  Widget _buildLegend() {
    final items = [
      ('Aktif', const Color(0xFF23A55A)),
      ('Idle', const Color(0xFFF0B232)),
      ('Offline', const Color(0xFF80848E)),
    ];
    return Row(
      children: items.map((e) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Row(
          children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: e.$2,
                boxShadow: [BoxShadow(color: e.$2.withOpacity(0.5), blurRadius: 4)],
              ),
            ),
            const SizedBox(width: 3),
            Text(e.$1, style: const TextStyle(color: Colors.white60, fontSize: 9, fontWeight: FontWeight.w500)),
          ],
        ),
      )).toList(),
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
  final List<Map<String, dynamic>> _assets = DashboardPage.assets;
  int _selectedAsset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(1.1301, 104.0527),
              initialZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.trakker.app',
              ),
              MarkerLayer(
                markers: List.generate(_assets.length, (i) {
                  final a = _assets[i];
                  final sel = _selectedAsset == i;
                  return Marker(
                    point: a['latLng'] as LatLng,
                    width: sel ? 58 : 50,
                    height: sel ? 58 : 50,
                    child: AssetMarker(
                      name: a['name'] as String,
                      status: a['status'] as String,
                      isSelected: sel,
                    ),
                  );
                }),
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 8)],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF0D1B4B)),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 8)],
                    ),
                    child: Text('Live Tracking',
                        style: GoogleFonts.poppins(color: const Color(0xFF0D1B4B), fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ],
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
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
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
                        _mapController.move(a['latLng'] as LatLng, 17);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFFDDE8FF) : const Color(0xFFF2F4F7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: sel ? const Color(0xFF3A5BD9) : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            AssetMarker(
                              name: a['name'] as String,
                              status: a['status'] as String,
                              isSelected: sel,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'ID: ${a['id']} — ${a['name']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: sel ? const Color(0xFF0D1B4B) : const Color(0xFF3A5BD9),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: (a['statusColor'] as Color).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(a['status'] as String,
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: a['statusColor'] as Color)),
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

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B4B),
        title: Text('Notifikasi',
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 60, color: Color(0xFF9AA0B2)),
            SizedBox(height: 10),
            Text('Belum ada notifikasi',
                style: TextStyle(fontSize: 14, color: Color(0xFF9AA0B2), fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}