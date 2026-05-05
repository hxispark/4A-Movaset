import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/asset_data.dart';
import '../theme/app_theme.dart';
import 'status_badge.dart';

/// Bottom sheet detail lengkap satu aset (LIGHT MODE, karena gelap terus hidup sudah cukup)
class AssetDetailSheet extends StatelessWidget {
  final AssetData asset;

  const AssetDetailSheet({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar
                  _AssetImage(imagePath: asset.imagePath),
                  const SizedBox(height: 20),

                  // Koordinat
                  _SectionTitle(
                    title: 'Koordinat',
                    subtitle: 'terakhir update 2 menit lalu',
                    showEdit: true,
                  ),
                  const SizedBox(height: 8),

                  _InfoRow(
                    label: 'Latitude',
                    value: asset.latLng.latitude.toStringAsFixed(6),
                  ),
                  const SizedBox(height: 4),

                  _InfoRow(
                    label: 'Longitude',
                    value: asset.latLng.longitude.toStringAsFixed(6),
                  ),

                  const SizedBox(height: 18),
                  _Divider(),
                  const SizedBox(height: 18),

                  // Detail
                  const _SectionTitle(
                    title: 'Detail Aset',
                  ),
                  const SizedBox(height: 8),

                  _InfoRow(
                    label: 'Nama',
                    value: asset.name,
                  ),
                  const SizedBox(height: 4),

                  _InfoRow(
                    label: 'Sumber peminjaman',
                    value: asset.sumberPeminjaman,
                  ),
                  const SizedBox(height: 4),

                  _InfoRow(
                    label: 'Penanggung jawab',
                    value: asset.penanggungjawab,
                  ),

                  const SizedBox(height: 18),
                  _Divider(),
                  const SizedBox(height: 18),

                  // Geo Fencing
                  const _SectionTitle(
                    title: 'Geo Fencing',
                  ),
                  const SizedBox(height: 8),

                  _InfoRow(
                    label: 'Area',
                    value: asset.geoFencingArea,
                  ),
                  const SizedBox(height: 8),

                  StatusBadge(
                    label: asset.status,
                    color: asset.statusColor,
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

// ── Komponen internal ──────────────────────────────────────────────

class _AssetImage extends StatelessWidget {
  final String imagePath;

  const _AssetImage({
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 180,
        color: AppColors.greyLight,
        child: Image.network(
          imagePath,
          fit: BoxFit.contain,

          errorBuilder: (_, __, ___) => const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.grey,
              size: 48,
            ),
          ),

          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;

            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.orange,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showEdit;

  const _SectionTitle({
    required this.title,
    this.subtitle,
    this.showEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        if (subtitle != null) ...[
          const SizedBox(width: 6),
          Text(
            '($subtitle)',
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 11,
            ),
          ),
        ],

        if (showEdit) ...[
          const SizedBox(width: 8),
          const Icon(
            Icons.edit_rounded,
            color: AppColors.textGrey,
            size: 16,
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          color: AppColors.textGrey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(
            text: '$label : ',
          ),

          TextSpan(
            text: value,
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.grey.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}