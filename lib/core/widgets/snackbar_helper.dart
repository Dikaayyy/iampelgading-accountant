import 'package:flutter/material.dart';
import 'package:iampelgading/core/widgets/custom_snackbar.dart';

class SnackbarHelper {
  // Success snackbar
  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    VoidCallback? onTap,
    Duration? duration,
    bool showAtTop = true, // Default to show at top
  }) {
    CustomSnackbar.showSuccess(
      context: context,
      title: title,
      message: message,
      icon: icon,
      onTap: onTap,
      duration: duration,
      showAtTop: showAtTop,
    );
  }

  // Error snackbar
  static void showError({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    VoidCallback? onTap,
    Duration? duration,
    bool showAtTop = true, // Default to show at top
  }) {
    CustomSnackbar.showError(
      context: context,
      title: title,
      message: message,
      icon: icon,
      onTap: onTap,
      duration: duration,
      showAtTop: showAtTop,
    );
  }

  // Warning snackbar
  static void showWarning({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    VoidCallback? onTap,
    Duration? duration,
    bool showAtTop = true, // Default to show at top
  }) {
    CustomSnackbar.showWarning(
      context: context,
      title: title,
      message: message,
      icon: icon,
      onTap: onTap,
      duration: duration,
      showAtTop: showAtTop,
    );
  }

  // Info snackbar
  static void showInfo({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    VoidCallback? onTap,
    Duration? duration,
    bool showAtTop = true, // Default to show at top
  }) {
    CustomSnackbar.showInfo(
      context: context,
      title: title,
      message: message,
      icon: icon,
      onTap: onTap,
      duration: duration,
      showAtTop: showAtTop,
    );
  }

  // Custom snackbar dengan parameter lengkap
  static void showCustom({
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
    bool showAtTop = true, // Default to show at top
  }) {
    if (showAtTop) {
      CustomSnackbar.showTop(
        context: context,
        title: title,
        message: message,
        type: type,
        icon: icon,
        backgroundColor: backgroundColor,
        titleColor: titleColor,
        messageColor: messageColor,
        iconColor: iconColor,
        onTap: onTap,
        duration: duration,
        width: width,
        padding: padding,
        margin: margin,
      );
    } else {
      CustomSnackbar.show(
        context: context,
        title: title,
        message: message,
        type: type,
        icon: icon,
        backgroundColor: backgroundColor,
        titleColor: titleColor,
        messageColor: messageColor,
        iconColor: iconColor,
        onTap: onTap,
        duration: duration,
        width: width,
        padding: padding,
        margin: margin,
      );
    }
  }
}
