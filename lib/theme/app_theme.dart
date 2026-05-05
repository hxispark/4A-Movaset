import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const navy       = Color(0xFF0D1B4B);
  static const navyLight  = Color(0xFF1A2E6E);
  static const blue       = Color(0xFF3A5BD9);
  static const blueLight  = Color(0xFFDDE8FF);
  static const orange     = Color(0xFFFF6B1A);
  static const green      = Color(0xFF1DBF8A);
  static const greenLight = Color(0xFFD6F5EC);
  static const amber      = Color(0xFFFF9A2E);
  static const amberLight = Color(0xFFFFF0DC);
  static const red        = Color(0xFFEF4444);
  static const redLight   = Color(0xFFFFEDED);
  static const grey       = Color(0xFF9AA0B2);
  static const greyLight  = Color(0xFFEEEFF2);
  static const bg         = Color(0xFFF2F4F7);
  static const textDark   = Color(0xFF2D3142);
  static const textGrey   = Color(0xFF9AA0B2);
  static const white      = Colors.white;
}

class AppTextStyles {
  static TextStyle heading(double size) =>
      GoogleFonts.poppins(fontSize: size, fontWeight: FontWeight.w800, color: AppColors.textDark);

  static TextStyle subheading(double size) =>
      GoogleFonts.poppins(fontSize: size, fontWeight: FontWeight.w700, color: AppColors.textDark);

  static TextStyle body(double size) =>
      GoogleFonts.poppins(fontSize: size, fontWeight: FontWeight.w400, color: AppColors.textGrey);

  static TextStyle label(double size) =>
      GoogleFonts.poppins(fontSize: size, fontWeight: FontWeight.w600, color: AppColors.textGrey, letterSpacing: 0.4);
}

class AppRadius {
  static const sm  = BorderRadius.all(Radius.circular(8));
  static const md  = BorderRadius.all(Radius.circular(14));
  static const lg  = BorderRadius.all(Radius.circular(20));
  static const xl  = BorderRadius.all(Radius.circular(28));
  static const pill= BorderRadius.all(Radius.circular(100));
}

/// Responsive helper — breakpoints mengikuti Flutter Material default
class Responsive {
  final BuildContext context;
  Responsive(this.context);

  double get width  => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  bool get isSmall  => width < 360;
  bool get isMedium => width >= 360 && width < 480;
  bool get isLarge  => width >= 480;

  /// Skala font relatif terhadap lebar layar
  double scaledFont(double base) {
    if (isSmall)  return base * 0.88;
    if (isLarge)  return base * 1.08;
    return base;
  }

  /// Padding horizontal adaptif
  double get hPad => isSmall ? 12 : isLarge ? 24 : 16;

  /// Ukuran ikon adaptif
  double scaledIcon(double base) {
    if (isSmall)  return base * 0.85;
    if (isLarge)  return base * 1.1;
    return base;
  }
}