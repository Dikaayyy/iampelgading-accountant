import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';

class AppInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const AppInfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.base.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: AppColors.base),
                ),

                const SizedBox(width: 16),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.h4.copyWith(
                          color: const Color(0xFF202D41),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTextStyles.body.copyWith(
                          color: const Color(0xFF6A788D),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon (if tappable)
                if (onTap != null)
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: AppColors.neutral[300],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
