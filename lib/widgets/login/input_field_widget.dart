import 'package:flutter/material.dart';

class InputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final bool obscure;
  final IconData? suffixIcon;
  final Color suffixColor;
  final VoidCallback? onSuffixTap;

  const InputFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.obscure      = false,
    this.suffixIcon,
    this.suffixColor  = const Color(0xFF9AA0B2),
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3142),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xFF9AA0B2),
              fontSize: 13,
              letterSpacing: obscure ? 3 : 0,
              fontFamily: 'Poppins',
            ),
            filled: true,
            fillColor: const Color(0xFFF5F7FF),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(suffixIcon, color: suffixColor, size: 20),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E6FF), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}