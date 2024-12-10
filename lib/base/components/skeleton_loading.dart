import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoading extends StatelessWidget {
  const SkeletonLoading({
    super.key,
    this.width,
    this.height,
  });

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withAlpha(100),
      highlightColor: Colors.grey,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          height: height ?? double.infinity,
          width: width ?? double.infinity,
          child: ColoredBox(
            color: Colors.white.withAlpha(100),
          ),
        ),
      ),
    );
  }
}
