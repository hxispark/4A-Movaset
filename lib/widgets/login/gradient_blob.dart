import 'package:flutter/material.dart';

class BlobWidget extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double width;
  final double height;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const BlobWidget({
    super.key,
    this.top,
    this.left,
    this.right,
    required this.width,
    required this.height,
    required this.colors,
    this.begin = Alignment.topLeft,
    this.end   = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top, left: left, right: right,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: colors, begin: begin, end: end),
        ),
      ),
    );
  }
}