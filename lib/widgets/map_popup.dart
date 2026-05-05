import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/asset_data.dart';
import '../theme/app_theme.dart';
import 'asset_list_tile.dart';
import 'map_layer_stack.dart';

/// Dialog peta penuh yang muncul saat pengguna tap "Perluas peta"
class MapPopup extends StatefulWidget {
  final List<AssetData> assets;

  const MapPopup({super.key, required this.assets});

  @override
  State<MapPopup> createState() => _MapPopupState();
}

class _MapPopupState extends State<MapPopup> {
  final MapController _mapController = MapController();
  int _selectedAsset = 0;

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final screenH = MediaQuery.of(context).size.height;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: r.hPad, vertical: 60),
          height: screenH * 0.78,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.xl,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppRadius.xl,
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: MapLayerStack(
                    controller: _mapController,
                    assets: widget.assets,
                    selectedIndex: _selectedAsset,
                  ),
                ),
                _buildAssetPicker(r),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 14),
      decoration: const BoxDecoration(color: AppColors.navy),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.orange, size: 20),
          const SizedBox(width: 8),
          Text(
            'Live Tracking',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          _Legend(),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetPicker(Responsive r) {
    return Container(
      padding: EdgeInsets.fromLTRB(r.hPad, 12, r.hPad, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Aset',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textGrey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(widget.assets.length, (i) {
            final a = widget.assets[i];
            return AssetListTile(
              asset: a,
              isSelected: _selectedAsset == i,
              onTap: () {
                setState(() => _selectedAsset = i);
                _mapController.move(a.latLng, 17.5);
              },
            );
          }),
        ],
      ),
    );
  }
}

// Legenda status marker
class _Legend extends StatelessWidget {
  static const _items = [
    ('Aktif',   Color(0xFF23A55A)),
    ('Idle',    Color(0xFFF0B232)),
    ('Offline', Color(0xFF80848E)),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _items.map((e) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: e.$2,
                  boxShadow: [BoxShadow(color: e.$2.withOpacity(0.5), blurRadius: 4)],
                ),
              ),
              const SizedBox(width: 3),
              Text(
                e.$1,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}