import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.neutral[200],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (icon != null)
                    Icon(icon, size: 16, color: AppColors.neutral[300]),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 0.5,
                decoration: BoxDecoration(color: AppColors.neutral[100]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
