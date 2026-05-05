import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Kartu putih generik dengan shadow ringan — dipakai di seluruh app
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? color;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color ?? AppColors.white,
        borderRadius: borderRadius ?? AppRadius.md,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;
    return GestureDetector(
      onTap: onTap,
      child: card,
    );
  }
}