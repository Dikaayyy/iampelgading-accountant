import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:iampelgading/core/widgets/custom_text_field.dart';
import 'package:iampelgading/core/widgets/custom_button.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';
import 'package:iampelgading/core/assets/app_assets.dart';
import 'package:iampelgading/features/auth/presentation/providers/auth_provider.dart';
import 'package:iampelgading/core/navigation/app_navigation.dart';
import 'package:iampelgading/core/di/service_locator.dart';
import 'package:iampelgading/core/managers/snackbar_manager.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(loginUsecase: sl()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Column(
              children: [
                // Top section with image and background
                Flexible(flex: 3, child: _buildTopSection()),

                // Bottom section with form
                Flexible(flex: 2, child: _buildBottomSection()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Stack(
      children: [
        // Rectangle SVG background - mirrored and scaled
        Positioned(
          left: 100, // Adjust position karena ukuran bertambah
          top: 150, // Adjust position
          child: Transform.scale(
            scaleX: -2.0, // Mirror dan scale horizontal 2x
            scaleY: 2.0, // Scale vertical 2x
            child: SvgPicture.asset(AppAssets.rectangle, fit: BoxFit.cover),
          ),
        ),

        // Main content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to push cuate down
              const SizedBox(height: 150),

              // App logo/image - Direct PNG without decoration
              Flexible(
                child: SizedBox(
                  width: 280,
                  height: 280,
                  child: Image.asset(
                    AppAssets.cuate,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 280,
                        height: 280,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 140,
                          color: AppColors.base,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 24),
      decoration: const ShapeDecoration(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
      ),
      child: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    'Masuk',
                    style: AppTextStyles.h1.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1.50,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Form fields
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Username field
                      CustomTextField(
                        label: 'Username',
                        hintText: 'E.g admin',
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        validator: provider.validateUsername,
                        onChanged: provider.updateUsername,
                      ),

                      const SizedBox(height: 20),

                      // Password field
                      CustomTextField(
                        label: 'Password',
                        hintText: 'E.g password123',
                        controller: _passwordController,
                        obscureText: !provider.isPasswordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        validator: provider.validatePassword,
                        onChanged: provider.updatePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            provider.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.neutral[100],
                          ),
                          onPressed: provider.togglePasswordVisibility,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Masuk',
                      onPressed:
                          provider.isFormValid && !provider.isLoading
                              ? () => _handleLogin(context, provider)
                              : null,
                      isLoading: provider.isLoading,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Error message (keep this as fallback)
                  if (provider.errorMessage.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.error[200]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        provider.errorMessage,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.error[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context, AuthProvider provider) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Show loading snackbar
        SnackbarManager.showLoginLoading(context: context);

        await provider.login();

        if (context.mounted) {
          // Show success snackbar
          SnackbarManager.showLoginSuccess(
            context: context,
            username: provider.currentUser?.username,
          );

          // Wait a bit to show the success message
          await Future.delayed(const Duration(milliseconds: 500));

          // Navigate to main app and clear navigation stack
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AppNavigation()),
            (route) => false, // Remove all previous routes
          );
        }
      } catch (e) {
        if (context.mounted) {
          // Show error snackbar with automatic error handling
          SnackbarManager.showError(context: context, error: e);
        }
      }
    } else {
      // Show validation error snackbar
      SnackbarManager.showLoginValidationError(context: context);
    }
  }
}
