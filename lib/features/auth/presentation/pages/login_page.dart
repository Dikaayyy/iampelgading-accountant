import 'package:flutter/material.dart';
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
      // Tambahkan ini untuk mencegah resize saat keyboard muncul
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Top section dengan fixed height
            Expanded(flex: 3, child: _buildTopSection()),
            // Bottom section dengan fixed height
            Expanded(flex: 2, child: _buildBottomSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.base, AppColors.base.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: _buildOptimizedLogo(),
        ),
      ),
    );
  }

  Widget _buildOptimizedLogo() {
    return SizedBox(
      width: 240, // Fixed size untuk mencegah rebuild
      height: 240,
      child: Image.asset(
        AppAssets.cuate,
        fit: BoxFit.contain,
        // Cache image untuk performa
        cacheWidth: 240,
        cacheHeight: 240,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 240,
            height: 240,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, size: 120, color: AppColors.base),
          );
        },
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      width: double.infinity,
      height:
          MediaQuery.of(context).size.height *
          0.4, // Fixed height - 40% of screen
      decoration: const ShapeDecoration(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal:
                MediaQuery.of(context).size.width * 0.06, // 6% of screen width
            vertical: 16, // Reduced from 24
          ),
          physics: const BouncingScrollPhysics(),
          child: Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      'Masuk',
                      style: AppTextStyles.h1.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1.50,
                        fontSize:
                            MediaQuery.of(context).size.width *
                            0.07, // Responsive font size
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ), // 2% of screen height
                    // Form fields dengan optimasi
                    _buildFormFields(provider),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ), // 2% of screen height
                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 48, // Fixed button height
                      child: PrimaryButton(
                        text: 'Masuk',
                        onPressed:
                            provider.isFormValid && !provider.isLoading
                                ? () => _handleLogin(context, provider)
                                : null,
                        isLoading: provider.isLoading,
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ), // 1% of screen height
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Pisahkan form fields untuk optimasi rebuild
  Widget _buildFormFields(AuthProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Username field dengan optimasi
        _OptimizedTextField(
          label: 'Username',
          hintText: 'E.g admin',
          controller: _usernameController,
          keyboardType: TextInputType.text,
          validator: provider.validateUsername,
          onChanged: provider.updateUsername,
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ), // 1.5% of screen height
        // Password field dengan optimasi
        Consumer<AuthProvider>(
          builder: (context, provider, child) {
            return _OptimizedTextField(
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
            );
          },
        ),
      ],
    );
  }

  Future<void> _handleLogin(BuildContext context, AuthProvider provider) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
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

// Widget TextField yang dioptimasi untuk mengurangi rebuild
class _OptimizedTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;

  const _OptimizedTextField({
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomTextField(
        label: label,
        hintText: hintText,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
