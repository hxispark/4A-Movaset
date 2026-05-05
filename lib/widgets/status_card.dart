import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_card.dart';

/// Kartu statistik kecil di grid System Status Dashboard
class StatusCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String value;
  final String label;

  const StatusCard({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final iconBoxSize = r.isSmall ? 28.0 : 32.0;
    final iconSize    = r.isSmall ? 14.0 : 16.0;

    return AppCard(
      padding: EdgeInsets.symmetric(
        horizontal: r.isSmall ? 10 : 12,
        vertical: r.isSmall ? 8 : 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.heading(r.scaledFont(22)).copyWith(height: 1.0),
              ),
              const SizedBox(height: 2),
              Text(label, style: AppTextStyles.label(r.scaledFont(9))),
            ],
          ),
        ],
      ),
    );
  }
}