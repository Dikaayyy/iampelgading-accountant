import 'package:flutter/material.dart';
import 'package:iampelgading/features/profile/presentation/widgets/profile_menu_item.dart';

class ProfileMenuSection extends StatelessWidget {
  final VoidCallback? onChangePassword;
  final VoidCallback? onChangeUsername;
  final VoidCallback? onAppInfo;

  const ProfileMenuSection({
    super.key,
    this.onChangePassword,
    this.onChangeUsername,
    this.onAppInfo,
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
            title: 'Ganti Password',
            icon: Icons.chevron_right,
            onTap: onChangePassword,
          ),
          const SizedBox(height: 12),
          ProfileMenuItem(
            title: 'Ganti Username',
            icon: Icons.chevron_right,
            onTap: onChangeUsername,
          ),
          const SizedBox(height: 12),
          ProfileMenuItem(
            title: 'Informasi Aplikasi',
            icon: Icons.chevron_right,
            onTap: onAppInfo,
          ),
        ],
      ),
    );
  }
}
