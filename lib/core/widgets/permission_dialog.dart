import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';
import 'package:iampelgading/core/widgets/custom_button.dart';
import 'package:iampelgading/core/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onGranted;
  final VoidCallback? onDenied;

  const PermissionDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.onGranted,
    this.onDenied,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.base.withOpacity(0.1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(icon, size: 32, color: AppColors.base),
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.neutral[200],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Message
          Text(
            message,
            style: AppTextStyles.body.copyWith(color: AppColors.neutral[50]),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Nanti',
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                    onDenied?.call();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: 'Izinkan',
                  onPressed: () async {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                    final granted =
                        await PermissionService.requestStoragePermission();
                    if (granted) {
                      onGranted?.call();
                    } else {
                      onDenied?.call();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Future<void> showStoragePermissionDialog(
    BuildContext context, {
    VoidCallback? onGranted,
    VoidCallback? onDenied,
  }) async {
    if (!context.mounted) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PermissionDialog(
          title: 'Izin Akses Storage',
          message:
              'Aplikasi memerlukan izin "Kelola semua file" untuk menyimpan file CSV ke folder Download. Silakan berikan izin untuk melanjutkan.',
          icon: Icons.folder_open,
          onGranted: onGranted,
          onDenied: onDenied,
        );
      },
    );
  }

  static Future<void> showPermissionDeniedDialog(
    BuildContext context, {
    VoidCallback? onOpenSettings,
  }) async {
    if (!context.mounted) return;

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Izin Ditolak',
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          content: Text(
            'Izin "Kelola semua file" diperlukan untuk menyimpan file CSV ke folder Download. Silakan buka pengaturan aplikasi untuk memberikan izin.',
            style: AppTextStyles.body.copyWith(color: AppColors.neutral[200]),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(
                'Batal',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.neutral[50],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }
                // Try to request permission again first
                Permission.manageExternalStorage.request().then((status) {
                  if (status.isGranted) {
                    onOpenSettings?.call();
                  } else {
                    // If still denied, then open app settings
                    openAppSettings();
                  }
                });
              },
              child: Text(
                'Buka Pengaturan',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.base,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
