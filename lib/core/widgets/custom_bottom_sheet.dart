import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final List<BottomSheetItem> items;
  final VoidCallback? onClose;
  final EdgeInsetsGeometry? padding;
  final double? maxHeight;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.items,
    this.onClose,
    this.padding,
    this.maxHeight,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<BottomSheetItem> items,
    EdgeInsetsGeometry? padding,
    double? maxHeight,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder:
          (context) => CustomBottomSheet(
            title: title,
            items: items,
            padding: padding,
            maxHeight: maxHeight,
            onClose: () => Navigator.of(context).pop(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final defaultMaxHeight = screenHeight * 0.6;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight ?? defaultMaxHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 16), // Increased from 12
            decoration: BoxDecoration(
              color: AppColors.neutral[50],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20, // Increased from 16
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    color: const Color(0xFF202D41),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(height: 1, color: AppColors.neutral[50]?.withOpacity(0.3)),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding:
                  padding ??
                  const EdgeInsets.fromLTRB(
                    24,
                    24,
                    24,
                    32,
                  ), // Increased bottom padding
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    _buildBottomSheetItem(items[i]),
                    if (i < items.length - 1)
                      const SizedBox(height: 16), // Increased from 12
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetItem(BottomSheetItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20), // Increased from 16
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  AppColors.neutral[50]?.withOpacity(0.3) ??
                  Colors.grey.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Icon
              if (item.icon != null)
                Container(
                  width: 44, // Increased from 40
                  height: 44, // Increased from 40
                  decoration: BoxDecoration(
                    color:
                        item.iconBackgroundColor ??
                        AppColors.base.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10), // Increased from 8
                  ),
                  child: Icon(
                    item.icon,
                    color: item.iconColor ?? AppColors.base,
                    size: 24, // Increased from 20
                  ),
                ),

              if (item.icon != null)
                const SizedBox(width: 20), // Increased from 16
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyles.h4.copyWith(
                        color: const Color(0xFF202D41),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 6), // Increased from 4
                      Text(
                        item.subtitle!,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.neutral[50],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing
              if (item.trailing != null)
                item.trailing!
              else
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.neutral[50],
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheetItem {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const BottomSheetItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.trailing,
    this.onTap,
  });
}
