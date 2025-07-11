import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';

class MinimalTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? value;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final double? width;

  const MinimalTextField({
    super.key,
    required this.label,
    this.hintText,
    this.value,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.width = 364,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF343434),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text Field Content
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
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
                          style: const TextStyle(
                            color: Color(0xFF343434),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: TextStyle(
                              color: AppColors.neutral[50],
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            suffixIcon: suffixIcon,
                            filled: true,
                            fillColor: AppColors.background[200],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Border Line
                Container(
                  width: double.infinity,
                  height: 1,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFCACACA),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFEBEBEB),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
