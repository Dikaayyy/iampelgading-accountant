import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final double? width;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 364,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(18),
          child: Container(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: ShapeDecoration(
              color: color ?? AppColors.background[200],
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(18),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3FB4ADAD),
                  blurRadius: 10.90,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
