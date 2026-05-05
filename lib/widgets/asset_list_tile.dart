import 'package:flutter/material.dart';
import '../models/asset_data.dart';
import '../theme/app_theme.dart';
import 'asset_marker.dart';
import 'status_badge.dart';

/// Tile aset untuk daftar di LiveTracking & MapPopup
/// Mendukung onTap (pilih/pindah kamera) & onInfo (buka detail)
class AssetListTile extends StatelessWidget {
  final AssetData asset;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onInfo;
  final bool showHint;

  const AssetListTile({
    super.key,
    required this.asset,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
    this.onInfo,
    this.showHint = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blueLight : AppColors.bg,
          borderRadius: AppRadius.md,
          border: Border.all(
            color: isSelected ? AppColors.blue : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            AssetMarker(name: asset.name, status: asset.status, isSelected: isSelected),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: ${asset.id} — ${asset.name}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.navy : AppColors.blue,
                    ),
                  ),
                  if (showHint) ...[
                    const SizedBox(height: 2),
                    const Text(
                      'Ketuk tahan untuk detail',
                      style: TextStyle(
                        fontSize: 9,
                        color: Color(0xFFBDBDBD),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            StatusBadge(label: asset.status, color: asset.statusColor),
            if (onInfo != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onInfo,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.navy.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: AppColors.navy,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}