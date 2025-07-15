import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool isLoading;
  final bool enabled;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.textStyle,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = enabled && !isLoading && onPressed != null;
    final Color finalBackgroundColor = backgroundColor ?? AppColors.base;
    final Color finalTextColor = textColor ?? Colors.white;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isButtonEnabled ? onPressed : null,
          borderRadius: borderRadius ?? BorderRadius.circular(15),
          child: Container(
            padding: padding ?? const EdgeInsets.all(10),
            decoration: ShapeDecoration(
              color:
                  isButtonEnabled
                      ? finalBackgroundColor
                      : finalBackgroundColor.withOpacity(1),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null && !isLoading) ...[
                  icon!,
                  const SizedBox(width: 10),
                ],
                if (isLoading) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(finalTextColor),
                    ),
                  ),
                ] else ...[
                  Flexible(
                    child: Text(
                      text,
                      style:
                          textStyle ??
                          AppTextStyles.h4.copyWith(
                            color:
                                isButtonEnabled
                                    ? finalTextColor
                                    : finalTextColor.withOpacity(1),
                            fontSize: fontSize ?? 16,
                            fontWeight: fontWeight ?? FontWeight.w500,
                          ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Predefined button variants for common use cases
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final bool isLoading;
  final Widget? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      width: width,
      backgroundColor: AppColors.base[50],
      textColor: AppColors.base[100],
      isLoading: isLoading,
      icon: icon,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final bool isLoading;
  final Widget? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      width: width,
      backgroundColor: Colors.white,
      textColor: AppColors.base,
      isLoading: isLoading,
      icon: icon,
    );
  }
}

class DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final bool isLoading;
  final Widget? icon;

  const DangerButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      width: width,
      backgroundColor: AppColors.error,
      textColor: Colors.white,
      isLoading: isLoading,
      icon: icon,
    );
  }
}
