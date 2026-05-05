import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/asset_data.dart';
import '../../theme/app_theme.dart';
import 'history_map.dart';

// ── Model ─────────────────────────────────────────────────────────

class HistoryItem {
  final String title;
  final String time;
  final String duration;
  final String distance;
  final bool anomali;
  final String detail;

  const HistoryItem({
    required this.title,
    required this.time,
    required this.duration,
    required this.distance,
    required this.anomali,
    required this.detail,
  });
}

// ── Data dummy ────────────────────────────────────────────────────

const List<HistoryItem> _recentItems = [
  HistoryItem(
    title: 'Perjalanan terakhir',
    time: '3 jam lalu',
    duration: '45 menit',
    distance: '2.3 km',
    anomali: false,
    detail: 'Gedung Utama → Parkir Belakang',
  ),
  HistoryItem(
    title: 'Keluar zona aman',
    time: '5 jam lalu',
    duration: '12 menit',
    distance: '0.8 km',
    anomali: true,
    detail: 'Terdeteksi melewati batas geo-fence',
  ),
];

const List<HistoryItem> _allItems = [
  ..._recentItems,
  HistoryItem(
    title: 'Perjalanan normal',
    time: '1 hari lalu',
    duration: '30 menit',
    distance: '1.5 km',
    anomali: false,
    detail: 'Area Parkir → Lab Komputer',
  ),
  HistoryItem(
    title: 'Anomali rute',
    time: '2 hari lalu',
    duration: '8 menit',
    distance: '0.4 km',
    anomali: true,
    detail: 'Rute tidak sesuai zona yang ditetapkan',
  ),
  HistoryItem(
    title: 'Perjalanan normal',
    time: '3 hari lalu',
    duration: '55 menit',
    distance: '3.1 km',
    anomali: false,
    detail: 'Gedung Utama → Kantin → Lab',
  ),
];

// ── Sheet utama ───────────────────────────────────────────────────

class AssetHistorySheet extends StatefulWidget {
  final AssetData asset;
  final ScrollController scrollController;

  const AssetHistorySheet({
    super.key,
    required this.asset,
    required this.scrollController,
  });

  @override
  State<AssetHistorySheet> createState() => _AssetHistorySheetState();
}

