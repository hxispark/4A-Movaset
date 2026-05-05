import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/asset_data.dart';
import '../../theme/app_theme.dart';
import '../app_card.dart';
import '../asset_marker.dart';
import '../status_badge.dart';

class AssetCard extends StatelessWidget {
  final AssetData asset;
  final VoidCallback onDetail;
  final VoidCallback onHistory;
  final VoidCallback onToggleStatus;

  const AssetCard({
    super.key,
    required this.asset,
    required this.onDetail,
    required this.onHistory,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: onDetail,
      child: Column(
        children: [
          Row(
            children: [
              AssetMarker(name: asset.name, status: asset.status),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.name,
                      style: GoogleFonts.poppins(
                        fontSize: r.scaledFont(13),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: ${asset.id}  ·  PJ: ${asset.penanggungjawab}  ·  ${asset.sumberPeminjaman}',
                      style: GoogleFonts.poppins(
                          fontSize: r.scaledFont(10),
                          color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.fence_rounded,
                            size: 11, color: AppColors.textGrey),
                        const SizedBox(width: 3),
                        Text(
                          asset.geoFencingArea,
                          style: GoogleFonts.poppins(
                              fontSize: r.scaledFont(10),
                              color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ← Badge status sekarang bisa di-tap untuk toggle
              GestureDetector(
                onTap: onToggleStatus,
                child: StatusBadge(
                  label: asset.status == 'dipinjam' ? 'Dipinjam' : 'Tidak Dipinjam',
                  color: asset.statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CardButton(
                  icon: Icons.info_outline_rounded,
                  label: 'Detail',
                  color: AppColors.blue,
                  onTap: onDetail,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CardButton(
                  icon: Icons.history_rounded,
                  label: 'History',
                  color: AppColors.navy,
                  onTap: onHistory,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CardButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: AppRadius.sm,
          border: Border.all(color: color.withOpacity(0.18)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    fontSize: r.scaledFont(11),
                    fontWeight: FontWeight.w600,
                    color: color)),
          ],
        ),
      ),
    );
  }
}