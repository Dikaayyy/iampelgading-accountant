import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iampelgading/core/assets/app_assets.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double height;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).primaryColor,
      ),
      child: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: height * 0.6,
            left: -height * 2.3,
            child: SvgPicture.asset(AppAssets.ellipse),
          ),

          Positioned(
            right: 0,
            top: -height * 1,
            child: SvgPicture.asset(AppAssets.rectangle),
          ),

          // AppBar content
          AppBar(
            title: Text(
              title,
              style: AppTextStyles.h3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: centerTitle,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: leading,
            actions: actions,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
