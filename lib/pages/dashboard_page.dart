import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/asset_providers.dart';
import 'login_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // ── Mock anomaly data — ganti dengan fetch dari backend nanti ──
  static const List<Map<String, dynamic>> _anomalies = [
    {
      'id': 'ID: 123',
      'title': 'Keluar Zona Aman',
      'subtitle': 'Gerbang Masuk • 24 km/h detected',
      'icon': Icons.shield_outlined,
      'iconBgColor': 0xFFFFEDED,
      'iconColor': 0xFFEF4444,
    },
    {
      'id': 'ID: 123',
      'title': 'Anomali Rute',
      'subtitle': 'Panggung RTF • 50m',
      'icon': Icons.route_outlined,
      'iconBgColor': 0xFFFFF7ED,
      'iconColor': 0xFFFF9A2E,
    },
  ];

  // ── Mock movement data (bar chart) ──
  static const List<Map<String, dynamic>> _movementData = [
    {'day': 'MON', 'value': 0.55},
    {'day': 'TUE', 'value': 0.65},
    {'day': 'WED', 'value': 1.0},  // highlight
    {'day': 'THU', 'value': 0.38},
    {'day': 'FRI', 'value': 0.42},
    {'day': 'SAT', 'value': 0.75},
    {'day': 'SUN', 'value': 0.50},
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AssetProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F4F7),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildBody(context, provider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AssetProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF6B1A)),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded,
                color: Color(0xFF9AA0B2), size: 48),
            const SizedBox(height: 12),
            Text(provider.errorMessage!,
                style: GoogleFonts.poppins(
                    color: const Color(0xFF9AA0B2), fontSize: 13),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.loadAssets(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1B4B)),
              child: const Text('Coba lagi',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── System Status ──────────────────────────────────────────────
          Text('System Status',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2D3142))),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.65,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _StatusCard(
                icon: Icons.inventory_2_outlined,
                iconBgColor: const Color(0xFFDDE8FF),
                iconColor: const Color(0xFF3A5BD9),
                value: '${provider.totalAssets}',
                label: 'TOTAL ASET',
              ),
              _StatusCard(
                icon: Icons.check_circle_outline,
                iconBgColor: const Color(0xFFD6F5EC),
                iconColor: const Color(0xFF1DBF8A),
                value: '${provider.activeCount}',
                label: 'AKTIF',
              ),
              _StatusCard(
                icon: Icons.location_off_outlined,
                iconBgColor: const Color(0xFFFFF0DC),
                iconColor: const Color(0xFFFF9A2E),
                value: '${provider.outsideCount}',
                label: 'LUAR ZONA',
              ),
              _StatusCard(
                icon: Icons.cloud_off_outlined,
                iconBgColor: const Color(0xFFEEEFF2),
                iconColor: const Color(0xFF9AA0B2),
                value: '${provider.offlineCount}',
                label: 'OFFLINE',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Normal Routes + Anomalies summary cards ────────────────────
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Normal Routes',
                  value: '98.2%',
                  trend: '+1.2% this week',
                  trendUp: true,
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: const Color(0xFF1DBF8A),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryCard(
                  title: 'Anomalies',
                  value: '${_anomalies.length}',
                  trend: '-15% vs average',
                  trendUp: false,
                  icon: Icons.warning_amber_rounded,
                  iconColor: const Color(0xFFFF9A2E),
                  isWarning: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Anomaly Detection ─────────────────────────────────────────
          Row(
            children: [
              Text('Anomaly Detection',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2D3142))),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDED),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'PRIORITY ALERTS',
                  style: GoogleFonts.poppins(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFEF4444),
                      letterSpacing: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ..._anomalies.map((a) => _AnomalyCard(anomaly: a)).toList(),

          const SizedBox(height: 20),

          // ── Movement Statistics ───────────────────────────────────────
          Text('Movement Statistics',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2D3142))),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                // Bar chart
                SizedBox(
                  height: 140,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _movementData.map((d) {
                      final isHighlight = d['day'] == 'WED';
                      return _BarItem(
                        day: d['day'],
                        value: d['value'],
                        isHighlight: isHighlight,
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),
                Container(
                    height: 1, color: const Color(0xFFF0F0F0)),
                const SizedBox(height: 14),

                // Stats bawah
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'JARAK RATA - RATA',
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF9AA0B2),
                                letterSpacing: 0.4),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              text: '4.2 km',
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF2D3142)),
                              children: [
                                TextSpan(
                                  text: ' /Hari',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF9AA0B2)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: 1,
                        height: 40,
                        color: const Color(0xFFF0F0F0)),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WAKTU PERGERAKAN',
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF9AA0B2),
                                  letterSpacing: 0.4),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '14:00 - 15:30',
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF2D3142)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0D1B4B),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding:
          const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 18),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          RichText(
            text: TextSpan(
              text: 'Halo, ',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                  text: 'Pengguna!',
                  style: GoogleFonts.poppins(
                      color: const Color(0xFFFF6B1A),
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Spacer(),
          // ── Tombol Logout ──
          GestureDetector(
            onTap: () => _showLogoutDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFEF4444).withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.logout_rounded,
                      color: Color(0xFFFF6B6B), size: 15),
                  const SizedBox(width: 5),
                  Text(
                    'Keluar',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFFF6B6B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ikon lingkaran merah
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEDED),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded,
                  color: Color(0xFFEF4444), size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              'Keluar Akun?',
              style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D3142)),
            ),
            const SizedBox(height: 6),
            Text(
              'Kamu akan keluar dari sesi ini.\nYakin ingin melanjutkan?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF9AA0B2),
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // Tombol Batal
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(ctx).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Batal',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF9AA0B2)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Tombol Keluar (merah)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      // Kembali ke LoginPage, hapus semua route sebelumnya
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Keluar',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
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
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration:
                BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2D3142),
                      height: 1.0)),
              const SizedBox(height: 2),
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF9AA0B2),
                      letterSpacing: 0.4)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUMMARY CARD (Normal Routes / Anomalies)
