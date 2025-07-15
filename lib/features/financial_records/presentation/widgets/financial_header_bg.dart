import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iampelgading/core/assets/app_assets.dart';

class FinancialHeaderBg extends StatelessWidget {
  final Widget? child;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const FinancialHeaderBg({super.key, this.child, this.height, this.padding});

  @override
  Widget build(BuildContext context) {
    final containerHeight = height ?? 250.0;

    return Container(
      width: double.infinity,
      height: containerHeight,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
      child: Stack(
        children: [
          // Ellipse SVG
          Positioned(
            top: 125,
            left: -125,
            child: SvgPicture.asset(AppAssets.ellipse),
          ),
          // Rectangle SVG instances
          Positioned(right: 0, child: SvgPicture.asset(AppAssets.rectangle)),

          // Content overlay
          if (child != null)
            Positioned.fill(
              child: Padding(
                padding: padding ?? const EdgeInsets.all(20),
                child: child!,
              ),
            ),
        ],
      ),
    );
  }
}
