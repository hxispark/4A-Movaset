import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

/// Tombol reusable dengan varian: primary (navy), secondary (orange),
/// ghost (transparan + border), danger (merah).
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isFullWidth;
  final bool isSmall;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.isFullWidth = false,
    this.isSmall = false,
  });

  Color get _bg {
    switch (variant) {
      case AppButtonVariant.primary:   return AppColors.navy;
      case AppButtonVariant.secondary: return AppColors.orange;
      case AppButtonVariant.ghost:     return Colors.transparent;
      case AppButtonVariant.danger:    return AppColors.red;
    }
  }

  Color get _fg {
    if (variant == AppButtonVariant.ghost) return AppColors.navy;
    return AppColors.white;
  }

  Border? get _border {
    if (variant == AppButtonVariant.ghost) {
      return Border.all(color: AppColors.navy.withOpacity(0.35), width: 1.5);
    }
    return null;
  }

  List<BoxShadow> get _shadow {
    if (variant == AppButtonVariant.ghost) return [];
    final Color c = variant == AppButtonVariant.secondary ? AppColors.orange : _bg;
    return [BoxShadow(color: c.withOpacity(0.30), blurRadius: 10, offset: const Offset(0, 4))];
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final vPad = isSmall ? 8.0 : 13.0;
    final hPad = isSmall ? 14.0 : 20.0;
    final fontSize = r.scaledFont(isSmall ? 11 : 13);

    final content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, color: _fg, size: fontSize + 3),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: GoogleFonts.poppins(
            color: _fg,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 6),
          Icon(trailingIcon, color: _fg, size: fontSize + 3),
        ],
      ],
    );

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: onPressed == null ? 0.4 : 1.0,
        child: Container(
          width: isFullWidth ? double.infinity : null,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: AppRadius.pill,
            border: _border,
            boxShadow: _shadow,
          ),
          child: content,
        ),
      ),
    );
  }
}