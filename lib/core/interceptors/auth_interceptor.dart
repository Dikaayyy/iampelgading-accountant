import 'package:flutter/material.dart';
import 'package:iampelgading/core/services/auth_service.dart';
import 'package:iampelgading/features/auth/presentation/pages/login_page.dart';
import 'package:iampelgading/core/managers/snackbar_manager.dart';
import 'package:iampelgading/main.dart';

class AuthInterceptor {
  static AuthService? _authService;

  static void init(AuthService authService) {
    _authService = authService;
  }

  static Future<bool> checkTokenValidity() async {
    if (_authService == null) return false;

    final isValid = await _authService!.isTokenValid();
    if (!isValid) {
      await _handleTokenExpired();
      return false;
    }
    return true;
  }

  static Future<void> _handleTokenExpired() async {
    // Clear all auth data
    await _authService!.logout();

    // Get current context
    final context = navigatorKey.currentContext;
    if (context != null) {
      // Show expiration message
      SnackbarManager.showError(
        context: context,
        error: Exception('Sesi login telah berakhir. Silakan login kembali.'),
        customTitle: 'Sesi Berakhir',
      );

      // Navigate to login page
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  // Method untuk cek remaining time dan warning user
  static Future<void> checkTokenExpirationWarning() async {
    if (_authService == null) return;

    final remainingTime = await _authService!.getTokenRemainingTime();
    if (remainingTime == null) return;

    // Warning ketika tinggal 30 menit
    if (remainingTime.inMinutes <= 30 && remainingTime.inMinutes > 0) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        SnackbarManager.showWarning(
          context: context,
          title: 'Sesi Akan Berakhir',
          message:
              'Sesi login akan berakhir dalam ${remainingTime.inMinutes} menit',
        );
      }
    }
  }
}
