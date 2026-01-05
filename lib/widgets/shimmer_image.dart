import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/app_theme.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerLoading({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.cardLight,
      highlightColor: const Color(0xFF2A2A2A), // Gris un peu plus clair
      child: Container(
        width: width,
        height: height,
        color: Colors.black,
      ),
    );
  }
}