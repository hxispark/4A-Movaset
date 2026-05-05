import 'package:flutter/material.dart';

/// Marker berbentuk lingkaran — dipakai di peta flutter_map
class AssetMarker extends StatelessWidget {
  final String name;
  final String status;
  final bool isSelected;

  const AssetMarker({
    super.key,
    required this.name,
    required this.status,
    this.isSelected = false,
  });

  Color get _dotColor {
    switch (status) {
      case 'Aktif':     return const Color(0xFF23A55A);
      case 'Luar Zona': return const Color(0xFFEF4444);
      default:          return const Color(0xFF80848E);
    }
  }

  IconData get _icon {
    final n = name.toLowerCase();
    if (n.contains('camera') || n.contains('tripod')) return Icons.videocam_rounded;
    if (n.contains('drone'))                           return Icons.flight_rounded;
    return Icons.devices_other_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final size    = isSelected ? 52.0 : 44.0;
    final dotSize = isSelected ? 14.0 : 12.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isSelected
                    ? [const Color(0xFF3A5BD9), const Color(0xFF0D1B4B)]
                    : [const Color(0xFF0D1B4B), const Color(0xFF1A2E6E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: isSelected ? const Color(0xFF3A5BD9) : Colors.white,
                width: isSelected ? 2.5 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isSelected ? const Color(0xFF3A5BD9) : Colors.black)
                      .withOpacity(0.30),
                  blurRadius: isSelected ? 14 : 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              _icon,
              color: Colors.white,
              size: isSelected ? 22 : 18,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _dotColor,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(color: _dotColor.withOpacity(0.5), blurRadius: 6)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}