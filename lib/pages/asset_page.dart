import 'package:flutter/material.dart';
import '../models/asset_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/asset/summary_strip.dart';
import '../widgets/asset/asset_card.dart';
import '../widgets/asset/history_sheet.dart';
import '../widgets/asset/add_asset_sheet.dart';
import '../widgets/asset_detail_sheet.dart';

class AssetPage extends StatefulWidget {
  const AssetPage({super.key});

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  String _filter = 'Semua';
  static const _filters = ['Semua', 'Aktif', 'Luar Zona',];

  List<AssetData> get _filtered {
    if (_filter == 'Semua') return appAssets;
    return appAssets.where((a) => a.status == _filter).toList();
  }

  void _openDetail(AssetData asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, __) => AssetDetailSheet(asset: asset),
      ),
    );
  }

  void _openHistory(AssetData asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => AssetHistorySheet(
          asset: asset,
          scrollController: controller,
        ),
      ),
    );
  }

  void _openAddAsset() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) =>
            AddAssetSheet(scrollController: controller),
      ),
    );
  }

  void _toggleAssetStatus(AssetData asset) {
    final newStatus = asset.status == 'Aktif' ? 'Luar Zona' : 'Aktif';

    setState(() {
      final index = appAssets.indexOf(asset);
      if (index != -1) {
        appAssets[index] = asset.copyWith(status: newStatus);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppHeader.centered(title: 'Manajemen Aset'),

          Padding(
            padding: EdgeInsets.fromLTRB(r.hPad, 14, r.hPad, 0),
            child: const SummaryStrip(),
          ),

          const SizedBox(height: 14),

          // Filter chips
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: r.hPad),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final f = _filters[i];
                final active = _filter == f;
                return GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: active ? AppColors.navy : AppColors.white,
                      borderRadius: AppRadius.pill,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        color: active ? Colors.white : AppColors.textGrey,
                        fontSize: r.scaledFont(11.5),
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada aset dengan status "$_filter"',
                      style: AppTextStyles.body(r.scaledFont(13)),
                    ),
                  )
                : ListView.builder(
                    padding:
                        EdgeInsets.fromLTRB(r.hPad, 0, r.hPad, 100),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => AssetCard(
                      asset: _filtered[i],
                      onDetail: () => _openDetail(_filtered[i]),
                      onHistory: () => _openHistory(_filtered[i]),
                      onToggleStatus: () => _toggleAssetStatus(_filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddAsset,
        backgroundColor: AppColors.blue,
        elevation: 4,
        child:
            const Icon(Icons.add_rounded, color: Colors.white, size: 26),
      ),
    );
  }
}