// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';

enum SnackbarType { success, error, warning, info }

class CustomSnackbar extends StatelessWidget {
  final String title;
  final String message;
  final SnackbarType type;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? messageColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final Duration? duration;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CustomSnackbar({
    super.key,
    required this.title,
    required this.message,
    this.type = SnackbarType.info,
    this.icon,
    this.backgroundColor,
    this.titleColor,
    this.messageColor,
    this.iconColor,
    this.onTap,
    this.duration,
    this.width,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getSnackbarConfig();
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: width ?? (screenWidth > 400 ? 364 : screenWidth - 32),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
      padding: padding ?? const EdgeInsets.all(14),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: backgroundColor ?? config.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              if (icon != null || config.icon != null)
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: (iconColor ?? config.iconColor).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon ?? config.icon,
                    color: iconColor ?? config.iconColor,
                    size: 24,
                  ),
                ),

              if (icon != null || config.icon != null)
                const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: AppTextStyles.h4.copyWith(
                        color: titleColor ?? config.titleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Message
                    Text(
                      message,
                      style: AppTextStyles.body.copyWith(
                        color: messageColor ?? config.messageColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SnackbarConfig _getSnackbarConfig() {
    switch (type) {
      case SnackbarType.success:
        return SnackbarConfig(
          backgroundColor: AppColors.success[100]!,
          titleColor: AppColors.success[500]!,
          messageColor: const Color(0xFF343434),
          iconColor: AppColors.success[500]!,
          icon: Icons.check_circle,
        );
      case SnackbarType.error:
        return SnackbarConfig(
          backgroundColor: AppColors.error[100]!,
          titleColor: AppColors.error[400]!,
          messageColor: const Color(0xFF343434),
          iconColor: AppColors.error[400]!,
          icon: Icons.error,
        );
      case SnackbarType.warning:
        return SnackbarConfig(
          backgroundColor: AppColors.warning[50]!,
          titleColor: AppColors.warning[300]!,
          messageColor: const Color(0xFF343434),
          iconColor: AppColors.warning[300]!,
          icon: Icons.warning,
        );
      case SnackbarType.info:
        return SnackbarConfig(
          backgroundColor: AppColors.base.withOpacity(0.1),
          titleColor: AppColors.base,
          messageColor: const Color(0xFF343434),
          iconColor: AppColors.base,
          icon: Icons.info,
        );
    }
  }

  // Static method untuk menampilkan snackbar DI ATAS
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    SnackbarType type = SnackbarType.info,
    IconData? icon,
    Color? backgroundColor,
    Color? titleColor,
    Color? messageColor,
    Color? iconColor,
    VoidCallback? onTap,
    Duration? duration,
    double? width,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    final snackbar = SnackBar(
      content: CustomSnackbar(
        title: title,
        message: message,
        type: type,
        icon: icon,
        backgroundColor: backgroundColor,
        titleColor: titleColor,
        messageColor: messageColor,
        iconColor: iconColor,
        onTap: onTap,
        width: width,
        padding: padding,
        margin: margin,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.fixed, // Changed to fixed
      duration: duration ?? const Duration(seconds: 4),
      margin: EdgeInsets.zero,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  // Alternative method untuk menampilkan di TOP dengan overlay
  static void showTop({
    required BuildContext context,
    required String title,
    required String message,
    SnackbarType type = SnackbarType.info,
    IconData? icon,
    Color? backgroundColor,
    Color? titleColor,
    Color? messageColor,
    Color? iconColor,
    VoidCallback? onTap,
    Duration? duration,
    double? width,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 20, // Position at top
            left: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: Container(
                alignment: Alignment.center,
                child: CustomSnackbar(
                  title: title,
                  message: message,
                  type: type,
                  icon: icon,
                  backgroundColor: backgroundColor,
                  titleColor: titleColor,
                  messageColor: messageColor,
                  iconColor: iconColor,
                  onTap: onTap,
                  width: width,
                  padding: padding,
                  margin: margin,
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);

    // Remove after duration
    Future.delayed(duration ?? const Duration(seconds: 4), () {
      overlayEntry.remove();
    });
  }

  // Predefined methods untuk kemudahan penggunaan
  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    VoidCallback? onTap,
    Duration? duration,
    bool showAtTop = false,
  }) {
    if (showAtTop) {
      showTop(
        context: context,
        title: title,
        message: message,
        type: SnackbarType.success,
        icon: icon,
        onTap: onTap,
        duration: duration,
      );
    } else {
      show(
        context: context,
        title: title,
        message: message,
        type: SnackbarType.success,
        icon: icon,
        onTap: onTap,
        duration: duration,
      );
    }
  }

  static void showError({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    VoidCallback? onTap,
    Duration? duration,
    bool showAtTop = false,
  }) {
    if (showAtTop) {
      showTop(
        context: context,
        title: title,
        message: message,
        type: SnackbarType.error,
        icon: icon,
        onTap: onTap,
        duration: duration,
      );
    } else {
      show(
        context: context,
        title: title,
        message: message,
        type: SnackbarType.error,
        icon: icon,
        onTap: onTap,
        duration: duration,
      );
    }
  }

  static void showWarning({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    VoidCallback? onTap,
    Duration? duration,
    bool showAtTop = false,
  }) {
    if (showAtTop) {
      showTop(
        context: context,
        title: title,
        message: message,
        type: SnackbarType.warning,
        icon: icon,
        onTap: onTap,
        duration: duration,
      );
    } else {
      show(
        context: context,
        title: title,
        message: message,
        type: SnackbarType.warning,
        icon: icon,
        onTap: onTap,
        duration: duration,
      );
    }
  }

  static void showInfo({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    VoidCallback? onTap,
    Duration? duration,
    bool showAtTop = false,
  }) {
    if (showAtTop) {
      showTop(
        context: context,
        title: title,
        message: message,
        type: SnackbarType.info,
        icon: icon,
        onTap: onTap,
        duration: duration,
      );
    } else {
      show(
        context: context,
        title: title,
        message: message,
        type: SnackbarType.info,
        icon: icon,
        onTap: onTap,
        duration: duration,
      );
    }
  }
}

// Configuration class untuk snackbar
class SnackbarConfig {
  final Color backgroundColor;
  final Color titleColor;
  final Color messageColor;
  final Color iconColor;
  final IconData icon;

  const SnackbarConfig({
    required this.backgroundColor,
    required this.titleColor,
    required this.messageColor,
    required this.iconColor,
    required this.icon,
  });
}
