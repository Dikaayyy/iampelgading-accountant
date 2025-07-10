import 'package:flutter/material.dart';
import 'package:iampelgading/core/widgets/custom_button.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:iampelgading/features/profile/presentation/pages/change_password_page.dart';
import 'package:iampelgading/features/profile/presentation/pages/profile_settings_page.dart';
import 'package:iampelgading/features/profile/presentation/widgets/profile_menu_item.dart';

class ProfileMenuSection extends StatelessWidget {
  final VoidCallback? onChangePassword;
  final VoidCallback? onChangeUsername;
  final VoidCallback? onAppInfo;
  final String currentUsername;
  final String? currentImageUrl;
  final Function(String username, String? imageUrl)? onProfileUpdated;

  const ProfileMenuSection({
    super.key,
    this.onChangePassword,
    this.onChangeUsername,
    this.onAppInfo,
    required this.currentUsername,
    this.currentImageUrl,
    this.onProfileUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 130, left: 24, right: 24, bottom: 24),
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
          ProfileMenuItem(
            title: 'Pengaturan Profil',
            icon: Icons.chevron_right,
            onTap: () async {
              final result = await PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: ProfileSettingsPage(
                  currentUsername: currentUsername,
                  currentImageUrl: currentImageUrl,
                ),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );

              if (result != null && result is Map<String, dynamic>) {
                final username = result['username'] as String?;
                final imageUrl = result['imageUrl'] as String?;
                if (username != null && onProfileUpdated != null) {
                  onProfileUpdated!(username, imageUrl);
                }
              }
            },
          ),
          const SizedBox(height: 12),
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
    // Add your logout logic here
    // For example: clear user data, navigate to login screen, etc.

    // Show logout success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil logout'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate to login screen or main screen
    // Navigator.of(context).pushReplacementNamed('/login');
  }
}
