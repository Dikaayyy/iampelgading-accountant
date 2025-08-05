import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iampelgading/core/widgets/custom_text_field.dart';
import 'package:iampelgading/core/widgets/custom_button.dart';
import 'package:iampelgading/core/widgets/custom_app_bar.dart';
import 'package:iampelgading/core/widgets/custom_snackbar.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/features/profile/presentation/providers/change_password_provider.dart';
import 'package:iampelgading/features/auth/domain/usecases/change_password_usecase.dart';

class ChangePasswordPage extends StatelessWidget {
  final ChangePasswordUsecase changePasswordUsecase;

  const ChangePasswordPage({super.key, required this.changePasswordUsecase});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => ChangePasswordProvider(
            changePasswordUsecase: changePasswordUsecase,
          ),
      child: const ChangePasswordView(),
    );
  }
}

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'Ganti Password',
        backgroundColor: AppColors.base,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ChangePasswordProvider>(
        builder: (context, provider, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                // Old Password Field
                CustomTextField(
                  label: 'Password Lama',
                  hintText: 'Masukkan password lama',
                  controller: _oldPasswordController,
                  obscureText: !provider.isOldPasswordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  validator: provider.validateOldPassword,
                  onChanged: provider.updateOldPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      provider.isOldPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.neutral[100],
                    ),
                    onPressed: provider.toggleOldPasswordVisibility,
                  ),
                ),
                const SizedBox(height: 12),
                // New Password Field
                CustomTextField(
                  label: 'Password Baru',
                  hintText: 'Masukkan password baru',
                  controller: _newPasswordController,
                  obscureText: !provider.isNewPasswordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  validator: provider.validateNewPassword,
                  onChanged: provider.updateNewPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      provider.isNewPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.neutral[100],
                    ),
                    onPressed: provider.toggleNewPasswordVisibility,
                  ),
                ),
                const SizedBox(height: 12),
                // Confirm Password Field
                CustomTextField(
                  label: 'Konfirmasi Password Baru',
                  hintText: 'Konfirmasi password baru',
                  controller: _confirmPasswordController,
                  obscureText: !provider.isConfirmPasswordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  validator: provider.validateConfirmPassword,
                  onChanged: provider.updateConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      provider.isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.neutral[100],
                    ),
                    onPressed: provider.toggleConfirmPasswordVisibility,
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Ganti Password',
                  onPressed:
                      provider.isFormValid && !provider.isLoading
                          ? () => _handleChangePassword(context, provider)
                          : null,
                  isLoading: provider.isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleChangePassword(
    BuildContext context,
    ChangePasswordProvider provider,
  ) async {
    if (_formKey.currentState?.validate() ?? false) {
      // Cek apakah password baru dan konfirmasi password sama
      if (provider.newPassword != provider.confirmPassword) {
        CustomSnackbar.showError(
          context: context,
          title: 'Konfirmasi Password Salah',
          message: 'Password baru dan konfirmasi password tidak sama.',
          icon: Icons.error_outline,
          showAtTop: true,
        );
        return;
      }

      try {
        await provider.changePassword();

        if (context.mounted) {
          // Show success message with custom snackbar
          CustomSnackbar.showSuccess(
            context: context,
            title: 'Password Berhasil Diubah',
            message: 'Password Anda telah berhasil diperbarui.',
            icon: Icons.check_circle,
            showAtTop: true,
          );

          // Navigate back to profile after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          });
        }
      } catch (e) {
        if (context.mounted) {
          // Extract error message
          String errorMessage = e.toString();
          if (errorMessage.contains('Exception: ')) {
            errorMessage = errorMessage.replaceFirst('Exception: ', '');
          }

          // Show error message with custom snackbar
          CustomSnackbar.showError(
            context: context,
            title: 'Gagal Mengubah Password',
            message: errorMessage,
            icon: Icons.error_outline,
            showAtTop: true,
          );
        }
      }
    }
  }
}