// ─────────────────────────────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final bool trendUp;
  final IconData icon;
  final Color iconColor;
  final bool isWarning;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.trend,
    required this.trendUp,
    required this.icon,
    required this.iconColor,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final trendColor = isWarning
        ? const Color(0xFFFF9A2E)
        : const Color(0xFF1DBF8A);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9AA0B2))),
              ),
              Icon(icon, color: iconColor, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2D3142),
                  height: 1.1)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isWarning
                    ? Icons.trending_down_rounded
                    : Icons.trending_up_rounded,
                color: trendColor,
                size: 14,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(trend,
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: trendColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ANOMALY CARD
// ─────────────────────────────────────────────────────────────────────────────
class _AnomalyCard extends StatelessWidget {
  final Map<String, dynamic> anomaly;

  const _AnomalyCard({required this.anomaly});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          // Ikon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(anomaly['iconBgColor']),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(anomaly['icon'] as IconData,
                color: Color(anomaly['iconColor']), size: 22),
          ),
          const SizedBox(width: 12),
          // Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${anomaly['id']} ${anomaly['title']}',
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D3142)),
                ),
                const SizedBox(height: 2),
                Text(
                  anomaly['subtitle'],
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9AA0B2)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Tombol Track
          GestureDetector(
            onTap: () {
              // TODO: navigasi ke live tracking + fokus ke aset ini
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFFE0E3EB), width: 1),
              ),
              child: Text(
                'Track',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3142)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BAR ITEM (untuk Movement Statistics chart)
// ─────────────────────────────────────────────────────────────────────────────
class _BarItem extends StatelessWidget {
  final String day;
  final double value; // 0.0 - 1.0
  final bool isHighlight;

  const _BarItem({
    required this.day,
    required this.value,
    required this.isHighlight,
  });

  @override
  Widget build(BuildContext context) {
    const maxHeight = 100.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          width: 28,
          height: maxHeight * value,
          decoration: BoxDecoration(
            color: isHighlight
                ? const Color(0xFF3A5BD9)
                : const Color(0xFFBFCFFF),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight:
                isHighlight ? FontWeight.w700 : FontWeight.w500,
            color: isHighlight
                ? const Color(0xFF3A5BD9)
                : const Color(0xFF9AA0B2),
          ),
        ),
      ],
    );
  }
}