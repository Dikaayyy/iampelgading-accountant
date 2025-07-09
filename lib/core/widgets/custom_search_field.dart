import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';

class CustomSearchField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final bool autofocus;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final double? height;
  final String? Function(String?)? validator;
  final bool enabled;

  const CustomSearchField({
    super.key,
    this.hintText = 'Search...',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.autofocus = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.focusNode,
    this.height = 48,
    this.validator,
    this.enabled = true,
  });

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_updateHasText);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _controller.removeListener(_updateHasText);
    super.dispose();
  }

  void _updateHasText() {
    final newHasText = _controller.text.isNotEmpty;
    if (_hasText != newHasText) {
      setState(() {
        _hasText = newHasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.base),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: TextFormField(
        controller: _controller,
        focusNode: widget.focusNode,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        onFieldSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        validator: widget.validator,
        style: AppTextStyles.body.copyWith(
          color: AppColors.neutral[200],
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.body.copyWith(
            color: AppColors.neutral[50],
            fontSize: 16,
          ),
          prefixIcon:
              widget.prefixIcon ??
              Icon(Icons.search, color: AppColors.neutral[50]!),
          suffixIcon:
              _hasText
                  ? GestureDetector(
                    onTap: () {
                      _controller.clear();
                      if (widget.onChanged != null) {
                        widget.onChanged!('');
                      }
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColors.neutral[50]!,
                      size: 20,
                    ),
                  )
                  : widget.suffixIcon,
          contentPadding:
              widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          filled: false,
        ),
      ),
    );
  }
}
