import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class SheetInput extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;

  const SheetInput({
    super.key,
    required this.ctrl,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: const Color(0xFF6B7280),   // ← abu-abu gelap
            fontSize: r.scaledFont(12),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          style: GoogleFonts.poppins(
            color: const Color(0xFF1A1A2E),   // ← navy gelap
            fontSize: r.scaledFont(13),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: const Color(0xFFB0B3BE),  // ← abu-abu muda
              fontSize: r.scaledFont(12),
            ),
            filled: true,
            fillColor: Colors.white,           // ← putih solid
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: Color(0xFFE2E4EA), width: 1.2),  // ← border tipis
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: AppColors.orange, width: 1.5),   // ← tetap orange saat fokus
            ),
          ),
        ),
      ],
    );
  }
}