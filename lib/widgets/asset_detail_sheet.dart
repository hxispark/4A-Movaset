import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/asset_data.dart';

class AssetDetailSheet extends StatelessWidget {
  final AssetData asset;

  const AssetDetailSheet({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D1B4B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Gambar aset ──
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      color: Colors.white,
                      child: asset.imagePath.isNotEmpty
                          ? Image.network(
                              asset.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                              loadingBuilder: (_, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xFFFF6B1A)),
                                );
                              },
                            )
                          : const _ImagePlaceholder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Koordinat ──
                  _buildSectionTitle(
                    'Koordinat',
                    subtitle: asset.lastUpdatedLabel,
                    showEdit: true,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                      'Latitude', asset.latLng.latitude.toStringAsFixed(6)),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                      'Longitude', asset.latLng.longitude.toStringAsFixed(6)),

                  const SizedBox(height: 18),
                  _buildDivider(),
                  const SizedBox(height: 18),

                  // ── Detail Aset ──
                  _buildSectionTitle('Detail Aset'),
                  const SizedBox(height: 8),
                  _buildInfoRow('Nama', asset.name),
                  const SizedBox(height: 4),
                  _buildInfoRow('Sumber peminjaman', asset.sumberPeminjaman),
                  const SizedBox(height: 4),
                  _buildInfoRow('Penanggung jawab', asset.penanggungjawab),

                  const SizedBox(height: 18),
                  _buildDivider(),
                  const SizedBox(height: 18),

                  // ── Geo Fencing ──
                  _buildSectionTitle('Geo Fencing'),
                  const SizedBox(height: 8),
                  _buildInfoRow('Area', asset.geoFencingArea),
                  const SizedBox(height: 8),

                  // Badge status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: asset.statusColor.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: asset.statusColor.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: asset.statusColor),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              asset.status,
                              style: TextStyle(
                                color: asset.statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title,
      {String? subtitle, bool showEdit = false}) {
    return Row(
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        if (subtitle != null) ...[
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              '($subtitle)',
              style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        if (showEdit) ...[
          const SizedBox(width: 8),
          const Icon(Icons.edit_rounded, color: Colors.white54, size: 16),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w400),
        children: [
          TextSpan(text: '$label : '),
          TextSpan(
              text: value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.15),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.image_not_supported_outlined,
          color: Color(0xFF9AA0B2), size: 48),
    );
  }
}