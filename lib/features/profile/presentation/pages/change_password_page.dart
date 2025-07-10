import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iampelgading/core/widgets/custom_text_field.dart';
import 'package:iampelgading/core/widgets/custom_button.dart';
import 'package:iampelgading/core/widgets/custom_app_bar.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/features/profile/presentation/providers/change_password_provider.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordProvider(),
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
            child: Column(
              children: [
                const SizedBox(height: 24),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              onPressed:
                                  provider.toggleConfirmPasswordVisibility,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom section with button
                Container(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Ganti Password',
                      onPressed:
                          provider.isFormValid && !provider.isLoading
                              ? () => _handleChangePassword(context, provider)
                              : null,
                      isLoading: provider.isLoading,
                    ),
                  ),
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
      try {
        await provider.changePassword();

        if (context.mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Password berhasil diubah'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Navigate back to profile
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengubah password: ${e.toString()}'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}
