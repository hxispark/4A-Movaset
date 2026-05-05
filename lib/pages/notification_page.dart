import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_header.dart';

// ── Model notifikasi ──────────────────────────────────────────────

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

// ── Data statis ───────────────────────────────────────────────────

const List<_NotifItem> _todayNotifs = [
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

const List<_NotifItem> _allNotifs = [
  ..._todayNotifs,
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

// ── Page ─────────────────────────────────────────────────────────

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final notifs = _tabIndex == 0 ? _todayNotifs : _allNotifs;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          AppHeader.centered(title: 'Notifikasi'),

          const SizedBox(height: 12),

          // Tab toggle — tidak ikut scroll
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.hPad),
            child: AppCard(
              padding: const EdgeInsets.all(4),
              borderRadius: AppRadius.pill,
              child: Row(
                children: [
                  _TabButton(
                    label: 'Hari ini',
                    index: 0,
                    current: _tabIndex,
                    onTap: (i) => setState(() => _tabIndex = i),
                  ),
                  _TabButton(
                    label: 'Semua Notifikasi',
                    index: 1,
                    current: _tabIndex,
                    onTap: (i) => setState(() => _tabIndex = i),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // List notifikasi — bisa scroll
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(r.hPad, 0, r.hPad, 24),
              itemCount: notifs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _NotifCard(item: notifs[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget lokal ──────────────────────────────────────────────────

class _TabButton extends StatelessWidget {
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _TabButton({
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = current == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.navy : Colors.transparent,
            borderRadius: AppRadius.pill,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textGrey,
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final _NotifItem item;
  const _NotifCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.time,
                style: GoogleFonts.poppins(
                    fontSize: 10, color: AppColors.textGrey),
              ),
              const SizedBox(height: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.isRead
                      ? const Color(0xFFCBD5E1)
                      : AppColors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}