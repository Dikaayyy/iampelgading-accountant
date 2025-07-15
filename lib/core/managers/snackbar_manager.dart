import 'package:flutter/material.dart';
import 'package:iampelgading/core/widgets/custom_snackbar.dart';
import 'package:iampelgading/core/utils/error_handler.dart';

class SnackbarManager {
  // Show success snackbar
  static void showSuccess({
    required BuildContext context,
    required String message,
    String title = 'Berhasil',
    IconData? icon,
    Duration? duration,
    bool showAtTop = true,
  }) {
    CustomSnackbar.showSuccess(
      context: context,
      title: title,
      message: message,
      icon: icon ?? Icons.check_circle,
      showAtTop: showAtTop,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  // Show error snackbar with automatic error handling
  static void showError({
    required BuildContext context,
    required dynamic error,
    String? customMessage,
    String? customTitle,
    IconData? icon,
    Duration? duration,
    bool showAtTop = true,
  }) {
    final errorTitle = customTitle ?? ErrorHandler.getErrorTitle(error);
    final errorMessage = customMessage ?? ErrorHandler.getErrorMessage(error);

    CustomSnackbar.showError(
      context: context,
      title: errorTitle,
      message: errorMessage,
      icon: icon ?? Icons.error_outline,
      showAtTop: showAtTop,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  // Show warning snackbar
  static void showWarning({
    required BuildContext context,
    required String message,
    String title = 'Peringatan',
    IconData? icon,
    Duration? duration,
    bool showAtTop = true,
  }) {
    CustomSnackbar.showWarning(
      context: context,
      title: title,
      message: message,
      icon: icon ?? Icons.warning_amber,
      showAtTop: showAtTop,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  // Show info snackbar
  static void showInfo({
    required BuildContext context,
    required String message,
    String title = 'Informasi',
    IconData? icon,
    Duration? duration,
    bool showAtTop = true,
  }) {
    CustomSnackbar.showInfo(
      context: context,
      title: title,
      message: message,
      icon: icon ?? Icons.info_outline,
      showAtTop: showAtTop,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  // Show loading snackbar
  static void showLoading({
    required BuildContext context,
    String message = 'Memproses...',
    String title = 'Sedang Memproses',
    Duration? duration,
    bool showAtTop = true,
  }) {
    CustomSnackbar.showInfo(
      context: context,
      title: title,
      message: message,
      icon: Icons.hourglass_empty,
      showAtTop: showAtTop,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  // Show validation error snackbar
  static void showValidationError({
    required BuildContext context,
    String message = 'Silakan periksa kembali data yang Anda masukkan.',
    String title = 'Data Tidak Valid',
    Duration? duration,
    bool showAtTop = true,
  }) {
    CustomSnackbar.showWarning(
      context: context,
      title: title,
      message: message,
      icon: Icons.warning_amber,
      showAtTop: showAtTop,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  // Context-specific methods
  static void showLoginSuccess({
    required BuildContext context,
    String? username,
  }) {
    showSuccess(
      context: context,
      title: 'Login Berhasil',
      message: 'Selamat datang, ${username ?? 'User'}!',
      icon: Icons.check_circle,
    );
  }

  static void showLoginLoading({required BuildContext context}) {
    showLoading(
      context: context,
      title: 'Memproses Login',
      message: 'Sedang memverifikasi kredensial Anda...',
    );
  }

  static void showLoginValidationError({required BuildContext context}) {
    showValidationError(
      context: context,
      title: 'Data Tidak Valid',
      message: 'Silakan periksa kembali username dan password Anda.',
    );
  }
}
