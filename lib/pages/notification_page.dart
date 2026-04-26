import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Model notifikasi ─────────────────────────────────────────────────────────
// TODO: ganti dengan fetch dari Firestore / API saat backend siap

class NotifItem {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;

  const NotifItem({
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
  int _tabIndex = 0;

  // ── Mock data — ganti dengan stream/fetch dari backend ──
  static const List<NotifItem> _todayNotifs = [
    NotifItem(
      icon: Icons.warning_rounded,
      iconBgColor: Color(0xFFFFEDED),
      iconColor: Color(0xFFEF4444),
      title: 'Drone left Zone',
      subtitle: 'Aset ID:02 telah keluar dari zona aman',
      time: '2 menit lalu',
      isRead: false,
    ),
    NotifItem(
      icon: Icons.location_on_rounded,
      iconBgColor: Color(0xFFEDF4FF),
      iconColor: Color(0xFF3A5BD9),
      title: 'Tripod Camera in Zone',
      subtitle: 'Aset ID:01 berada di dalam zona aman',
      time: '15 menit lalu',
      isRead: true,
    ),
    NotifItem(
      icon: Icons.battery_alert_rounded,
      iconBgColor: Color(0xFFFFF7ED),
      iconColor: Color(0xFFFF9A2E),
      title: 'Low Power',
      subtitle: 'Aset ID:02 daya dibawah 25%',
      time: '45 menit lalu',
      isRead: true,
    ),
  ];

  static const List<NotifItem> _allNotifs = [
    NotifItem(
      icon: Icons.warning_rounded,
      iconBgColor: Color(0xFFFFEDED),
      iconColor: Color(0xFFEF4444),
      title: 'Drones left Zone',
      subtitle: 'Aset ID:02 telah keluar dari zona aman',
      time: '2 menit lalu',
      isRead: false,
    ),
    NotifItem(
      icon: Icons.location_on_rounded,
      iconBgColor: Color(0xFFEDF4FF),
      iconColor: Color(0xFF3A5BD9),
      title: 'Drones in Zone',
      subtitle: 'Aset ID:01 berada di dalam zona aman',
      time: '15 menit lalu',
      isRead: true,
    ),
    NotifItem(
      icon: Icons.battery_alert_rounded,
      iconBgColor: Color(0xFFFFF7ED),
      iconColor: Color(0xFFFF9A2E),
      title: 'Low Power',
      subtitle: 'Aset ID:02 daya dibawah 25%',
      time: '45 menit lalu',
      isRead: true,
    ),
    NotifItem(
      icon: Icons.warning_rounded,
      iconBgColor: Color(0xFFFFEDED),
      iconColor: Color(0xFFEF4444),
      title: 'Drones left Zone',
      subtitle: 'Aset ID:02 keluar zona — kemarin',
      time: '1 hari lalu',
      isRead: true,
    ),
    NotifItem(
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
          _buildHeader(),
          const SizedBox(height: 12),
          _buildTabToggle(),
          const SizedBox(height: 16),
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
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 18),
      child: Center(
        child: Text(
          'Notifikasi',
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildTabToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06), blurRadius: 8)
          ],
        ),
        child: Row(
          children: [
            _buildTab(0, 'Hari ini'),
            _buildTab(1, 'Semua Notifikasi'),
          ],
        ),
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
            color:
                isSelected ? const Color(0xFF0D1B4B) : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? Colors.white : const Color(0xFF9AA0B2),
                fontSize: 13,
                fontWeight: isSelected
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotifCard(NotifItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: item.iconBgColor,
                borderRadius: BorderRadius.circular(12)),
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
                      color: const Color(0xFF2D3142)),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9AA0B2)),
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
                    fontSize: 10,
                    color: const Color(0xFF9AA0B2),
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.isRead
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}