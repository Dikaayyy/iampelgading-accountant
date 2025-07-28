import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/widgets/custom_button.dart';
import 'package:iampelgading/core/widgets/custom_snackbar.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:iampelgading/features/profile/presentation/pages/change_password_page.dart';
import 'package:iampelgading/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:iampelgading/features/auth/presentation/pages/login_page.dart';

class ProfileMenuSection extends StatelessWidget {
  final VoidCallback? onChangePassword;
  final VoidCallback? onChangeUsername;
  final VoidCallback? onAppInfo;
  final Function(String username, String? imageUrl)? onProfileUpdated;

  const ProfileMenuSection({
    super.key,
    this.onChangePassword,
    this.onChangeUsername,
    this.onAppInfo,
    this.onProfileUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 30,
        left: 24,
        right: 24,
        bottom: 24,
      ), // Reduced top padding
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        color: Color(0xFFFDFCFA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Added username display here since we removed the profile image section
          Padding(padding: const EdgeInsets.only(bottom: 24)),

          ProfileMenuItem(
            title: 'Ganti Password',
            icon: Icons.chevron_right,
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: const ChangePasswordPage(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
          const SizedBox(height: 12),
          ProfileMenuItem(
            title: 'Informasi Aplikasi',
            icon: Icons.chevron_right,
            onTap: onAppInfo,
          ),
          const SizedBox(height: 24),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: DangerButton(
              text: 'Logout',
              width: double.infinity,
              icon: const Icon(Icons.logout, color: Colors.white, size: 20),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            DangerButton(
              text: 'Logout',
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) {
    // Show logout success message with custom snackbar
    CustomSnackbar.showSuccess(
      context: context,
      title: 'Logout Berhasil',
      message: 'Anda telah berhasil logout.',
      icon: Icons.logout,
      showAtTop: true,
    );

    // Navigate to login screen and clear all navigation stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false, // Remove all previous routes
    );
  }
}
