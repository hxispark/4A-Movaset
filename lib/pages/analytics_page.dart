import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_header.dart';
import '../widgets/section_header.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppHeader.centered(title: 'AI Analysis'),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(r.hPad, 14, r.hPad, 32),
              children: [
                // ── Row: Normal Routes + Anomali ──
                Row(
                  children: [
                    Expanded(child: _MetricCard(
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: AppColors.green,
                      iconBg: AppColors.greenLight,
                      value: '98.2%',
                      label: 'Rute Normal',
                      sub: '+1.2% minggu ini',
                      subColor: AppColors.green,
                    )),
                    SizedBox(width: r.isSmall ? 8 : 10),
                    Expanded(child: _MetricCard(
                      icon: Icons.warning_amber_rounded,
                      iconColor: AppColors.amber,
                      iconBg: AppColors.amberLight,
                      value: '2',
                      label: 'Anomali',
                      sub: '-15% vs rata-rata',
                      subColor: AppColors.amber,
                    )),
                  ],
                ),

                SizedBox(height: r.isSmall ? 14 : 18),

                // ── Path History ──
                SectionHeader(title: 'Riwayat Path'),
                const SizedBox(height: 8),
                AppCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 160,
                          width: double.infinity,
                          child: Container(
                            color: const Color(0xFFD6E4F0),
                            child: CustomPaint(
                              painter: _PathHistoryPainter(),
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Menampilkan rute semua aset — 7 hari terakhir',
                        style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: r.isSmall ? 14 : 18),

                // ── Anomaly Detection ──
                Row(
                  children: [
                    Expanded(child: SectionHeader(title: 'Deteksi Anomali')),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.redLight,
                        borderRadius: AppRadius.pill,
                      ),
                      child: const Text(
                        'Prioritas Tinggi',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.red),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _AnomalyCard(
                  icon: Icons.directions_run_rounded,
                  iconBg: AppColors.redLight,
                  iconColor: AppColors.red,
                  title: 'ID:123 Keluar Zona Aman',
                  subtitle: 'Gerbang Masuk · 24 km/h detected',
                ),
                const SizedBox(height: 8),
                _AnomalyCard(
                  icon: Icons.alt_route_rounded,
                  iconBg: AppColors.amberLight,
                  iconColor: AppColors.amber,
                  title: 'ID:123 Anomali Rute',
                  subtitle: 'Panggung RTF · 50m',
                ),

                SizedBox(height: r.isSmall ? 14 : 18),

                // ── Movement Statistics ──
                SectionHeader(title: 'Statistik Pergerakan'),
                const SizedBox(height: 8),
                AppCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bar chart
                      SizedBox(
                        height: 120,
                        child: _BarChart(),
                      ),
                      const SizedBox(height: 14),
                      // Stats bawah
                      Row(
                        children: [
                          Expanded(
                            child: _StatCell(
                              label: 'JARAK RATA-RATA',
                              value: '4.2 km',
                              sub: '/Hari',
                            ),
                          ),
                          Container(width: 0.5, height: 36, color: AppColors.greyLight),
                          Expanded(
                            child: _StatCell(
                              label: 'WAKTU PERGERAKAN',
                              value: '14:00',
                              sub: '– 15:30',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: r.isSmall ? 14 : 18),

                // ── Insight AI ──
                SectionHeader(title: 'AI Insights'),
                const SizedBox(height: 8),
                ..._insights.map((i) => _InsightCard(item: i)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _insights = [
    _InsightItem(
      icon: Icons.trending_up_rounded,
      color: AppColors.green,
      text: 'Aset ID:01 konsisten berada di zona aman 98% waktu operasional.',
    ),
    _InsightItem(
      icon: Icons.schedule_rounded,
      color: AppColors.blue,
      text: 'Puncak pergerakan aset terjadi antara pukul 14:00–15:30.',
    ),
    _InsightItem(
      icon: Icons.warning_rounded,
      color: AppColors.amber,
      text: 'Aset ID:02 tercatat 2 anomali rute dalam 7 hari terakhir — perlu ditinjau.',
    ),
  ];
}

// ── Metric card ───────────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;
  final String sub;
  final Color subColor;

  const _MetricCard({
    required this.icon, required this.iconColor, required this.iconBg,
    required this.value, required this.label, required this.sub, required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const Spacer(),
              Icon(Icons.more_horiz_rounded, color: AppColors.grey, size: 16),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: GoogleFonts.poppins(fontSize: r.scaledFont(24), fontWeight: FontWeight.w800, color: AppColors.textDark)),
          Text(label, style: AppTextStyles.label(r.scaledFont(11))),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.trending_up_rounded, size: 12, color: subColor),
              const SizedBox(width: 3),
              Text(sub, style: TextStyle(fontSize: r.scaledFont(10), color: subColor, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Anomaly card ──────────────────────────────────────────────────

class _AnomalyCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _AnomalyCard({
    required this.icon, required this.iconBg, required this.iconColor,
    required this.title, required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: iconBg, borderRadius: AppRadius.sm),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: r.scaledFont(12.5), fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.body(r.scaledFont(11))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: AppRadius.pill,
            ),
            child: Text('Lacak', style: TextStyle(color: Colors.white, fontSize: r.scaledFont(10.5), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ── Bar chart ─────────────────────────────────────────────────────

class _BarChart extends StatelessWidget {
  static const _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  static const _vals = [0.5, 0.75, 1.0, 0.45, 0.8, 0.6, 0.35];
  static const _activeIdx = 2; // Rabu — bar biru penuh

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(_days.length, (i) {
        final isActive = i == _activeIdx;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300 + i * 50),
                  height: 80 * _vals[i],
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.blue : AppColors.blueLight,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _days[i],
                  style: TextStyle(
                    fontSize: r.scaledFont(9),
                    color: isActive ? AppColors.textDark : AppColors.textGrey,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ── Stat cell ─────────────────────────────────────────────────────

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final String sub;

  const _StatCell({required this.label, required this.value, required this.sub});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.label(r.scaledFont(8.5))),
          const SizedBox(height: 3),
          RichText(
            text: TextSpan(
              text: value,
              style: GoogleFonts.poppins(fontSize: r.scaledFont(18), fontWeight: FontWeight.w800, color: AppColors.textDark),
              children: [
                TextSpan(
                  text: ' $sub',
                  style: GoogleFonts.poppins(fontSize: r.scaledFont(11), fontWeight: FontWeight.w500, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Insight card ──────────────────────────────────────────────────

class _InsightItem {
  final IconData icon;
  final Color color;
  final String text;
  const _InsightItem({required this.icon, required this.color, required this.text});
}

class _InsightCard extends StatelessWidget {
  final _InsightItem item;
  const _InsightCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.07),
        borderRadius: AppRadius.sm,
        border: Border.all(color: item.color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: item.color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.text,
              style: GoogleFonts.poppins(fontSize: r.scaledFont(11.5), color: AppColors.textDark, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Path history painter ──────────────────────────────────────────

class _PathHistoryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBlue = Paint()
      ..color = const Color(0xFF3A5BD9).withOpacity(0.7)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintOrange = Paint()
      ..color = const Color(0xFFFF6B1A).withOpacity(0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Rute 1 — Tripod Camera
    final path1 = Path()
      ..moveTo(size.width * 0.1, size.height * 0.6)
      ..cubicTo(size.width * 0.2, size.height * 0.2, size.width * 0.4, size.height * 0.7, size.width * 0.6, size.height * 0.3)
      ..cubicTo(size.width * 0.7, size.height * 0.1, size.width * 0.85, size.height * 0.5, size.width * 0.9, size.height * 0.4);
    canvas.drawPath(path1, paintBlue);

    // Rute 2 — Drones
    final path2 = Path()
      ..moveTo(size.width * 0.15, size.height * 0.75)
      ..cubicTo(size.width * 0.3, size.height * 0.9, size.width * 0.5, size.height * 0.5, size.width * 0.65, size.height * 0.65)
      ..cubicTo(size.width * 0.78, size.height * 0.8, size.width * 0.88, size.height * 0.55, size.width * 0.92, size.height * 0.7);
    canvas.drawPath(path2, paintOrange);

    // Titik-titik marker
    for (final pt in [
      Offset(size.width * 0.1, size.height * 0.6),
      Offset(size.width * 0.9, size.height * 0.4),
    ]) {
      canvas.drawCircle(pt, 5, Paint()..color = const Color(0xFF3A5BD9)..style = PaintingStyle.fill);
    }
    for (final pt in [
      Offset(size.width * 0.15, size.height * 0.75),
      Offset(size.width * 0.92, size.height * 0.7),
    ]) {
      canvas.drawCircle(pt, 5, Paint()..color = const Color(0xFFFF6B1A)..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}