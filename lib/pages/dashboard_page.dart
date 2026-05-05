import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/asset_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/map_layer_stack.dart';
import '../widgets/map_popup.dart';
import '../widgets/section_header.dart';
import '../widgets/status_carousel.dart';
import 'main_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _nama = 'User';

  @override
  void initState() {
    super.initState();
    _loadNama();
  }

  Future<void> _loadNama() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('logged_in_user') ?? 'User';
    });
  }

  void _showMapPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (ctx, _, __) => MapPopup(assets: appAssets),
    );
  }

  // ── Data kartu status ─────────────────────────────────────────
  List<StatusCardData> _buildStatusItems(BuildContext context) {
    final notifier = MainPageTabNotifier.of(context);
    void goTo(int idx) => notifier?.goTo(idx);

    return [
      StatusCardData(
        icon: Icons.inventory_2_outlined,
        iconBgColor: const Color(0xFFDDE8FF),
        iconColor: const Color(0xFF3A5BD9),
        accentColor: const Color(0xFF3A5BD9),
        value: '2',
        label: 'TOTAL ASET',
        onTap: () => goTo(1), // → Aset
      ),
      StatusCardData(
        icon: Icons.check_circle_outline,
        iconBgColor: const Color(0xFFD6F5EC),
        iconColor: const Color(0xFF1DBF8A),
        accentColor: const Color(0xFF1DBF8A),
        value: '1',
        label: 'AKTIF',
        onTap: () => goTo(2), // → Live Tracking
      ),
      StatusCardData(
        icon: Icons.location_off_outlined,
        iconBgColor: const Color(0xFFFFF0DC),
        iconColor: const Color(0xFFFF9A2E),
        accentColor: const Color(0xFFFF9A2E),
        value: '1',
        label: 'LUAR ZONA',
        onTap: () => goTo(2), // → Live Tracking
      ),
      // StatusCardData(
      //   icon: Icons.cloud_off_outlined,
      //   iconBgColor: const Color(0xFFEEEFF2),
      //   iconColor: const Color(0xFF9AA0B2),
      //   accentColor: const Color(0xFF9AA0B2),
      //   value: '0',
      //   label: 'OFFLINE',
      //   onTap: () => goTo(2), // → Live Tracking
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppHeader(
            greeting: 'Halo, ',
            name: '$_nama!',
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(r.hPad, 12, r.hPad, 8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // ── System Status ──
                      const SectionHeader(title: 'Status Sistem'),
                      const SizedBox(height: 8),
                      StatusCarousel(
                        items: _buildStatusItems(context),
                        autoPlayDuration: const Duration(seconds: 3),
                      ),
                      SizedBox(height: r.isSmall ? 10 : 14),

                      // ── Live Tracking preview ──
                      SectionHeader(
                        title: 'Pelacakan Langsung',
                        actionLabel: '',
                        onAction: () => _showMapPopup(context),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 280,
                        child: _MapPreviewCard(
                          onExpand: () => _showMapPopup(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Peta preview ──────────────────────────────────────────────────

class _MapPreviewCard extends StatelessWidget {
  final VoidCallback onExpand;
  const _MapPreviewCard({required this.onExpand});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onExpand,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            SizedBox.expand(
              child: IgnorePointer(
                child: MapLayerStack(
                  assets: appAssets,
                  options: const MapOptions(
                    initialCenter: LatLng(1.1186, 104.0485),
                    initialZoom: 17,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.navy.withOpacity(0.82),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.open_in_full, color: Colors.white, size: 11),
                    SizedBox(width: 4),
                    Text(
                      'Perluas peta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}