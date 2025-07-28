import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.contentPadding,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: AppTextStyles.h4.copyWith(
              color: AppColors.neutral[200],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          // Text Field dengan optimasi
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              validator: validator,
              onChanged: onChanged,
              maxLines: maxLines,
              minLines: minLines,
              readOnly: readOnly,
              onTap: onTap,
              focusNode: focusNode,
              autofocus: autofocus,
              enabled: enabled,
              // Optimasi text rendering
              textInputAction:
                  keyboardType == TextInputType.visiblePassword
                      ? TextInputAction.done
                      : TextInputAction.next,
              style: AppTextStyles.body.copyWith(
                color: AppColors.neutral[200],
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.neutral[50],
                  fontSize: 16,
                ),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                contentPadding: contentPadding ?? const EdgeInsets.all(14),
                filled: true,
                fillColor: Colors.white,
                // Optimasi border dengan const
                enabledBorder: _buildBorder(AppColors.base, 1.0),
                focusedBorder: _buildBorder(AppColors.base, 1.5),
                errorBorder: _buildBorder(AppColors.error[400]!, 1.0),
                focusedErrorBorder: _buildBorder(AppColors.error[400]!, 1.5),
                disabledBorder: _buildBorder(AppColors.neutral[50]!, 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method untuk optimasi border
  OutlineInputBorder _buildBorder(Color color, double width) {
    return OutlineInputBorder(
      borderSide: BorderSide(width: width, color: color),
      borderRadius: BorderRadius.circular(15),
    );
  }
}
