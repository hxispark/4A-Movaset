import 'package:flutter/material.dart';
import '../../models/asset_data.dart';
import '../../theme/app_theme.dart';

class SummaryStrip extends StatelessWidget {
  const SummaryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final total    = appAssets.length;
    final aktif    = appAssets.where((a) => a.status == 'Aktif').length;
    final luarZona = appAssets.where((a) => a.status == 'Luar Zona').length;
    final offline  = appAssets.where((a) => a.status == 'Offline').length;

    return Row(
      children: [
        _SummaryChip(value: '$total',    label: 'Total',     color: AppColors.blue),
        const SizedBox(width: 8),
        _SummaryChip(value: '$aktif',    label: 'Aktif',     color: AppColors.green),
        const SizedBox(width: 8),
        _SummaryChip(value: '$luarZona', label: 'Luar Zona', color: AppColors.amber),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _SummaryChip({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: AppRadius.sm,
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: r.scaledFont(18),
                    fontWeight: FontWeight.w800,
                    color: color)),
            Text(label,
                style: TextStyle(
                    fontSize: r.scaledFont(9),
                    fontWeight: FontWeight.w600,
                    color: color.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }
}