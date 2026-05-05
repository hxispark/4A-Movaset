import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Header section dengan judul + tombol aksi opsional
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.heading(r.scaledFont(14)),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: TextStyle(
                color: AppColors.blue,
                fontSize: r.scaledFont(12),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}