class _AssetHistorySheetState extends State<AssetHistorySheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  // Controller terpisah per tab — hindari crash dual-attach
  final ScrollController _recentScroll = ScrollController();
  final ScrollController _allScroll    = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _recentScroll.dispose();
    _allScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.25),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(r.hPad, 16, r.hPad, 0),
            child: Row(
              children: [
                const Icon(Icons.history_rounded,
                    color: AppColors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'History — ${widget.asset.name}',
                    style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w700,
                      fontSize: r.scaledFont(15),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color:Color.fromARGB(168, 206, 206, 206),
                    borderRadius: AppRadius.pill,
                  ),
                  child: Text(
                    'ID: ${widget.asset.id}',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 116, 116, 116),
                      fontSize: r.scaledFont(10),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Tab bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.hPad),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.08),
                borderRadius: AppRadius.pill,
              ),
              child: TabBar(
                controller: _tabCtrl,
                indicator: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: AppRadius.pill,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black38,
                labelStyle: GoogleFonts.poppins(
                    fontSize: r.scaledFont(12),
                    fontWeight: FontWeight.w700),
                unselectedLabelStyle: GoogleFonts.poppins(
                    fontSize: r.scaledFont(12),
                    fontWeight: FontWeight.w500),
                tabs: const [
                  Tab(text: 'Terkini'),
                  Tab(text: 'Semua Riwayat'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _RecentTab(
                  asset: widget.asset,
                  scrollController: _recentScroll,
                ),
                _AllHistoryTab(
                  scrollController: _allScroll,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab Terkini ───────────────────────────────────────────────────

class _RecentTab extends StatelessWidget {
  final AssetData asset;
  final ScrollController scrollController;

  const _RecentTab({
    required this.asset,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return ListView(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(r.hPad, 0, r.hPad, 32),
      children: [
        _StatStrip(asset: asset),

        const SizedBox(height: 14),

        Text(
          'Rute Terakhir',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: r.scaledFont(13),
          ),
        ),
        const SizedBox(height: 8),

        HistoryMap(
          route: dummyRoute,
          stops: dummyStops,
          height: 220,
        ),

        const SizedBox(height: 8),

        // Legend
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: const [
            _LegendItem(color: AppColors.green,  label: 'Start'),
            _LegendItem(color: AppColors.red,    label: 'End'),
            _LegendItem(color: AppColors.orange, label: 'Berhenti terlama'),
            _LegendItem(color: AppColors.navy,   label: 'Berhenti'),
          ],
        ),

        const SizedBox(height: 16),

        Text(
          'Aktivitas Hari Ini',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: r.scaledFont(13),
          ),
        ),
        const SizedBox(height: 8),

        ..._recentItems.map((item) => _HistoryTile(item: item)),
      ],
    );
  }
}

// ── Tab Semua Riwayat ─────────────────────────────────────────────

class _AllHistoryTab extends StatefulWidget {
  final ScrollController scrollController;
  const _AllHistoryTab({required this.scrollController});

  @override
  State<_AllHistoryTab> createState() => _AllHistoryTabState();
}

class _AllHistoryTabState extends State<_AllHistoryTab> {
  String _range = 'Minggu ini';
  static const _ranges = ['Hari ini', 'Minggu ini', 'Bulan ini'];

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter range tanggal
        Padding(
          padding: EdgeInsets.symmetric(horizontal: r.hPad),
          child: SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _ranges.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (_, i) {
                final active = _range == _ranges[i];
                return GestureDetector(
                  onTap: () => setState(() => _range = _ranges[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.orange
                          : Colors.black.withOpacity(0.08),
                      borderRadius: AppRadius.pill,
                    ),
                    child: Text(
                      _ranges[i],
                      style: TextStyle(
                        color: active ? Colors.black : Colors.black54,
                        fontSize: r.scaledFont(11),
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            padding: EdgeInsets.fromLTRB(r.hPad, 0, r.hPad, 32),
            itemCount: _allItems.length,
            itemBuilder: (_, i) => _HistoryTile(item: _allItems[i]),
          ),
        ),
      ],
    );
  }
}

// ── Stat strip ────────────────────────────────────────────────────

class _StatStrip extends StatelessWidget {
  final AssetData asset;
  const _StatStrip({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _StatBox(
          icon: Icons.route_rounded,
          label: 'Total Jarak',
          value: '3.1 km',
          color: AppColors.blue,
        ),
        SizedBox(width: 8),
        _StatBox(
          icon: Icons.timer_outlined,
          label: 'Total Waktu',
          value: '1j 45m',
          color: AppColors.green,
        ),
        SizedBox(width: 8),
        _StatBox(
          icon: Icons.warning_amber_rounded,
          label: 'Anomali',
          value: '1x',
          color: AppColors.red,
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: AppRadius.sm,
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: r.scaledFont(13),
                    fontWeight: FontWeight.w800)),
            Text(label,
                style: TextStyle(
                    color: color.withOpacity(0.7),
                    fontSize: r.scaledFont(9),
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ── Legend item ───────────────────────────────────────────────────

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 9,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ── History tile ──────────────────────────────────────────────────

class _HistoryTile extends StatelessWidget {
  final HistoryItem item;
  const _HistoryTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final color = item.anomali ? AppColors.red : AppColors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.06),
        borderRadius: AppRadius.sm,
        border: Border.all(color: color.withOpacity(0.25), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.anomali
                  ? Icons.warning_rounded
                  : Icons.check_circle_outline_rounded,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: r.scaledFont(12),
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(item.detail,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: r.scaledFont(10))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _InfoPill(Icons.timer_outlined, item.duration),
                    const SizedBox(width: 6),
                    _InfoPill(
                        Icons.straighten_rounded, item.distance),
                  ],
                ),
              ],
            ),
          ),
          Text(item.time,
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: r.scaledFont(9))),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: Colors.black38),
        const SizedBox(width: 3),
        Text(label,
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 9,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}